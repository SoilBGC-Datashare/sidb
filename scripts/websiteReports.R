# This scripts creates summary statistics from the database and outputs it in yaml format

library(yaml)

source("~/sidb/scripts/readYaml.R")
source("~/sidb/scripts/loadEntries.R")

# Calculate some statistics
dataPoints=NULL
nCols=NULL
for(i in 1:length(entryNames)){
  mtx=get(entryNames[i])$data
  nCols[i]=dim(mtx)[2]-1
  dataPoints[i]=length(as.matrix(mtx))
  rm(mtx)
}

smr=list(entries=length(entryNames),timeseries=as.integer(sum(nCols)), datapoints=sum(dataPoints))
as.yaml(smr)

write_yaml(smr, file="~/sidb/docs/_data/summary.yml")

library(maps)

png("~/sidb/docs/assets/map.png", bg=NA)
map('world', interior = FALSE)
points(longitude, latitude, pch=20, col=2)
dev.off()

png("~/sidb/docs/assets/incubationTime.png", bg=NA)
hist(incubationTime, xlab="Incubation time (days)", main ="", ylab="Number of studies")
dev.off()
