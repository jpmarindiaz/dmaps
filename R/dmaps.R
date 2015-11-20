#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
dmaps <- function(mapName, data = NULL, groupCol = NULL, valueCol = NULL,
                  regionCols = NULL, bubbles = NULL, opts = NULL,
                  width = '100%', height = '80%',...) {
  # message(mapName)
  # mapName <- "co_departamentos"
  # mapName <- "world_countries"
  if(!mapName %in% availableDmaps())
    stop("No map with that name, check available maps with availableDmaps()")

  if(!is.null(data)){
    regionCols <- regionCols %||% "name"
  }

  dmap <- dmapMeta(mapName)

  if(is.null(data$info)){
    infoTpl <- opts$infoTpl %||% defaultTpl(data)
    data$info <- pystr_format(infoTpl,data)
  }
  if(!is.null(bubbles) && is.null(bubbles$info)){
    infoTpl <- opts$bubbleInfoTpl %||% defaultTpl(bubbles)
    bubbles$info <- pystr_format(infoTpl,bubbles)
  }

  if(!is.null(groupCol)){
    if(!groupCol%in% names(data)){
      stop("groupCol not in data")
    }else{
      data$group <- data[[groupCol]]
    }
  }

  if(!is.null(valueCol)){
    if(!valueCol%in% names(data)){
      stop("valueCol not in data")
    }else{
      data$value <- data[[valueCol]]
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

  d <- getData(dmap,data, bubbles,
               defaultFill = settings$defaultFill,
               palette = settings$palette,
               nLevels = settings$nLevels)


  # pass the data and settings using 'x'
  x <- list(
    data = d,
    dmap = dmap,
    settings = settings
  )

  str(x)
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
