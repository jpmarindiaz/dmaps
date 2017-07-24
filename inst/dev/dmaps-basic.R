
devtools::install()

library(dmaps)

## Colombia

mapName <- "co_departments"
dmaps("co_departments")


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

