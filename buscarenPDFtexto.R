install.packages("pdftools")
library(pdftools)
download.file("https://www.ilab.org/catalog_view/3101/3101_Cat%20%C3%A9so%20144%20LD.pdf", "3101_Cat%20%C3%A9so%20144%20LD.pdf", mode = "wb")

txt <- pdf_text("3101_Cat%20%C3%A9so%20144%20LD.pdf")

cat(txt[63])