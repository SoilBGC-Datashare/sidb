#' Load a single SIDb entry from entry files
#'
#' @param path character string with the path where SIDb entry files are stored
#' @param entryName character string with the name of the entry in the database
#' @return R list of the entry with the SIDb structure
#' @export
#' @import yaml
#' @examples
#' \dontrun{
#' Andrews2000SBB=readEntry(path="~/sidb/data/", entryName="Andrews2000SBB")
#' }
readEntry <- function(path, entryName) {

    entry=yaml::yaml.load_file(input=paste(path,entryName,"/metadata.yaml",sep="")) #,handlers=list("float#fix"=function(x) as.character(x)))
    ts_data_csv=read.csv(file=paste(path,entryName,"/timeSeries.csv",sep=""))
    entry[["timeSeries"]]<-ts_data_csv
    init=read.csv(file=paste(path,entryName,"/initConditions.csv",sep=""))
    entry[["initConditions"]]<-init

    assign(entryName, entry)

    return(entry)
}
