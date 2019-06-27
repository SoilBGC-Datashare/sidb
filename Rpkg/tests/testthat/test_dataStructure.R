context("Template Structure")
library(sidb)

database<-loadEntries()

testthat::test_that("check that each table in variables list has the same number of fields",{
  n.fields <- lapply(database, function(x) {
    len <- length(unique(unlist(lapply(x$variables[-1], function(y) length(y)))))
    return(len)
  })
  for(i in 1:length(n.fields)){
    if(n.fields[[i]]!=1) {cat(names(n.fields[i]),"\n")}
    expect_equal(n.fields[[i]], 1)
  }
})

testthat::test_that("ensure site names in initConditions.csv match the names in siteInfo",{
  s.names.SI<-lapply(database, function(x) unique(x$siteInfo$site))
  s.names.IC<-lapply(database, function(x) unique(x$initConditions$site))
  for(i in 1:length(s.names.SI)){
    if(length(match(s.names.SI[[i]],s.names.IC[[i]]))!=length(s.names.SI[[i]])) {
      cat(names(s.names.SI[i]),"\n")
      }
    expect_equal(length(match(s.names.SI[[i]],s.names.IC[[i]])), length(s.names.SI[[i]]))
  }
})

