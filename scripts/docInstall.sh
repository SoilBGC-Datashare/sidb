#!/bin/bash

rm *tar.gz
Rscript pkgDocumentation.R
R CMD build ../Rpkg/
R CMD install *tar.gz

