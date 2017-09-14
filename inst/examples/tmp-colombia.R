library(devtools)
document()
#load_all()
install()

library(dmaps)


## Test Regions

#d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")
d <- read.csv("inst/data/co/co_municipalities-2-vars.csv")

mapName <- "col_municipalities"
names(d)
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  nLevels = 3,
  choroLegend = list(shapeWidth = 40, labelFormat = ".0f"),
  projectionOpts = list(scale = 20)
)
dmaps(mapName, data = d,
      valueCol = "conf_uso_2",
      regionCols = c("municipio","departamento"),
      regions = "Cesar",
      opts = opts
)



mapName <- "col_dc_districts"
dmaps(data = NULL, mapName)






## TEST regions

opts = NULL
regionCols = NULL
codeCol = NULL
groupCol = NULL
valueCol = NULL
regions = NULL
bubbles = NULL


d <- read_csv(system.file("data/co/co_municipalities-2-vars.csv", package = "dmaps"),
              col_types = cols(code = "c"))
mapName <- "col_municipalities"

dmaps(mapName, data = d,
      valueCol = "conf_uso_2",
      #regionCols = c("municipio","departamento"),
      codeCol = "code",
      regions = "Altiplano Cundiboyacense",
      opts = opts
)

dmaps(mapName, data = d,
      valueCol = "conf_uso_2",
      #regionCols = c("municipio","departamento"),
      codeCol = "code",
      regions = "Valle de Aburrá",
      opts = opts
)

dmaps(mapName, data = d,
      valueCol = "conf_uso_2",
      #regionCols = c("municipio","departamento"),
      codeCol = "code",
      regions = "Valle de Aburrá",
      opts = opts
)

getAvailableRegions("co_municipalities")





dmaps(mapName, data = d,
      valueCol = "conf_uso_2",
      codeCol = "code",
      regions = "Cesar",
      opts = opts
)
dmaps(mapName, data = d,
      valueCol = "conf_uso_2",
      codeCol = "code",
      regions = c("Cesar","Meta","Catatumbo","La Guajira"),
      opts = opts
)






## Colombia

mapName <- "co_departments"
dmaps("co_departments")
library(dplyr)

data <- read.csv("inst/data/co/piensa-grande.csv")
d <- data %>%
  group_by(Departamentos) %>%
  summarise(count = n(), embajadores = paste(embajadores, collapse = ", "))
d <- as.data.frame(d)
d$info <- paste("<strong>Embajadores: </strong>", d$embajadores)
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 1,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  choroLegend = list(shapeWidth = 40, label = "Hola"),
  zoomable = TRUE
)
names(d)
dmaps("co_departments",data = d,
      regionCols = "Departamentos",
      valueCol = "count",
      opts = opts)






## Colombia

mapName <- "co_departments"
dmaps("co_departments")

data <- read.csv("inst/data/co/ncolegios-departamento.csv")

names(data)
dmaps("co_departments",data, regionCols = "departamento", valueCol = "count")
dmaps("co_departments",data[1:4,], regionCols = "departamento", valueCol = "count")


name = c("Antioquia","Amazonas","Cundinamarca","Nariño", "Bogotá")
group = c("X","X","Y","Z","Z")
value = c( 50, 20, 2,20,10)
info = c("<h1>Ant</h1> info","Ama Info","Cund Info","<strong>NAR</strong>","YES!!!")

data <- data.frame(depto = name, group = group, value = value)

dmaps("co_departments",data)
dmaps("co_departments",data, groupCol = "group")
dmaps("co_departments",data, valueCol = "value")
dmaps("co_departments",data, regionCols = "depto")

dmaps("co_departments",data, regionCols = "depto", groupCol = "group")
dmaps("co_departments",data, regionCols = "depto", valueCol = "value")


opts <- list(
  #defaultFill = "#FFFFFF",
  #borderColor = "#00FF00",
  borderWidth = 1,
  highlightFillColor = "#999999",
  highlightBorderColor = "#0000FF",
  highlightBorderWidth = 1,
  legendTitle = "Grupo",
  legendDefaultFillTitle = "No hay datos",
  palette = "Set2"
)
dmaps("co_departments",data,
      regionCols = "depto",groupCol = "group", opts = opts)


opts <- list(
  borderWidth = 1,
  highlightFillColor = "#999999",
  highlightBorderColor = "#0000FF",
  highlightBorderWidth = 0,
  palette = "Set2"
)

dmaps("co_departments",data,regionCols = "depto", groupCol = "group",opts = opts)







dmaps("co_municipalities")
mapName <- "co_municipalities"
data <- read.csv("inst/data/co_municipalities/iniciativas.csv", stringsAsFactors = FALSE)
dmaps(mapName, data = data,
      groupCol = "Organización",
      regionCols = c("Municipio","Departamento"),
      opts = list())

css <- "
body {
background-color: aliceblue;
}
"

dmaps(mapName, data = data,
      groupCol = "Organización",
      regionCols = c("Municipio","Departamento"),
      opts = list(styles = css, choroLegend = list(top = 10,left=80)))








d <- read.csv("inst/data/co/bubbles-poblacion-ciudades-colombia.csv")
names(d) <- c("latitude","longitude","radius","group")
infoTpl <- "<strong>{group}</strong><br><strong>Población:</strong> {radius}<br>"
d$info <- str_tpl_format(infoTpl,d)
opts <- list(
  bubbleBorderWidth = 2,
  bubbleBorderColor= "rgba(0,0,0,1)",
  minSizeFactor = 5,
  maxSizeFactor = 10
)
dmaps("co_departments",bubbles = d, opts = opts)


d$radius <- 20
dmaps("co_departments",bubbles = d, opts = opts)

d$group <- NULL
dmaps("co_departments",bubbles = d, opts = opts)

geodataMeta("co_departments")

d <- read.csv("inst/data/co/iniciativas.csv")

bubbles <- data.frame(
  latitude=d$latitud,
  longitude=d$longitud,
  radius=5,
  group=d$Organización
)
infoTpl <- "<strong>{Municipio}</strong><br><strong>Año:</strong> {Año}<br><strong>Iniciativa:</strong> {Iniciativa}<br><strong>Objetivo: </strong>{Objetivo} "
bubbles$info <- str_tpl_format(infoTpl,d)
opts <- list(
  bubbleBorderWidth = 0.001,
  bubbleBorderColor= "rgba(0,0,0,1)"
)
d <- dmaps("co_departments",bubbles = bubbles, opts = opts)
saveWidget(d,"~/Desktop/tmp.html")



