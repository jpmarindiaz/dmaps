

library(rgdal)

#https://www.nceas.ucsb.edu/~frazier/RSpatialGuides/OverviewCoordinateReferenceSystems.pdf

# http://rud.is/b/2014/11/16/moving-the-earth-well-alaska-hawaii-with-r/
map <- readOGR(dsn="inst/tmp/ch-all.geo.json", layer="OGRGeoJSON")

# convert it to WSG84
map_wgr84 <- spTransform(map, CRS=CRS("+init=EPSG:4326"))
str(map_wgr84)

writeOGR(map_wgr84, "tmp.json", "tmp",driver='GeoJSON')

geojsonio::geojson_write(map_wgr84, file = "tmp.geojson")

