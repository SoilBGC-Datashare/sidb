# Runing tests in SIDb
This folder contains scripts to run tests in SIDb and check the integrity of the data and the R package.
The R package already contains tests in the folder `Rpkg/tests/testthat/`, which can be run as part of an R session with the command
```r
devtools::test()
```

These tests are also run with the general tests when running `R CMD check`. The script `sidb_pkg_test.sh` builds and runs all tests automatically. You can run it as

```
./sidb_pkg_test.sh
```
