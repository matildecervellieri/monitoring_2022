# R code for uploading and visualizing Coprnicus data in R

library(ncdf4)
library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
# install.packages("viridis")
library(viridis)

# Set the working directory
setwd("/Users/matildecervellieri/lab/copernicus/")

# we upload data and we use the raster function 
snow20211214 <- raster("c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc")
# to see how many layers are inside Copernicus data
# snow20211214 <- brick(“c_gls_SCE_202112140000_NHEMI_VIIRS_V1.0.1.nc”)
snow20211214 # snow cover extent (sce)
snow20211214 # snow cover extent (sce)

# plot of this data 
plot(snow20211214) # higher values in the northern part in green 

# we are plotting it with a new color
cl <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(snow20211214, col=cl)
# Quite nice image. We can zoom 

# We will use viridis: the viridis palette is useful for colorblind people because they can discriminate between minimum and maximum
# ggplot using the geom_raster since we are plotting an image
ggplot() + geom_raster(snow20211214, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent))

# now we will use also viridis with the ggplot function  
ggplot() + geom_raster(snow20211214, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent)) + scale_fill_viridis()
# the default palette is viridis
# all blind people can see it. The human eye is catch by the yellow colour

# let’s use the cividis color palette 
ggplot() + geom_raster(snow20211214, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent)) + scale_fill_viridis(option=“cividis”) 

# we can put names
ggplot() + geom_raster(snow20211214, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent)) + scale_fill_viridis(option="cividis") + ggtitle("cividis palette”)

