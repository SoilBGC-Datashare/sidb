#' Multiple model fitting
#'
#' @param db Data base with time series of respiration values and
#'     initial amount of carbon
#' @param model set of pool models 
#' @param ts.col List of column numbers in respiration time series 
#' @param ic.col List of row numbers in the data of initial carbon
#' @param inipars List of initial parameters
#' @export
#' @import
#' @examples
#'\donttest{
#'tmp <- MultiFit(db, model = c('twoppFit',
#'                              'twopsFit',
#'                              'twopfFit',
#'                              'threeppFit',
#'                              'threepsFit'),
#'                inipars = list(c(0.01, 0.001, 0.1),
#'                               c(0.05, 0.00001, 0.1, 0.01),
#'                               c(0.005, 0.00001, 0.1, 0.01, 0.01),
#'                               c(0.05, 0.01, 0.001, 0.1, 0.1),
#'                               c(0.9,0.01, 0.000001, 0.01, 0.01, 0.01, 0.1)),
#'                ic.col = list(78),
#'                ts.col = list(75:79))
#'}
#'

multiSidbFit <- function(
    db, model = 'twopsFit',ts.col = 2:3, ic.col = 1, inipars = c(0.05, 0.00001, 0.1, 0.01)){
    dts <- c('timeSeries','initConditions','carbonMean')
    dt_needed  <- all(dts[1:2]%in%names(db))
    if(!dt_needed)
        stop(paste0("Missing data: be sure the objects '",
                    paste(dts[1:2], collapse ="' and '"),
                    "' are included in 'db'"))
    condf <- function(y, model, ic.col, inipars){
        inp <- list(timeSeries = db[[dts[1L]]][,c(1,y)],
                    initialCarbon = db[[dts[2L]]][ic.col,dts[3L]]*1E4,
                    inipars = inipars)
        mod <- tryCatch(do.call(model, inp),
                        error = function(e) return(NA))
        return(mod)}
    if(is.null(ts.col))
        ts.col <- 2:ncol(db[[dts[1L]]])
    ic <- Map(function(x)
        condf(x, model, ic.col, inipars), ts.col)
    names(ic) <- ts.col
    return(ic)
} 


MultiFit <- function(db,...){
    Map(function(db, ...)
        multiSidbFit(db, ...),
        MoreArgs = list(db = db), ...)
    }
