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
ext_italy <- c(6, 19.5, 36.5, 47)
fcover_cropped <- crop(fcover, ext_italy)
fcover_cropped

fcover1999 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.1
fcover2009 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.2
fcover2019 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.3

par(mfrow=c(1,3))
plot(fcover1999, main="Forest cover 1999")
plot(fcover2009, main="Forest cover 2009")
plot(fcover2019, main="Forest cover 2019")

# Let's save the results 
pdf("forest")
par(mfrow=c(1,3))
plot(fcover1999, main="Forest cover 1999")
plot(fcover2009, main="Forest cover 2009")
plot(fcover2019, main="Forest cover 2019")
dev.off()

# let's make a quantative analysis 
# unsuperClass function: unsupervised classification. We don't explain to the software which is the forest and which the agricultural areas

####### 1999 #######
fcover1999c <- unsuperClass(fcover1999, nClasses=2) # unsuperClass(x, nClasses)
fcover1999c 

plot(fcover1999c$map)
# value 1 = forest
# value 2 = agricultural areas and water

# now I want to know the percentage of forest and the percentage of agricultural areas
# the function freq is doing the job, it calculates the number of pixel of forest and agricultural areas
freq(fcover1999c$map) 
# forest (class 1) = 305665
# agricultural areas and water (class 2) = 35627

# let's make the proportion
total1999 <- 471887 + 332321
propagri1999 <- 332321 / total1999
propforest1999 <- 471887 / total1999
propagri1999
propforest1999

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
# prop1992 <- c(0.8956114, 0.1043886)
prop1999 <- c(propforest1999, propagri1999)

proportion1999 <- data.frame(cover, prop1999)
proportion1999 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms (geom_bar function with the statistic values, so the actual ones. Fill is the colour inside the bar)
ggplot(proportion1999, aes(x=cover, y=prop1999, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)

####### 2009 #######
fcover2009c <- unsuperClass(fcover2009, nClasses=2) # unsuperClass(x, nClasses)
fcover2009c 

plot(fcover2009c$map)
# value 1 = forest
# value 2 = agricultural areas and water

# now I want to know the percentage of forest and the percentage of agricultural areas
# the function freq is doing the job, it calculates the number of pixel of forest and agricultural areas
freq(fcover2009c$map) 
# forest (class 1) = 305665
# agricultural areas and water (class 2) = 35627

# let's make the proportion
total2009 <- 507388 + 296820
propagri2009 <- 296820 / total2009
propforest2009 <- 507388 / total2009
propagri2009
propforest2009

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
# prop1992 <- c(0.8956114, 0.1043886)
prop2009 <- c(propforest2009, propagri2009)

proportion2009 <- data.frame(cover, prop2009)
proportion2009 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms (geom_bar function with the statistic values, so the actual ones. Fill is the colour inside the bar)
ggplot(proportion2009, aes(x=cover, y=prop2009, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)


####### 2019 #######
fcover2019c <- unsuperClass(fcover2019, nClasses=2) # unsuperClass(x, nClasses)
fcover2019c 

plot(fcover2019c$map)
# value 1 = forest
# value 2 = agricultural areas and water

# now I want to know the percentage of forest and the percentage of agricultural areas
# the function freq is doing the job, it calculates the number of pixel of forest and agricultural areas
freq(fcover2019c$map) 
# forest (class 1) = 305665
# agricultural areas and water (class 2) = 35627

# let's make the proportion
total2019 <- 437644 + 366564
propagri2019 <- 366564 / total2019
propforest2019 <- 437644 / total2019
propagri2019
propforest2019

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
# prop1992 <- c(0.8956114, 0.1043886)
prop2019 <- c(propforest2019, propagri2019)

proportion2019 <- data.frame(cover, prop2019)
proportion2019 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms (geom_bar function with the statistic values, so the actual ones. Fill is the colour inside the bar)
ggplot(proportion2019, aes(x=cover, y=prop2019, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)


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
