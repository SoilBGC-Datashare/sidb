## Test environments
* local OS X install, R 3.6.2
* ubuntu 16.04 (on travis-ci), R 3.6.2
* ubuntu 18.04, R 3.6.3

## R CMD check results
There were no ERRORs or WARNINGs. 

There was 1 NOTE:

* checking data for non-ASCII characters ... NOTE
  Note: found 18 marked UTF-8 strings

  A dataset contains non-ASCII characters, but the utf-8 encoding is set correctly. This is due to a degree symbol in temperature data.

