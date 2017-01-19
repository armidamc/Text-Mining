library(xml2)
library(rjson)
library(jsonlite)
library(tm)
library(NLP)
library(XML)

#lee el archivo
csvdata <- read.csv("financieronews.csv", header=TRUE)
obs <- NROW(csvdata)
contenido <- url_unescape(csvdata[,1])
vector.cuerpo <- vector()
vector.titulo <- vector()
vector.fecha <- vector()
vector.facebook <- vector()
vector.soriana <- vector()
vector.gruma <- vector()
vector.femsa <- vector()
vector.bachoco <- vector()
vector.bimbo <- vector()
vector.amovil <- vector()
vector.ohl <- vector()
vector.asur <- vector()

#accede a las ligas y lee el contenido, lo convierte en texto limpio
mylist_ <- list()
for(i in 1:obs) {
  {
    mylist <- readLines(contenido[i])
    mylist <- htmlParse(mylist,handlers = NULL)
    mylist <- xpathSApply(mylist, "//p", xmlValue)
    mylist <- paste(mylist, collapse = ' ')
    vector.cuerpo[i] <- mylist
    vector.titulo[i] <- toString(csvdata[i,2])
    vector.fecha[i] <- csvdata[i,3]
    vector.facebook[i] <- grepl("Facebook",mylist)
    vector.soriana[i] <- grepl("Soriana",mylist)
    vector.gruma[i] <- grepl("Gruma",mylist)
    vector.femsa[i] <- grepl("Femsa",mylist)
    vector.bachoco[i] <- grepl("Bachoco",mylist)
    vector.bimbo[i] <- grepl("Bimbo",mylist)
    vector.amovil[i] <- grepl("AMóvil",mylist)
    vector.ohl[i] <- grepl("OHL",mylist)
    vector.asur[i] <- grepl("Asur",mylist)
  }
  mylist_[[i]] <- mylist
}

dataframe.textnews <- data.frame(bodynews=vector.cuerpo,title=vector.titulo,fecha=vector.fecha,facebook=vector.facebook,soriana=vector.soriana,amovil=vector.amovil,bachoco=vector.bachoco,bimbo=vector.bimbo,gruma=vector.gruma,femsa=vector.femsa,ohl=vector.ohl,asur=vector.asur)
write.csv(dataframe.textnews, file="financieronewsMining.csv", row.names=TRUE)
