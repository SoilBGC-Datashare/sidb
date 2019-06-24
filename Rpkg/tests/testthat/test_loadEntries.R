context("Load entries")
library(sidb)

test_that("all entries from the database can be read", {
  expect_silent(loadEntries())
})

test_that("entry names correspond to metadata template", {
  template=yaml::yaml.load_file(input="~/sidb/data/template_metadata.yaml")
  database=loadEntries()
  for(i in 1:length(database)){
   entry=database[[i]]
   expect_equal(names(entry)[-(11:12)],names(template))
  }
  
  for(i in 1:length(database)){
    entry=database[[i]]
    expect_equal(names(entry$siteInfo),names(template$siteInfo))
  }
  
  for(i in 1:length(database)){
    entry=database[[i]]
    expect_equal(names(entry$incubationInfo),names(template$incubationInfo))
  }
})

