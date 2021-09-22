packs <- c('SoilR', 'sidb', 'R.utils', 'dplyr')
sapply(packs, require, character.only=TRUE)
rm(list=ls())
############
db=loadEntries(path="~/sidb/data/")
db_flat=flatterSIDb(db)
##################
modelLoop <- function(db, ts.col, ic.col, unitConverter,
                      inipars=list(oneP=0.5,
                                   parallel=c(0.01, 0.001, 0.1), 
                                   series=c(0.05, 0.0001, 0.01, 0.1), 
                                   feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01))){
  # Models
  print("One pool model")
  M0=onePoolFlux(timeSeries = db$timeSeries[,c(1,ts.col)], 
                 initialCarbon=db$initConditions[ic.col,"carbonMean"]*unitConverter, 
                 inipars= inipars[["oneP"]])
  print("Two pool model-parallel structure")
  M1=twoppFit(timeSeries = db$timeSeries[,c(1,ts.col)], 
              initialCarbon=db$initConditions[ic.col,"carbonMean"]*unitConverter, 
              inipars= inipars[["parallel"]])
  print("Two pool model-Series structure")
  M2=twopsFit(timeSeries = db$timeSeries[,c(1,ts.col)], 
              initialCarbon=db$initConditions[ic.col,"carbonMean"]*unitConverter, 
              inipars= inipars[["series"]])
  print("Two pool model-feedback structure")
  M3=twopfFit(timeSeries = db$timeSeries[,c(1,ts.col)], 
              initialCarbon=db$initConditions[ic.col,"carbonMean"]*unitConverter, 
              inipars= inipars[["feedback"]])
  
  #Extracting model info
  days=M0$SoilRmodel@times
  Mlist=list(M0, M1, M2, M3)
  modelNames=c("One-pool","Two-pool parallel" , "Two-pool series","Two-pool feedback")
  Rt=lapply(Mlist, function(x){getReleaseFlux(x$SoilRmodel)})
  
  # Plot all models together_ model prediction in lines, observed flux in points
  par(mfrow=c(2,2))
  for (i in c(1:4)){
    matplot(days, Rt[[i]], type="l", lty=1, ylab=db$variables$V2$units, xlab="Day", 
            main=modelNames[i])
    points(db$timeSeries[, c(1,ts.col)], pch=19, cex=0.5)}
  par(mfrow=c(1,1))
  
  # Calculating the AIC
  AIC=sapply(Mlist, function(x){AIC=x$AIC})
  K=sapply(Mlist, function(x){length(x$FMEmodel$par)})
  n=nrow(db$timeSeries[ , c(1, ts.col)])
  
  AICc=list=NULL
  for (i in 1:length(Mlist)){
    AICc[[i]]= AIC[[i]] + ( (2*K[[i]]* (K[[i]]+1)) / (n-K[[i]]-1))
  }
  AICmin=min(unlist(AICc))
  
  delta_i=list(NULL)
  for(i in 1:length(AICc)){
    delta_i[[i]]=AICc[[i]]-AICmin
  }
  
  # Weighted AIC
  wi=list(NULL)
  for(i in 1:length(delta_i)){
    wi[[i]]=exp(-0.5 * delta_i[[i]])/
      (exp(-0.5* delta_i[[1]]) + exp(-0.5*delta_i[[2]]) + exp(-0.5*delta_i[[3]]) )
  }
  
  ## Transit Time ##
  
  ####one-pool model####
  # SATT1=stock/u1
  tt0=db$initConditions[ic.col,"carbonMean"]*unitConverter
  
  ### two Prallel-pool model###
  gam=M1$SoilRmodel@initialValues
  k=M1$FMEmodel$par[1:2]  
  A1=diag(-k)  # This is the same as a1=M1$SoilRmodel@mat@map()
  uM1=c((k[1]*gam[1]/(k[1]*gam[1]+k[2]*gam[2])) ,
        (k[2]*gam[2]/(k[1]*gam[1]+k[2]*gam[2])) ) # for the transit time model it doesn't matter if we use the value u or the proportion of u
  
  tt1=transitTime(A = A1, u = uM1, q = 0.5, a = 0)
  
  #### two series-pool model####
  a2=M2$SoilRmodel@mat@map()
  tt2=transitTime(A = a2, u=c(1,0), q=0.5, a=0)
  
  #### two feedback pool model####
  a3=M3$SoilRmodel@mat@map()
  tt3=transitTime(A = a3, u=c(1,0), q=0.5, a=0)
  
  TT=c(tt0, tt1$meanTransitTime, tt2$meanTransitTime, tt3$meanTransitTime)
  q05=c(NA, tt1$quantiles, tt2$quantiles, tt3$quantiles)
  
  # Model parameters to be collected in the table
  k1=sapply(Mlist, function(x){x$FMEmodel$par[1]})
  k2=sapply(Mlist, function(x){x$FMEmodel$par[2]})
  pC0= c(NA, M1$FMEmodel$par[3], M2$FMEmodel$par[4], M3$FMEmodel$par[5])
  a21=c(NA, NA, M2$FMEmodel$par[3], M3$FMEmodel$par[3])
  a12=c(NA, NA ,NA , M2$FMEmodel$par[4])
  
  SSR=sapply(Mlist, function(x){x$FMEmodel$ssr}) 
  MSR=sapply(Mlist, function(x){x$FMEmodel$ms})
  
  tbldb <- data.frame(model=modelNames, AIC=AIC, k1=k1, k2=k2, 
                      C0Inp1=pC0, a21=a21, a12=a12, AICc= unlist(AICc), 
                      wi=unlist(wi), MeanTrT=TT, q05=q05, SSR=SSR, MSR=MSR )
  
  tbldb=tbldb %>% 
    mutate_if(is.numeric, funs(signif(., 3)))
  
  data=list("one-pool"= M0,
            "two-pool Parallel"= M1,
            "two-pool Series"= M2,
            "two-pool Feedback"= M3,
            "AIC"= AIC,
            "k1"= k1,
            "k2"= k2,
            "C0 in pools"= pC0,
            "a21"= a21,
            "a12"= a12,
            "AICc"= unlist(AICc),
            "Wighted AIC"= unlist(wi),
            "TransitTime"= TT,
            "quantile5"= q05,
            "Sum of squared residuals"= SSR,
            "Mean squared residulas"=MSR)

  
  # Saving the summary statistic of each timeSeries as "entryName_VariableNumber.RData" 
  entryName= paste(db$citationKey, "_", ts.col, sep="")
  assign(entryName, data)
  
  rDatafile=paste("~/sidb/manuscript/man2data/", db$citationKey,"_",ts.col, sep = "")
  
  save(list=entryName, file = paste0(rDatafile, '.RData') )
}

