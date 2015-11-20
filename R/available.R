getDefaultOpts <- function(projectionName = NULL,projectionOpts = NULL){
  defaultStyles <- "
#notes{
  position: absolute;
  top: 80%;
  left: 0%;
  text-align:center;
  font-size: smaller;
  margin: 0 10%;
}

#title{
  position: absolute;
  top: 80%;
  left: 0%;
  margin:0;
  text-align:center;
}

.datamaps-legend dt, .datamaps-legend dd {
  float: none;
}
.datamaps-legend {
left: 1%;
top: 0%;
max-width: 30%;
}
.datamaps-hoverover {
color: #444;
max-width:35%
}
"

  list(
    title = list(text="",top=0,left=0),
    notes = list(text="",top=80,left=0),
    nLevels = 5,
    infoTpl = NULL,
    bubblesInfoTpl = NULL,
    projection = projectionName,
    projectionOpts = projectionOpts,
    zoomable = TRUE,
    defaultFill = "#DCE5E0",
    borderColor = "#ffffff",
    borderWidth = 1,
    highlightFillColor = "#999999",
    highlightBorderColor = "#444444",
    highlightBorderWidth = 0,
    showLegend = TRUE,
    legend = list(
      title = "",
      defaultFillTitle = NULL,
      top = 0,
      left = 1
      ),
    graticule = FALSE,
    palette = "RdYlBu",
    styles = defaultStyles,
    bubbleBorderWidth = 1,
    bubbleBorderColor = '#FF6A37',
    bubbleFillOpacity = 0.5,
    bubbleHighlightOnHover = TRUE,
    bubbleHighlightFillColor = 'rgba(255, 106, 55, 0.3)',
    bubbleHighlightBorderColor = '#FB4B3A',
    bubbleHighlightBorderWidth = 1,
    bubbleHighlightFillOpacity = 0.7
  )
}

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


