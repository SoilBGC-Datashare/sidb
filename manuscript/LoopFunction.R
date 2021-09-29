packs <- c('SoilR', 'sidb', 'R.utils', 'dplyr')
sapply(packs, require, character.only=TRUE)
rm(list=ls())
############
db=loadEntries(path="~/sidb/data/")
db_flat=flatterSIDb(db)
##################
modelFitTS <- function(db, ts.col, ic.col, unitConverter,
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

V2=modelFitTS(db = db[[9]], ts.col = 2, ic.col = 1, unitConverter = 1e3)

V3=modelFitTS(db = db[[9]], ts.col = 3, ic.col = 2, unitConverter = 1e3) #, 
#load("~/sidb/manuscript/man2data/Crow2019a_3.RData")             
V4=modelFitTS(db = db[[9]], ts.col = 4, ic.col = 3, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1))) 

V5=modelFitTS(db = db[[9]], ts.col = 5, ic.col = 4, unitConverter = 1e3)

V6=modelFitTS(db = db[[9]], ts.col = 6, ic.col = 5, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))

V7=modelFitTS(db = db[[9]], ts.col = 7, ic.col = 6, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))

V8=modelFitTS(db = db[[9]], ts.col = 8, ic.col = 7, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.01, 0.0001, 0.01, 0.1), 
                          feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))

V9=modelFitTS(db = db[[9]], ts.col = 9, ic.col = 8, unitConverter = 1e3, 
             inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.01, 0.0001, 0.01, 0.1), 
                          feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)))

V10=modelFitTS(db = db[[9]], ts.col = 10, ic.col = 9, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                          parallel=c(0.01, 0.001, 0.1), 
                          series=c(0.05, 0.0001, 0.01, 0.1), 
                          feedback=c(0.01, 0.001, 0.1, 0.01, 0.01)))
# The models get fitted but the folowing error prevents the data to be saved
# Error in solve.default(A) : 
#   system is computationally singular: reciprocal condition number = 1.37957e-17

V11=modelFitTS(db = db[[9]], ts.col = 11, ic.col = 10, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1), 
                           series=c(0.01, 0.0001, 0.01, 0.1), 
                           feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)))

V12=modelFitTS(db = db[[9]], ts.col = 12, ic.col = 11, unitConverter = 1e3)

V13=modelFitTS(db = db[[9]], ts.col = 13, ic.col = 12, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.05, 0.0005, 0.01, 0.1),
                           feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01)) )

V14=modelFitTS(db = db[[9]], ts.col = 14, ic.col = 13, unitConverter = 1e3 )

V15=modelFitTS(db = db[[9]], ts.col = 15, ic.col = 14, unitConverter = 1e3 )

V16=modelFitTS(db = db[[9]], ts.col = 16, ic.col = 15, unitConverter = 1e3 )

V17=modelFitTS(db = db[[9]], ts.col = 17, ic.col = 16, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.01, 0.0001, 0.05, 0.1),
                           feedback=c(0.05, 0.0005, 0.1, 0.01, 0.01)))

V18=modelFitTS(db = db[[9]], ts.col = 18, ic.col = 17, unitConverter = 1e3 )

V19=modelFitTS(db = db[[9]], ts.col = 19, ic.col = 18, unitConverter = 1e3,
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.01, 0.0001, 0.05, 0.1),
                           feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))

V20=modelFitTS(db = db[[9]], ts.col = 20, ic.col = 19, unitConverter = 1e3 )

V21=modelFitTS(db = db[[9]], ts.col = 21, ic.col = 20, unitConverter = 1e3,
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.01, 0.0001, 0.01, 0.1),
                           feedback=c(0.01, 0.0001, 0.1, 0.01, 0.01)) )

V22=modelFitTS(db = db[[9]], ts.col = 22, ic.col = 11, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.05, 0.0001, 0.01, 0.1),
                           feedback=c(0.01, 0.0001, 0.1, 0.01, 0.01)) )

V23=modelFitTS(db = db[[9]], ts.col = 23, ic.col = 22, unitConverter = 1e3 )

V24=modelFitTS(db = db[[9]], ts.col = 24, ic.col = 23, unitConverter = 1e3 )

V25=modelFitTS(db = db[[9]], ts.col = 25, ic.col = 24, unitConverter = 1e3 )

V26=modelFitTS(db = db[[9]], ts.col = 26, ic.col = 25, unitConverter = 1e3 )

