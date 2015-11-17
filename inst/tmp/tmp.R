

library(rgdal)

#https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf

# http://rud.is/b/2014/11/16/moving-the-earth-well-alaska-hawaii-with-r/
map <- readOGR(dsn="inst/tmp/ch-all.geo.json", layer="OGRGeoJSON")
str(map)
plot(map)
summary(map)


# convert it to WSG84
map_wgr84 <- spTransform(map, CRS=CRS("+init=EPSG:4326"))
summary(map_wgr84)

map_2 <- spTransform(map, CRS=CRS("+init=EPSG:4326 +lat_0=5 +lon_0=10"))
summary(map_2)


map_2 <- spTransform(map, CRS=CRS("+init=EPSG:4326 +lat_ts=5 +lon_ts=10"))
summary(map_2)

map_2 <- spTransform(map, CRS=CRS("+init=EPSG:4326 +x_0=5000 + y_0=10000"))
summary(map_2)

map_2 <- spTransform(map, CRS=CRS("+proj=longlat +datum=WGS84 +no_defs"))
summary(map_2)

map_2 <- spTransform(map, CRS=CRS("+init=EPSG:4326 +x_0=-999 +y_0=0"))
summary(map_2)


map_2 <- spTransform(map, CRS=CRS("+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs"))
summary(map_2)


geojsonio::geojson_write(map_2, file = "inst/tmp/tmp2.geojson")

str(map_wgr84)
CRS(map)

geojsonio::geojson_write(map_wgr84, file = "tmp.geojson")

