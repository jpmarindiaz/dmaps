#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
dmaps <- function(type = "depto", data, opts = NULL,width = '100%', height = '100%',...) {

  opts <- getOpts(opts)
  defaultFill <- opts$defaultFill
  palette <- opts$palette

  d <- getData("depto",data, defaultFill = defaultFill, palette = palette)

  settings <- opts
  settings$mapType <- type

  # pass the data and settings using 'x'
  x <- list(
    data = d,
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
