#' Read single entry of the sidb
#'
#' @param path character string with the path where isdb is stored
#' @param entryName character string with the name of the entry in the database
#' @return R list with the entry
#' @export
#' @import yaml
#' @examples
#' Andrews2000SBB=readEntry(entryName="Andrews2000SBB")
readEntry <- function(path="~/sidb/data/", entryName) {

    entry=yaml::yaml.load_file(input=paste(path,entryName,"/metadata.yaml",sep=""),handlers=list("float#fix"=function(x) as.character(x)))
    ts_data_csv=read.csv(file=paste(path,entryName,"/timeSeries.csv",sep=""))
    entry[["timeSeries"]]<-ts_data_csv
    init=read.csv(file=paste(path,entryName,"/initConditions.csv",sep=""))
    entry[["initConditions"]]<-init

    assign(entryName, entry)

    return(entry)
}
