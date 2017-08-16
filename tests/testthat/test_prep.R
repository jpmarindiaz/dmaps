context("Opts")


test_that("opts",{

  mapName <- "world_countries"
  dmap_t <- geodataMeta(mapName)

  opt1 <- getOpts(dmap_t)

  # take the first projection by default
  expect_equal(opt1$projectionOpts, dmap_t$projections[[1]])

  #defaultOpts <- getDefaultOpts()
  #expext_equal(opt1, defaultOpts)

  opts <- list(
    projectionOpts = list(
      scale = 0.15,
      center = c(0,0),
      translate = c(0,0),
      rotate = c(0,0),
      distance = 1.5,
      clipAngle = 60,
      tilt = 25
    )
  )
  getOpts(dmap_t, opts)


  opts <- list(
    projectionName = "orthographic",
    projectionOpts = list(
      scale = 2,
      center = c(10,10),
      translate = c(10,10),
      rotate = c(10,10),
      distance = 1.5,
      clipAngle = 80,
      tilt = 15
    )
  )
  expect_error(getOpts(dmap_t, opts = list(projectionName = "xxx")), "Projection not defined for the given dmap_t")

  opt2 <- getOpts(dmap_t, opts)
  expect_equal(opts$projectionName, opt2$projectionName)
  expect_equal(opts$projectionOpts$scale, opt2$projectionOpts$scale)
  expect_equal(opts$projectionOpts$center, opt2$projectionOpts$center)
  expect_equal(sort_list(opt2$projectionOpts), sort_list(opts$projectionOpts))

  # Make sure chorolegend is categoric/numeric depending on input data
  d <- data_frame(countryName = c("Colombia","United States","Germany", "Flatland"),
                  countryCode = c("COL","USA","DEU", "XXX"),
                  value = c(1,2,3, 4),
                  continent = c("America","America","Europe", "XXX"))
  dmap_t <- geodataMeta("world_countries")
  data <- dmap_ts:::makeGeoData(dmap_t, data = d,
                              regionCols = "countryName",
                              valueCol = "value")
  dopts <- getOpts(dmap_t, opts = NULL, data = data)
  expect_equal(dopts$legend$choropleth$type, "numeric")

  data <- dmap_ts:::makeGeoData(dmap_t, data = d,
                              regionCols = "countryName",
                              groupCol = "continent")
  dopts <- getOpts(dmap_t, opts = NULL, data = data)
  expect_equal(dopts$legend$choropleth$type, "categorical")

  opts <- list(
    legend = list(left=0,top=60,orient="horizontal", title = "HEELLO"),
    title = list(text="Hello world"),
    notes = list(text="Lorem sdfa;lfk fd[osfdsa f alkre re e re re er r a sfdfaa",
                 top = 70),
    tooltip = list(choropleth = list(template = "NAMEEE: {country}"))
    ,styles = "svg{background-color:#eee}"
  )
  getOpts(dmap_t, opts = opts)

  opts=list(title = list(text="Hola",left=90))
  getOpts(dmap_t, opts = opts)

})


context("Parameters")

test_that("params",{

  opts = NULL
  regionCols = NULL
  codeCol = NULL
  groupCol = NULL
  valueCol = NULL
  regions = NULL
  bubbles = NULL

  mapName <- "world_countries"
  dmap_t <- geodataMeta(mapName)

  expect_true(is.null(makeGeoData(dmap_t, data = NULL)))

  data <- data_frame(countryName = c("Colombia","United States","Germany", "Flatland"),
                     countryCode = c("COL","USA","DEU", "XXX"),
                     value = c(1,2,3, 4),
                     valueChr = c('1','2','3','4'),
                     continent = c("America","America","Europe", "XXX"))

  expect_error(makeGeoData(dmap_t, data = data,
                           regionCols = NULL, codeCol = NULL),
               "Need to provide regionCols or codeCol")

  expect_error(makeGeoData(dmap_t, data = data,
                           regionCols = "xxx"))
  expect_error(makeGeoData(dmap_t, data = data,
                           codeCol = "xxx"))
  expect_error(makeGeoData(dmap_t, data = data,
                           codeCol = "countryCode"),
               "Need to povide a groupCol or a valueCol")
  expect_error(makeGeoData(dmap_t, data = data,
                           codeCol = "countryCode",
                           valueCol = "valueChr"),
               "valueCol must be numeric")

  dmap_t <- geodataMeta(mapName)
  g1 <- makeGeoData(dmap_t, data = data,
                    regionCols = "countryName", valueCol = "value")
  expect_false(any(is.na(g1$..code)))
  g2 <- makeGeoData(dmap_t, data = data,
                    codeCol = "countryCode", valueCol = "value")
  expect_false(any(is.na(g2$..code)))

  ## TEST make geo data with no NA's

  expect_equal(names(g1), names(g2))
  expect_equal(names(g1), c("..code","..name","..info","..value","..group",names(data)))
  expect_equal(g1 %>% select(..code, ..name), g2 %>% select(..code, ..name))

  mapName <- "col_municipalities"
  data <- read_csv(system.file("data/co/alcaldias-partido-2011.csv", package = "dmap_ts"))
  dmap_t <- geodataMeta(mapName)

  g <- makeGeoData(dmap_t, data = data,
                   regionCols = c("Municipio","Departamento"), groupCol = "Aval Partidos 2011")
  gRegion <- makeGeoData(dmap_t, data = data,
                         regionCols = c("Municipio","Departamento"), groupCol = "Aval Partidos 2011",
                         region = c("Catatumbo", "Valle de Aburrá"))
  all(gRegion$..code %in% c(dmap_t$regions$Catatumbo$ids,dmap_t$regions$`Valle de Aburrá`$ids))

  # Provide bubbles
  # dmap_ts("co_departments")
  # dmap_ts("co_municipalities")
  # dmap_ts("world_countries")
  #
  # getAvailableRegions("co_municipalities")
  # getAvailableProjections("co_municipalities")



})
