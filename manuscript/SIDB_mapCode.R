library(sp)
library(maptools)
library(rgdal)
#install.packages('rgeos')
library(rgeos)
library(raster)
#install.packages('rasterVis')
library(rasterVis)
library(classInt)
library(RColorBrewer)
library(sf)

#   http://www.naturalearthdata.com/downloads/50m-physical-vectors/

# Natural Earth shape files -- global (Robinson) projections
# get shapefiles from http://www.naturalearthdata.com

#### Be sure to link to your own path below ####
shape_path <-
coast_shapefile <- paste(shape_path, "ne_50m_coastline.shp", sep="")
ocean_shapefile <- paste(shape_path, "ne_50m_ocean.shp", sep="")
admin0_shapefile <- paste(shape_path, "ne_50m_admin_0_countries.shp", sep="")
admin1_shapefile <- paste(shape_path, "ne_50m_admin_1_states_provinces_lakes.shp", sep="")
lakes_shapefile <- paste(shape_path, "ne_50m_lakes.shp", sep="")
bb_shapefile <- paste(shape_path, "ne_50m_wgs84_bounding_box.shp", sep="")
grat30_shapefile <- paste(shape_path, "ne_50m_graticules_30.shp", sep="")

# find out kind of shapefile (lines vs. polygons)
layer <- ogrListLayers(coast_shapefile)
ogrInfo(coast_shapefile, layer=layer)

# read the shape file
coast_lines <- readOGR(coast_shapefile, layer=layer)
#summary(coast_lines)

unproj_proj4string <- proj4string(coast_lines)
unproj_proj4string

# read the shape file
layer <- ogrListLayers(ocean_shapefile)
ocean_poly <- readOGR(ocean_shapefile, layer=layer)
#summary(ocean_poly)

layer <- ogrListLayers(admin0_shapefile)
ogrInfo(admin0_shapefile, layer=layer)
admin0_poly <- readOGR(admin0_shapefile, layer=layer)
#summary(admin0_poly)

layer <- ogrListLayers(admin1_shapefile)
ogrInfo(admin1_shapefile, layer=layer)
admin1_poly <- readOGR(admin1_shapefile, layer=layer)
#summary(admin1_poly)

layer <- ogrListLayers(lakes_shapefile)
ogrInfo(lakes_shapefile, layer=layer)
lakes_poly <- readOGR(lakes_shapefile, layer=layer)
#summary(lakes_poly)

lrglakes_poly <- lakes_poly[lakes_poly$scalerank <= 2 ,]

layer <- ogrListLayers(grat30_shapefile)
ogrInfo(grat30_shapefile, layer=layer)
grat30_lines <- readOGR(grat30_shapefile, layer=layer)
#summary(grat30_lines)

layer <- ogrListLayers(bb_shapefile)
ogrInfo(bb_shapefile, layer=layer)
bb_poly <- readOGR(bb_shapefile, layer=layer)
#summary(bb_poly)
bb_lines <- as(bb_poly, "SpatialLines")

# Map uses Robinson projection
# set Robinson CRS
unproj_crs <- CRS("+proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0")
unproj_crs

robin_crs <- CRS("+proj=robin +lon_0=0w")
robin_crs

#Transform all shape files
bb_poly_proj <- spTransform(bb_poly, robin_crs)
coast_lines_proj <- spTransform(coast_lines, robin_crs)
admin0_poly_proj <- spTransform(admin0_poly, robin_crs)
admin1_poly_proj <- spTransform(admin1_poly, robin_crs)
lakes_poly_proj <- spTransform(lakes_poly, robin_crs)
grat30_lines_proj <- spTransform(grat30_lines, robin_crs)
ocean_poly_proj <- spTransform(ocean_poly, robin_crs)

################ SIDB DATA ADDITION ####################
sp::coordinates(coords) <- ~longitude+latitude
proj4string(coords) <- CRS("+proj=longlat +datum=WGS84")
llCoords <- spTransform(coords, robin_crs)
raster::shapefile(llCoords, 'SIDB_sites.shp')
sidb_shape <- paste(shape_path, 'SIDB_sites.shp', sep = '')
layer <- ogrListLayers(sidb_shape)
ogrInfo(sidb_shape, layer=layer)
sidb_lines <- readOGR(sidb_shape, layer=layer)
summary(sidb_lines)

plot(bb_poly_proj, col="gray95")
plot(admin0_poly_proj, col="white", bor="darkgray", add=TRUE)
#plot(admin1_poly_proj, col="white", bor="darkgray", add=TRUE)
plot(lakes_poly_proj, bor="lightblue", add=TRUE)
#plot(lrglakes_poly_proj, bor="purple", add=TRUE)
plot(coast_lines_proj, col="gray18", add=TRUE, lwd = 0.5)
plot(ocean_poly_proj, col = 'lightskyblue1', add=TRUE)
plot(grat30_lines_proj, col="pink", add=TRUE, lwd = 1.2)
plot(bb_poly_proj, bor="black", add=TRUE)
plot(sidb_lines, col = 'red', pch = 2, lwd = 1.3, cex =0.5, add = TRUE, fill = 'white')
