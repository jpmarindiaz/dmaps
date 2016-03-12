#' <Add Title>
#'
#' <Add Description>
#'
#' @import htmlwidgets
#'
#' @export
dmaps <- function(mapName, data = NULL, regions = NULL,
                  regionCols = NULL, codeCol = NULL,
                  groupCol = NULL, valueCol = NULL,
                  bubbles = NULL, opts = NULL,
                  width = '100%', height = '80%',...) {
  # message(mapName)
  # mapName <- "co_departments"
  # mapName <- "co_municipalities"
  # mapName <- "world_countries"
  if(!mapName %in% availableDmaps())
    stop("No map with that name, check available maps with availableDmaps()")

  #if(!is.null(data)){
  #  regionCols <- regionCols %||% "name"
  #}

  dmap <- dmapMeta(mapName)

  if(!is.null(data) && is.null(regionCols) && is.null(codeCol)){
    stop("need to provide a regionCols")
  }

  if(!is.null(data) && (is.null(groupCol) && is.null(valueCol))){
    stop("Need to povide a groupCol or a valueCol")
  }

  #str(data)
  if(is.null(data$info) && !is.null(data)){
    #message(opts$infoTpl)
    infoTpl <- opts$infoTpl %||% defaultTpl(data)
    #message(infoTpl)
    data$info <- pystr_format(infoTpl,data)
    #str(data)
  }
  if(!is.null(bubbles) && is.null(bubbles$info)){
    infoTpl <- opts$bubbleInfoTpl %||% defaultTpl(bubbles)
    bubbles$info <- pystr_format(infoTpl,bubbles)
  }
  bubbleSizeLegendShow <- TRUE
  bubbleColorLegendShow <- TRUE

  if(is.null(bubbles)){
    bubbleSizeLegendShow <- FALSE
    bubbleColorLegendShow <- FALSE
  }
  if(!is.null(bubbles) && is.null(bubbles$radius)){
    bubbles$radius <- 5
    bubbleSizeLegendShow <- FALSE
  }
  if(!is.null(bubbles) && is.null(bubbles$group)){
    bubbleColorLegendShow <- FALSE
  }
  if(!is.null(groupCol)){
    if(!groupCol%in% names(data)){
      stop("groupCol not in data")
    }else{
      data$group <- as.character(data[[groupCol]])
      data$group[is.na(data$group)] <- ""
      opts$choroLegend$type <- opts$choroLegend$type %||% "categorical"
    }
  }

  if(!is.null(valueCol)){
    if(!valueCol%in% names(data)){
      stop("valueCol not in data")
    }else{
      data$value <- data[[valueCol]]
      data$group <- NULL ### removes groups so legendData doesn't use groupValues
      opts$choroLegend$type <- opts$choroLegend$type %||% "numeric"
    }
  }


  if(!is.null(regionCols)){
    if(!all(regionCols %in% names(data))){
      stop("regionCols not in data")
    }
    else{
      data$name <- apply(data[regionCols],1,paste, collapse = " - ")
    }
  }else{
    if(is.null(codeCol)){
      warning('No codeCol provided')
    }
    }

  if(!is.null(codeCol)){
      data$name <- NULL
      if(!codeCol %in% names(data))
        stop("codeCols needs to be in names(data)")
      data$code <- data[[codeCol]]
  }

  # Add region projection options
  codeIds <- NULL
  if(!is.null(regions)){
    regionMeta <- dmap$regions[[regions]]
    projectOptsRegions <- regionMeta[c("center","scale")]
    o <- list()
    for(i in c("center","rotate","scale","translate")){
      o[[i]] <- opts$projectioOpts[[i]] %||% projectOptsRegions[[i]]
    }
    opts$projectionOpts <- o
    codeIds <- regionMeta$ids
  }

  settings <- getSettings(dmap,opts, data)

  settings$bubbleColorLegend$show <- bubbleColorLegendShow
  settings$bubbleSizeLegend$show <- bubbleSizeLegendShow

  #filter data to show only data in selected region

  # message("SETTINGS")
  d <- getData(dmap,data, bubbles,
               defaultFill = settings$defaultFill,
               palette = settings$palette,
               bubblePalette = settings$bubblePalette,
               nLevels = settings$nLevels,
               customPalette = settings$customPalette,
               fillKeyLabels = settings$legend$labels, codeIds = codeIds)


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