V27=modelFitTS(db = db[[9]], ts.col = 27, ic.col = 26, unitConverter = 1e3 )

V28=modelFitTS(db = db[[9]], ts.col = 28, ic.col = 27, unitConverter = 1e3 )

V29=modelFitTS(db = db[[9]], ts.col = 29, ic.col = 28, unitConverter = 1e3, 
              inipars=list(oneP=0.5,
                           parallel=c(0.01, 0.001, 0.1),
                           series=c(0.05, 0.0001, 0.01, 0.1),
                           feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)) )

V30=modelFitTS(db = db[[9]], ts.col = 30, ic.col = 29, unitConverter = 1e3 )
V31=modelFitTS(db = db[[9]], ts.col = 31, ic.col = 30, unitConverter = 1e3 )
V32=modelFitTS(db = db[[9]], ts.col = 32, ic.col = 31, unitConverter = 1e3 )
V33=modelFitTS(db = db[[9]], ts.col = 33, ic.col = 32, unitConverter = 1e3 )
V34=modelFitTS(db = db[[9]], ts.col = 34, ic.col = 33, unitConverter = 1e3 )
V35=modelFitTS(db = db[[9]], ts.col = 35, ic.col = 34, unitConverter = 1e3 )
V36=modelFitTS(db = db[[9]], ts.col = 36, ic.col = 35, unitConverter = 1e3,
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.01, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)))
##
V37=modelFitTS(db = db[[9]], ts.col = 37, ic.col = 36, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1)) )

V38=modelFitTS(db = db[[9]], ts.col = 38, ic.col = 37, unitConverter = 1e3 )
V39=modelFitTS(db = db[[9]], ts.col = 39, ic.col = 38, unitConverter = 1e3 )
V40=modelFitTS(db = db[[9]], ts.col = 40, ic.col = 39, unitConverter = 1e3 )
V41=modelFitTS(db = db[[9]], ts.col = 41, ic.col = 40, unitConverter = 1e3 )
V42=modelFitTS(db = db[[9]], ts.col = 42, ic.col = 41, unitConverter = 1e3 )
V43=modelFitTS(db = db[[9]], ts.col = 43, ic.col = 42, unitConverter = 1e3 )
V44=modelFitTS(db = db[[9]], ts.col = 44, ic.col = 43, unitConverter = 1e3 )
V45=modelFitTS(db = db[[9]], ts.col = 45, ic.col = 44, unitConverter = 1e3 )
V46=modelFitTS(db = db[[9]], ts.col = 46, ic.col = 45, unitConverter = 1e3 )
V47=modelFitTS(db = db[[9]], ts.col = 47, ic.col = 46, unitConverter = 1e3 )
V48=modelFitTS(db = db[[9]], ts.col = 48, ic.col = 47, unitConverter = 1e3 )
V49=modelFitTS(db = db[[9]], ts.col = 49, ic.col = 48, unitConverter = 1e3 )
V50=modelFitTS(db = db[[9]], ts.col = 50, ic.col = 49, unitConverter = 1e3 )
V51=modelFitTS(db = db[[9]], ts.col = 51, ic.col = 50, unitConverter = 1e3 )
V52=modelFitTS(db = db[[9]], ts.col = 52, ic.col = 51, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.01, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
V53=modelFitTS(db = db[[9]], ts.col = 53, ic.col = 52, unitConverter = 1e3 , 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
V54=modelFitTS(db = db[[9]], ts.col = 54, ic.col = 53, unitConverter = 1e3 )
V55=modelFitTS(db = db[[9]], ts.col = 55, ic.col = 54, unitConverter = 1e3 )
V56=modelFitTS(db = db[[9]], ts.col = 56, ic.col = 55, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )

V57=modelFitTS(db = db[[9]], ts.col = 57, ic.col = 56, unitConverter = 1e3 )
V58=modelFitTS(db = db[[9]], ts.col = 58, ic.col = 57, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )
V59=modelFitTS(db = db[[9]], ts.col = 59, ic.col = 58, unitConverter = 1e3 )
V60=modelFitTS(db = db[[9]], ts.col = 60, ic.col = 59, unitConverter = 1e3 )
V61=modelFitTS(db = db[[9]], ts.col = 61, ic.col = 59, unitConverter = 1e3 )
V62=modelFitTS(db = db[[9]], ts.col = 62, ic.col = 61, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )
V63=modelFitTS(db = db[[9]], ts.col = 63, ic.col = 62, unitConverter = 1e3 )
V64=modelFitTS(db = db[[9]], ts.col = 64, ic.col = 63, unitConverter = 1e3 )
V65=modelFitTS(db = db[[9]], ts.col = 65, ic.col = 64, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1))  )
V66=modelFitTS(db = db[[9]], ts.col = 66, ic.col = 65, unitConverter = 1e3 , 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.05, 0.0005, 0.1, 0.01, 0.1)))
V67=modelFitTS(db = db[[9]], ts.col = 67, ic.col = 66, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.05, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )

