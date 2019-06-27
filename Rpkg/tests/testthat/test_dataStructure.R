context("Template Structure")
library(sidb)

database<-loadEntries()

test_that("entry names correspond to new metadata template", {
  template=yaml::yaml.load_file(input="~/sidb/data/template_metadata_new.yaml")
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

