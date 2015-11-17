#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
dmaps <- function(mapName, data = NULL, groupCol = NULL,
                  regionCols = NULL,  infoTpl = NULL, opts = NULL,
                  width = '100%', height = '100%',...) {
  message(mapName)
  # mapName <- "co_departamentos"
  # mapName <- "world_countries"
  if(!mapName %in% availableDmaps())
    stop("No map with that name, check available maps with availableDmaps()")

  dmap <- dmapMeta(mapName)

  infoTpl <- infoTpl %||% defaultTpl(data)
  data$info <- pystr_format(infoTpl,data)

  if(!is.null(groupCol)){
    if(!groupCol%in% names(data)){
      stop("groupCol not in data")
    }else{
      data$group <- data[[groupCol]]
    }
  }

  if(!is.null(regionCols)){
  if(!all(regionCols %in% names(data))){
    stop("regionCols not in data")
  }
  else{
    data$name <- apply(data[regionCols],1,paste, collapse = " - ")
  }
  }

  settings <- getSettings(dmap,opts)
  defaultFill <- settings$defaultFill
  palette <- settings$palette

  d <- getData(dmap,data, defaultFill = defaultFill, palette = palette)


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
