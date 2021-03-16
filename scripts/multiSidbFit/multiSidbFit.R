multiSibdFit <- structure(function #Multiple Sidb-model fitting 
### This function processes data bases from \code{\link{load_entries}}
### to recursivelly fit models in \code{\link{sidb}}
(
    db, ##<<\code{list}. data base such as that produced by
        ##\code{\link{loadEntries}}.
    model = 'twopsFit', ##<<\code{character}. Model name. It can be
                        ##\code{'twoppFit'}, \code{'twopsFit'},
                        ##\code{'threeppFit'}, \code{'threepsFit'},
                        ##among other, see documentation of
                        ##\code{\link{sidb}.
    ts.col = 2:3, ##<<\code{numeric}. Time-series columns in the
    ##\code{'timeSeries'} object of \code{'db'}.
    ic.col = 1, ##<<\code{numeric}. Row number in the
                ##\code{'initConditions'} object having a
                ##\code{"carbonMean"} value
    inipars = c(0.05, 0.00001, 0.1, 0.01) ##<<\code{numeric}. Vector
                                          ##of starting
                                          ##parameters. Number of
                                          ##parameters depend on the
                                          ##fitted model.
) {
    dts <- c('timeSeries','initConditions','carbonMean')
    dt_needed  <- all(dts[1:2]%in%names(db))
    if(!dt_needed)
        stop(paste0("Missing data: be sure data sets '",
                    paste(dts[1:2], collapse ="' and '"),
                    "' are included in 'db'"))
    condf <- function(y, model, ic.col, inipars){
        ## inp <- list(timeSeries = db$'timeSeries'[,c(1,y)],
        ## initialCarbon = db$'initConditions'[ic.col,"carbonMean"]*1E4,
        inp <- list(timeSeries = db[[dts[1L]]][,c(1,y)],
                    initialCarbon = db[[dts[2L]]][ic.col,dts[3L]]*1E4,
                    inipars = inipars)
        mod <- tryCatch(do.call(model, inp),
                        error = function(e) return(NA))
        return(mod)}
    if(is.null(ts.col))
        ts.col <- 2:ncol(db$'timeSeries')
    ic <- Map(function(x)
        condf(x, model, ic.col, inipars), ts.col)
    names(ic) <- ts.col
    return(ic)
### \code{list}. Model parameters
} , ex=function() {

})
