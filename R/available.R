getDefaultOpts <- function(projectionName = NULL,projectionOpts = NULL,
                           titleOpts = NULL, notesOpts = NULL, legendOpts = NULL, data = NULL){

  textStyles <- textStyles(titleOpts$top, titleOpts$left,
                           notesOpts$top, notesOpts$left)
  legendStyles <- legendStyles(legendOpts$orientation,
                               legendOpts$top,
                               legendOpts$left)
  defaultStyles <- paste0(textStyles,legendStyles)

dopts <- list(
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
  choroLegend = list(
    type = "categorical",
    title = "",
    defaultFillTitle = NULL,
    top = 1,
    left = 1,
    orient = "vertical",
    shapeWidth = 40,
    labels = NULL,
    show = TRUE
  ),
  bubbleColorLegend = list(
    type = "numeric",
    title = "",
    defaultFillTitle = NULL,
    top = 35,
    left = 1,
    orient = "vertical",
    labels = NULL,
    show = TRUE
  ),
  bubbleSizeLegend = list(
    type = "numeric",
    title = "",
    defaultFillTitle = NULL,
    top = 70,
    left = 1,
    orient = "horizontal",
    labels = NULL,
    show = TRUE
  ),
  bivariateLegend = list(
    type = "numeric",
    title = "",
    defaultFillTitle = NULL,
    top = 70,
    left = 5,
    labels = NULL,
    show = FALSE,
    var1Label = "Variable 1",
    var2Label = "Variable 2"
  ),
  graticule = FALSE,
  palette = "PuBu",
  styles = defaultStyles,
  bubbleBorderWidth = 0.001,
  bubbleBorderColor = '#FF6A37',
  bubbleFillOpacity = 0.5,
  bubbleHighlightOnHover = TRUE,
  bubbleHighlightFillColor = 'rgba(255, 106, 55, 0.3)',
  bubbleHighlightBorderColor = '#FB4B3A',
  bubbleHighlightBorderWidth = 1,
  bubbleHighlightFillOpacity = 0.7,
  bubblePalette = "Set3",
  minSizeFactor = 1,
  maxSizeFactor = 50,
  customPalette = NA
)

if(is.null(data)){
  dopts$choroLegend$show <- FALSE
}
dopts
}

textStyles <- function(titleTop = NULL, titleLeft = NULL,
                       notesTop = NULL, notesLeft = NULL){
  textStylesTpl <-
"
.axis path,
.axis line {
    fill: none;
    stroke: black;
    shape-rendering: crispEdges;
    stroke-width:1;
}

.axis text {
    font-family: sans-serif;
    font-size: 11px;
}

#notes{
  position: absolute;
  top: {notesTop}%;
  left: {notesLeft}%;
  text-align:center;
  margin: 0;
  font-size: smaller;
z-index: 1002;
}

#title{
  position: absolute;
  top: {titleTop}%;
  left: {titleLeft}%;
  text-align:center;
  margin:0;
  z-index: 1002;
}
"
pystr_format(textStylesTpl,
             list(
               titleTop=titleTop %||% 0,
               titleLeft=titleLeft %||% 0,
               notesTop=notesTop %||% 80,
               notesLeft=notesLeft %||% 0
             )
)

}

legendStyles <- function(orientation = NULL, top = NULL,left = NULL){
  orientation <- orientation %||% "vertical"
  legendHorizontalStyleTpl <- "
.datamaps-legend {
  position: absolute;
  top: {top}%;
  left: {left}%;
  z-index: 1001;
}
.datamaps-legend dl {
text-align: center;
display: inline-block;
}
.datamaps-hoverover {
color: #444;
max-width:50%
}
"
legendVerticalStyleTpl <- "
.datamaps-legend dt, .datamaps-legend dd {
float: none;
}
.datamaps-legend {
top: {top}%;
left: {left}%;
max-width: 30%;
z-index: 1001;
}
.datamaps-hoverover {
color: #444;
max-width:50%
}
"
if(orientation == 'horizontal'){
  s <- legendHorizontalStyleTpl
}else{
  s <- legendVerticalStyleTpl
}
pystr_format(s,list(top=top %||% 0,left=left %||% 1))
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
      #basePath <- "http://localhost:8000/dmaps"
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


