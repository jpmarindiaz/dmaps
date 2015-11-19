
catColor <- function(v,palette = NULL){
  palette <- palette %||% "RdYlBu"
  pal <- colorFactor(palette, levels = unique(v))
  pal(v)
}

numColor <- function(v,palette = "RdYlBu"){
  pal <- colorNumeric(palette, domain = NULL)
  pal(v)
}

# Seq palette
# Blues BuGn BuPu GnBu Greens Greys Oranges OrRd PuBu PuBuGn PuRd Purples RdPu Reds YlGn YlGnBu YlOrBr YlOrRd
# Divergent
# BrBG PiYG PRGn PuOr RdBu RdGy RdYlBu RdYlGn Spectral
# Qualitative
# Accent Dark2 Paired Pastel1 Pastel2 Set1 Set2 Set3


# c("Blues", "BuGn", "BuPu", "GnBu", "Greens", "Greys", "Oranges", "OrRd", "PuBu", "PuBuGn", "PuRd", "Purples", "RdPu", "Reds", "YlGn", "YlGnBu", "YlOrBr", "YlOrRd", "BrBG", "PiYG", "PRGn", "PuOr", "RdBu", "RdGy", "RdYlBu", "RdYlGn", "Spectral", "Accent", "Dark2", "Paired", "Pastel1", "Pastel2", "Set1", "Set2", "Set3")
