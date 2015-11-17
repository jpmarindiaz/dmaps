
removeAccents <- function(string){
  accents <- "àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝäëïöüÄËÏÖÜâêîôûÂÊÎÔÛñÑç"
  translation <- "aeiouAEIOUaeiouyAEIOUYaeiouAEIOUaeiouAEIOUnNc"
  chartr(accents, translation, string)
}

dictionaryMatch <- function(inputStr,dict, empty=c("")){
  dict <- unique(dict)
  l <- lapply(inputStr, function(inputStr){
    #message(inputStr)
    #inputStr <- "CAUCA"
    if(inputStr %in% empty){return(empty[1])}
    inputStr <- tolower(inputStr)
    inputStr <- removeAccents(inputStr)
    dict_tmp <- tolower(dict)
    dict_tmp <- removeAccents(dict_tmp)
    tmp <- adist(inputStr, dict_tmp)
    tmp <- as.vector(tmp)
    dict[which.min(tmp)]
  })
  unlist(l)
}



