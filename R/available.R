


#' #' @export
#' availableDmaps <- function(){
#'   names(dmapMeta())
#' }
#'
#' #' @export
#' dmapMeta <- function(mapName = NULL){
#'   dir <- system.file("dmaps",package="dmaps", mustWork=TRUE)
#'   files <- list.files(dir,pattern = ".*.yaml",full.names = TRUE)
#'   l <- map(files,function(x){
#'       ll <- yaml.load_file(x)
#'       map(ll, function(y){
#'         y$geoname = basename(file_path_sans_ext(x))
#'         y
#'         })
#'     }) %>% flatten()
#'
#'   basePath <- "https://rawgit.com/jpmarindiaz/geo-collection/master"
#'   l <- map(l,function(x){
#'     x$path <- file.path(basePath,x$geoname, x$file)
#'     x$codesPath <- file.path(basePath,x$geoname,x$codes)
#'     x
#'   })
#'   if(!is.null(mapName)){
#'     return(l[[mapName]])
#'   }
#'   l
#' }
#'
#' #' @export
#' dmapProjections <- function(mapName){
#'   l <- dmapMeta(mapName)
#'   names(l$projections)
#' }
#'
#' #' @export
#' dmapProjectionOptions <- function(mapName, projection, withDefaults = TRUE){
#'   l <- dmapMeta(mapName)
#'   if(!projection %in% names(l$projections))
#'     stop(mapName, "does not support this projection")
#'   projection <- l$projections[[projection]]
#'   if(!withDefaults) return(names(projection))
#'   projection
#' }


