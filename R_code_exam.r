library(raster)
library(ggplot2)
library(RStoolbox)
library(patchwork)
library(viridis)
library(ncdf4)
library(gridExtra)

# Set the working directory
setwd("/Users/matildecervellieri/lab/exam/")

# Prediction of the alpine glacier retreat using albedo as an indicator of glacier presence
# 3 albedo measurements were used for the years 1999, 2009 and 2009
# In particular, the detections were made in the period August-September: high albedo values indicate permanent snow and ice, thus avoiding the snow cover of the winter months 

# importing dark-sky albedo files: first we make a list and then use the lapply function 
albedo_list <- list.files(pattern="ALDH")
albedo_list

albedo_import <- lapply(albedo_list, raster)
albedo_import # 3 files imported inside r

# stacking them all together
albedo <- stack(albedo_import)
albedo

# Let's change their names
names(albedo) <- c("albedo_1999", "albedo_2009", "albedo_2019")
names(albedo)
albedo

# cropping the images: focusing on the Alps
ext_alps <- c(3, 18, 43, 49)
albedo_cropped <- crop(albedo, ext_alps)
albedo_cropped

# Let's associate them to an object
albedo1999 <- albedo_cropped$albedo_1999
albedo2009 <- albedo_cropped$albedo_2009
albedo2019 <- albedo_cropped$albedo_2019

# let's plot them using cividis palette
a1 <- ggplot() + geom_raster(albedo1999, mapping = aes(x=x, y=y, fill= albedo_1999)) + scale_fill_viridis(option="cividis") + ggtitle("Alps's glaciers in 1999")
a2 <- ggplot() + geom_raster(albedo2009, mapping = aes(x=x, y=y, fill= albedo_2009)) + scale_fill_viridis(option="cividis") + ggtitle("Alps's glaciers in 2009")
a3 <- ggplot() + geom_raster(albedo2019, mapping = aes(x=x, y=y, fill= albedo_2019)) + scale_fill_viridis(option="cividis") + ggtitle("Alps's glaciers in 2019")

# plotting them together to see the changes in the amount of ice and snow over the years: 1999 vs 2009 vs 2019
a1 / a2 / a3

# Let's save the results 
pdf("albedo")
grid.arrange(a1, a2, a3, nrow=3)
dev.off()


# ---------- part 2: envestigate in a deeper way the recent changes in the amount of ice and snow using SCE (snow cover extent)
# yearly changes from 2017 to 2021: always using detections made in the summer season (Sept. 2)

fcover_list <- list.files(pattern="FCOVER")
fcover_list

fcover_import <- lapply(fcover_list, raster)
fcover_import # 3 files imported inside r

# stacking them all together
fcover <- stack(fcover_import)
fcover

# cropping the images: Italy
ext_italy <- c(3, 20, 35, 49)
fcover_cropped <- crop(fcover, ext_italy)
fcover_cropped

fcover1999 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.1
fcover2009 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.2
fcover2019 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.3

par(mfrow=c(1,3))
plot(fcover1999)
plot(fcover2009)
plot(fcover2019)

# Let's save the results 
pdf("forest")
par(mfrow=c(1,3))
plot(fcover1999)
plot(fcover2009)
plot(fcover2019)
dev.off()


# part 3: 
ndvi_list <- list.files(pattern="NDVI")
ndvi_list

ndvi_import <- lapply(ndvi_list, brick)
ndvi_import # 3 files imported inside r

# stacking them all together
ndvi <- stack(ndvi_import)
ndvi

# cropping the images: Italy
ext_italy <- c(3, 20, 35, 49)
ndvi_cropped <- crop(ndvi, ext_italy)
ndvi_cropped

plot(ndvi_cropped)
