library(devtools)
load_all()
install()

library(dmaps)

## Bivariate coropleth

d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")
mapName <- "co_municipalities"
d$cruce <- paste(
  paste(names(d)[3],cut2(d[,3],g=2)),
  "; ",
  paste(names(d)[4],cut2(d[,4],g=2)))
unique(d$cruce)
dd <- d[c(1,2,5)]
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  nLevels = 3,
  legend = list(
    title = "Cruce"
  )
)
dmaps(mapName, data = dd,
      groupCol = "cruce",
      regionCols = c("mupio","depto"),
      opts = opts)






## Legend Labels

d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")
codes <- read.csv("inst/dmaps/co/dane-codes-municipio.csv")
selvar <- "accionesMilitares"
dd <- d[c("mupio","depto",selvar)]

mapName <- "co_municipalities"
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  nLevels = 3,
  legend = list(
    title = names(selvar),
    labels = letters[1:3]
  )
)
dd$info <- paste(dd$mupio,", ",names(selvar),": <strong>",dd[,selvar],"</strong>")

dmaps(mapName, data = dd,
      valueCol = selvar,
      regionCols = c("mupio","depto"),
      opts = opts)



## Custom Palette

customPalette <- read.csv("inst/data/co/customPalette-partidos.csv")
customPalette$partido <- NULL
names(customPalette) <- c("group","color")

d <- read.csv("inst/data/co/alcaldias-partido.csv")
names(d) <- gsub("."," ",names(d),fixed = TRUE)
names(d)

mapName <- "co_municipalities"
d$info <- d$`Primer aval 2011`
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
      groupCol = "Primer aval 2011",
      regionCols = c("Municipio","Departamento"),
      opts = opts)



d$info <- d$`Primer aval 2015`

dmaps(mapName, data = d,
      groupCol = "Primer aval 2015",
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