#Analysing each timeSerie of the entry Crow2019a. A file of the results will be saved in the folrder "~/sidb/manuscript/man2data/". I changed the inipars values whenever there was an error.  

# inipars=list(oneP=0.5,
#              parallel=c(0.01, 0.001, 0.1), 
#              series=c(0.05, 0.0001, 0.01, 0.1), 
#              feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01))

V2=modelLoop(db = db[[9]], ts.col = 2, ic.col = 1, unitConverter = 1e3)

V3=modelLoop(db = db[[9]], ts.col = 3, ic.col = 2, unitConverter = 1e3) #, 
#load("~/sidb/manuscript/man2data/Crow2019a_3.RData")             
V4=modelLoop(db = db[[9]], ts.col = 4, ic.col = 3, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1))) 

V5=modelLoop(db = db[[9]], ts.col = 5, ic.col = 4, unitConverter = 1e3)

V6=modelLoop(db = db[[9]], ts.col = 6, ic.col = 5, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))

V7=modelLoop(db = db[[9]], ts.col = 7, ic.col = 6, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))

V8=modelLoop(db = db[[9]], ts.col = 8, ic.col = 7, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.01, 0.0001, 0.01, 0.1), 
                          feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))

V9=modelLoop(db = db[[9]], ts.col = 9, ic.col = 8, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.01, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)))

