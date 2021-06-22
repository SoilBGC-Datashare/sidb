TwopModel_SidB <-  function(
  db, model='twoppFit', ts.col=2:3, ic.col=1, inipars=c(0.01, 0.001, 0.1)){
  dts <- c('timeSeries', 'initConditions', 'carbonMean')
  dt_needed <- all(dts[1:2] %in% names(db))
  if(!dt_needed)
      stop(paste0("Missing data: be sure the objects '", 
                  paste(dts[1:2], collapse = "' and '"), 
                  "' are includedin 'db'"))
  
  condf <- function(y, model , ic.col, inipars){
    inp <- list(timeSeries=db[[dts[1L]]][ , c(1,y)], 
                initialCarbon= db[[dts[2L]]][ic.col, dts[3L]]*1e4, 
                inipars=inipars)
    mod <- tryCatch(do.call(model, inp), 
                    error = function(e) return(NA))
    return(mod)}
  
  if(is.null(ts.col))
    ts.col=2:ncol(db[[dts[1L]]])
  ic <- Map(function(x)
        condf(x, model, ic.col, inipars), ts.col)
  #db_plot <- plotEntry(db)
  names(ic) <- ts.col
  return(ic)
  
  days=mod[[]]
}



# 
# MultiFit <- function(db,...){
#   Map(function(db, ...)
#     multiSidbFit(db, ...),
#     MoreArgs = list(db = db), ...)
# }

myMod <- TwopModel_SidB(db = ds15, model = 'twoppFit', ts.col = 2, ic.col = 1, 
               inipars = twopp_inipars)



source.R <- file.path('sidb/scripts/multiSidbFit')
sourceDirectory(source.R, modifiedOnly = TRUE, verbose = TRUE)
twopsFit_model <- multiSidbFit(ds15,
                        model = 'twopsFit',
                        ic.col = list(1),
                        ts.col = list(2),
                        inipars=c(0.05, 0.00001, 0.1, 0.01))


Mod1_152=twoppFit(timeSeries = ds15$timeSeries[,c(1,2)], initialCarbon = iniC_SasNG*1e4, inipars = twopp_inipars ) #c(0.1, 0.1, 0.1)
Mod2_152=twopfFit(timeSeries = ds15$timeSeries[, c(1,2)], initialCarbon =iniC_SasNG*1e4, inipars =twopf_inipars) 
Mod3_152=twopsFit(timeSeries = ds15$timeSeries[, c(1,2)], initialCarbon =iniC_SasNG*1e4, inipars = c(0.001, 1e-5, 0.15, 0.01))

mod152 <- MultiFit(db=ds15, model=c('twoppFit','twopfFit', 'twopsFit'), 
                   inipars =list(twopp_inipars, twopf_inipars, twops_inipars), 
                   ic.col=list(1), 
                   ts.col=list(2))

Mod1_152$SoilRmodel@times
print(paste(modelNames152[1], c("k1=", "k2=", "proportion of C0 in pool 1="), Mod1_152$FMEmodel$par))
print(paste(modelNames152[1], "AIC = ", Mod1_152$AIC))
days152=Mod1_152$SoilRmodel@times
Mlist152=list(Mod1_152, Mod2_152, Mod3_152)

complete=data.frame(time=ts[complete.cases(ts),1],Rt=ts[complete.cases(ts),2] )
tt=seq(from=0, to=tail(complete[,1],1), length.out = 500)

ts=ds15$timeSeries[ ,c(1,2)]
time=ts[complete.cases(ts),1]
Rt=ts[complete.cases(ts),2]

Rs152=sapply(Mlist152, function(x){rowSums(getReleaseFlux(x$SoilRmodel))})


modelNames152=c("Two-pool parallel" ,"Two-pool feedback", "Two-pool series")
Rt152=lapply(Mlist152, function(x){getReleaseFlux(x$SoilRmodel)})


par(mfrow=c(2,2))
for(i in c(1:3)){
  matplot(days152, Rt152[[i]], type="l", lty = 1, ylab = ds15$variables$V2$units, xlab="Day", 
          main=modelNames152[i])
  points(ds15$timeSeries[, c(1,2)], pch=19, cex=0.5)
}
par(mfrow=c(1,1))

Mod1_152$FMEmodel$par
Mod2_152$FMEmodel$par
Mod3_152$FMEmodel$par

aic <- sapply(Mlist152, function(x){x$AIC})
k1 <- sapply(Mlist152, function(x){x$FMEmodel$par[1]})
k2 <- sapply(Mlist152, function(x){x$FMEmodel$par[2]})
pC0 <- sapply(Mlist152, function(x){x[[1]]$FMEmodel$par})
pC01 <- Mod1_152$FMEmodel$par[3]
pC02 <- Mod2_152$FMEmodel$par[5]

Mlist152[[1]]$FMEmodel$par[3]


tbldb152 <- data.frame(model=modelNames152, AIC=aic, k1= k1, k2=k2)
knitr::kable(tbldb152)
ds15$initConditions$site
ds15$initConditions['', 'carbonMean']
ds15$variables$V2$site
Fun_SidBmodel <- function(db, ts.col, ic.col, 
                          inipars= list(c(0.01, 0.001, 0.1),
                                        c(5e-03, 1e-05, 0.1, 0.01, 0.01), 
                                        c(5e-03, 1e-05, 0.1, 0.01))){
  mod1 <- twoppFit(timeSeries = db$timeSeries[, c(1,ts.col)], initialCarbon = db$initConditions[ic.col, 'carbonMean']*1e4, 
                     inipars = inipars[[1]])
  mod2 <- twopfFit(timeSeries = db$timeSeries[, c(1,ts.col)], initialCarbon = db$initConditions[ic.col, 'carbonMean']*1e4, 
                   inipars = inipars[[2]])
  mod3 <- twopsFit(timeSeries = db$timeSeries[, c(1,ts.col)], initialCarbon = db$initConditions[ic.col, 'carbonMean']*1e4, 
                   inipars = inipars[[3]])
  
  days= mod1$SoilRmodel@times
  Mlist=list(mod1, mod2, mod3)
  modelNames=c("Two-pool parallel" ,"Two-pool feedback", "Two-pool series")
  Rt=lapply(Mlist, function(x){getReleaseFlux(x$SoilRmodel)})
  
  par(mfrow=c(2,2))
  for (i in c(1:3)){
    matplot(days, Rt[[i]], type="l", lty=1, ylab=db$variables$V2$units, xlab="Day", 
    main=modelNames[i])
    points(db$timeSeries[, c(1,ts.col)], pch=19, cex=0.5)}
  par(mfrow=c(1,1))
  
  aic=sapply(Mlist, function(x){AIC=x$AIC})
  k1=sapply(Mlist, function(x){x$FMEmodel$par[1]})
  k2=sapply(Mlist, function(x){x$FMEmodel$par[2]})

  pC0= c(mod1$FMEmodel$par[3], mod2$FMEmodel$par[5], mod3$FMEmodel$par[4])
  a21=c(NA, mod2$FMEmodel$par[3], mod3$FMEmodel$par[3])
  a12=c(NA, mod2$FMEmodel$par[4], NA)
  tbldb <- data.frame(model=modelNames, AIC=aic, k1=k1, k2=k2, "Proportion of C0 in pool 1"=pC0, a21=a21, a12=a12)
  knitr::kable(tbldb)
}
Fun_SidBmodel(db = ds15, ts.col = 2, ic.col = 1)
