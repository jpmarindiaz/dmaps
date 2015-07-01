
catColor <- function(v,palette = "RdYlBu"){
  pal <- colorFactor(palette, levels = unique(v))
  pal(v)
}

numColor <- function(v,palette = "RdYlBu"){
  pal <- colorNumeric(palette, domain = NULL)
  pal(v)
}
