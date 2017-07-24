context("Resources")


test_that("Resource exists",{

  geoCodesFiles <- dmapMeta() %>% map("codesPath")
  codeFileFound <- map_lgl(geoCodesFiles, function(x) !httr::http_error(x))
  codeFileFound %>% keep(. == FALSE)
  expect_true(all(codeFileFound))

  geoFiles <- dmapMeta() %>% map("path")
  geoFileFound <- map_lgl(geoFiles, function(x) !httr::http_error(x))
  geoFileFound %>% keep(. == FALSE)
  expect_true(all(codeFileFound))
})

context("Opts")


test_that("opts",{

  mapName <- "world_countries"
  dmap <- dmapMeta(mapName)

  opt1 <- getOpts(dmap)

  # take the first projection by default
  expect_equal(opt1$projectionOpts, dmap$projections[[1]])

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
  getOpts(dmap, opts)


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
  expect_error(getOpts(dmap, opts = list(projectionName = "xxx")), "Projection not defined for the given dmap")

  opt2 <- getOpts(dmap, opts)
  expect_equal(opts$projectionName, opt2$projectionName)
  expect_equal(opts$projectionOpts$scale, opt2$projectionOpts$scale)
  expect_equal(opts$projectionOpts$center, opt2$projectionOpts$center)
  expect_equal(sort_list(opt2$projectionOpts), sort_list(opts$projectionOpts))

  # Make sure chorolegend is categoric/numeric depending on input data
  d <- data_frame(countryName = c("Colombia","United States","Germany", "Flatland"),
                     countryCode = c("COL","USA","DEU", "XXX"),
                     value = c(1,2,3, 4),
                     continent = c("America","America","Europe", "XXX"))
  dmap <- dmapMeta("world_countries")
  data <- dmaps:::makeGeoData(dmap, data = d,
                              regionCols = "countryName",
                              valueCol = "value")
  dopts <- getOpts(dmap, opts = NULL, data = data)
  expect_equal(dopts$legend$choropleth$type, "numeric")

  data <- dmaps:::makeGeoData(dmap, data = d,
                              regionCols = "countryName",
                              groupCol = "continent")
  dopts <- getOpts(dmap, opts = NULL, data = data)
  expect_equal(dopts$legend$choropleth$type, "categorical")

  opts <- list(
    legend = list(left=0,top=60,orient="horizontal", title = "HEELLO"),
    title = list(text="Hello world"),
    notes = list(text="Lorem sdfa;lfk fd[osfdsa f alkre re e re re er r a sfdfaa",
                 top = 70),
    tooltip = list(choropleth = list(template = "NAMEEE: {country}"))
    ,styles = "svg{background-color:#eee}"
  )
  getOpts(dmap, opts = opts)

  opts=list(title = list(text="Hola",left=90))
  getOpts(dmap, opts = opts)

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
  dmap <- dmapMeta()

  expect_true(is.null(makeGeoData(dmap, data = NULL)))

  data <- data_frame(countryName = c("Colombia","United States","Germany", "Flatland"),
                     countryCode = c("COL","USA","DEU", "XXX"),
                     value = c(1,2,3, 4),
                     continent = c("America","America","Europe", "XXX"))

  expect_error(makeGeoData(dmap, data = data,
                           regionCols = NULL, codeCol = NULL),
               "Need to provide regionCols or codeCol")

  expect_error(makeGeoData(dmap, data = data,
                           regionCols = "xxx"))
  expect_error(makeGeoData(dmap, data = data,
                           codeCol = "xxx"))
  expect_error(makeGeoData(dmap, data = data,
                           codeCol = "countryCode"),
               "Need to povide a groupCol or a valueCol")

  dmap <- dmapMeta(mapName)
  g1 <- makeGeoData(dmap, data = data,
                    regionCols = "countryName", valueCol = "value")
  expect_false(any(is.na(g1$..code)))
  g2 <- makeGeoData(dmap, data = data,
                    codeCol = "countryCode", valueCol = "value")
  expect_false(any(is.na(g2$..code)))

  ## TEST make geo data with no NA's

  expect_equal(names(g1), names(g2))
  expect_equal(names(g1), c("..code","..name","..info",names(data)))
  identical(g1 %>% select(..code, ..name), g2 %>% select(..code, ..name))
  expect_equal(g1 %>% select(..code, ..name), g2 %>% select(..code, ..name))

  mapName <- "col_municipalities"
  data <- read_csv(system.file("data/co/alcaldias-partido-2011.csv", package = "dmaps"))
  dmap <- dmapMeta(mapName)

  g <- makeGeoData(dmap, data = data,
                   regionCols = c("Municipio","Departamento"), groupCol = "Aval Partidos 2011")
  # OJO g tiene 1107 rows, data 1103.
  gRegion <- makeGeoData(dmap, data = data,
                         regionCols = c("Municipio","Departamento"), groupCol = "Aval Partidos 2011",
                         region = c("Catatumbo", "Valle de Aburrá"))
  all(gRegion$..code %in% c(dmap$regions$Catatumbo$ids,dmap$regions$`Valle de Aburrá`$ids))

  # Provide bubbles
  # dmaps("co_departments")
  # dmaps("co_municipalities")
  # dmaps("world_countries")
  #
  # getAvailableRegions("co_municipalities")
  # getAvailableProjections("co_municipalities")



})
