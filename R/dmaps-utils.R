
makeGeoData <- function(dmap, data = NULL,
                        regionCols = NULL, codeCol = NULL,
                        groupCol = NULL, valueCol = NULL,
                        regions = NULL,
                        opts = NULL){

  if(is.null(data)) return()
  # data must have regionCols or codeCols
  if(!is.null(data) && (is.null(regionCols) && is.null(codeCol))){
    stop("Need to provide regionCols or codeCol")
  }
  geo <- data[c(regionCols, codeCol)]
  # data must have a groupCol or valueCol
  if(!is.null(data) && (is.null(groupCol) && is.null(valueCol))){
    stop("Need to povide a groupCol or a valueCol")
  }

  # Create name col from regionCols
  if(!is.null(regionCols)){
    geo$..name <- apply(data[regionCols],1,paste, collapse = " - ")
  }
  # Create name col from regionCols
  if(!is.null(codeCol)){
    geo$..code <- data[[codeCol]]
  }
  # Match code from name
  codes0 <- read_csv(dmap$codesPath)
  codes <- codes0 %>%
    gather(col, name, name, alternativeNames,na.rm = TRUE) %>%
    select(-col) %>%
    select(..code = id, ..name = name, everything())
  if(suppressWarnings(is.null(geo$..code))){
    geo <- geo %>% mutate(..name = remove_accents(tolower(..name)))
    codes <- codes %>% mutate(...name = remove_accents(tolower(..name)))
    geo <- left_join(geo, codes, by = c("..name"="...name"))
    geo$..name <- match_replace(geo$..code, codes)
    ## TODO Add approximate match
  }else{
    geo$..name <- match_replace(geo$..code, codes)
  }
  d <- left_join(geo, data)
  d <- makeInfoCol(d, opts = opts)

  #
  if(!is.null(valueCol) && !is.null(groupCol)){
    stop("Please use either groupCol of valueCol for choropleth map")
  }
  # Add value cols
  if(!is.null(valueCol)){
    if(!valueCol%in% names(data)){
      stop("valueCol not in data")
    }else{
      d$..value <- data[[valueCol]]
      d$..group <- NA ### removes groups so legendData doesn't use groupValues
      #opts$choroLegend$type <- opts$choroLegend$type %||% "numeric"
    }
  }
  # Add group cols
  if(!is.null(groupCol)){
    if(!groupCol%in% names(data)){
      stop("groupCol not in data")
    }else{
      d$..group <- as.character(data[[groupCol]])
      d$..group[is.na(data$..group)] <- ""
      #opts$choroLegend$type <- opts$choroLegend$type %||% "categorical"
      d$..value <- NA
    }
  }

  # Filter data for values in region
  if(!is.null(regions)){
    regionMeta <- dmap$regions[regions]
    codeIds <- map(regionMeta, "ids") %>% flatten_chr()
    d <- d %>% filter(..code %in% codeIds)
  }
  # Filter data only valid codes
  d <- d %>% filter(!is.na(..code))
  d %>% select(..code, ..name, ..info, ..value, ..group, one_of(names(data)))
}



defaultTpl <- function(data, nms = NULL){
  nms <- nms %||% names(data)[!grepl("^\\.\\.", names(data))]
  title <- paste0("<strong>",nms,"</strong>")
  paste(paste0(title,": {",nms,"}"),collapse="\n<br>\n")
}

makeInfoCol <- function(data, opts = NULL){
  if(is.null(data$..info) && !is.null(data)){
    infoTpl <- opts$tooltip_tpl %||% defaultTpl(data)
    data$..info <- str_tpl_format(infoTpl,data)
  }
  data
}

#' @export
getAvailableRegions <- function(mapName){
  dmap <- dmapMeta(mapName)
  names(dmap$regions)
}

#' @export
getCodesData <- function(mapName){
  dmap <- dmapMeta(mapName)
  read_csv(dmap$codesPath)
}

#' @export
getAvailableProjections <- function(mapName){
  dmap <- dmapMeta(mapName)
  names(dmap$projections)
}
