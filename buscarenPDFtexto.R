#install.packages("pdftools")

library(pdftools)
download.file("http://www.itvalledelguadiana.edu.mx/librosdigitales/Sigmund%20Freud%20-%20La%20interpretaci%C3%B3n%20de%20los%20sue%C3%B1os.pdf", "documento.pdf", mode = "wb")
txt <- pdf_text("documento.pdf")


vector.pagina <- c(txt)
dataframe.texto <- data.frame(PaginaView=(vector.pagina))
write.csv(dataframe.texto, file="txt/textminingPDF.txt", row.names=TRUE)

#install.packages("tm")
#install.packages("NLP")

library(NLP)
library(tm)

cname <- file.path(".","txt")
dir(cname)

corpus <- Corpus(DirSource(cname))
corpus
inspect(corpus[1])

corpus <- tm_map(corpus, tolower)
corpus <- tm_map(corpus, removeNumbers)
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, removeWords, stopwords("spanish"))
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, PlainTextDocument)

vector.remove <- c("freud","interpretación","sigmund","pues")
corpus <- tm_map(corpus, function(x) removeWords(x, vector.remove))

dtm <- DocumentTermMatrix(corpus)
dtm
freq <- colSums(as.matrix(dtm))
length(freq)
ord <- order(freq)
freq[head(ord)]
freq[tail(ord)]
head(table(freq), 15)
tail(table(freq), 15)
dim(dtm)
dtms <- removeSparseTerms(dtm, .1)
dim(dtms)
inspect(dtms)

#install.packages("RColorBrewer")
library(RColorBrewer)
library(wordcloud)
palette <- brewer.pal(9,"Greys")[-(1:5)]
wordcloud(names(freq), freq, min.freq=5, rot.per=0.2, scale=c(5, .1), colors=palette,max.words=30)

#identificar las palabras mas frecuentes
freq <- colSums(as.matrix(dtms))
findFreqTerms(dtm, lowfreq=150)

##Dibujamos las frecuencias
freq <- sort(colSums(as.matrix(dtm)), decreasing=TRUE)
head(freq, 14)
wf <- data.frame(word=names(freq), freq=freq,libro="la interpretacion de los sueños")
head(wf)

write.csv(wf, file="freqterms.csv", row.names=TRUE)

#Dibujamos las palabras con más de 15 frecuencia
library(ggplot2)
p <- ggplot(subset(wf, freq>500), aes(word, freq))
p <- p + geom_bar(stat="identity")
p <- p + theme(axis.text.x=element_text(angle=45, hjust=1))
p 