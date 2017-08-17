library(devtools)
document()
#load_all()
install()

library(dmaps)

availableDmaps()

mapName <- "col_dc_districts"
opts <- list(
  zoomable = FALSE,
  projectionOpts = list(scale = 50, center = c(-74.1, 4.55)),
  legend = list(show = FALSE)
)
dmaps(data = NULL, mapName, opts = opts)

dmaps(data = data_frame(id = c("19","8"), group = c("x","x")), mapName,
      groupCol = "group", codeCol = "id",
      palette = "PuBu",
      opts = opts)




library(shiny)
app <- shinyApp(
  ui = fluidPage(
    verbatimTextOutput("debug"),
    h2("Localidades"),
    dmapsOutput("viz")
  ),
  server = function(input, output, session) {
    output$viz <- renderDmaps({
      var <- input$selectVariable
      opts <- list(
        zoomable = FALSE,
        defaultFill = "#44DD99",
        borderColor = "#FFFFFF",
        borderWidth = 2,
        highlightFillColor = "#999999",
        projectionOpts = list(scale = 50, center = c(-74.1, 4.55)),
        legend = list(show = FALSE)
      )
      dmaps(data = NULL, "col_dc_districts", opts = opts)
    })

    output$debug <- renderPrint({
      #if(is.null(viz$dmaps_clicked_region)) return()
      paste("CLICKED LOCALIDAD", input$dmaps_clicked_region)
    })

  }
)
runApp(app)
