#' Reports what fields are missing from an entry in relation to a template
#'
#' @param entry An entry from the sidb database
#' @param template A template of sidb created from a yaml file
#' @return A data.frame with the latitude and longitude of sites from the database
#' @export
#' @examples
#' \dontrun{
#' template=yaml::yaml.load_file(input="~/sidb/data/template_metadata.yaml")
#' missingFields(entry=sidb[[1]], template = template)
#' }

missingFields=function(entry, template){
  l1=names(template) %in% names(entry)[-(11:12)]
  m1=match(FALSE, l1)
  n1=names(template)[l1==FALSE]
  if(length(n1)==0) message("1: all good at the upper level")
   else message(paste("1: ", toString(n1), "is missing at the upper metadata level"))

  l2=names(template$siteInfo) %in% names(entry$siteInfo)
  m2=match(FALSE, l2)
  n2=names(template$siteInfo)[l2==FALSE]
  if(length(n2)==0) message("2: all good at the siteInfo level")
   else message(paste("2: ", toString(n2), "is missing at the siteInfo level"))

  l3=names(template$incubationInfo) %in% names(entry$incubationInfo)
  m3=match(FALSE, l3)
  n3=names(template$incubationInfo)[l3==FALSE]
  if(length(n3)==0) message("3: all good at the incubationInfo level")
  else message(paste("3: ", toString(n3), "is missing at the incubationInfo level"))
}
