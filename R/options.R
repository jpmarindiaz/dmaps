

getOpts <- function(dmap, opts = NULL, data = NULL,
                    regions = NULL){

  userOpts <- opts
  defaultOpts <- getDefaultOpts(titleOpts = opts$title,
                                legendOpts = opts$legend,
                                notesOpts = opts$notes)

  if(!is.null(data)){
    if(!all(is.na(data$..group))){
      # Is group categories
      defaultOpts$palette <- "Set1"
      defaultOpts$legend$choropleth$type <- "categorical"
    }
  }
  if(!is.null(opts)){
    opts <- modifyList(defaultOpts, userOpts)
  }else{
    opts <- defaultOpts
  }

  if(is.null(data)){
    opts$choroLegend$show <- FALSE # ?????
  }

  opts$styles <- paste(defaultOpts$styles,
                       opts$styles,sep="\n")

  if(is.null(userOpts$projectionName)){
    opts$projectionName <- names(dmap$projections[1]) # take first projection by default
  }else{
      if(!userOpts$projectionName %in% names(dmap$projections))
        stop("Projection not defined for the given dmap")
  }
  opts$projectionOpts <- modifyList(dmap$projections[[opts$projectionName]], opts$projectionOpts)

  # Add region projection options
  if(!is.null(regions)){
    regionMeta <- dmap$regions[[regions]]
    projectOptsRegions <- regionMeta[-1] # select all but ids
    opts$projectionOpts <- modifyList(opts$projectionOpts, projectOptsRegions)
  }


  # settings$bubbleColorLegend$show <- bubbleColorLegendShow
  # settings$bubbleSizeLegend$show <- bubbleSizeLegendShow

  #projectionName <- opts[["projection"]] %||% names(dmap$projections)[1]
  #projectionOpts <- dmap$projections[[projectionName]]
  #titleOpts <- opts$title
  #notesOpts <- opts$notes
  #legendOpts <- opts$legend

  # defaultOpts <- getDefaultOpts(projectionName, projectionOpts,
  #                               titleOpts, notesOpts, legendOpts, data)

  opts
}

getDefaultOpts <- function(titleOpts = NULL, legendOpts = NULL, notesOpts = NULL){

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
    tooltip = list(
      choropleth = list(template = NULL),
      bubbles = list(template = NULL)
    ),
    #tooltip_tpl = NULL,
    #bubblesInfoTpl = NULL,
    projectionName = NULL,
    projectionOpts = list(),
    zoomable = TRUE,
    graticule = FALSE,
    palette = "PuBu",
    minSizeFactor = 1,
    maxSizeFactor = 50,
    customPalette = NA,
    styles = defaultStyles,
    defaultFill = "#DCE5E0",
    borderColor = "#ffffff",
    borderWidth = 1,
    highlightFillColor = "#999999",
    highlightBorderColor = "#444444",
    highlightBorderWidth = 0,
    legend = list(
      show = TRUE,
      choropleth = list(
        type = "numeric",
        title = "",
        defaultFillTitle = NULL,
        top = 1,
        left = 1,
        orient = "vertical",
        shapeWidth = 40,
        labels = NULL,
        show = TRUE
      ),
      bubbleColor = list(
        type = "numeric",
        title = "",
        defaultFillTitle = NULL,
        top = 35,
        left = 1,
        orient = "vertical",
        labels = NULL,
        show = TRUE
      ),
      bubbleSize = list(
        type = "numeric",
        title = "",
        defaultFillTitle = NULL,
        top = 70,
        left = 1,
        orient = "horizontal",
        labels = NULL,
        show = TRUE
      ),
      bivariate = list(
        type = "numeric",
        title = "",
        defaultFillTitle = NULL,
        top = 70,
        left = 5,
        labels = NULL,
        show = FALSE,
        var1Label = "Variable 1",
        var2Label = "Variable 2"
      )
    ),
    # showLegend = TRUE,
    bubbles = list(
      borderWidth = 0.001,
      borderColor = '#FF6A37',
      fillOpacity = 0.5,
      highlightOnHover = TRUE,
      highlightFillColor = 'rgba(255, 106, 55, 0.3)',
      highlightBorderColor = '#FB4B3A',
      highlightBorderWidth = 1,
      highlightFillOpacity = 0.7,
      palette = "Set3"
    )
  )
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
  str_tpl_format(textStylesTpl,
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

  .axis path{
  stroke: #000000 !important;
  }

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
  str_tpl_format(s,list(top=top %||% 0,left=left %||% 1))
}



# if(!is.null(bubbles) && is.null(bubbles$info)){
#   infoTpl <- opts$bubbleInfoTpl %||% defaultTpl(bubbles)
#   bubbles$info <- str_tpl_format(infoTpl,bubbles)
# }
# bubbleSizeLegendShow <- TRUE
# bubbleColorLegendShow <- TRUE
#
# if(is.null(bubbles)){
#   bubbleSizeLegendShow <- FALSE
#   bubbleColorLegendShow <- FALSE
# }
# if(!is.null(bubbles) && is.null(bubbles$radius)){
#   bubbles$radius <- 5
#   bubbleSizeLegendShow <- FALSE
# }
# if(!is.null(bubbles) && is.null(bubbles$group)){
#   bubbleColorLegendShow <- FALSE
# }
