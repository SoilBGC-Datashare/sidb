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

    entry=yaml::yaml.load_file(input=paste(path,entryName,"/metadata.yaml",sep=""))
    csv=read.csv(file=paste(path,entryName,"/data.csv",sep=""))
    entry[["data"]]<-csv
    assign(entryName, entry)

    return(entry)
}
