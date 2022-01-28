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

# linear regressions between each year 
par(mfrow=c(2,5))
plot(fcover1999, fcover2004, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2004")
abline(0,1, col="red")
plot(fcover1999, fcover2009, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2009")
abline(0,1, col="red")
plot(fcover1999, fcover2014, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2014")
abline(0,1, col="red")
plot(fcover1999, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2019")
abline(0,1, col="red")
plot(fcover2004, fcover2009, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2004", ylab="fcover 2009")
abline(0,1, col="red")
plot(fcover2004, fcover2014, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2004", ylab="fcover 2014")
abline(0,1, col="red")
plot(fcover2004, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2004", ylab="fcover 2019")
abline(0,1, col="red")
plot(fcover2009, fcover2014, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2009", ylab="fcover 2014")
abline(0,1, col="red")
plot(fcover2009, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2009", ylab="fcover 2019")
abline(0,1, col="red")
plot(fcover2014, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2014", ylab="fcover 2019")
abline(0,1, col="red")

# plotting the histogram of each year and all the linear reegression between them 
pairs(fcover_cropped)

# Saving the result
pdf("regressions", width=30, height=10)
par(mfrow=c(2,5))
plot(fcover1999, fcover2004, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2004")
abline(0,1, col="red")
plot(fcover1999, fcover2009, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2009")
abline(0,1, col="red")
plot(fcover1999, fcover2014, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2014")
abline(0,1, col="red")
plot(fcover1999, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 1999", ylab="fcover 2019")
abline(0,1, col="red")
plot(fcover2004, fcover2009, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2004", ylab="fcover 2009")
abline(0,1, col="red")
plot(fcover2004, fcover2014, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2004", ylab="fcover 2014")
abline(0,1, col="red")
plot(fcover2004, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2004", ylab="fcover 2019")
abline(0,1, col="red")
plot(fcover2009, fcover2014, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2009", ylab="fcover 2014")
abline(0,1, col="red")
plot(fcover2009, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2009", ylab="fcover 2019")
abline(0,1, col="red")
plot(fcover2014, fcover2019, xlim=c(0, 1), ylim=c(0, 1), xlab="fcover 2014", ylab="fcover 2019")
abline(0,1, col="red")
dev.off()


# Second step: let's make a quantative analysis in order to estimate the percentage of forest loss or gained every 5 years (1999 - 2004 - 2009 - 2014 - 2019)
# 1999 - 2004
dif_1 <- -(fcover1999 - fcover2004)
dif_1
names(dif_1) <- c("dif1")
dif_1
# 2004 - 2009
dif_2 <- -(fcover2004 - fcover2009)
dif_2
names(dif_2) <- c("dif2")
dif_2
# 2009 - 2014
dif_3 <- -(fcover2009 - fcover2014)
dif_3
names(dif_3) <- c("dif3")
dif_3
# 2014 - 2019
dif_4 <- -(fcover2014 - fcover2019)
dif_4
names(dif_4) <- c("dif4")
dif_4

d1 <- ggplot() + geom_raster(dif_1$dif1, 
                             mapping = aes(x=x, y=y, fill= dif1)) + scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                                                                                         midpoint = 0, limits=c(-0.8, 0.8), breaks=c(-0.8, -0.4, 0, 0.4, 0.8), 
                                                                                         labels=c("- 80%",  "- 40%", "0%", "+ 40%", "+ 80%"), 
                                                                                         name = "% of forest loss or gain") + ggtitle("% of forest loss or gain between 1999 and 2004")
d2 <- ggplot() + geom_raster(dif_2$dif2, 
                             mapping = aes(x=x, y=y, fill= dif2)) + scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                                                                                         midpoint = 0, limits=c(-0.8, 0.8), breaks=c(-0.8, -0.4, 0, 0.4, 0.8), 
                                                                                         labels=c("- 80%",  "- 40%", "0%", "+ 40%", "+ 80%"), 
                                                                                         name = "% of forest loss or gain") + ggtitle("% of forest loss or gain between 2004 and 2009")
d3 <- ggplot() + geom_raster(dif_3$dif3, 
                             mapping = aes(x=x, y=y, fill= dif3)) + scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                                                                                         midpoint = 0, limits=c(-0.8, 0.8), breaks=c(-0.8, -0.4, 0, 0.4, 0.8), 
                                                                                         labels=c("- 80%",  "- 40%", "0%", "+ 40%", "+ 80%"), 
                                                                                         name = "% of forest loss or gain") + ggtitle("% of forest loss or gain between 2009 and 2014")
d4 <- ggplot() + geom_raster(dif_4$dif4, 
                             mapping = aes(x=x, y=y, fill= dif4)) + scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
                                                                                         midpoint = 0, limits=c(-0.8, 0.8), breaks=c(-0.8, -0.4, 0, 0.4, 0.8), 
                                                                                         labels=c("- 80%",  "- 40%", "0%", "+ 40%", "+ 80%"), 
                                                                                         name = "% of forest loss or gain") + ggtitle("% of forest loss or gain between 2014 and 2019")

d1 + d2 + d3 + d4

# Let's save the results!
pdf("percentage_forest_loss_gain_every5years")
grid.arrange(d1, d2. d3, d4, nrow=2, ncol=2)
dev,off()

# Third step: let's make a quantative analysis in order to estimate the percentage of forest loss or gain in 20 years (1999 vs 2019)
dif_1999_2019 <- -(fcover1999 - fcover2019)
dif_1999_2019
names(dif_1999_2019) <- c("dif_1999_2019_")
dif_1999_2019

d_1999_2019 <- ggplot() + geom_raster(dif_1999_2019$dif_1999_2019_, mapping = aes(x=x, y=y, fill= dif_1999_2019_)) + scale_fill_gradient2(low = "blue", mid = "white", high = "red", midpoint = 0, limits=c(-0.8, 0.8), breaks=c(-0.8, -0.4, 0, 0.4, 0.8), labels=c("- 80%",  "- 40%", "0%", "+ 40%", "+ 80%"), name = "% of forest loss or gain") + ggtitle("% of forest loss or gain between 1999 and 2019")
d_1999_2019
     
# Let's save the results!
pdf("percentage_forest_loss_gain_1999_2009")
d_1999_2019
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
