#!/usr/bin/env python
import json
import os.path
import re
import sys
from subprocess import check_output, Popen

# chefbox.py
# Inspired by the excellent busybox project.  One entrypoint, behaves like
# different programs depending on the symlink invocation name.

# single entrypoint for knife searches
def knife_search(org, fmt, *args):
    assert(org in ["int", "ext"])
    cmd = "knife search"
    if org == "ext":
        cmd = "{} -c ~/.chef/knife.external.rb".format(cmd)

    idx = 0
    for t in args:
        if t.startswith("-"): break
        idx += 1
    idx -= 1
    assert(idx >= 0)
    rl = args[0:idx]
    env = args[idx]

    args = ' '.join(args[idx+1:])
    if not args:
        args = "-a chef_environment -a ipaddress -a run_list -a tags"
    args = "{} -F {}".format(args, fmt)

    rl_filter = "{}".format(
        ' AND '.join(["run_list:*{}*".format(t) for t in rl]))

    query = "{} AND chef_environment:*{}* NOT chef_environment:*delayed*".format(rl_filter, env)
    out = check_output('{} "{}" {}'.format(cmd, query, args), shell=True)
    return out

def bail(msg):
    sys.stderr.write("{}\n".format(msg))
    sys.exit(-1)

if __name__ == "__main__":
    name = os.path.basename(sys.argv[0])

    if name == "chefbox.py":
        for target in ['ks', 'ksn', 'sshks']:
            check_output('ln -sf {} {}'.format(name, target), shell=True)
            check_output('ln -sf {} e{}'.format(name, target), shell=True)
        sys.exit()

    org = "int"
    if name[0] == 'e':
        org = "ext"
        name = name[1:]

    if name == "ks":
        print(knife_search(org, "summary", *sys.argv[1:]))

    elif name == "ksn":
        j = json.loads(knife_search(org, "json", *sys.argv[1:]))
        names = []
        for row in j['rows']:
            for name in row:
                names.append(name)
        sys.stdout.write(' '.join(names))

    elif name == "sshks":
        ip_rex = re.compile(r'ipaddress:\s+(\S+)')
        out = knife_search(org, "summary", *sys.argv[1:])
        ips = []
        for match in ip_rex.finditer(out):
            ips.append(match.group(1))

        if len(ips) < 0:
            bail("no nodes found")
        elif len(ips) > 1:
            bail("multiple nodes found:\n\n{}".format(out))

        ip = ips[0]
        p = Popen("ssh {}".format(ip), shell=True)
        p.communicate()
        sys.exit(p.returncode)

    else:
        bail("unhandled invocation: {}".format(name))
