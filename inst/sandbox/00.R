library(devtools)
#load_all()
document()
install()

library(dmaps)

mapName <- "world_countries"
d <- read.csv("inst/data/world_countries/world-countries-military-per-1000.csv")
opts <- list(
  legend = list(choropleth = list(left=0,top=60,orient="horizontal", title = "HEELLO")),
  nLevels = 3,
  title = list(text="Hello world", left=50),
  notes = list(text="Lorem sdfa;lfk fd[osfdsa f alkre re e re re er r a sfdfaa",
               top = 70),
  tooltip = list(choropleth = list(template = "NAMEEE: {country}")),
  styles = "svg{background-color:#eee}"
)
dmaps(mapName,data = d,
      regionCols = "country", valueCol = "military",
      opts = opts)





dmaps("world_countries",data = data[1:3,])

dmaps("world_countries",data = data)

dmaps("world_countries",data = data, opts = list(nLevels = 3))


dmaps("world_countries",
      opts=
        list(title = list(text="Hello World"),
             notes= list(text="Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo conaborum."),
             zoomable=TRUE,
             projectionOpts=list(translate=c(50,0))
        )
)




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
data$info <- pystr::str_tpl_format(tpl, data)
dmaps(mapName,data, opts = list(legend=list(left=80)))




# Saving widgets
s <- dmaps("co_departments")
htmlwidgets::saveWidget(s,"~/Desktop/index.html", selfcontained = FALSE)
htmlwidgets::saveWidget(s,"~/Desktop/index.html")







# A nice shiny app
library(shiny)
app <- shinyApp(
  ui = bootstrapPage(
    verbatimTextOutput("clicked"),
    dmapsOutput("viz")
  ),
  server = function(input, output) {
    data <- read.csv(system.file("data/co_municipalities/iniciativas.csv", package = "dmaps"))
    output$viz <- renderDmaps({
      e <- dmaps("co_municipalities",data = data,
                 groupCol = "Organización",
                 regionCols = c("Municipio","Departamento"))
      htmlwidgets::saveWidget(e,"~/Desktop/index.html")
      e
    })
    output$clicked <- renderPrint({
      input$dmaps_clicked_region
    })
  }
)
runApp(app)








