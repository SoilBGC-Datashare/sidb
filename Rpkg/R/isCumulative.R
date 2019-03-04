#' Test whether a time series of CO2 release is cummulative
#'
#' @param x A data.frame with only two columns, first column for time and second column for CO2 release. Test is performed on the second column.
#' @return logical
#' @export
#' @examples
#' series=data.frame(time=seq(1,10), CO2=cumsum(rep(0.1, 10)))
#' isCummulative(x=series)
isCumulative=function(x){
  if(class(x) != "data.frame") stop("This function can only be applied to objects of class data.frame")
  if(ncol(x) != 2) stop("This function can only be applied to data.frames with two columns")
  head(x[,2], 1) < tail(x[,2], 1)
}