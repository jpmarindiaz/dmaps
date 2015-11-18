
removeAccents <- function(string){
  accents <- "àèìòùÀÈÌÒÙáéíóúýÁÉÍÓÚÝäëïöüÄËÏÖÜâêîôûÂÊÎÔÛñÑç"
  translation <- "aeiouAEIOUaeiouyAEIOUYaeiouAEIOUaeiouAEIOUnNc"
  chartr(accents, translation, string)
}

dictionaryMatch <- function(inputStr,dict, empty=c("")){
  l <- strsplit(paste(dict$name,dict$alternativeNames,sep="|"),"|",fixed = TRUE)
  names(l) <- seq_along(l)
  l <- reshape2::melt(l)
  names(l) <- c("name","id")
  l$id <- as.numeric(l$id)
  ids <- lapply(inputStr, function(str){
    #message(inputStr)
    #str <- "CAUCA"
    # str <- "Bogota - Cundinamarca"
    if(str %in% empty){return(empty[1])}
    str <- tolower(str)
    str <- removeAccents(str)
    dict_tmp <- tolower(l[,1])
    dict_tmp <- removeAccents(dict_tmp)
    tmp <- adist(str, dict_tmp)
    tmp <- as.vector(tmp)
    l$id[which.min(tmp)]
  })
  ids <- unlist(ids)
  dict$name[ids]
}

