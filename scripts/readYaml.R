
library(yaml)

tmp=yaml.load_file("~/Repos/sidb/data/Arevalo2012/metadata.yaml")
tmp=yaml.load_file("~/Repos/sidb/data/template_metadata.yaml")

str(tmp)

tmp$siteInfo$coordinates$latitude
tmp$incubationInfo$carbon
tmp$incubationInfo$Treatments$Temperature
