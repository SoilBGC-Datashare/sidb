#' Load SIDb entries
#'
#' @param path character string with the path where SIDb entries are stored
#' @return R list with all entries with the SIDb structure
#' @export
#' @examples
#' # Two entries are included as examples in the sidb R package
#' # The path should be changed to a local directory where you store sidb entries
#' sidbEx <- loadEntries(path = paste0(system.file("extdata", "sidbEntries",
#'  package = "sidb"), "/"))

loadEntries <- function(path) {
  entryNames=list.dirs(path, full.names=FALSE, recursive=FALSE)

  sidbList=lapply(entryNames, FUN=readEntry, path=path)
  names(sidbList)<-entryNames

 return(sidbList)
}
