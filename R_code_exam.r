# Ecological and environmental changes during the years in Italy: glaciers, forests and thropic state of lakes

library(raster) # main used package in remote sensing 
library(ggplot2) # used to ggplot raster layers 
library(RStoolbox) # used for Unsupervised classification 
library(patchwork) # used to compose multiple ggplots 
library(viridis) # used for the color scales
library(ncdf4) # used to open neetCDF files 
library(gridExtra) # used to arrange multiple grobs on a page

# Set the working directory
setwd("/Users/matildecervellieri/lab/exam/")


# -------- part 1: prediction of the Alpine glacier retreat using albedo as an indicator of glacier presence
# 6 albedo measurements were used for the years 1999, 2003, 2007, 2011, 2015 and 2019, taken from Copernicus Global Land Service
# In particular, the detections were made in the period August-September: high albedo values indicate permanent snow and ice, thus avoiding the snow cover of the winter months 

# importing dark-sky albedo files: first we make a list and then use the lapply function 
albedo_list <- list.files(pattern="ALDH")
albedo_list

# using the function nc_open on a file it's possible to see all the layers/variable in the opened file. The one of our interest now is AL_DH_BB and can be selected using the function brick and specify the varname
# nc_open("c_gls_ALDH_199909030000_GLOBE_VGT_V1.4.1.nc")
albedo_import <- lapply(albedo_list, brick, varname="AL_DH_BB")
albedo_import

# stacking them all together
albedo <- stack(albedo_import)
albedo

# Let's change their names
names(albedo) <- c("albedo_1999", "albedo_2003", "albedo_2007", "albedo_2011", "albedo_2015", "albedo_2019")
names(albedo)
albedo

# cropping the data: focusing on the Alps
ext_alps <- c(3, 18, 43, 49)
albedo_cropped <- crop(albedo, ext_alps)
albedo_cropped

# Let's associate them to an object
albedo1999 <- albedo_cropped$albedo_1999
albedo2003 <- albedo_cropped$albedo_2003
albedo2007 <- albedo_cropped$albedo_2007
albedo2011 <- albedo_cropped$albedo_2011
albedo2015 <- albedo_cropped$albedo_2015
albedo2019 <- albedo_cropped$albedo_2019

