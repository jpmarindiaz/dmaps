#' @export
getAvailableRegions <- function(mapName){
  dmap <- dmapMeta(mapName)
  names(dmap$regions)
}

#' @export
getCodesData <- function(mapName){
  dmap <- dmapMeta(mapName)
  path <- file.path("dmaps",basename(dirname(dmap$codesPath)),basename(dmap$codesPath))
  read.csv(system.file(path,package = "dmaps"),colClasses = "character")
}


defaultTpl <- function(data, nms = NULL){
  nms <- nms %||% names(data)
  title <- paste0("<strong>",nms,"</strong>")
  paste(paste0(title,": {",nms,"}"),collapse="\n<br>\n")
}

`%||%` <- function (x, y)
{
  if (is.empty(x))
    return(y)
  else if (is.null(x) || is.na(x))
    return(y)
  else if (class(x) == "character" && nchar(x) == 0)
    return(y)
  else x
}

is.empty <- function (x)
{
  !as.logical(length(x))
}

file_path_sans_ext <- function (x)
{
  sub("([^.]+)\\.[[:alnum:]]+$", "\\1", x)
}
