
getData <- function(dmap,data, ...){
  if(is.null(data))
    return(list(fills = list(), fillKeys = list(), bubblesData = list()))
  args <- list(...)
  codePath <- "inst/dmaps/"
  palette <- args$palette
  codes <- read.csv(dmap$codesPath, colClasses = "character")

  #if(is.null(data$name))
  #  stop("Need a region name")

  matchCode <- function(codes,data){
    dict <- codes[c("name","alternativeNames")]
    x <- dictionaryMatch(data$name,dict)
    idx <- match(x,codes$name)
    codes$id[idx]
  }
  if(!is.null(data$name))
    data$code <- matchCode(codes,data)

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
    return(list(fills = list(), fillKeys = list(), bubblesData = list()))
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


getSettings <- function(dmap, opts = NULL,...){
  args <- list(...)

  defaultStyles <- "
.datamaps-legend dt, .datamaps-legend dd {
    float: none;
}
.datamaps-legend {
    left: {left}%;
    top: {top}%;
    max-width: 30%;
}
.datamaps-hoverover {
  color: #444;
  max-width:35%
}
"
defaultStyles <- pystr_format(defaultStyles,list(top=opts$legend$top %||% 0,left=opts$legend$left %||% 1))
opts$styles <- paste(defaultStyles, opts$styles,sep="\n")

  projectionName <- opts[["projection"]] %||% names(dmap$projections)[1]
  projectionOpts <- dmap$projections[[projectionName]]

  defaultOpts <- list(
    projection = projectionName,
    projectionOpts = projectionOpts,
    zoomable = TRUE,
    defaultFill = "#DCE5E0",
    borderColor = "#ffffff",
    borderWidth = 1,
    highlightFillColor = "#999999",
    highlightBorderColor = "#444444",
    highlightBorderWidth = 0,
    legend = TRUE,
    graticule = FALSE,
    legendTitle = "",
    legendDefaultFillTitle = NULL,
    palette = "RdYlBu",
    styles = ""
  )



  ## Cambiar por rapply
  #  mapply(function(i,j){j %||% i},defaultOpts,opts,
  # USE.NAMES = TRUE, SIMPLIFY = FALSE)

  optNames <- names(defaultOpts)
  o <- list()
  for(i in optNames){
    o[[i]] <- opts[[i]] %||% defaultOpts[[i]]
    if(i=="projectionOpts"){
      for(j in names(defaultOpts[[i]]))
        o[[i]][[j]] <- opts[[i]][[j]] %||% defaultOpts[[i]][[j]]
    }
  }
  o
}
