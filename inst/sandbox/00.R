
library(devtools)
library(htmlwidgets)
document()
load_all()
install()

library(dmaps)

availableDmaps()

# World
mapName <- "world_countries"
#dmaps("world_countries")

d <- read.csv("inst/data/world_countries/world-countries-military-per-1000.csv")
data <- d
names(data) <- c("name","value")
dmaps("world_countries",data = data,
      opts=list(
        legend = list(left=0,top=60,orientation="vertical"),
        title = list(text="Hello world"),
        notes = list(text="Lorem sdfa;lfk fd[osfdsa f alkre re e re re er r a sfdfaa",
                     top = 70),
        infoTpl = "NAMEEE: {name}"
        ,styles = "svg{background-color:#eee}"
        )
      )



dmaps("world_countries",data = data,
      opts=list(title = list(text="Hola Mundo",left=50)))

dmaps("world_countries",data = data,
      opts=list(title = list(text="Hola",left=90)))


dmaps("world_countries",data = data[1:3,])
dmaps("world_countries",data = data)

dmaps("world_countries",data = data, opts = list(nLevels = 3))


dmaps("world_countries",
      opts=
        list(title = list(text="Hello World"),
             notes= list(text="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo conaborum."),
             zoomable=TRUE))




data <- read.csv("inst/data/world_countries/world-countries-military-per-1000.csv")
dmaps("world_countries",data = data, regionCols = "country",valueCol="military", opts=list(legend = list(left=20)))



mapName <- "world_countries"
dmaps("world_countries")

d <- read.csv("inst/data/world_countries/world-countries-popular-sport.csv")
data <- d
dmaps("world_countries",data = data, regionCols = "country",groupCol="sport")





bubbles <- data.frame(
  latitude=c(50,4),
  longitude=c(4,-70),
  radius=c(10,15)
)
dmaps("world_countries",bubbles = bubbles)
bubbles <- data.frame(
  latitude=c(50,4),
  longitude=c(4,-70),
  radius=c(10,15),
  group=c("A","B"),
  info = c("AA","BB")
  )
dmaps("world_countries",bubbles = bubbles)
dmaps(mapName,data=data.frame(name="Brazil",group="Big"))
dmaps("world_countries", opts=list(defaultFill="#FF6c34"))
dmaps("world_countries", opts=list(projection="mercator"))
dmaps("world_countries", opts=list(zoomable=TRUE))
dmaps("world_countries", opts=list(projection="satellite",zoomable=FALSE))

dmapProjections("world_countries")
dmapProjectionOptions("world_countries","equirectangular")
dmaps("world_countries", opts=list(projection="equirectangular"))

dmaps("world_countries", opts=list(projection="equirectangular"))
dmaps("world_countries", opts=list(projection="mercator"))
opts = list(projection="orthographic",projectionOpts=list(clipAngle=120))
dmaps("world_countries", opts = opts)


# Latam

dmaps("latam_countries")
mapName <- "latam_countries"
dmaps(mapName,data=data.frame(name="Brazil",group="World Cup"))
bubbles <- data.frame(
  latitude=c(-5,4,-10),
  longitude=c(-74,-70,-55),
  radius=c(5,8,10),
  group=c("Español","Español","Portugués")
)
dmaps("latam_countries", bubbles = bubbles,
      opts=list(
        projection="orthographic",
        zoomable=FALSE,
        graticule = TRUE,
        bubbleInfoTpl="{group}: {radius}",
        projectionOpts = list(scale = 0.25,translateY=15)
        )
      )
dmaps("latam_countries", opts=list(projection="equirectangular"))
dmaps("latam_countries", opts=list(projection="mercator",zoomable=TRUE))
dmaps("latam_countries", opts=list(projection="orthographic",zoomable=FALSE,graticule = TRUE))




# Brazil
mapName <- "br_states"
dmaps(mapName, data = data.frame(name="Rio de Janeiro",group="Samba"))


# Ecuador
mapName <- "ec_provinces"
dmaps(mapName)
dmaps(mapName, opts=list(title = "Hello World",notes="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
                                   quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
                                   conaborum."))
d <- data.frame("regiones"=c("MANABI"))
d$group <- sample(LETTERS[1:3],1)
dmaps(mapName,d, regionCols = "regiones")






# Switzerland

dmaps("ch_cantons")
dmaps("ch_cantons", opts=list(projection="equirectangular"))
dmaps("ch_cantons", opts=list(projection="mercator"))
dmaps("ch_cantons", opts=list(projection="albers"))
data <- data.frame(name = c("Zurich","Geneve"), group = c("Yes","No"))
data <- data.frame(name = c("Zurigo","Genf"), group = c("Yes","No"))
dmaps("ch_cantons",data, opts=list(projection="albers"))


# Mexico

dmaps("mx_states")
dmaps("mx_states", opts=list(projection="equirectangular"))
dmaps("mx_states", opts=list(projection="mercator"))

mapName <- "mx_states"
name = c("Coahuila","Guanajuato","México","Nuevo León", "Yucatán")
group = c("X","X","Y","Z","Z")
value = c( 50, 20, 2,20,10)
data <- data.frame(name = name, group = group)
dmaps(mapName,data, infoTpl = "<strong>We are bold {name}</name>",opts = list(legend=list(left=80)))
tpl <- "{name}<br>Group:{group}"
data$info <- pystr::pystr_format(tpl, data)
dmaps(mapName,data, opts = list(legend=list(left=80)))


## Colombia

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
s <- dmaps("co_departments")
htmlwidgets::saveWidget(s,"~/Desktop/index.html", selfcontained = FALSE)
htmlwidgets::saveWidget(s,"~/Desktop/index.html")







# A nice shiny app
library(shiny)
app <- shinyApp(
  ui = bootstrapPage(
    dmapsOutput("viz")
  ),
  server = function(input, output) {
    data <- read.csv(system.file("data/co_municipalities/iniciativas.csv", package = "dmaps"))
    output$viz <- renderDmaps({
      dmaps("co_municipalities",data = data,
            groupCol = "Organización",
            regionCols = c("Municipio","Departamento"))
    })
  }
)
runApp(app)








