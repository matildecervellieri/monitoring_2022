# R code for estimating energy in the ecosystems 

library(raster) 

setwd("/Users/matildecervellieri/lab/")

# we need to install the package rgdal 
install.packages("rgdal")
library(rgdal)

# we are going to import data 
l1992 <- brick("defor1_.jpg") # image of 1992
l1992

# Bands: defor1_.1, defor1_.2, defor1_.3
# plotRGB 
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin") 

# defor1_.1 = NIR
# defor1_.2 = red
# defor1_.3 = green 
# water is absorbing all the NIR, so as we plotted it may appears blue or black -> in the example is whitish such as bare soil, that's because there is soil inside
