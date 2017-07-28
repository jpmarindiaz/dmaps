library(devtools)
load_all()
document()
install()

library(dmaps)



## Categorical Legend
d <- read.csv("inst/data/world_countries/world-countries-popular-sport.csv")
names(d)
opts <- list(
  choroLegend = list(title = "", top = 1, orient="vertical"),
  showLegend = TRUE
)
mapName <- "world_countries"
dmaps("world_countries",data = d, regionCol = "country", groupCol = "sport", opts = opts)

getAvailableRegions("world_countries")
dmaps:::geodataMeta("world_countries")
dmaps("world_countries",data = d,
      regionCol = "country", groupCol = "sport",
      regions = "Colombia",
      opts = opts)








## Numeric Legend
d <- read.csv("inst/data/world_countries/Asian_Infrastructure_Investment_Bank.csv")
names(d)
opts <- list(
  choroLegend = list(title = "", top = 90, orient="horizontal",cells=10),
  showLegend = TRUE
)
mapName <- "world_countries"
dmaps("world_countries",data = d, regionCol = "Country", valueCol = "Votes", opts = opts)


d <- read.csv("inst/data/world_countries/swaps-china.csv", stringsAsFactors = FALSE)
names(d)
opts <- list(
  palette = "OrRd",
  legend = list(title = ""),
  showLegend = TRUE,
  defaultFill = "#444"
)
mapName <- "world_countries"
names(d) <- c("Country","Yuan")
dmaps("world_countries",data = d, regionCol = "Country", valueCol = "Yuan", opts = opts)



### World AIIB

## OJO Escala numérica
d <- read.csv("inst/data/world_countries/Asian_Infrastructure_Investment_Bank.csv")
names(d)
opts <- list(
  nLevels = 10
)

dmaps("world_countries",data = d, regionCol = "Country", valueCol = "Votes", opts = opts)

