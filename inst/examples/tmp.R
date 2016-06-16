library(devtools)
load_all()
document()
install()

library(dmaps)


## Bivariate coropleth

d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")
mapName <- "co_municipalities"

var1 <- cut2(d[,3],g=3)
levels(var1) <- c("x1","x2","x3")

var2 <- cut2(d[,4],g=3)
levels(var2) <- c("y1","y2","y3")


d$cruce <- paste(
  paste(names(d)[3],cut2(d[,3],g=3)),
  "; ",
  paste(names(d)[4],cut2(d[,4],g=2)))
unique(d$cruce)

d$group <- paste(var1,var2,sep="")

groups2d <- apply(expand.grid(paste0("x",1:3),paste0("y",1:3)),1,
                  function(r)paste0(r[1],r[2]))
colors2d <- c("#e8e8e8","#e4acac","#c85a5a","#b0d5df","#ad93a5","#985356","#64acbe","#62718c","#574249")
customPalette <- data.frame(group = groups2d, color = colors2d)

opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  customPalette = customPalette,
  choroLegend = list(show = FALSE),
  bivariateLegend = list(show = TRUE, var1Label = "V1", var2Label = "V2")
)
dmaps(mapName, data = d,
      groupCol = "group",
      regionCols = c("mupio","depto"),
      opts = opts)




## Group choropleth

d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")[250:300,]
mapName <- "co_municipalities"
names(d)
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  choroLegend = list(shapeWidth = 40),
  zoomable = TRUE
)
dmaps(mapName, data = d,
      valueCol = "accionesMilitares",
      regionCols = c("mupio","depto"),
      opts = opts
)




# A nice shiny app
library(shiny)
app <- shinyApp(
  ui = bootstrapPage(
    selectInput("selectedVar","VARS",c(4,3)),
    verbatimTextOutput("debug"),
    dmapsOutput("viz")
  ),
  server = function(input, output) {
    d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")[250:300,]
    output$debug <- renderPrint({
      #names(d)[input$selectedVar]
      input$selectedVar
    })
    output$viz <- renderDmaps({
      if(is.null(input$selectedVar)) return()
      n <- as.numeric(input$selectedVar)
      opts <- list(
        defaultFill = "#FFFFFF",
        borderColor = "#CCCCCC",
        borderWidth = 0.3,
        highlightFillColor = "#999999",
        highlightBorderWidth = 1,
        palette = "PuBu",
        choroLegend = list(shapeWidth = 40),
        zoomable = TRUE
      )
      mapName <- "co_municipalities"
      e <- dmaps(mapName, data = d,
            groupCol = names(d)[n],
            regionCols = c("mupio","depto"),
            opts = opts
      )
      htmlwidgets::saveWidget(e,"~/Desktop/index.html")
      e
    })
  }
)
runApp(app)









## Test Regions

#d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")
d <- read.csv("inst/data/co_municipalities/co_municipalities-2-vars.csv")

mapName <- "co_municipalities"
names(d)
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  nLevels = 3,
  choroLegend = list(shapeWidth = 40),
  projectionOpts = list(scale = 20)
)
dmaps(mapName, data = d,
      valueCol = "conf_uso_2",
      regionCols = c("municipio","departamento"),
      regions = "Cesar",
      opts = opts
)


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



d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  nLevels = 3,
  choroLegend = list(shapeWidth = 40)
)
dmaps(mapName, data = d,
      valueCol = "accionesMilitares",
      regionCols = c("mupio","depto"),
      regions = "Tolima",
      opts = opts
)
dmaps(mapName, data = d,
      valueCol = "accionesMilitares",
      regionCols = c("mupio","depto"),
      regions = "Cesar",
      opts = opts
)

dmaps(mapName, data = d,
      valueCol = "accionesMilitares",
      regionCols = c("mupio","depto"),
      regions = "Frontera venezolana",
      opts = opts
)



###
d <- read.csv("~/Desktop/BASE_COMPLETA_elegida_all.csv", stringsAsFactors = FALSE)
d[d == "#NULL!"] <- NA
mapName <- "co_municipalities"
selvars <- sample(names(d),1)
selvars <- "municipios_1_1"
d[[selvars]] <- as.numeric(d[[selvars]])

opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  nLevels = 3,
  choroLegend = list(shapeWidth = 40)
)
dmaps(mapName, data = d,
      valueCol = selvars,
      regionCols = c("mupio","depto"),
      opts = opts
)
selvars
d[[selvars]]
unique(d[[selvars]])



##
getAvailableRegions("co_municipalities")
codes <- getCodesData("co_municipalities")








## Group choropleth

d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")[250:300,]
mapName <- "co_municipalities"
names(d)
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  choroLegend = list(shapeWidth = 40)
)
dmaps(mapName, data = d,
      groupCol = "accionesMilitares",
      regionCols = c("mupio","depto"),
      opts = opts
)




d <- read.csv("inst/data/co_municipalities/alcaldias-partido.csv")
mapName <- "co_municipalities"
names(d)
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "Set1",
  nLevels = 3,
  choroLegend = list(shapeWidth = 40, orient = "vertical")
)
dmaps(mapName, data = d,
      groupCol = "Primer.aval.2011",
      regionCols = c("Municipio","Departamento"),
      opts = opts
)




# Numeric Choropleth

d <- read.csv("inst/data/co_municipalities/carto-2-vars.csv")
mapName <- "co_municipalities"
names(d)
opts <- list(
  defaultFill = "#FFFFFF",
  borderColor = "#CCCCCC",
  borderWidth = 0.3,
  highlightFillColor = "#999999",
  highlightBorderWidth = 1,
  palette = "PuBu",
  nLevels = 3,
  choroLegend = list(shapeWidth = 40)
)
dmaps(mapName, data = d,
      valueCol = "accionesMilitares",
      regionCols = c("mupio","depto"),
      opts = opts
      )




















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

d <- read.csv("inst/data/co_municipalities/alcaldias-partido.csv")
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




## NARIÑO

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





## Dmaps directly from geo code
## Todo add validation or warning when not all codes are in map

codes <- read.csv("inst/dmaps/co/dane-codes-municipio.csv", colClasses = "character")
d <- data.frame(
  code = sample(codes$id,5),
  group = sample(letters[1:2],5,replace = TRUE)
)
d$nombre <- codes$name[match(d$code,codes$id)]

mapName <- "co_municipalities"
d
dmaps(mapName, data = d,
      groupCol = "group",
      codeCol = "code")

## Test export widget

dm <- dmaps("world_countries")

library(htmltools)
library(exportwidget)
html <- tagList(
  dm,
  export_widget( )
)
html_print(html,viewer = utils::browseURL )





