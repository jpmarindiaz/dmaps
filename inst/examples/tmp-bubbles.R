
library(devtools)
load_all()
document()
install()

library(dmaps)



## Dmaps Choro + Bubbles
## Added bubble palette option

codes <- read.csv("inst/dmaps/co/dane-codes-municipio.csv", colClasses = "character")
d <- data.frame(
  code = sample(codes$id,500),
  group = sample(letters[1:2],500,replace = TRUE)
)
d$nombre <- codes$name[match(d$code,codes$id)]


d2 <- data.frame(
  code = sample(codes$id,500),
  #group = sample(letters[3:4],5,replace = TRUE)
  group = sample(3:4,500,replace = TRUE)
)
d$municipio <- codes$municipio[match(d$code,codes$id)]
d$departamento <- codes$departamento[match(d$code,codes$id)]
d2$latitude <- codes$latitud[match(d2$code,codes$id)]
d2$longitude <- codes$longitud[match(d2$code,codes$id)]
d2$radius <- sample(c(5,3),nrow(d2),replace = TRUE)

mapName <- "co_municipalities"
d
dmaps(mapName,
      data = d,
      groupCol = "group",
      #regionCols = c("municipio","departamento"),
      codeCol = "code",
      bubbles = d2)



### Bubbles

### Check if only bubbles work
bubbles <- data.frame(
  latitude=c(50,4),
  longitude=c(4,-70)
)
mapName <- "world_countries"
dmaps("world_countries",bubbles = bubbles)

### Check if only bubbles work
bubbles <- data.frame(
  latitude=c(50,4),
  longitude=c(4,-70),
  radius=c(10,15)
)
mapName <- "world_countries"
dmaps("world_countries",bubbles = bubbles)


### Check if only bubbles with groups work
bubbles <- data.frame(
  latitude=c(50,4),
  longitude=c(4,-70),
  radius=c(10,15),
  group=c("A","B"),
  info = c("AA","BB")
)
dmaps("world_countries",bubbles = bubbles)


