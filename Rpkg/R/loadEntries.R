#' Load entries of the sidb
#'
#' @param path character string with the path where isdb is stored
#' @return R list with all entries
#' @export
#' @examples
#' sidb=loadEntries()
loadEntries <- function(path="~/sidb/data/") {
  entryNames=list.dirs(path, full.names=FALSE, recursive=FALSE)

  sidbList=lapply(entryNames, FUN=readEntry, path=path)
  names(sidbList)<-entryNames

 return(sidbList)
}


