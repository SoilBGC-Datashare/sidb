
library(sidb)
library(rcrossref)

sidb=loadEntries()
dois=sapply(sidb, function(x){x$doi})

a=sapply(dois,FUN=cr_cn, format="text", style="apa", USE.NAMES = FALSE)
n=length(a)

# Yaml front matter
front="---"
f1="layout: post"
f2="title: References"

# Body
h1="## Studies within SIDB "
p1=paste("Currently, there are", n, "entries in SIDB, which are from the following publications:")

# Print markdown file for website
cat(c(front, f1, f2, front, " ",
      h1, p1, " ", paste("* ",a)), sep="\n", file="~/sidb/docs/references.md")



