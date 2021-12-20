# Ice melt in Greenland
# Proxy: LST (Land Surface Temperature): if LST increase we associate that with ice melting

library(raster)
library(ggplot2)
library(RStoolbox)
library(patchwork)
library(viridis)

# Set the working directory
setwd("/Users/matildecervellieri/lab/greenland/")

# importing files: first we make a list and then using the lapply function
# list f files:
rlist <- list.files(pattern="lst")
rlist 

import <- lapply(rlist, raster)
import # we have the 4 files imported inside r. 16 byt images 2^16 = 65536 

# now we need to stack them all together
tgr <- stack(import) # TGr stays for Temperature of Greenland 
tgr # we can see the number of pixels and the names

# we're gonna plot them
cl <- colorRampPalette(c("blue", "light blue", "pink", "yellow"))(100)
plot(tgr, col=cl) 
# we can see how the temperature changed 

# we will use ggplot for the first and final images: 2000 vs 2015
ggplot() + geom_raster(tgr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma")
# we can add a ggtitle 
ggplot() + geom_raster(tgr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2000")

# we're making the same thing with the image of 2015
ggplot() + geom_raster(tgr$lst_2015, mapping = aes(x=x, y=y, fill=lst_2015)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2015")
# the lowest value of T decreased in space, this means that there are higher temperatures

# we can assign this 2 plots to objects and then plot them together 
p1 <- ggplot() + geom_raster(tgr$lst_2000, mapping = aes(x=x, y=y, fill=lst_2000)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2000")
p2 <- ggplot() + geom_raster(tgr$lst_2015, mapping = aes(x=x, y=y, fill=lst_2015)) + scale_fill_viridis(option="magma") + ggtitle("LST in 2015")

p1 + p2 
# we need to resize because ggplot is making squared values 
# LST in 2000 was lower than in 2015. Overall the main point is that the lower temperatures are decreasing in space: higher T. If we do this for this year (2021) temperatures are increasing even more 

# plotting frequency distributions of data
# we're creating a histogram for the 2000 image and 2015 image
par(mfrow=c(1,2))
hist(tgr$lst_2000)
hist(tgr$lst_2015)
# 2000 is a good distribution 
# 2015 has two peaks, so it's weird: Temperature rising in a certain part

# plotting all the images 
par(mfrow=c(2,2))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)

# we can measure the change with time in the value of temperature by using pixels: we expect bigger values of T
# dev.off()
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))
abline(0,1, col="red") # now we want to put the line from 0 
# lowest temperature: highest temperature in 2015 than in 2010 because they are above the line 

# make a plot with all the histograms and all the regressions for all the variables
par(mfrow=c(4,4))
hist(tgr$lst_2000)
hist(tgr$lst_2005)
hist(tgr$lst_2010)
hist(tgr$lst_2015)
plot(tgr$lst_2000, tgr$lst_2005, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2000, tgr$lst_2010, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2000, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2005, tgr$lst_2010, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2005, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))
plot(tgr$lst_2010, tgr$lst_2015, xlim=c(12500, 15000), ylim=c(12500, 15000))

# big nightmare, so let's use pairs!
# we can do this using a function called pairs: it crates scatterplot matrices 
pairs(tgr)
# if we compare 2000 and 2015 we can see at lower T values which are above the line, so it means that in time temperatures have increased a lot, especially for lowest temperature, which are the ones that keep the ice and avoid melting

