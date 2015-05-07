#!/bin/bash -x
#
# This script cleans up directories that shouldn't be packaged and then zips up everything else
# this is for Paul's use
#
basename=$(pwd | sed -e 's/^.*\///g')
echo 'Cleaning up'
rm -fv ../${basename}.zip
echo 'Deleting all but the latest two files in pkg directory'
cd pkg
b=0; for a in $(ls -1t) ; do if [ $b -gt 1 ]; then rm -rv $a; fi; b=$((b+1)); done
cd ..
cd ..
echo 'Zipping'
zip -r ${basename} ${basename}/*
cd ${basename}
