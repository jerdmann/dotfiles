#!/usr/bin/env python3
import json
import os
import os.path
import re
import shlex
import sys
from collections import namedtuple
from operator import itemgetter
from subprocess import check_output, Popen, run, PIPE

# chefbox.py
# Inspired by the excellent busybox project.  One entrypoint, behaves like
# different programs depending on the symlink invocation name.

Filter = namedtuple('Filter', ['rl', 'env', 'args'])

# globals because lazy
allow_delayed = False
rl_exact = False

# parse a list of command arguments like:
# mds_adapter_cme ppiq dev-cert -a cpu.total memory.total
# into a Filter tuple above
def make_filter(toks):
    idx = 0
    for t in toks:
        if t.startswith("-"): break
        idx += 1
    idx -= 1
    assert(idx >= 0)

    rl = toks[0:idx]
    env = toks[idx]
    args = ""
    if len(toks) > idx:
        args = ' '.join(toks[idx+1:])

    return Filter(rl, env, args)

# single entrypoint for knife searches
def knife_search(org, fmt, filt):
    assert(org in ["int", "ext"])
    cmd = "knife search"
    if org == "ext":
        cmd = "{} -c ~/.chef/knife.external.rb".format(cmd)

    args = filt.args
    if not args:
        args = "-a chef_environment -a ipaddress -a run_list -a tags"
    args = "{} -F {}".format(args, fmt)

    if rl_exact:
        rl_fmt = "run_list:*\\[{}\\]*"
    else:
        rl_fmt = "run_list:*{}*"
    rl_filter = "{}".format(
        ' AND '.join([rl_fmt.format(t) for t in filt.rl]))
    query = "{} AND chef_environment:*{}*".format(rl_filter, filt.env)
    if not allow_delayed:
        query += " NOT chef_environment:*delayed*"

    p = run('{} "{}" {}'.format(cmd, query, args), shell=True, stdout=PIPE)
    if p.returncode == 0:
        return p.stdout.decode()
    else:
        return ""

def knife_environment_get(org, filt):
    assert(org in ["int", "ext"])
    cmd = "knife"
    if org == "ext":
        cmd = "{} -c ~/.chef/knife.external.rb".format(cmd)
    cmd = "{} environment show".format(cmd)

    p = run('{} "{}" {}'.format(cmd, query, args), shell=True, stdout=PIPE)
    if p.returncode == 0:
        return p.stdout.decode()
    else:
        return ""

def bail(msg):
    sys.stderr.write("{}\n".format(msg))
    sys.exit(-1)

class printer(object):
    def __init__(self):
        self.indent = 0

    def print(self, msg, end=None):
        print('\t' * self.indent, end='')
        if end is not None:
            print(msg, end=end)
        else:
            print(msg)

RunlistEntry = namedtuple("RunlistEntry", ['name', 'hash', 'version'])

def cb_basename(rl_name):
    toks = rl_name.split("::")
    return rl_name if len(toks) == 1 else toks[1]

def ksv_print_node(node, filt):
    p = printer()
    p.print("{}\t{}({})\t".format(
        node['chef_environment'],
        node['name'],
        node['automatic']['ipaddress']), end='')

    nd = node['default']
    dcb = nd['deployed_cookbooks']
    rl_entries = []
    for (rl_name, rl_version) in dcb.items():
        include = False
        for frag in filt.rl:
            if frag in rl_name:
                include = True
                break

        if include:
            rl_hash = nd.get(cb_basename(rl_name), {}).get('version', None)
            rl_entry = RunlistEntry(rl_name, rl_hash, rl_version)
            rl_entries.append(rl_entry)

    if len(rl_entries) == 0:
        p.print("(all filtered)")
        return

    for rl in rl_entries:
        if rl.hash:
            p.print("{}@{}\t{}".format(rl.name, rl.version, rl.hash))
        else:
            p.print("{}@{}".format(rl.name, rl.version))
        p.indent = 5

def is_ext(env):
    # really lame heurestic on this for now
    for tok in ['ext', 'prod', 'uat', 'live']:
        if tok in env or env in tok:
            return True
    return False

def ks_deploy(env):
    pass
    # oneoff -c mds_adapter_b3 -r --override-oneoff -s $(ksn ter_b3 dev-md-sp) --run-chef

def assert_nodes(out):
    if not out: sys.exit(-1)

if __name__ == "__main__":
    name = os.path.basename(sys.argv[0])

    env_idx = -1
    for idx,arg in enumerate(sys.argv):
        if arg == "--delayed":
            allow_delayed = True
            env_idx = idx
        elif arg == "--exact":
            rl_exact = True
            sys.argv.remove(arg)
    if env_idx > -1:
        sys.argv[env_idx] = "-delayed"

    if name == "chefbox.py":
        for target in ['ks', 'ksn', 'sshks', 'kev']:
            check_output('ln -sf {} {}'.format(name, target), shell=True)
            check_output('ln -sf {} e{}'.format(name, target), shell=True)

        for target in ['ksv', 'ksd']:
            check_output('ln -sf {} {}'.format(name, target), shell=True)
        sys.exit()

    filt = make_filter(sys.argv[1:])

    # always heurestic, compatible with e-prefix things
    org = "ext" if is_ext(filt.env) else "int"
    if name[0] == 'e':
        name = name[1:]

    if name == "ks":
        out = knife_search(org, "summary", filt)
        print(out)
        sys.exit(0 if out else -1)

    elif name == "ksn":
        out = knife_search(org, "json", filt)
        assert_nodes(out)
        j = json.loads(out)
        names = []
        for row in j['rows']:
            for name in row:
                names.append(name)
        sys.stdout.write(' '.join(names))

    elif name == "sshks":
        ip_rex = re.compile(r'ipaddress:\s+(\S+)')
        out = knife_search(org, "summary", filt)
        assert_nodes(out)

        ips = []
        for match in ip_rex.finditer(out):
            ips.append(match.group(1))

        if len(ips) < 0:
            bail("no nodes found")

        ip = None
        if len(ips) == 1:
            ip = ips[0]
        else:
            print(out)
            for idx,val in enumerate(ips):
                print("{}) {}".format(idx+1, val))
            while ip is None:
                tok = input("# ")
                try:
                    idx = int(tok) - 1
                    ip = ips[idx]
                except:
                    continue

        p = Popen("ssh {}".format(ip), shell=True)
        p.communicate()
        sys.exit(p.returncode)

    elif name == "ksv":
        filt = Filter(filt.rl, filt.env, "-l")
        out = knife_search(org, "json", filt)
        assert_nodes(out)

        j = json.loads(out)
        rows = sorted(j['rows'], key=lambda row: row['name'])
        for node in rows:
            ksv_print_node(node, filt)

    elif name == "kev":
        # kev ase prod-live
        e = knife_environment_get(sys.argv[1])

        # 'cookbook_versions'

    else:
        bail("unhandled invocation: {}".format(name))
