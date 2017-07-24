
sort_list <- function(l){
  l[sort(names(l))]
}


discard_all_na_cols <- function (d){
  f <- function(x) !all(is.na(x))
  d %>% keep(f)
}

remove_accents <- function(string){
  accents <- "àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝäëïöüÄËÏÖÜâêîôûÂÊÎÔÛñÑç"
  translation <- "aeiouAEIOUaeiouyAEIOUYaeiouAEIOUaeiouAEIOUnNc"
  chartr(accents, translation, string)
}

match_replace <- function(v,dic, force = TRUE){
  matches <- dic[[2]][match(v,dic[[1]])]
  out <- matches
  if(!force)
    out[is.na(matches)] <- v[is.na(matches)]
  out
}

str_tpl_format <- function(tpl, l){
  if("list" %in% class(l)){
    listToNameValue <- function(l){
      mapply(function(i,j) list(name = j, value = i), l, names(l), SIMPLIFY = FALSE)
    }
    f <- function(tpl,l){
      gsub(paste0("{",l$name,"}"), l$value, tpl, fixed = TRUE)
    }
    return( Reduce(f,listToNameValue(l), init = tpl))
  }
  if("data.frame" %in% class(l)){
    myTranspose <- function(x) lapply(1:nrow(x), function(i) lapply(l, "[[", i))
    return( unlist(lapply(myTranspose(l), function(l, tpl) str_tpl_format(tpl, l), tpl = tpl)) )
  }
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
