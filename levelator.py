from __future__ import with_statement

import logging
import os
import os.path
import sys

if len(sys.argv) != 3:
    sys.exit('Please provide input and output files as parameters')

# Override sys.platform, which has the kernel version hardcoded
sys.platform = 'linux2'

# Hide noise from proj import
with open(os.devnull,'wb') as null:
    sys.stdout = null

    import proj

# Log to stdout
root = logging.getLogger()
root.removeHandler(root.handlers[0])
ch = logging.StreamHandler(sys.__stdout__)
root.addHandler(ch)

# Hide more noise
ch.setLevel(logging.WARNING)
l = proj.levelator.Levelator(proj.worker.WorkerThread)

ch.setLevel(logging.INFO)
l.callLeveler(sys.argv[1], sys.argv[2])
