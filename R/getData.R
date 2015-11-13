
getData <- function(type,data, ...){
  args <- list(...)
  palette <- args$palette
  codes <- read.csv(system.file("data/dane-codes.csv",package = "dmaps"))

  if(type == "colombia0" && !names(data) %in% c("depto","group"))
    stop("for type colombia0, names of data must be 'depto' and 'group'")
  if(type == "colombia1" && !names(data) %in% c("mpio","group"))
    stop("for type mpio, names of data must be 'mpio' and 'group'")

  if(type == "ecuador0" && !names(data) %in% c("prov","group"))
    stop("for type colombia0, names of data must be 'prov' and 'group'")

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



  if(type %in% c("colombia0")){
    data$code <- codes$departamentoId[match(data$depto,codes$departamento)]
    data$code <- sprintf("%02d", data$code)
    }
  if(type == "colombia1"){
    data$code <- codes$municipioId[match(data$municipio,codes$departamento)]
  }
  if(type %in% c("ecuador0")){
    data$code <- codes$departamentoId[match(data$depto,codes$departamento)]
    data$code <- sprintf("%02d", data$code)
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
    scale = 2,
    translateX = 0,
    translateY = 0,
    defaultFill = "#B8CDB9",
    borderColor = "#00FF000",
    borderWidth = 1,
    highlightFillColor = "#999999",
    highlightBorderColor = "#444444",
    highlightBorderWidth = 0,
    legend = TRUE,
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
