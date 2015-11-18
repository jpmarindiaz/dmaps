#' @export
availableDmaps <- function(){
  names(dmapMeta())
}

#' @export
dmapMeta <- function(mapName = NULL){
  dir <- system.file("dmaps",package="dmaps", mustWork=TRUE)
  regex <- paste0(".*yaml$")
  files <- Filter(function(f){grepl(regex,f)},list.files(dir, recursive = TRUE))
  l <- lapply(files,function(name){
    ll <- yaml.load_file(file.path(dir,name))
    ll <- Map(function(ll){
      #basePath <- "https://cdn.rawgit.com/jpmarindiaz/dmaps/master/inst/dmaps"
      basePath <- "https://rawgit.com/jpmarindiaz/dmaps/master/inst/dmaps"
      ll$path <- file.path(basePath,dirname(name),ll$file)
      fp <- file.path("dmaps",dirname(name),ll$codes)
      ll$codesPath <- system.file(fp,package="dmaps")
      ll
    },ll)
    ll
  })

  #names(l) <- file_path_sans_ext(files)
  x <- unlist(l, recursive=FALSE, use.names = TRUE)
  if(!is.null(mapName)){
    return(x[[mapName]])
  }
  x
}

#' @export
dmapProjections <- function(mapName){
  l <- dmapMeta(mapName)
  names(l$projections)
}

#' @export
dmapProjectionOptions <- function(mapName, projection, withDefaults = TRUE){
  l <- dmapMeta(mapName)
  if(!projection %in% names(l$projections))
    stop(mapName, "does not support this projection")
  projection <- l$projections[[projection]]
  if(!withDefaults) return(names(projection))
  projection
}


