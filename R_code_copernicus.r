# R code for uploading and visualizing Coprnicus data in R

library(ncdf4)
library(raster)
library(RStoolbox)
library(ggplot2)
library(gridExtra)
# install.packages("viridis")
library(viridis)
library(patchwork)

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
ggplot() + geom_raster(snow20211214, mapping = aes(x=x, y=y, fill= Snow.Cover.Extent)) + scale_fill_viridis(option="cividis") + ggtitle("cividis palette")

# ------ day 2
# We did this for the image of the 14th of December, now we're dealing with the one of the 29th of August 
# importing all the data together with the lapply function. The common pattern is SCE
rlist <- list.files(pattern="SCE")
rlist

list_rast <- lapply(rlist, raster)
list_rast # we can see the two files

# now we need to stack all the files together 
snowstack <- stack(list_rast)
snowstack

ssummer <- snowstack$Snow.Cover.Extent.1 # summer 
swinter <- snowstack$Snow.Cover.Extent.2 # winter 
ssummer
swinter

# let's make a ggplot 
ggplot() + geom_raster(ssummer, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.1)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during my birthday!")
# it's a good colour palette because the yellow is for the maximum value 

ggplot() + geom_raster(swinter, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.2)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during the 14th of December!")
# the gray part is like that because data is missing 

# let's patchwork them together
p1 <- ggplot() + geom_raster(ssummer, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.1)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during my birthday!")
p2 <- ggplot() + geom_raster(swinter, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.2)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during the 14th of December!")

p1 / p2

# we can see coordinates, such as latitude and longitude
# we can zoom to a specific point 

# we can crop your image on a certain area

# longitude from 0 to 20
# latitude from 30 to 50
# crop the stack to the extent of Sicily
ext <- c(0, 20, 30, 50)
# stack_cropped <- crop(snowstack, ext) # this will crop the whole srack, and 
ssummer_cropped <- crop(ssummer, ext)
swinter_cropped <- crop(swinter, ext)

plot(ssummer_cropped)
plot(swinter_cropped)

p1 <- ggplot() + geom_raster(ssummer_cropped, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.1)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during my birthday!")
p2 <- ggplot() + geom_raster(swinter_cropped, mapping = aes(x=x, y=y, fill=Snow.Cover.Extent.2)) + scale_fill_viridis(option="viridis") + ggtitle("Snow cover during the 14th of December!")

p1 / p2



