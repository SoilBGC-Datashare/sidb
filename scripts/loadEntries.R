
#Create vector with names of all available files
entryNames=list.dirs("~/sidb/data/", full.names=FALSE, recursive=FALSE)

# extract data and metadata from each folder and create one single list object
library(yaml)
for(i in 1:length(entryNames)){
  entry=yaml.load_file(input=paste("~/sidb/data/",entryNames[i],"/metadata.yaml",sep=""))
  csv=read.csv(file=paste("~/sidb/data/",entryNames[i],"/data.csv",sep=""))
  entry[["data"]]<-csv
  assign(entryNames[i], entry)
  rm(entry,csv)
}
