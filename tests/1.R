
# Test that metadata files can be read by R

library(yaml)

entryNames=list.dirs("~/sidb/data/", full.names=FALSE, recursive=FALSE)

for(i in 1:length(entryNames)){
  yaml.load_file(input=paste("~/sidb/data/",entryNames[i],"/metadata.yaml",sep=""))
  print(paste(entryNames[i],"is ok"))
  #is.list(tmp)
}
