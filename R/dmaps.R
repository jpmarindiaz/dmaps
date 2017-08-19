#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
dmaps <- function(data = NULL, mapName, opts = NULL,
                  regionCols = NULL, codeCol = NULL,
                  groupCol = NULL, valueCol = NULL,
                  regions = NULL,
                  bubbles = NULL,
                  width = '100%', height = '100%',...) {

  if(!mapName %in% availableDmaps())
    stop("No map with that name, check available maps with availableDmaps()")

  dmap <- geodataMeta(mapName)
  # Add quick fix
  # https://rawgit.com/jpmarindiaz/geodata/master/inst/geodata/col/col-adm2-municipalities.topojson
  basepath <- "https://cdn.rawgit.com/jpmarindiaz/geodata/master/inst/geodata"
  dmap$path <- file.path(basepath,dmap$geoname,paste0(dmap$basename,".topojson"))

  #topojsonPath <- file.path("geodata",dmap$geoname,paste0(dmap$basename,".topojson"))
  #topojson <- paste0(readLines(system.file(topojsonPath, package = "geodata")),collapse = "")
  #dmap$path

  #message("makeGeoData")

  data <- preprocessData(data, mapName)

  dgeo <- dmaps:::makeGeoData(dmap, data = data, regions = regions,
                  regionCols = regionCols, codeCol = codeCol,
                  groupCol = groupCol, valueCol = valueCol,
                  opts = opts)
  #message("getOpts")
  #str(opts)
  opts <- getOpts(dmap, opts = opts, data = dgeo)
  #str(dmap)
  # message("prepData")
  d <- prepData(dmap, opts, data = dgeo, bubbles = bubbles)
  # message("after prepData")
  #str(d)

  # pass the data and settings using 'x'
  x <- list(
    data = d,
    dmap = dmap,
    settings = opts
  )

  htmlwidgets::createWidget(
    name = "dmaps",
    x = x,
    width = width,
    height = height,
    package = 'dmaps',
    sizingPolicy = htmlwidgets::sizingPolicy(
      viewer.padding = 0,
      browser.padding = 0,
      browser.fill = TRUE
    )
  )
}

#' Widget output function for use in Shiny
#'
#' @export
dmapsOutput <- function(outputId, width = '100%', height = '400px'){
  shinyWidgetOutput(outputId, 'dmaps', width, height, package = 'dmaps')
}

#' Widget render function for use in Shiny
#'
#' @export
renderDmaps <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, dmapsOutput, env, quoted = TRUE)
}
