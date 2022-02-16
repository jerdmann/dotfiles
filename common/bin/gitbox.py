#!/usr/bin/env python3
import os
import os.path
import re
import sys
from subprocess import check_output

# gitbox.py
# Also inspired by the excellent busybox project.  One entrypoint, behaves like
# different programs depending on the symlink invocation name.

def release_name(v):
    return "release_v{}/current".format(v)

def has_jira(v, jira):
    out = check_output("git log --grep {} origin/{}".format(jira, release_name(v)),
            shell=True)
    out = out.decode()
    return len(out) > 0

def first_release(nums, jira, floor=150):
    low = None
    for i,v in enumerate(nums):
        if v == floor:
            low = i
            break
    assert(low)
    high = len(nums)-1

    first = None
    seen = set()
    while low <= high:
        cur = int((high + low) / 2)
        if cur in seen: break
        seen.add(cur)

        has = has_jira(nums[cur], jira)
        print("[{}:{}] {} has {}: {}".format(
            nums[low], nums[high],
            release_name(nums[cur]), jira, has))
        if has:
            high = cur
            if not first:
                first = cur
            elif cur < first:
                first = cur
        else:
            low = cur

    return nums[first]

def bail(msg):
    sys.stderr.write("{}\n".format(msg))
    sys.exit(-1)

if __name__ == "__main__":
    name = os.path.basename(sys.argv[0])

    if name == "gitbox.py":
        for target in ['gfr']:
            check_output('ln -sf {} {}'.format(name, target), shell=True)
        sys.exit()

    if name == 'gfr':
        jira = sys.argv[1]
        if sys.stdin.isatty():
            cmd = "git remote show origin"
            sys.stderr.write("running: {}\n".format(cmd))
            f = check_output(cmd, shell=True).decode()
        else:
            f = sys.stdin.read()

        nums = []
        release_rex = re.compile(r"release_v(\d+)/current")
        for m in release_rex.finditer(f):
            nums.append(int(m.group(1)))
        nums = sorted(set(nums))
        if len(nums) == 0:
            bail("no releases found (are you in a debesys repo?)")
        first = first_release(nums, jira)
        print("{} first in: {}".format(jira, release_name(first)))

    else:
        bail("unhandled invocation: {}".format(name))
