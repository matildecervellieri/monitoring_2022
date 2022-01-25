# Ecological and environmental changes during the years in Italy: glaciers, forests and temperatures
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
a1 <- ggplot() + geom_raster(albedo1999, mapping = aes(x=x, y=y, fill= albedo_1999)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 1999")
a2 <- ggplot() + geom_raster(albedo2009, mapping = aes(x=x, y=y, fill= albedo_2009)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 2009")
a3 <- ggplot() + geom_raster(albedo2019, mapping = aes(x=x, y=y, fill= albedo_2019)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 2019")

# plotting them together to see the changes in the amount of ice and snow over the years: 1999 vs 2009 vs 2019
a1 / a2 / a3

# Let's save the results 
pdf("albedo.pdf")
grid.arrange(a1, a2, a3, nrow=3)
dev.off()

png("albedo.png", 
    width = 1500, height = 2000)
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
pdf("forest.pdf")
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
# value 1 = agricultural areas and water in white
# value 2 = forest in green

# now I want to know the percentage of forest and the percentage of agricultural areas
# the function freq is doing the job, it calculates the number of pixel of forest and agricultural areas
freq(fcover1999c$map) 
# agricultural areas and water (class 1) = 332321
# forest (class 2) = 471887

# let's make the proportion
total1999 <- 471887 + 332321
propagri1999 <- 332321 / total1999
propforest1999 <- 471887 / total1999
propagri1999
propforest1999

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
prop1999 <- c(propforest1999, propagri1999)

proportion1999 <- data.frame(cover, prop1999)
proportion1999 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms
ggplot(proportion1999, aes(x=cover, y=prop1999, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 1999")


####### 2019 #######
fcover2019c <- unsuperClass(fcover2019, nClasses=2) # unsuperClass(x, nClasses)
fcover2019c 

plot(fcover2019c$map)
# value 1 = forest in white
# value 2 = agricultural areas and water in green 

# percentage of forest and the percentage of agricultural areas
freq(fcover2019c$map) 
# forest (class 1) = 437644
# agricultural areas and water (class 2) = 366564

# let's make the proportion
total2019 <- 437644 + 366564
propagri2019 <- 366564 / total2019
propforest2019 <- 437644 / total2019
propagri2019
propforest2019

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
prop2019 <- c(propforest2019, propagri2019)

proportion2019 <- data.frame(cover, prop2019)
proportion2019 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms 
ggplot(proportion2019, aes(x=cover, y=prop2019, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 2019")

# plotting the differences between 1999 conditions and 2019 contitions
fdif <- fcover1999c$map - fcover2019c$map
cl <- colorRampPalette(c("tan3", "yellow", "forest green"))(100)
plot(fdif, col=cl) # yellow parts are the area in which forest has been lost, while green indicates the continuos presence of forest and brown the unchanged agricultural zones

# plotting them all together
pdf("quantitative forest difference map.pdf")
par(mfrow=c(1,3))
plot(fcover1999c$map, main="Forest vs agriculture 1999")
plot(fcover2019c$map, main="Forest vs agriculture 2019")
plot(fdif, col=cl, main="Difference between 1999 and 2019")
dev.off()

g1 <- ggplot(proportion1999, aes(x=cover, y=prop1999, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 1999")
g2 <- ggplot(proportion2019, aes(x=cover, y=prop2019, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 2019")

pdf("quantitative forest difference graph.pdf")
g1 + g2
dev.off()


# part 3: 
lst_list <- list.files(pattern="LST")
lst_list

lst_import <- lapply(lst_list, raster)
lst_import 

# stacking them all together
lst <- stack(lst_import)
lst

# Let's change their names
names(lst) <- c("lst_2017", "lst_2018", "lst_2019", "lst_2020")
names(lst)
lst

# cropping the files: focusing on Italy
lst_cropped <- crop(lst, ext_italy)
lst_cropped


