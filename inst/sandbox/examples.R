
library(devtools)
library(htmlwidgets)
document()
load_all()
devtools::install()

library(dmaps)


# A nice shiny app 2
library(dmaps)
library(shiny)
app <- shinyApp(
  ui = bootstrapPage(
    selectInput("selectVariable","Selected Variable",
                choices=rev(c("accionesMilitares","IDH_1_1"))),
    dmapsOutput("viz")
  ),
  server = function(input, output) {
    data <- read.csv(system.file("data/co_municipalities/carto-2-vars.csv", package = "dmaps"))
    data <- data[1:20,]
    output$viz <- renderDmaps({
      var <- input$selectVariable
      dmaps("co_municipalities",
            data[c("mupio","depto",var)],
            regionCols = c("mupio","depto"),
            valueCol = var)
    })
  }
)
runApp(app)





depto = c("Antioquia","Amazonas","Cundinamarca","Nariño", "Bogotá")
group = c("X","X","Y","Z","Z")
value = c( 50, 20, 2,20,10)
info = c("<h1>Ant</h1> info","Ama Info","Cund Info","<strong>NAR</strong>","YES!!!")

data <- data.frame(depto = depto, group = group, info = info)
data <- data.frame(depto = depto, group = group)
#data <- data.frame(depto = depto, value = value)
dmaps("co_departments",data, regionCols = "depto",groupCol = "group")













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







