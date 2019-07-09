context("Template Structure")
library(sidb)

test_that("all entries from the database can be read", {
  expect_silent(loadEntries())
})

database<-loadEntries()

test_that("entry names correspond to metadata template", {
  template=yaml::yaml.load_file(input="~/sidb/data/template_metadata.yaml")
  for(i in 1:length(database)){
    entry=database[[i]]
    expect_equal(names(entry)[-(12:13)],names(template))
  }

  for(i in 1:length(database)){
    entry=database[[i]]
    expect_equal(names(entry$siteInfo),names(template$siteInfo))
  }

  # allows new fields to be added, but none to be removed
  for(i in 1:length(database)){
    entry=database[[i]]
    if(length(match(names(template$incubationInfo),names(entry$incubationInfo)))!=length(names(template$incubationInfo)))
      {cat(names(database[i]),"\n")}
    expect_equal(length(match(names(template$incubationInfo),names(entry$incubationInfo))),
                 length(names(template$incubationInfo)))
  }
})

test_that("check first column in timeSeries file is called 'time' ",{
  for(i in 1:length(database)){
    entry=database[[i]]
    expect_equal(colnames(entry$timeSeries)[1], "time")

  }
})

test_that("check that timeseries time variable matches allowable units",{
  for(i in 1:length(database)){
    v1.unit<-database[[i]][["variables"]][[1]]["units"]
    if(length(which(v1.unit == "d" | v1.unit == "h"))==0) {
      cat(names(database)[i],"\n")
    }
    expect_true(v1.unit == "d" | v1.unit == "h")
  }
})

test_that("check that flux rate units match allowable time units",{
  for(i in 1:length(database)){
    vars.ls <- database[[1]][["variables"]][-1]
    flx.u <- lapply(vars.ls, function(x) x$units)
    flx.u <- Filter(Negate(is.na),lapply(flx.u, function(x) unlist(strsplit(x, split="/"))[3]))
    expect_true(unique(flx.u) %in% c("d","h",NA))
  }
})

test_that("variable names in timeSeries correspond to names in metadata file",{
  for(i in 1:length(database)){
    entry=database[[i]]
    tsName=as.character(colnames(entry$timeSeries))
    varname=as.character(sapply(entry$variables, function(x){x$name}))
    expect_equal(tsName, varname)
  }
})

testthat::test_that("check that each table in variables list has the same number of fields",{
  n.fields <- lapply(database, function(x) {
    len <- length(unique(unlist(lapply(x$variables[-1], function(y) length(y)))))
    return(len)
  })
  for(i in seq_along(n.fields)){
    if(n.fields[[i]]!=1) {cat(names(n.fields[i]),"\n")}
    expect_equal(n.fields[[i]], 1)
  }
})

testthat::test_that("ensure site names in initConditions.csv match the names in siteInfo",{
  s.names.SI<-lapply(database, function(x) unique(x$siteInfo$site))
  s.names.IC<-lapply(database, function(x) unique(x$initConditions$site))
  for(i in seq_along(s.names.SI)){
    if(length(match(s.names.SI[[i]],s.names.IC[[i]]))!=length(s.names.SI[[i]])) {
      cat(names(s.names.SI[i]),"\n")
      }
    expect_equal(length(match(s.names.SI[[i]],s.names.IC[[i]])), length(s.names.SI[[i]]))
  }
})

testthat::test_that("timeseries statistic matches allowable values",{
  stat <- c("SD","SE","none")
  vars <- lapply(database, function(x) x$variables[-1])
  ix <- Filter(length, lapply(vars, function(x) {
    Filter(length, lapply(x, function(y) {
      if(length(grep("statistic", names(y))) > 0) {
         which(y$statistic != stat[1] & y$statistic != stat[2] & y$statistic != stat[3])
        }
    }))
  }))
  expect_equal(length(ix),0)
})

testthat::test_that("moisture units match allowable values",{
  mu <- c("percentGWC", "percentFieldCapacity", "percentWaterFilledPoreSpace")
  incInfo <- lapply(database, "[[", "incubationInfo")
  inc.null <- names(Filter(length,lapply(incInfo, function(x) which(is.null(x$moisture$units)))))
  incInfo <- incInfo[-match(inc.null,names(incInfo))]
  for(i in seq_along(incInfo)){
    if(incInfo[[i]][["moisture"]]["units"] != mu[1] &
       incInfo[[i]][["moisture"]]["units"] != mu[2] &
       incInfo[[i]][["moisture"]]["units"] != mu[3]) {
      cat(names(incInfo[i]),"\n")
    }}
  for(i in seq_along(incInfo)){
    expect_true(incInfo[[i]][["moisture"]]["units"] == mu[1] |
                   incInfo[[i]][["moisture"]]["units"] == mu[2] |
                   incInfo[[i]][["moisture"]]["units"] == mu[3])
  }
})
