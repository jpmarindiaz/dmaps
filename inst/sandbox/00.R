
library(devtools)
library(htmlwidgets)
document()
load_all()
devtools::install()

library(dmaps)

dmapMeta("co_deptos")
availableDmaps()








type <- "ecuador0"
data <- read.csv(system.file("inst/data/ecuador0-codes.csv",package = "dmaps"))
d <- data[c("name","pob_mas")]
d$group <- sample(LETTERS[1:3],25,replace = TRUE)
dmaps("ecuador0", d)

depto = c("Antioquia","Amazonas","Cundinamarca","Nariño", "Bogotá")
group = c("X","X","Y","Z","Z")
value = c( 50, 20, 2,20,10)
info = c("<h1>Ant</h1> info","Ama Info","Cund Info","<strong>NAR</strong>","YES!!!")

data <- data.frame(depto = depto, group = group, info = info)
data <- data.frame(depto = depto, group = group)
data <- data.frame(depto = depto, value = value)
dmaps("depto",data)




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








