# R_code_quantitative_estimates_land_cover.r

# first install new packages
install.packages("ggplot2") # for new graphical properties
install.packages("gridExtra") # for new multiframe properties
install.packages("ncdf4") # for managing Copernicus data
install.packages("RStoolbox")

library(raster)
library(RStoolbox) # we're using this package for the classification 
library(ggplot2) # we're using this package for the ggplot function 
library(gridExtra) # we will use this package for multiframe ggplot

# setting the working directory 
setwd("/Users/matildecervellieri/lab/")

# brick 
# 1 list the files available 
rlist <- list.files(pattern="defor")
rlist
# 2 then we use the lapply function to apply to a list a function 
list_rast <- lapply(rlist, brick) # brick function is used to import entire satellite images in R 
list_rast
# we have two separate files

plot(list_rast[[1]]) # we don't need to use the dollar sign because the two files are separated

# defor: NIR 1, red 2, green 3
plotRGB(list_rast[[1]], r=1, g=2, b=3, stretch="lin") # in this case everything will become red because in the red we have the NIR layer 
# to simplify we can assign list_rast[[1]] to a new object
l1992 <- list_rast[[1]]
plotRGB(l1992, r=1, g=2, b=3, stretch="lin") # the function will become like this 

# we can do the same with the other 
l2006 <- list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# we can estimate the amount of forest which has been lost
# we can classify our image with forest and agricultural areas 
# unsuperClass function: unsupervised classification. We don't explain to the software which is the forest and which the agricultural areas
l1992c <- unsuperClass(l1992, nClasses=2) # unsuperClass(x, nClasses)
l1992c # before we had a raster brick (several layers) but now we have raster layer which is only one layer

plot(l1992c$map)
# the colour depends on the name the the software give to forest and everything else: forest is class number 1 so it's white and agricultural area is number 2, so green
# the values are or 1 or 2: the middle values are not in the map 
# value 1 = forest
# value 2 = agricultural areas and water

# now I want to know the percentage of forest and the percentage of agricultural areas
# the function freq is doing the job, it calculates the number of pixel of forest and agricultural areas
freq(l1992c$map) 
#     value  count
# [1,]     1 305665
# [2,]     2  35627

# forest (class 1) = 305665
# agricultural areas and water (class 2) = 35627

# let's make the proportion
total <- 341292
propagri <- 35627 / total
propforest <- 305665 / total
propagri
propforest

# forest: 0.8956114 ~ 0.90
# agriculture and water: 0.1043886 ~ 0.10

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
# prop1992 <- c(0.8956114, 0.1043886)
prop1992 <- c(propforest, propagri)

proportion1992 <- data.frame(cover, prop1992)
proportion1992 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms (geom_bar function with the statistic values, so the actual ones. Fill is the colour inside the bar)
ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)
# we got an histogram with the actual quantitative values of forest and agriculture
# we are gonna do the same with the image of 2006 and see what changed quantitatively 

# ------- day 2

# the first part is the same as the one we did in day one, but today we're also working with the second image 
l2006c <- unsuperClass(l2006, nClasses=2) # unsuperClass(x, nClasses)
l2006c

plot(l2006c$map)
# value 1 = forest (white)
# value 2 = agricultural areas and water (green)

# Frequencies
freq(l2006c$map)
#     value  count
# [1,]     1 178730     # forest
# [2,]     2 163996     # agriculture

# Proportions
# forest (class 1) = 178730
# agricultural areas and water (class 2) = 163996

total2006 <- 342726
propagri2006 <- 163996 / total2006
propforest2006 <- 178730 / total2006
propagri2006
propforest2006

# forest: 0.5214953 ~ 0.52
# agriculture and water: 0.4785047 ~ 0.48

# build a dataframe
cover <- c("Forest", "Agriculture") # we use quotes because is text  
# prop1992 <- c(0.8956114, 0.1043886)
prop1992 <- c(propforest, propagri)
prop2006 <- c(propforest2006, propagri2006)

proportion <- data.frame(cover, prop1992, prop2006)
proportion # we have the new dataframe with the column of 2006 

#        cover  prop1992  prop2006
# 1      Forest 0.8956114 0.5214953
# 2 Agriculture 0.1043886 0.4785047

# plot the proportion of 2006
ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white") + ylim(0,1)

# plot everything all together using a package called gridExtra
p1 <- ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")
p2 <- ggplot(proportion, aes(x=cover, y=prop2006, color=cover)) + geom_bar(stat="identity", fill="white")

grid.arrange(p1, p2, nrow=1)
# + ylim(0,100)

# in 1992 the forest part is huge in respect to the agricultural part: 90% of landscape is forest 
# in 2006 both classes have more or less the same values: forest passed from 90% to the 50% of the landscape, while agricultural areas pass from 10% to 50% of the total landscape 
# agricultural parts are rising up, while there is a lot of deforestation 

# or with patchwork package:
# install.packages("patchwork")
library(patchwork)

p1+p2
# if you want to put one graph on top of the other:
p1/p2

# patchworkn is working even with raster data, but they should be plotted with the ggplot2 package
# instead of using plotRGB we are going to use ggRGB
# Common stuff:
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")

# we're using ggRGB with different stretch
ggRGB(l1992, r=1, g=2, b=3)
ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
ggRGB(l1992, r=1, g=2, b=3, stretch="hist") # hard stretch: is showing additional infos. We can see horizontal lines because is not a photo, is an image. 
ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt") 
ggRGB(l1992, r=1, g=2, b=3, stretch="log") # is natural logarithm. 

# patchwork: we can see all the graphs together. First we need to assign them to an object
gp1 <- ggRGB(l1992, r=1, g=2, b=3, stretch="lin")
gp2 <- ggRGB(l1992, r=1, g=2, b=3, stretch="hist")
gp3 <- ggRGB(l1992, r=1, g=2, b=3, stretch="sqrt")
gp4 <- ggRGB(l1992, r=1, g=2, b=3, stretch="log") 

gp1 + gp2 + gp3 + gp4

# multitemporal patchwork
gp1 <- ggRGB(l1992, r=1, g=2, b=3)
gp5 <- ggRGB(l2006, r=1, g=2, b=3)

gp1 + gp5
gp1 / gp5

# par, stack, grid.arrange, patchwork: we used them to plot different images or graphs together

