
getData <- function(dmap,data, ...){
  if(is.null(data))
    return(list(fills = list(), fillKeys = list(), bubblesData = list()))
  args <- list(...)
  codePath <- "inst/dmaps/"
  palette <- args$palette
  codes <- read.csv(dmap$codesPath, colClasses = "character")

  data$code <- codes$id[match(data$name,codes$name)]

  if(is.null(data$info))
    data$info <-""

  if(!is.null(data$group)){
    key <- unique(data$group)
    keyColor <- catColor(key, palette)
  }
  if(is.null(data$group) && !is.null(data$value)){
    key <- unique(data$value)
    keyColor <- numColor(key, palette)
    data$group <- as.character(data$value)
    ## use library(Hmisc), cut2 function to generate numeric intervals
  }
  if(is.null(data$group) && is.null(data$value)){
    stop("need to provide a group or a value")
  }

  fillKeys <- as.list(keyColor)
  names(fillKeys) <- key
  fillKeys$defaultFill <- args$defaultFill

  fills <- Map(function(i){
    list(fillKey=data$group[i], info = data$info[i])
    },1:nrow(data))
  names(fills) <- as.character(data$code)

  list(fills = fills, fillKeys = fillKeys, bubblesData = list())
}


getOpts <- function(opts = NULL,...){
  args <- list(...)
  defaultOpts <- list(
    projectionName = NULL, # This is set on each dmap.yaml
    scale = NULL, # This is set on each dmap.yaml
    translateX = 0,
    translateY = 0,
    defaultFill = "#B8CDB9",
    borderColor = "#00FF000",
    borderWidth = 1,
    highlightFillColor = "#999999",
    highlightBorderColor = "#444444",
    highlightBorderWidth = 0,
    legend = TRUE,
    graticule = TRUE,
    legendTitle = "",
    legendDefaultFillTitle = NULL,
    palette = "RdYlBu"
  )
  optNames <- names(defaultOpts)
  o <- list()
  for(i in optNames){
    o[i] <- opts[[i]] %||% defaultOpts[[i]]
  }
  o
}
