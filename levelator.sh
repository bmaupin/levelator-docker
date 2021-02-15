#!/bin/sh
# Pass the full path of the input and output files to levelator
/usr/local/bin/level $(readlink -f "$1") $(readlink -f "$2") $(echo -n 'The Levelator copyright (c) 2006 by GigaVox Media, Inc. and Singular Software'$(( `date +%s` / 10 ))0 | md5sum | cut -f 1 -d ' ')
