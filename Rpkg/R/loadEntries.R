#' Load SIDb entries
#'
#' @param path character string with the path where SIDb entries are stored
#' @return R list with all entries with the SIDb structure
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
