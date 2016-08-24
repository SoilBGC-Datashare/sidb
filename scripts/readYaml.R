
#This script reads all yaml entries in the database, asigns them a name (their own folder name), and puts the output in the global environment

library(yaml)
entryNames=list.dirs("~/sidb/data/", full.names=FALSE, recursive=FALSE)
  
for(i in 1:length(entryNames)){
    assign(entryNames[i], yaml.load_file(input=paste("~/sidb/data/",entryNames[i],"/metadata.yaml",sep="")))
  }

citationKey=NULL
for(i in 1:length(entryNames)){
  citationKey[i]=get(entryNames[i])$citationKey
}

doi=NULL
for(i in 1:length(entryNames)){
  doi[i]=get(entryNames[i])$doi
}

entryAuthor=NULL
for(i in 1:length(entryNames)){
  entryAuthor[i]=get(entryNames[i])$entryAuthor
}

entryCreationDate=NULL
for(i in 1:length(entryNames)){
  entryCreationDate[i]=get(entryNames[i])$entryCreationDate
}

latitude=NULL
for(i in 1:length(entryNames)){
  latitude=c(latitude,get(entryNames[i])$siteInfo$coordinates$latitude)
}

longitude=NULL
for(i in 1:length(entryNames)){
  longitude=c(longitude,get(entryNames[i])$siteInfo$coordinates$longitude)
}

# dataPoints=NULL
# nCols=NULL
# for(i in 1:length(entryNames)){
#   mtx=get(entryNames[i])$data
#   nCols[i]=dim(mtx)[2]-1
#   dataPoints[i]=length(as.matrix(mtx))
#   rm(mtx)
# }

