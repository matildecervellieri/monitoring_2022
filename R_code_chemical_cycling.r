# R code for chemical cycling study
# time series of NO2 change in Europe during the lockdown 

# set the working directory 
setwd("/Users/matildecervellieri/lab/en/")

library(raster)
en01 <- raster("EN_0001.png")
# what is the minimum value and the maximum value?
en01 # 0 to 255, it's an 8 bit file 2^8 = 256. So that's why we have the range 0 to 255

# now we are gonna plot it: yellow component is catching our eyes so we are using it 
cl <- colorRampPalette(c("red","orange","yellow"))(100)

# plot the NO2 values of January 2020 by the cl 
plot(en01, col=cl) 
# 0 is the smallest amount possibile. We can make a comparison with the amount of people in Europe: thee higher the amount of people, the higher the amount of NO2

# Ecercise: import the end of March NO2 and plot it 
en13 <- raster("EN_0013.png")
# what is the minimum value and the maximum value?
en13 # 0 to 255, it's an 8 bit file 2^8 = 256. So that's why we have the range 0 to 255
# plot the NO2 values of January 2020 by the cl 
plot(en13, col=cl)
# there is still NO2 over the Pianura Padana, but the Europe situation is betteer

# Build a multiframe window with these 2 images with 2 rows and 1 columns 
par(mfrow=c(2,1))
plot(en01, col=cl)
plot(en13, col=cl)
# Rome and Madrid have had a large redunction in NO2 emissions 

# import all the images 
en01 <- raster("EN_0001.png")
en02 <- raster("EN_0002.png")
en03 <- raster("EN_0003.png")
en04 <- raster("EN_0004.png")
en05 <- raster("EN_0005.png")
en06 <- raster("EN_0006.png")
en07 <- raster("EN_0007.png")
en08 <- raster("EN_0008.png")
en09 <- raster("EN_0009.png")
en10 <- raster("EN_0010.png")
en11 <- raster("EN_0011.png")
en12 <- raster("EN_0012.png")
en13 <- raster("EN_0013.png")

# plot all the data together: two ways to do it 
# using the par function 
par(mfrow=c(4,4))
plot(en01, col=cl)
plot(en02, col=cl)
plot(en03, col=cl)
plot(en04, col=cl)
plot(en05, col=cl)
plot(en06, col=cl)
plot(en07, col=cl)
plot(en08, col=cl)
plot(en09, col=cl)
plot(en10, col=cl)
plot(en11, col=cl)
plot(en12, col=cl)
plot(en13, col=cl)

# how to import everything without coping all of them. We use stack
# make a stack 
en <- stack(en01, en02, en03, en04, ee05, en06, en07, en08, en09, en10, en11, en12, en13)

# plot the stack all together 
plot(en, col=cl)

# plot only the first image from the stack 
dev.off()
en # to see the names
plot(en$EN_0001, col=cl)

# rgb 
plotRGB(en, r=1, g=7, b=13, stretch="lin")
# what will become red is the highest amount of NO2 in January, green is the middle situation, blue is the highest amount in March
# yellow is something that remain unaltered because: Pianura Padana for example 
# industries of Madrid are in the Northern part
# red in the northern EU: high NO2 in January and then it stopped: geophysical reasons 

# ------ day 2
library(raster)

# set working directory 
setwd("/Users/matildecervellieri/lab/en/")

# we're gonna use the lapply function to apply a function over a list or a vector
# first we need to make the list, explaining to the software what are the images we want to import
rlist <- list.files(pattern="EN") # we use the common part of the names of the images, so EN -> we store it with the arrow to assign it to an object
rlist

# lapply applies a function over a list 
list_rast <- lapply(rlist, raster) 
list_rast  
# we created a list, importing all of the images together

# now we need a function to stack all the elements together. We build the stack with the list that we made
en_stack <- stack(list_rast)
en_stack

cl <- colorRampPalette(c("red","orange","yellow"))(100)
plot(en_stack, col=cl)
# we are at the same point of the previous lesson but in a much easier way

# excercise: plot only the first image of the stack 
plot(en_stack$EN_0001, col=cl)

# difference between the final image and the first image 
en_dif <- en_stack$EN_0001 - en_stack$EN_0013 
cldif <- colorRampPalette(c("blue", "white", "red"))(100)
plot(en_dif, col=cldif)
# red parts are big change, while the blue parts are mantaining the amount of NO2

# automated processing source function. to run a code which is stored in our pc or that stays in the web
# we will save a script in our computer and run directly in R
dev.off()
source("R_code_automatic_script.txt")

# pairs
paird(en)

# direct import 





