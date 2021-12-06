# R_code_quantitative_estimates_land_cover.r

# first install new packages
install.packages("ggplot2") # for new graphical properties
install.packages("gridExtra") # for new multiframe properties
install.packages("ncdf4") # for managing Copernicus data
install.packages("RStoolbox")

library(raster)
library(RStoolbox)
library(ggplot2)
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
plotRGB(l1996, r=1, g=2, b=3, stretch="lin") # the function will become like this 

# we can do the same with the other 
l2006 <- list_rast[[2]]
plotRGB(l2006, r=1, g=2, b=3, stretch="lin")

# we can estimate the amount of forest which has been lost
# we can classify our image with forest and agricultural areas 
# unsuperClass function: unsupervised classification. We don't explain to the software which is the forest and which the agricultural areas
l1992c <- unsuperClass(l1992, nClasses=2)
l1992c

plot(l1992c$map)
# the colour depends on the name the the software give to forest and everything else: forest is class number 2 so it's green and agricultural area is number 1, so white
# the values are or 1 or 2: the middle values are not in the map 
# value 1 = agricultural areas and water
# value 2 = forest

# now I want to know the percentage of forest and the percentage of agricultural areas
# the function freq is doing the job, it calculates the number of pixel of forest and agricultural areas
freq(l1992c$map) 
#      value  count
# [1,]     1  34653
# [2,]     2 306639

# agricultural areas and water (class 1) = 34653
# forest (class 2) = 306639

# let's make the proportion
total <- 341292
propagri <- 34653 / total
propforest <- 306639 / total
propagri
propforest

# agriculture and water: 0.1015348 ~ 0.10
# forest: 0.8984652 ~ 0.90

# build a dataframe 
cover <- c("Forest", "Agriculture") # we use quotes because is text  
prop1992 <- c(0.8984652, 0.1015348)

proportion1992 <- data.frame(cover, prop1992)
proportion1992 # this are the real proportion of forest and agriculture: quantitative values 

# we are gonna use the ggplot function. We want to use histograms (geom_bar function with the statistic values, so the actual ones. Fill is the colour inside the bar)
ggplot(proportion1992, aes(x=cover, y=prop1992, color=cover)) + geom_bar(stat="identity", fill="white")
# we got an histogram with the actual quantitative values of forest and agriculture
# we are gonna do the same with the image of 2006 and see what changed quantitatively 