# let's plot them using cividis palette
a1 <- ggplot() + geom_raster(albedo1999, mapping = aes(x=x, y=y, fill= albedo_1999)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 1999")
a2 <- ggplot() + geom_raster(albedo2003, mapping = aes(x=x, y=y, fill= albedo_2003)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 2003")
a3 <- ggplot() + geom_raster(albedo2007, mapping = aes(x=x, y=y, fill= albedo_2007)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 2007")
a4 <- ggplot() + geom_raster(albedo2011, mapping = aes(x=x, y=y, fill= albedo_2011)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 2011")
a5 <- ggplot() + geom_raster(albedo2015, mapping = aes(x=x, y=y, fill= albedo_2015)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 2015")
a6 <- ggplot() + geom_raster(albedo2019, mapping = aes(x=x, y=y, fill= albedo_2019)) + scale_fill_viridis(option="cividis", limits=c(0, 0.5)) + ggtitle("Alps's glaciers in 2019")


# plotting them together to see the changes in the amount of ice and snow over the years: 1999 vs 2009 vs 2019
a1 + a4 / a5 + a2 / a3 + a6

# difference between 1999 and 2019 ice conditions
adif <- albedo1999 - albedo2019
adif
# plotting the difference beetween 1999 and 2019 ice conditions in the Alps 
acl <- colorRampPalette(c("navyblue", "royalblue3","white", "red2"))(100)
plot(adif, col=acl, main="difference between 1999 and 2019 ice conditions in the Alps")


# Let's save the results 
pdf("albedo.pdf")
grid.arrange(a1, a2, a3, a4, a5, a6, ncol=2, nrow=3)
dev.off()

png("_albedo_difference.png", 
    width = 1500, height = 2000)
plot(adif, col=acl, main="difference between 1999 and 2019 ice conditions in the Alps")
dev.off()


# ---------- part 2: changes over the years in the Italian forest area using the Forest Cover data from Copernicus Global Land Service
# ten years changes: 1999 vs 2009 vs 2019

# importing the FCOVER data: first we make a list and then use the lapply function
fcover_list <- list.files(pattern="FCOVER")
fcover_list

fcover_import <- lapply(fcover_list, raster) # same as doing fcover_import <- lapply(fcover_list, brick, varname="FCOVER") because the first layer is FCOVER
fcover_import # 5 files imported inside r

# stacking them all together
fcover <- stack(fcover_import)
fcover

# cropping the data: Italy
ext_italy <- c(6, 19.5, 36.5, 47)
fcover_cropped <- crop(fcover, ext_italy)
fcover_cropped

# Let's assign them to an object
fcover1999 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.1
fcover2004 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.2
fcover2009 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.3
fcover2014 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.4
fcover2019 <- fcover_cropped$Fraction.of.green.Vegetation.Cover.1km.5

# First step: qualitative analysis 
par(mfrow=c(2,3))
plot(fcover1999, main="Forest cover 1999")
plot(fcover2004, main="Forest cover 2004")
plot(fcover2009, main="Forest cover 2009")
plot(fcover2014, main="Forest cover 2014")
plot(fcover2019, main="Forest cover 2019")

# Let's save the results 
pdf("forest.pdf")
par(mfrow=c(2,3))
plot(fcover1999, main="Forest cover 1999")
plot(fcover2004, main="Forest cover 2004")
plot(fcover2009, main="Forest cover 2009")
plot(fcover2014, main="Forest cover 2014")
plot(fcover2019, main="Forest cover 2019")
dev.off()

# Second step: let's make a quantative analysis in order to estimate the percentage of forest loss in 20 years (1999 vs 2019)
# unsuperClass function: unsupervised classification. We don't explain to the software which is the forest and which the agricultural areas

####### 1999 #######
fcover1999c <- unsuperClass(fcover1999, nClasses=2) # unsuperClass(x, nClasses)
fcover1999c 

plot(fcover1999c$map)
# value 1 = forest in white
# value 2 = agricultural areas and water in green

# now I want to know the percentage of forest and the percentage of agricultural areas
# the function freq is doing the job, it calculates the number of pixel of forest and agricultural areas
freq(fcover1999c$map) 
# forest (class 1) = 511418
# agricultural areas and water (class 2) = 292790

# let's make the proportion
total1999 <- 511418 + 292790
propagri1999 <- 292790 / total1999
propforest1999 <- 511418 / total1999
propagri1999 # 36% of agricoltural and water areas
propforest1999 # 64% of forest

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
prop1999 <- c(propforest1999, propagri1999)

proportion1999 <- data.frame(cover, prop1999)
proportion1999 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function: histograms
ggplot(proportion1999, aes(x=cover, y=prop1999, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 1999")


####### 2019 #######
fcover2019c <- unsuperClass(fcover2019, nClasses=2) # unsuperClass(x, nClasses)
fcover2019c 

plot(fcover2019c$map)
# value 1 = agricultural areas and water in white
# value 2 = forest in green 

# percentage of forest and the percentage of agricultural areas
freq(fcover2019c$map) 
# agricultural areas and water (class 1) = 341614
# forest (class 2) = 462594

# let's make the proportion
total2019 <- 462594 + 341614
propagri2019 <- 341614 / total2019
propforest2019 <- 462594 / total2019
propagri2019 # 46% of agricoltural and water areas
propforest2019 # 54% of forest: -5% of forests

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
prop2019 <- c(propforest2019, propagri2019)

proportion2019 <- data.frame(cover, prop2019)
proportion2019 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms 
ggplot(proportion2019, aes(x=cover, y=prop2019, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 2019")

# plotting the differences between 1999 conditions and 2019 contitions
fdif <- fcover1999c$map - fcover2019c$map
cl <- colorRampPalette(c("forest green", "yellow", "tan3"))(100)
plot(fdif, col=cl, main="Difference between 1999 and 2019") # in this case: yellow parts are the area in which forest has been lost, while green indicates the continuos presence of forest and brown the unchanged agricultural zones
# if the unsuperClass function gives different values to the forest and agricultural areas, the colour palette should be adjusted in order to point out changes

# plotting them all together
pdf("quantitative forest difference map.pdf")
par(mfrow=c(1,3))
plot(fcover1999c$map, main="Forest vs agriculture 1999")
plot(fcover2019c$map, main="Forest vs agriculture 2019")
plot(fdif, col=cl, main="Difference between 1999 and 2019")
dev.off()

g1 <- ggplot(proportion1999, aes(x=cover, y=prop1999, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 1999")
g2 <- ggplot(proportion2019, aes(x=cover, y=prop2019, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1) + ggtitle("Proportion of 2019")
g1 + g2 # loss of 5% of forests

pdf("quantitative forest difference graph.pdf")
g1 + g2
dev.off()


# ------------ part 3: changes during the years in the thropic state index (layer of Lake Water Quality dataset from Copernicus Global Land Service) of Northern Italy lakes 
# Comparison between the lakes trophic conditions of the years 2004, 2008, 2012, 2016, 2020

# TSI from 0 to 100:

# oligotrophic (TSI 0–40, having the least amount of biological productivity, "good" water quality)
# mesotrophic (TSI 40–60, having a moderate level of biological productivity, "fair" water quality)
# eutrophic to hypereutrophic (TSI 60–100, having the highest amount of biological productivity, "poor" water quality)

# importing the Lake Water Quality data: first we make a list and then use the lapply function 
lwq_list <- list.files(pattern="LWQ")
lwq_list

lwq_import <- lapply(lwq_list, brick, varname="trophic_state_index")
lwq_import

# stacking them all together
lwq <- stack(lwq_import)
lwq

# Let's change their names
names(lwq) <- c("lwq_2004", "lwq_2008", "lwq_2012", "lwq_2016", "lwq_2020")
names(lwq)
lwq

# cropping the data: focusing on the Lombardy's basin
ext_alps_zoom <- c(8.2, 11.2, 45.4, 46.2)
lwq_cropped <- crop(lwq, ext_alps_zoom)
lwq_cropped

# plotting the data dividing by colour the three trophic categories: 
# oligotrophic (TSI 0–40, "good" water quality): light blue/green 
# mesotrophic (TSI 40–60, "fair" water quality): orange
# eutrophic to hypereutrophic (TSI 60–100, "poor" water quality): red/dark red 
l1 <- ggplot() + geom_raster(lwq_cropped$lwq_2004, mapping = aes(x=x, y=y, fill= lwq_2004)) + scale_fill_viridis(option="turbo", limits=c(0, 100), breaks=c(0, 40, 60, 100), begin=0.3, end=1) + ggtitle("TSI 2004")
l2 <- ggplot() + geom_raster(lwq_cropped$lwq_2008, mapping = aes(x=x, y=y, fill= lwq_2008)) + scale_fill_viridis(option="turbo", limits=c(0, 100), breaks=c(0, 40, 60, 100), begin=0.3, end=1) + ggtitle("TSI 2008")
l3 <- ggplot() + geom_raster(lwq_cropped$lwq_2012, mapping = aes(x=x, y=y, fill= lwq_2012)) + scale_fill_viridis(option="turbo", limits=c(0, 100), breaks=c(0, 40, 60, 100), begin=0.3, end=1) + ggtitle("TSI 2012")
l4 <- ggplot() + geom_raster(lwq_cropped$lwq_2016, mapping = aes(x=x, y=y, fill= lwq_2016)) + scale_fill_viridis(option="turbo", limits=c(0, 100), breaks=c(0, 40, 60, 100), begin=0.3, end=1) + ggtitle("TSI 2016")
l5 <- ggplot() + geom_raster(lwq_cropped$lwq_2020, mapping = aes(x=x, y=y, fill= lwq_2020)) + scale_fill_viridis(option="turbo", limits=c(0, 100), breaks=c(0, 40, 60, 100), begin=0.3, end=1) + ggtitle("TSI 2020")

# Let's plot the graphs all together!
l1 + l2 + l3 + l4 + l5

# plotting the TSI histograms all together 
par(mfrow=c(2,3))
hist(lwq_cropped$lwq_2004, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2004", xlab="TSI values")
hist(lwq_cropped$lwq_2008, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2008", xlab="TSI values")
hist(lwq_cropped$lwq_2012, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2012", xlab="TSI values")
hist(lwq_cropped$lwq_2016, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2016", xlab="TSI values")
hist(lwq_cropped$lwq_2020, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2020", xlab="TSI values")

# saving the results!
pdf("TSI plot", width=30, height=10)
l1 + l2 + l3 + l4 + l5
dev.off()

pdf("TSI histograms")
par(mfrow=c(2,3))
hist(lwq_cropped$lwq_2004, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2004", xlab="TSI values")
hist(lwq_cropped$lwq_2008, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2008", xlab="TSI values")
hist(lwq_cropped$lwq_2012, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2012", xlab="TSI values")
hist(lwq_cropped$lwq_2016, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2016", xlab="TSI values")
hist(lwq_cropped$lwq_2020, breaks=c(0, 40, 60, 100), xlim=c(0,100), ylim=c(0, 0.04), main="TSI 2020", xlab="TSI values")
dev.off()

# -------- the end








