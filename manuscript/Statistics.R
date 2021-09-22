


dataName=list.files(path = "~/sidb/manuscript/man2data", pattern="*.RData", full.names = TRUE)


# Load
files <- list.files(path = "~/sidb/manuscript/man2data", pattern="*.RData", full.names = TRUE)

RdataList<- lapply(files, function(x) {
  load(file = x)
  get(ls())
})
nameFile <- list.files(path = "~/sidb/manuscript/man2data", full.names = FALSE, recursive = FALSE)
names(RdataList) <- nameFile 


##### Statistics #####

# A list of AIC for all entries
AIC=lapply(mylist, function(x){x$AIC})


#load each single data file separately
# rData=list()
# for(i in 1:length(files)){
#   as.list(load(files[i]))
# } 




# The following function will create a new environment and load the RData file in that new env.   
# env <- lapply(files, function(f){
#   e <- new.env()
#   load(f, envir=e)
#   e
# })







#############
path="~/sidb/manuscript/man2data/"
dataName= "Crow2019a_12"
dt= load(paste(path , dataName, ".RData", sep="") )

# Load one single rData file
dataEntry <- function(path, dataName){
  load(paste(path, dataName,  ".RData" , sep=""))
  #data[["rData"]] <- data
  #assign(dataName, data)
  get(ls())
}

#Load several rData file in one single list.file ==> didnt worked yet
loadData <- function(path) {
  dataNames=list.dirs(path, full.names=FALSE, recursive=FALSE)
  
  dataList=lapply(dataNames, FUN=dataEntry, path=path)
  names(dataList)<-dataNames
  
  return(dataList)
}

rdata=loadData(path)

x=dataEntry(path = path, dataName = "Crow2019a_13")
x


dataName=list.files(path = "~/sidb/manuscript/man2data", pattern="*.RData", full.names = TRUE)

dataName=as.list(dir(path = "~/sidb/manuscript/man2data/"))
lapply(dataName, load, environment() )


