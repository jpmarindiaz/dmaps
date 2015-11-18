
library(devtools)
library(htmlwidgets)
document()
load_all()
install()

library(dmaps)

availableDmaps()

dmaps("co_municipalities")

mapName <- "co_municipalities"
data <- read.csv("inst/data/co_municipalities/iniciativas.csv", stringsAsFactors = FALSE)
dmaps(mapName, data = data,
      groupCol = "Organización",
      regionCols = c("Municipio","Departamento"),
      opts = list())

css <- "
.datamaps-legend {
  background-color: aliceblue;
  padding:10px;
}
"

dmaps(mapName, data = data,
      groupCol = "Organización",
      regionCols = c("Municipio","Departamento"),
      opts = list(styles = css, legend = list(top = 10,left=80)))





dmaps("ch_cantons")
dmaps("ch_cantons", opts=list(projection="equirectangular"))

mapName <- "mx_states"
name = c("Coahuila","Guanajuato","México","Nuevo León", "Yucatán")
group = c("X","X","Y","Z","Z")
value = c( 50, 20, 2,20,10)
data <- data.frame(name = name, group = group)
tpl <- "{name}<br>Group:{group}"
data$info <- pystr::pystr_format(tpl, data)
dmaps(mapName,data)



dmaps("mx_states")


dmaps("mx_states")
dmaps("mx_states", opts=list(projection="equirectangular"))
dmaps("mx_states", opts=list(projection="mercator"))


dmapMeta("world_countries")
mapName <- "world_countries"
dmaps("world_countries", opts=list(projection="satellite"))

dmaps("world_countries")
dmapProjections("world_countries")
dmapProjectionOptions("world_countries","equirectangular")
dmaps("world_countries", opts=list(projection="equirectangular"))
dmaps("world_countries", opts=list(projection="mercator"))


dmaps("world_countries", opts=list(projection="equirectangular"))
dmaps("world_countries", opts=list(projection="mercator"))
opts = list(projction="orthographic",projectionOpts=list(clipAngle=120))
dmaps("world_countries", opts = opts)








mapName <- "co_departments"
dmaps("co_departments")

name = c("Antioquia","Amazonas","Cundinamarca","Nariño", "Bogotá")
group = c("X","X","Y","Z","Z")
value = c( 50, 20, 2,20,10)
info = c("<h1>Ant</h1> info","Ama Info","Cund Info","<strong>NAR</strong>","YES!!!")

data <- data.frame(name = name, group = group, info = info)
#data <- data.frame(depto = depto, group = group)
#data <- data.frame(depto = depto, value = value)
dmaps("co_departments",data)




opts <- list(
  #defaultFill = "#FFFFFF",
  #borderColor = "#00FF00",
  borderWidth = 1,
  highlightFillColor = "#999999",
  highlightBorderColor = "#0000FF",
  highlightBorderWidth = 1,
  legend = TRUE,
  legendTitle = "Grupo",
  legendDefaultFillTitle = "No hay datos",
  palette = "Set2"
)

dmaps("co_departments",data, opts)



dmaps("")




type <- "ecuador0"
data <- read.csv(system.file("inst/data/ecuador0-codes.csv",package = "dmaps"))
d <- data[c("name","pob_mas")]
d$group <- sample(LETTERS[1:3],25,replace = TRUE)
dmaps("ecuador0", d)






opts <- list(
  scale = 2,
  translateX = 0,
  translateY = 0,
  #defaultFill = "#FFFFFF",
  #borderColor = "#00FF00",
  borderWidth = 1,
  highlightFillColor = "#999999",
  highlightBorderColor = "#0000FF",
  highlightBorderWidth = 0,
  legend = TRUE,
  legendTitle = "Grupo",
  legendDefaultFillTitle = "No hay datos"
  #,palette = "Set2"
)

dmaps("depto",data, opts)
dmaps("depto",data)


# Saving widgets
s <- dmaps("depto", data)
htmlwidgets::saveWidget(s,"index.html", selfcontained = FALSE)
htmlwidgets::saveWidget(s,"index.html")







# A nice shiny app
library(shiny)
app <- shinyApp(
  ui = bootstrapPage(
    dmapsOutput("viz")
  ),
  server = function(input, output) {
    data <- read.csv(system.file("data/deptoCO1.csv", package = "dmaps"))
    output$viz <- renderDmaps({
      dmaps("depto",data)
    })
  }
)
runApp(app)








