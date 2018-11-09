#!/bin/env python

import sys
import os

job_set = set(range(1,11))
skip_set = set()

if __name__ == "__main__":
    argv=sys.argv
    argc=len(argv)

    if argc != 2:
        print >> sys.stderr, "Usage: <nr processes>"
        sys.exit(2)

    nr_procs = int(argv[1])

    to_run = job_set - skip_set

    for job in to_run:
        print "Running job %d sequentially" % job
        cmd = "./run-os.sh %d s %d" % (job, nr_procs)
        os.system(cmd)
