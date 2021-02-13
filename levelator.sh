#!/bin/sh
# Pass the full path of the input and output files to levelator
python2.5 INSTALLDIR/.levelator/levelator.py $(readlink -f "$1") $(readlink -f "$2")
