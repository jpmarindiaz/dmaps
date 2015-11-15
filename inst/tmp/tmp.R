

library(rgdal)

#https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf

# http://rud.is/b/2014/11/16/moving-the-earth-well-alaska-hawaii-with-r/
map <- readOGR(dsn="inst/tmp/ch-all.geo.json", layer="OGRGeoJSON")
str(map)
plot(map)

# convert it to WSG84
map_wgr84 <- spTransform(map, CRS=CRS("+init=EPSG:4326"))
writeOGR(map_wgr84, "tmp.json", "tmp",driver='GeoJSON')

map_2 <- spTransform(map, CRS=CRS("+init=EPSG:4326 +k_0=0.0020157689989 +x_0=265059.01009 +y_0=5294295.52816"))
geojsonio::geojson_write(map_2, file = "inst/tmp/tmp2.geojson")

map_2 <- spTransform(map, CRS=CRS("+proj=latlong"))
geojsonio::geojson_write(map_2, file = "inst/tmp/tmp2.geojson")


map_2 <- spTransform(map, CRS=CRS("+proj=utm +zone=32 +datum=WGS84 +units=m +no_defs"))
geojsonio::geojson_write(map_2, file = "inst/tmp/tmp2.geojson")



str(map_wgr84)
CRS(map)

geojsonio::geojson_write(map_wgr84, file = "tmp.geojson")

