#R codes to reconstruct the histograms in the manuscript
devtools::install_github('SoilBGC-Datashare/sidb/Rpkg', force=TRUE)
library(sidb)

#The database
database = loadEntries("~/sidb/data/")

#Hist1: Incubation time
incubTimes=incubationTime(database=database)

#Hist2: Incubation temperature
tempList <- list()
for(x in database){
  if(is.null(x$incubationInfo$temperature) == FALSE){
    topLvlTemp <- x$incubationInfo$temperature
    tempList <- append(tempList, topLvlTemp)
} else {
  y <- x$variables
  varTempList <-list()
  for(z in y){
    if(z$name != 'time'){
      varTempList <- append(varTempList, z$temperature)
    }
  }
  varTempList <- unique(varTempList)
  if(length(varTempList) != 0){
    tempList <- append(tempList, varTempList)
  }}
}
tempList <- unlist(tempList)

#Hist 3: Soil depth
depthList <- list()
for(x in database){
  if(is.null(x$incubationInfo$depthInfo$midDepth) == FALSE){
    depthList <- append(depthList, x$incubationInfo$depthInfo$midDepth)
  } else {
  y <- x$variables
  varDepthList <- list()
  for(z in y){
    if(z$name != 'time'){
      if(is.null(z$midDepth) == FALSE){
        varDepthList <- append(varDepthList, z$midDepth)
      }}}
  varDepthList <- unique(varDepthList)
  if(length(varDepthList) != 0){
    depthList <- append(depthList, varDepthList)
    }}
}
depthList <- unlist(depthList)

#Initial Carbon content, all the units has been converted to the percent
listC=list()
for(x in database){
  if(is.null(levels(x$initConditions$carbonUnits[1])) == FALSE){
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
     xlim=c(0,1000),
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

hist(depthList,
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

