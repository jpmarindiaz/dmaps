library(devtools)
load_all()
document()
install()

library(dmaps)

mapName <- "us_states"
dmaps(mapName)


## Categorical Legend
d <- read.csv("inst/data/us/us_states/treeforbnb-states.csv")
names(d)
opts <- list(
  choroLegend = list(title = "", top = 1, orient="vertical"),
  showLegend = TRUE
)
dmaps("us_states",data = d, regionCol = "state", valueCol = "units", opts = opts)



## Bivariate Choropleth
d <- read.csv("inst/data/us/us_states/treeforbnb-states.csv")
var1 <- cut2(d[,2],g=3)
levels(var1) <- c("x1","x2","x3")
var2 <- cut2(d[,3],g=3)
levels(var2) <- c("y1","y2","y3")

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
  bivariateLegend = list(show = TRUE, var1Label = "Units", var2Label = "Median Price")
)
dmaps(mapName, data = d,
      groupCol = "group",
      regionCols = "state",
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
