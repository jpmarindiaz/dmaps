#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
dmaps <- function(mapName, data = NULL, opts = NULL,width = '100%', height = '100%',...) {
  message(mapName)
  # mapName <- "co_departamentos"
  if(!mapName %in% availableDmaps())
    stop("No map with that name, check available maps with availableDmaps()")

  dmap <- dmapMeta(mapName)


  opts <- getOpts(opts)
  defaultFill <- opts$defaultFill
  palette <- opts$palette

  d <- getData(dmap,data, defaultFill = defaultFill, palette = palette)

  settings <- opts

  # pass the data and settings using 'x'
  x <- list(
    data = d,
    dmap = dmap,
    settings = settings
  )

  htmlwidgets::createWidget(
    name = "dmaps",
    x,
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
dmapsOutput <- function(outputId, width = '100%', height = '500px'){
  shinyWidgetOutput(outputId, 'dmaps', width, height, package = 'dmaps')
}

#' Widget render function for use in Shiny
#'
#' @export
renderDmaps <- function(expr, env = parent.frame(), quoted = FALSE) {
  if (!quoted) { expr <- substitute(expr) } # force quoted
  shinyRenderWidget(expr, dmapsOutput, env, quoted = TRUE)
}
