# This scripts creates summary statistics from the database and outputs it in yaml format

library(yaml)
library(sidb)
library(maps)

#Load database
database=loadEntries(path='~/sidb/data/')

# Calculate some statistics
timeseries=lapply(database, FUN=function(x){ncol(x$timeSeries)-1})
dataPoints=lapply(database, FUN=function(x){length(as.matrix(x$timeSeries))})

smr=list(entries=length(database),timeseries=sum(unlist(timeseries)), datapoints=sum(unlist(dataPoints)))
as.yaml(smr)

# Print yaml data for website
write_yaml(smr, file="~/sidb/docs/_data/summary.yml")

# Compute coordinate
coor=coordinates(database)

png("~/sidb/docs/assets/map.png", bg=NA)
map('world', interior = FALSE)
points(coor, pch=20, col=2)
dev.off()

# Compute incubation times
it=incubationTime(database)

png("~/sidb/docs/assets/incubationTime.png", bg=NA)
hist(it, xlab="Incubation time (days)", main ="", ylab="Number of studies")
dev.off()
