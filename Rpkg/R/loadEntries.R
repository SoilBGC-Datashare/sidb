#' Load entries of the sidb
#'
#' @param path character string with the path where sidb is stored
#' @return R list with all entries
#' @export
#' @examples
#' \dontrun{
#' sidb=loadEntries(path="~/sidb/data/")  # Assuming you downloaded 
#'                     # the sidb repository in your home directory
#' }
loadEntries <- function(path) {
  entryNames=list.dirs(path, full.names=FALSE, recursive=FALSE)

  sidbList=lapply(entryNames, FUN=readEntry, path=path)
  names(sidbList)<-entryNames

 return(sidbList)
}


