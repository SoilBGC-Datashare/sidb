#R codes to reinstruct the histograms in the manuscript
devtools::install_github('SoilBGC-Datashare/sidb/Rpkg', force=TRUE)
library(sidb)

#the database 
database = loadEntries("~/sidb/clean/") #change to the data

#Hist1: The incubation time
incubTimes=incubationTime(database=database)

# The temperature list
tempList <- list()
for(x in database){
  if(is.null(x$incubationInfo$temperature) == FALSE){
    temper <- x$incubationInfo$temperature
    tempList <- append(tempList, temper)
  } else {
    temper <- x$incubationInfo$laboratoryTreatment$temperature$value
    tempList <- append(tempList, temper)
  }
}
tempList <- unlist(tempList)

# Soil depth as a site information
depth= function(database){
  mean=lapply(database, FUN=function(x){x$siteInfo$depthInfo$midDepth})
  return(data.frame(depth=unlist(mean)
  ))
}
depth=depth(database)

#Initial Carbon content, all the units has been converted to the percent
listC=list()
for(x in database){
  if(is.null(levels(x$initConditions$carbonUnits[1]))){
  }
  else{
    if(x$initConditions$carbonUnits == 'g/gSoil'){
      perC <- as.list(x$initConditions$carbonMean * 100)
      listC <- append(listC,  perC)}
    if(x$initConditions$carbonUnits == 'percent'){
      perC <- as.list(x$initConditions$carbonMean)
      listC <- append(listC, perC)}
    if(x$initConditions$carbonUnits == 'g/kg'){
      perC <- as.list(x$initConditions$carbonMean / 10)
      listC <- append(listC, perC)}
    if(x$initConditions$carbonUnits == 'mgC/gSoil'){
      perC <- as.list(x$initConditions$carbonMean / 10)
      listC <- append(listC, perC)}
    if(x$initConditions$carbonUnits == 'gC/kgSoil'){
      perC <- as.list(x$initConditions$carbonMean / 10)
      listC <- append(listC, perC)}
    if(x$initConditions$carbonUnits == 'mg/gSoil'){
      perC <- as.list(x$initConditions$carbonMean / 10)
      listC <- append(listC, perC)}
  }
}

listC=unlist(listC)

# Now the Histograms

par(mfrow=c(2,2))
hist(incubTimes, 
     freq=FALSE, 
     main="Incubation Time", 
     xlab="Time (days)", 
     border="black", 
     col="gray",
     cex.main=1.4,cex.lab=1.1, cex.axis=0.9,font.lab=2 ,
     #xlim=c(0,1000),
     #ylim = c(0,10),
     las=1, 
     breaks=seq(0,1000, l=9))

hist(tempList,
     freq=FALSE, 
     main="Incubation Temperature", 
     xlab="Temperature (˚C)", 
     border="black", 
     col="gray",
     cex.main=1.4,cex.lab=1.1, cex.axis=0.9,font.lab=2 ,
     #xlim=c(0,40),
     ylim = c(0,0.05),
     las=1,
     breaks = seq(0, max(tempList), l=9))
#breaks=seq(0,max(temperature), l=11))

hist(listC, 
     freq=FALSE, 
     main="Initial Soil Carbon Content", 
     xlab="Percent Carbon", 
     border="black", 
     col="gray",
     cex.main=1.4,cex.lab=1.1, cex.axis=0.9,font.lab=2 ,
     #xlim=c(0,100),
     ylim = c(0,0.1),
     las=1, 
     breaks=seq(0,50, l=9))

hist(depth$depth,
     freq=FALSE, 
     main="Soil Depth", 
     xlab="Soil Depth (cm)", 
     border="black", 
     col="gray",
     cex.main=1.4,cex.lab=1.1, cex.axis=0.9,font.lab=2 ,
     #xlim=c(0,135),
     ylim = c(0,0.04),
     las=1, 
     breaks = 9)
#breaks=seq(0,max(depth$depth), l=11))

par(mfrow=c(1,1))

