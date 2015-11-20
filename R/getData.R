
getData <- function(dmap,data = NULL,bubbles = NULL, ...){
  if(is.null(data) && is.null(bubbles))
    return(list(fills = list(), fillKeys = list(), bubblesData = list()))
  args <- list(...)
  codePath <- "inst/dmaps/"
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

  #args <- list(palette = "Set1", nLevels = 5)
  dataFills <- getDataFills(data,defaultFill = args$defaultFill,
                            palette = args$palette, nLevels = args$nLevels)
  bubbleFills <- getBubbleFills(bubbles,defaultFill = args$defaultFill,
                            palette = args$palette)
  # message("dataFills")
  # str(dataFills)
  # message("bubbleFills")
  # str(bubbleFills)
  if(!is.null(bubbles)){
    bubbles$fillKey <- bubbles$group
  }

  list(fills = c(dataFills$fills,bubbleFills$fills),
       fillKeys = c(dataFills$fillKeys,bubbleFills$fillKeys),
       bubblesData = bubbles)
}

getDataFills <- function(data,...){
  args <- list(...)
  palette <- args$palette
  if(!is.null(data$group)){
    key <- unique(data$group)
    key <- key[!key=="" | is.null(key) | is.na(key)]
    keyColor <- catColor(key, palette)
    fills <- Map(function(i){
      list(fillKey=data$group[i], info = data$info[i])
    },1:nrow(data))
    names(fills) <- as.character(data$code)
    fillKeys <- as.list(keyColor)
    names(fillKeys) <- key
    fillKeys$defaultFill <- args$defaultFill
  }
  if(is.null(data$group) && !is.null(data$value)){
    #data$group <- cut2(data$value,g=5,levels.mean=TRUE)
    ncuts <- args$nLevels
    data$group <- cut2(data$value,g=ncuts)
    key <- levels(data$group)
    key <- key[!key=="" | is.null(key) | is.na(key)]
    cuts <- cut2(data$value,g=ncuts,onlycuts = TRUE)
    if(length(cuts)<nrow(data)) cuts <- cuts[-1]
    keyColor <- quanColor(cuts, palette, domain = cuts, n = ncuts)
    #data$color <- numColor(data$value, palette, domain = data$value)
    data$color <- quanColor(data$value, palette, domain = data$value, n = ncuts)
    ## use library(Hmisc), cut2 function to generate numeric intervals
    fills <- Map(function(i){
      list(fillColor=data$color[i], info = data$info[i],fillKey=data$group[i])
    },1:nrow(data))
    names(fills) <- as.character(data$code)
    fillKeys <- as.list(keyColor)
    names(fillKeys) <- key
    fillKeys$defaultFill <- args$defaultFill
    #fillKeys <- list()
  }
  if(is.null(data$group) && is.null(data$value)){
    return(list(fills = list(), fillKeys = list()))
  }
  list(fills=fills,fillKeys=fillKeys)
}



getBubbleFills <- function(bubbles,...){
  if(is.null(bubbles))
    return(list(fills=list(),fillKeys=list()))
  args <- list(...)
  palette <- args$palette
  if(!is.null(bubbles$group)){
    key <- unique(bubbles$group)
    key <- key[!key=="" | is.null(key) | is.na(key)]
    keyColor <- catColor(key, palette)
  }else{
    return(list(fills=list(),fillKeys=list()))
  }
  fillKeys <- as.list(keyColor)
  names(fillKeys) <- key
  fillKeys$defaultFill <- args$defaultFill
  fills <- Map(function(i){
    list(fillKey=bubbles$group[i], info = bubbles$info[i])
  },1:nrow(bubbles))
  names(fills) <- paste0("bubble",1:nrow(bubbles))
  list(fills=fills,fillKeys=fillKeys)
}






getSettings <- function(dmap, opts = NULL,...){
  args <- list(...)



  projectionName <- opts[["projection"]] %||% names(dmap$projections)[1]
  projectionOpts <- dmap$projections[[projectionName]]
  titleOpts <- opts$title
  notesOpts <- opts$notes
  legendOpts <- opts$legend

  defaultOpts <- getDefaultOpts(projectionName, projectionOpts,
                                titleOpts, notesOpts, legendOpts)

  defaultOpts$styles <- paste(defaultOpts$styles,
                              opts$styles,sep="\n")



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
