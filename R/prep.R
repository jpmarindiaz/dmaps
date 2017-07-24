
prepData <- function(dmap,opts = NULL, data = NULL, bubbles = NULL, arcs = NULL, ...){
  # message("GET DATA INIT")
  if(is.null(data) && is.null(bubbles))
    return(list(fills = list(), fillKeys = list(), bubblesData = list()))

  data$name <- data$..name
  data$code <- data$..code
  data$value <- data$..value
  data$group <-  data$..group

  data <- discard_all_na_cols(data)


  message("getDataFills")
  str(data)
  dataFills <- getDataFills(data, opts)

  message("after getDataFills")

  bubbleOpts <- opts$bubbles
  bubbleFills <- getBubbleFills(bubbles, bubbleOpts)

  # bubbleFills <- getBubbleFills(bubbles,defaultFill = opts$defaultFill,
  #                               palette = opts$bubblePalette)
  # message("dataFills")
  # str(dataFills)
  message("after bubbleFills")
  # str(bubbleFills)

  fillKeyLabelIds <- c(dataFills$fillKeys,bubbleFills$fillKeys)
  if(!is.null(opts$fillKeyLabels)){
    optsFillKeyLabs <- opts$fillKeyLabels
  }else{
    optsFillKeyLabs <- names(fillKeyLabelIds)
  }
  fkl <- lapply(seq_along(fillKeyLabelIds),function(i) fillKeyLabelIds[[i]] <- optsFillKeyLabs[i])
  names(fkl) <- names(fillKeyLabelIds)

  message("GET DATA END")
  list(fills = c(dataFills$fills,bubbleFills$fills),
       fillKeys = c(dataFills$fillKeys,bubbleFills$fillKeys),
       fillKeyLabels = fkl,
       legendData = dataFills$legendData,
       bubblesData = bubbleFills$bubbles %||% list(),
       legendBubbles = bubbleFills$legendBubbles  %||% list(),
       legendBubblesSize = list(domain = unique(sort(bubbles$radius)  %||% list()))
  )
}


getDataFills <- function(data,opts){
  # message("GET DATA FILLS INIT")
  palette <- opts$palette

  if(!is.null(data$group)){
    if(!is.na(opts$customPalette)){
      key <- opts$customPalette$group
    }else{
      key <- unique(data$group)
    }
    key <- key[!key=="" | is.null(key) | is.na(key)]
    if(!is.na(opts$customPalette)){
      keyColor <- opts$customPalette$color
    }else{
      keyColor <- paletero_cat(key, palette)
    }

    fills <- Map(function(i){
      list(fillKey=data$group[i], info = data$..info[i])
    },1:nrow(data))
    names(fills) <- as.character(data$code)
    fillKeys <- as.list(keyColor)
    names(fillKeys) <- key
    fillKeys$defaultFill <- opts$defaultFill
    legendData <- data.frame(keyColor = keyColor, key = key)
  }
  if(is.null(data$group) && !is.null(data$value)){
    key <- unique(sort(data$value))
    key <- key[!key=="" | is.null(key) | is.na(key)]
    keyColor <- paletero_num(key, palette)
    fills <- Map(function(i){
      list(fillKey=as.character(data$value[i]), info = data$..info[i])
    },1:nrow(data))
    names(fills) <- as.character(data$code)
    fillKeys <- as.list(keyColor)
    names(fillKeys) <- key
    fillKeys$defaultFill <- opts$defaultFill
    legendData <- data.frame(keyColor = keyColor, key = key)
    #fillKeys <- list()
  }
  if(!is.null(data$quantValue)){
    #data$group <- cut2(data$value,g=5,levels.mean=TRUE)
    ncuts <- opts$nLevels
    data$group <- cut2(data$value,g=ncuts)
    key <- levels(data$group)
    key <- key[!key=="" | is.null(key) | is.na(key)]
    cuts <- cut2(data$value,g=ncuts,onlycuts = TRUE)
    if(length(cuts)<nrow(data)) cuts <- cuts[-1]
    keyColor <- quanColor(cuts, palette, domain = cuts, n = ncuts)
    #data$..color <- numColor(data$value, palette, domain = data$value)
    data$..color <- quanColor(data$value, palette, domain = data$value, n = ncuts)
    ## use library(Hmisc), cut2 function to generate numeric intervals
    fills <- Map(function(i){
      list(fillColor=data$..color[i], info = data$..info[i],fillKey=data$group[i])
    },1:nrow(data))
    names(fills) <- as.character(data$code)
    fillKeys <- as.list(keyColor)
    names(fillKeys) <- key
    fillKeys$defaultFill <- opts$defaultFill
    #fillKeys <- list()
    legendData <- data.frame(keyColor = keyColor, key = key)

  }
  if(is.null(data$group) && is.null(data$value)){
    return(list(fills = list(), fillKeys = list()))
  }
  list(fills=fills,fillKeys=fillKeys, legendData = legendData)
}



getBubbleFills <- function(bubbles,...){
  opts <- list(...)
  palette <- opts$bubblePalette
  if(is.null(bubbles))
    return(list(fills=list(),fillKeys=list()))
  opts <- list(...)
  palette <- opts$palette
  #   if(!is.null(bubbles$group)){
  #     key <- unique(bubbles$group)
  #     key <- key[!key=="" | is.null(key) | is.na(key)]
  #     keyColor <- paletero_cat(key, palette)
  #   }else{
  #     return(list(fills=list(),fillKeys=list(),legendBubbles = list(keyColor="",key="")))
  #   }
  if(is.null(bubbles$group)){
    bubbles$group <- "___defaultFill___"
  }
  if(!is.null(bubbles)){
    bubbles$fillKey <- bubbles$group
  }
  key <- unique(bubbles$group)
  key <- key[!key=="" | is.null(key) | is.na(key)]
  keyColor <- paletero_cat(key, palette)
  fillKeys <- as.list(keyColor)
  #str(fillKeys)
  names(fillKeys) <- key
  #fillKeys$defaultFill <- opts$defaultFill
  fills <- Map(function(i){
    list(fillKey=bubbles$group[i], info = bubbles$info[i])
  },1:nrow(bubbles))
  names(fills) <- paste0("bubble",1:nrow(bubbles))
  legendBubbles <- data.frame(keyColor = keyColor, key = key)
  list(fills=fills,fillKeys=fillKeys,legendBubbles = legendBubbles, bubbles = bubbles)
}







