
#Create vector with names of all available files
entryNames=list.dirs("~/sidb/data/", full.names=FALSE, recursive=FALSE)

# extract data from all existing files and marge into one database

all=read.csv(file=paste("~/sidb/data/",entryNames,"/data.csv",sep=""))

ytp=yaml.load_file(input=paste("~/sidb/data/",entryNames[1],"/metadata.yaml",sep=""))
tmp=read.csv(file=paste("~/sidb/data/",entryNames[1],"/data.csv",sep=""))

ytp[["data"]]<-tmp
