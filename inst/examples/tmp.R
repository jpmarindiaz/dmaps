library(devtools)
load_all()
install()

library(dmaps)

customPalette <- read.csv("inst/data/co/customPalette-partidos.csv")
customPalette$partido <- NULL
names(customPalette) <- c("group","color")

d <- read.csv("inst/data/co/alcaldias-partido-2011.csv")
names(d) <- gsub("."," ",names(d),fixed = TRUE)
names(d)
mapName <- "co_municipalities"
d$info <- d$`Aval Partidos 2011`
opts <- list(
  #defaultFill = "#FFFFFF",
  #borderColor = "#00FF00",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  #highlightBorderColor = "#0000FF",
  highlightBorderWidth = 1,
  #legend = TRUE,
  #legendTitle = "Grupo",
  #legendDefaultFillTitle = "No hay datos",
  palette = "Set3",
  customPalette =customPalette
)



dmaps(mapName, data = d,
      groupCol = "Aval Partidos 2011",
      regionCols = c("Municipio","Departamento"),
      opts = opts)




## CARLA NARIÑO

d <-  read.csv("inst/data/co/nariño-indigenas-afro.csv")
d <-  read.csv("inst/data/co/nariño-indigenas-afro-2.csv")
d$comunidad <- "Comunidades Afrodescendientes"
names(d)[1] <-  "municipio"
d$departamento <- "Nariño"

codes <- read.csv("inst/dmaps/co/dane-codes-municipio.csv", colClasses = "character")
codesN <- codes[codes$departamento == "Nariño",c("municipio","departamento")]
codesN$comunidad <- "ninguno"
codesN <- codesN[c("municipio","comunidad","departamento")]

oriM <- d$municipio

codesN <- codesN[!codesN$municipio %in% oriM,]

d <- rbind.data.frame(d,codesN)

mapName <- "co_municipalities"
opts <- list(
  defaultFill = "#FFFFFF",
  #borderColor = "#00FF00",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  #highlightBorderColor = "#0000FF",
  highlightBorderWidth = 1,
  #legend = TRUE,
  #legendTitle = "Grupo",
  #legendDefaultFillTitle = "No hay datos",
  palette = "Set2"
)

dmaps(mapName, data = d,
      groupCol = "comunidad",
      regionCols = c("municipio","departamento"),
      opts = opts)