V10=modelLoop(db = db[[9]], ts.col = 10, ic.col = 9, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.01, 0.001, 0.1, 0.01, 0.01)))
# The models get fitted but the folowing error prevents the data to be saved
# Error in solve.default(A) : 
#   system is computationally singular: reciprocal condition number = 1.37957e-17

V11=modelLoop(db = db[[9]], ts.col = 11, ic.col = 10, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1), 
                           series=c(0.01, 0.0001, 0.01, 0.1), 
                           feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)))

V12=modelLoop(db = db[[9]], ts.col = 12, ic.col = 11, unitConverter = 1e3)

V13=modelLoop(db = db[[9]], ts.col = 13, ic.col = 12, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.05, 0.0005, 0.01, 0.1),
                           feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)) )

V14=modelLoop(db = db[[9]], ts.col = 14, ic.col = 13, unitConverter = 1e3 )

V15=modelLoop(db = db[[9]], ts.col = 15, ic.col = 14, unitConverter = 1e3 )

V16=modelLoop(db = db[[9]], ts.col = 16, ic.col = 15, unitConverter = 1e3 )

V17=modelLoop(db = db[[9]], ts.col = 17, ic.col = 16, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.01, 0.0001, 0.05, 0.1),
                           feedback=c(0.05, 0.0005, 0.1, 0.01, 0.01)))

V18=modelLoop(db = db[[9]], ts.col = 18, ic.col = 17, unitConverter = 1e3 )

V19=modelLoop(db = db[[9]], ts.col = 19, ic.col = 18, unitConverter = 1e3,
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.01, 0.0001, 0.05, 0.1),
                           feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))

V20=modelLoop(db = db[[9]], ts.col = 20, ic.col = 19, unitConverter = 1e3 )

V21=modelLoop(db = db[[9]], ts.col = 21, ic.col = 20, unitConverter = 1e3,
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.01, 0.0001, 0.01, 0.1),
                           feedback=c(0.01, 0.0001, 0.1, 0.01, 0.01)) )

V22=modelLoop(db = db[[9]], ts.col = 22, ic.col = 11, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.05, 0.0001, 0.01, 0.1),
                           feedback=c(0.01, 0.0001, 0.1, 0.01, 0.01)) )

V23=modelLoop(db = db[[9]], ts.col = 23, ic.col = 22, unitConverter = 1e3 )

V24=modelLoop(db = db[[9]], ts.col = 24, ic.col = 23, unitConverter = 1e3 )

V25=modelLoop(db = db[[9]], ts.col = 25, ic.col = 24, unitConverter = 1e3 )

V26=modelLoop(db = db[[9]], ts.col = 26, ic.col = 25, unitConverter = 1e3 )

V27=modelLoop(db = db[[9]], ts.col = 27, ic.col = 26, unitConverter = 1e3 )

V28=modelLoop(db = db[[9]], ts.col = 28, ic.col = 27, unitConverter = 1e3 )

V29=modelLoop(db = db[[9]], ts.col = 29, ic.col = 28, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.05, 0.0001, 0.01, 0.1),
                           feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)) )

V30=modelLoop(db = db[[9]], ts.col = 30, ic.col = 29, unitConverter = 1e3 )


# file=list.files(path = "~/sidb/manuscript/man2data/", 
#                 full.names = FALSE, recursive = FALSE)
# list.sidb <- lapply(file, FUN = load, path="~/sidb/manuscript/man2data/")
# loadRData <- function(path){
#   RDataNames=list.files(path, full.names = FALSE, recursive = FALSE)
#   
#   dataList=lapply(RDataNames, FUN = load)
#   names(dataList) <- RDataNames
#   
#   return(dataList)
# }
# 
# loadRData("~/sidb/manuscript/man2data/")
treatmentLevels(database = db, treatment = "moisture")
treatmentLevels(sidb, "moisture", "percentFieldCapacity")

# data= list.files(path = "~/sidb/manuscript/man2data/", full.names = TRUE, recursive = FALSE)
# dataAll=lapply(data, FUN = load)
# load("~/sidb/manuscript/man2data/Crow2019a_11.RData")
# 
# data=list.dirs(path = "~/sidb/manuscript/man2data/", full.names = FALSE, recursive = FALSE)


