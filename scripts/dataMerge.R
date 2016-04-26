
#Create vector with names of all available files
dataNames=list.dirs("~/Repos/sidb/data/", full.names=FALSE, recursive=FALSE)

# extract data from all existing files and marge into one database

all=read.csv(file=paste("~/Repos/sidb/data/",dataNames,"/data.csv",sep=""))


