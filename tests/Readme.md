# Runing tests in SIDb
This folder contains scripts to run tests in SIDb and check the integrity of the data and the R package.

## Testing the integrity of the data
Data that lives outside the R package in the `data` folder can be tested using the file `data_test.R`. This is an R script that goes to the `testthat` folder and runs all tests that are there. They can be run from the command line as

```r
Rscript data_test.R
```
or directly inside R using devtools.
Contributors of new data must run these tests before contributing to SIDb. We won't accept pull request with new data if at least one test fails.

## Testing the R package
The R package is tested using build in R tools for packages. The script `pkg_test.sh` is a bash script that builds the package from source files and tests the compiled package. New contributors must also ensure that additions of new functions do not break any test.
To run the script in the command line, simply type
```
./pkg_test.sh
```
