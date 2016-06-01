
library(yaml)

arev=yaml.load_file("~/sidb/data/Arevalo2012/metadata.yaml") # Fails
and=yaml.load_file("~/sidb/data/Andrews2000SBB/metadata.yaml")
tmp=yaml.load_file("~/sidb/data/template_metadata.yaml")

str(tmp)

tmp$siteInfo$coordinates$latitude
tmp$incubationInfo$carbon
tmp$incubationInfo$Treatments$Temperature

str(and)

and$variables
and$incubationInfo$Treatments$Temperature
