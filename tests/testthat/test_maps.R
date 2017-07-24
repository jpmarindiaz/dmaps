context("Maps")


test_that("Resource exists",{

  dmaps(data = NULL, mapName = "world_countries")

  # World
  data <- read.csv("inst/data/world_countries/latam-pib.csv")
  mapName <- "world_countries"

  dmaps(data, mapName, regionCols = "País", groupCol = "Grupo")
  dmaps(data, mapName, regionCols = "País", valueCol = "PIB")

  palette <- dmaps:::getDefaultOpts()$palette

  previewColors(palette, data$PIB)

  opts <- list(
    projectionOpts = list(
      scale = 0.65,
      center = c(-74,4)
    )
  )

  s <- dmaps(data, mapName,
             regionCols = "País", valueCol = "PIB",
             opts = opts)
  s



  opts <- list(
    projectionName="satellite",
    projectionOpts = list(
      scale = .5,
      rotate =  c(70, -4, -30),
      center = c(0, 0),
      distance = 2.1,
      tilt =  15,
      clipAngle = 60,
      precision = .1
    )
  )

  mapName <- "world_countries"
  dmaps(data = NULL, "world_countries", opts = opts)


  ## Check
  # Default styles
  # title opts
  # Choropleth tooltip
  # custom styles
  # nLevels

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

})
