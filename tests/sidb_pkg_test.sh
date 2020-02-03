#!/bin/bash

rm *tar.gz
rm -r sidb.Rcheck
R CMD build ../Rpkg/
R CMD check *tar.gz
