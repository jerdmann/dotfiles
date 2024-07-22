#!/bin/bash
target=$(python3 - $@ <<EOF
import argparse
import os
import sys
from subprocess import Popen, PIPE

def ep(msg): sys.stderr.write('%s\n' % msg)
def print_dirs(dirs):
    for dname, bname in dirs:
        ep('{}\t=> {}'.format(dname, bname))

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('toks', nargs="*")
    args = parser.parse_args()

    dirs = []
    droot = os.path.expanduser('~/dev-root')
    for n in ['one', 'two', 'three']:
        dname = 'debesys-{}'.format(n)
        p = Popen('cd {}/{} && git rev-parse --abbrev-ref HEAD'.format(droot, dname),
                              shell=True,
                              stdout=PIPE)
        out, _ = p.communicate()
        dirs.append((dname, out.decode().strip()))

    hit = ()
    if len(args.toks) > 0:
        for dname, bname in dirs:
            for tok in args.toks:
                if tok in bname:
                    hit = (dname, bname)
    if hit:
        dname, bname = hit
        p = Popen('cd {}/{}'.format(droot, dname), shell=True)
        p.communicate()
        target = '{}/{}'.format(droot, dname)
        ep('{}\t=> {}'.format(dname, bname))
        print(target)
        sys.exit(0)

    for dname, bname in dirs:
        ep('{}\t=> {}'.format(dname, bname))
    sys.exit(-1)
EOF
)
if [[ $? -eq 0 ]]; then
    cd $target
fi
