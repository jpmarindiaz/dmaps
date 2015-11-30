library(devtools)
load_all()
###
d <- read.csv("inst/data/co/departamento-municipio.csv")
d <- read.csv("inst/data/co/ciudades-colombia-poblacion.csv")
d$name <- paste(d$ciudad,d$departamento,sep = " - ")
codes <- read.csv("inst/dmaps/co/dane-codes-municipio.csv", colClasses = "character")
matchCode <- function(codes,data){
  dict <- codes[c("name","alternativeNames")]
  x <- dictionaryMatch(data$name,dict)
  idx <- match(x,codes$name)
  cbind(data[1:2],codes[idx,c("name","latitud","longitud")])
}
m <- matchCode(codes,d)
write.csv(m,"~/Desktop/dep-mun.csv",row.names = FALSE)