##
V68=modelFitTS(db = db[[9]], ts.col = 68, ic.col = 67, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.01, 0.001, 0.1),
                            series=c(0.01, 0.0005, 0.01, 0.1),
                            feedback=c(0.01, 0.0001, 0.1, 0.01, 0.1))  )
V69=modelFitTS(db = db[[9]], ts.col = 69, ic.col = 68, unitConverter = 1e3 )
V70=modelFitTS(db = db[[9]], ts.col = 70, ic.col = 69, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.05, 0.001, 0.1),
                            series=c(0.5, 0.0001, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)) )
V71=modelFitTS(db = db[[9]], ts.col = 71, ic.col = 70, unitConverter = 1e3)
V72=modelFitTS(db = db[[9]], ts.col = 72, ic.col = 71, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.05, 0.001, 0.1),
                            series=c(0.01, 0.0005, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
V73=modelFitTS(db = db[[9]], ts.col = 73, ic.col = 72, unitConverter = 1e3)
V74=modelFitTS(db = db[[9]], ts.col = 74, ic.col = 73, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.05, 0.001, 0.1),
                            series=c(0.01, 0.0005, 0.01, 0.1),
                            feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
V75=modelFitTS(db = db[[9]], ts.col = 75, ic.col = 74, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.1, 0.005, 0.1),
                            series=c(0.01, 0.005, 0.01, 0.1),
                            feedback=c(0.01, 0.005, 0.01, 0.01, 0.1)))
##
V76=modelFitTS(db = db[[9]], ts.col = 76, ic.col = 75, unitConverter = 1e3 , 
               inipars=list(oneP=0.5,
                            parallel=c(0.5, 0.001, 0.1),
                            series=c(0.01, 0.0005, 0.01, 0.1),
                            feedback=c(0.05, 0.0001, 0.1, 0.01, 0.1)))
V77=modelFitTS(db = db[[9]], ts.col = 77, ic.col = 76, unitConverter = 1e3)
V78=modelFitTS(db = db[[9]], ts.col = 78, ic.col = 77, unitConverter = 1e3, 
               inipars=list(oneP=0.5,
                            parallel=c(0.05, 0.001, 0.1),
                            series=c(0.01, 0.0005, 0.01, 0.1),
                            feedback=c(0.01, 0.0005, 0.1, 0.01, 0.1)))
V79=modelFitTS(db = db[[9]], ts.col = 79, ic.col = 78, unitConverter = 1e3)
############# End of Crow2019a ###################
#
#
############ Start with Sierra2017BG ############
Sierra_V2=modelFitTS(db = db[[24]], ts.col = 2, ic.col = 1, unitConverter = 10, 
                     inipars=list(oneP=0.5,
                                  parallel=c(0.1, 0.005, 0.1),
                                  series=c(0.1, 0.005, 0.01, 0.05),
                                  feedback=c(0.1, 0.005, 0.1, 0.01, 0.5)))
Sierra_V3=modelFitTS(db = db[[24]], ts.col = 3, ic.col = 1, unitConverter = 10, 
                     inipars=list(oneP=0.5,
                                  parallel=c(0.1, 0.001, 0.1), 
                                  series=c(0.1, 0.005, 0.05, 0.1), 
                                  feedback=c(0.1, 0.005, 0.1, 0.01, 0.01)))
Sierra_V4=modelFitTS(db = db[[24]], ts.col = 4, ic.col = 1, unitConverter = 10)

# inipars=list(oneP=0.5,
#              parallel=c(0.01, 0.001, 0.1), 
#              series=c(0.05, 0.0001, 0.01, 0.1), 
#              feedback=c(0.05, 0.0001, 0.1, 0.01, 0.01))
# inipars= list(c(0.05, 0.005, 0.1),
#               c(0.05, 0.00005, 0.1, 0.01, 0.01),
#               c(0.05, 0.00005, 0.1, 0.01))

