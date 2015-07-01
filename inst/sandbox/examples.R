
library(devtools)
library(htmlwidgets)
document()
load_all()
devtools::install()

library(dmaps)

depto = c("Antioquia","Amazonas","Cundinamarca","Nariño")
group = c("A","A","C","E")
value = c( 50, 20, 2,20)
info = c("<h1>Ant</h1> info","Ama Info","Cund Info")

data <- data.frame(depto = depto, group = group, info = info)
data <- data.frame(depto = depto, group = group)
data <- data.frame(depto = depto, value = value)

# Seq palette
# Blues BuGn BuPu GnBu Greens Greys Oranges OrRd PuBu PuBuGn PuRd Purples RdPu Reds YlGn YlGnBu YlOrBr YlOrRd
# Divergent
# BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
# Qualitative
# Accent Dark2 Paired Pastel1 Pastel2 Set1 Set2 Set3


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
s <- d3plus("tree", countries)
htmlwidgets::saveWidget(s,"index.html", selfcontained = FALSE)
htmlwidgets::saveWidget(s,"index.html")


# Grouping bubbles
bubbles <- read.csv(system.file("data/bubbles.csv", package = "d3plus"))
d3plus("bubbles", bubbles)
bubbles <- read.csv(system.file("data/senado-tlc-corea.csv", package = "d3plus"))
d3plus("bubbles", bubbles)
d3plus("bubbles", bubbles[c(2,1,3)])


# Some lines
data <- read.csv(system.file("data/expenses.csv", package = "d3plus"))
d3plus("lines", data)

# Some networks
edges <- read.csv(system.file("data/edges.csv", package = "d3plus"))
nodes <- read.csv(system.file("data/nodes.csv", package = "d3plus"))
d3plus("rings",edges)
d3plus("rings", edges, focusDropdown = TRUE)
d3plus("rings", edges, nodes = nodes,focusDropdown = TRUE)
d3plus("network", edges)
d3plus("network",edges,nodes = nodes)

# A scatter plot
countries <- read.csv(system.file("data/countries.csv", package = "d3plus"))
d3plus("scatter", countries)
countries$big <- ceiling(10*runif(1:nrow(countries)))
d3plus("scatter", countries)




# Some treemaps
d3plus("tree", countries)
d3plus("tree", bubbles[c("name","value")])






# A nice shiny app
library(shiny)
app <- shinyApp(
  ui = bootstrapPage(
    checkboxInput("swapNCols","Swap columns",value=FALSE),
    d3plusOutput("viz")
  ),
  server = function(input, output) {
    countries <- read.csv(system.file("data/countries.csv", package = "d3plus"))
    output$viz <- renderD3plus({
      d <- countries
      if(input$swapNCols){
        d <- d[c(1,3,2)]
      }
      d3plus("tree",d)
    })
  }
)
runApp(app)








