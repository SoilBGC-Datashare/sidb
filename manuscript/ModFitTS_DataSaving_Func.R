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
