# R code for ecosystem monitoring by remote sensing
# First of all, we need to install additional packages
# raster package to manage image data
# https://cran.r-project.org/web/packages/raster/index.html

install.packages("raster")

library(raster)

# set working directory
setwd("/Users/matildecervellieri/lab/")

# We are going to import satellite data (Landsat program)
# objects cannot be numbers
l2011 <- brick("p224r63_2011.grd")

l2011

plot(l2011)

# B1 is the reflectance in the blue wavelength band
# B2 is the reflectance in the green wavelength band
# B3 is the reflectance in the red wavelength band 
# the higher the reflectance the higher the value 

plot(l2011$B1_sre)

cl <- colorRampPalette(c("black","grey","light grey"))(100)
plot(l2011, col=cl)

plotRGB(l2011, r=3, g=2, b=1, stretch="Lin")

# ------------- day 2
# B1 is the reflectance in the blue wavelength band
# B2 is the reflectance in the green wavelength band
# B3 is the reflectance in the red wavelength band 
# B4 is the reflectance in the NIR band (near infrared)

# Let's plot the green band 
plot(l2011$B2_sre)
# to link we use the dollar simble
# plot is the funciton and the stuff inside the parenthesis is the argument

# "black","grey","light grey" is an arrey in R and it needs the function c 
cl <- colorRampPalette(c("black","grey","light grey"))(100)
plot(l2011$B2_sre, col=cl)

# change the colorRampPalette with dark green, green and light green, e.g. clg
clg <- colorRampPalette(c("dark green", "green", "light green"))(100)
plot(l2011$B2_sre, col=clg)

# let's plot the blue band using "dark blue", "blue", "light blue", e.g. clb
plot(l2011$B1_sre)
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)

# plot both images in just one multiframe graph
par(mfrow=c(1,2)) # the first number is the number of rows in the multiframe, while the second one is the number of columns 
plot(l2011$B1_sre, col=clb)
plot(l2011$B2_sre, col=clg)

par(mfrow=c(2,1))
plot(l2011$B2_sre, col=clg)
plot(l2011$B1_sre, col=clb)


# ----------------- day 3

# plot the blue band using a blue colorRampPalette
plot(l2011$B1_sre)
clb <- colorRampPalette(c("dark blue", "blue", "light blue"))(100)
plot(l2011$B1_sre, col=clb)




