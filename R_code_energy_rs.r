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

plotRGB(l1992, r=2, g=1, b=3, stretch="Lin") 

# day 2
# we are going to import data 
l2006 <- brick("defor2_.jpg") # image of 2006
l2006

# plotting the imported image
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
# Rio Peixoto has a smaller amount of dispersed soil: it's blue because water is absorbing all the NIR

# par 
par(mfrow=c(2,1))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")

# now we calculate energy using DVI in a new layer called 1992 which is the NIR minus the Red
# let's calculate energy in 1992
dev.off()
dvi1992 <- l1992$defor1_.1 - l1992$defor1_.2
cl <- colorRampPalette(c("darkblue","yellow","red","black"))(100) # specifying a colour scheme
plot(dvi1992, col=cl)

# calculate energy in 2006
dvi2006 <- l2006$defor2_.1 - l2006$defor2_.2
cl <- colorRampPalette(c("darkblue","yellow","red","black"))(100) # specifying a colour scheme
plot(dvi2006, col=cl) # we use yellow because is the first colour that is catched by our eyes  

# differencing two images of energy in two different times
dvidif <- dvi1992 - dvi2006
# plotting the results 
cld <- colorRampPalette(c("blue","white","red"))(100)
plot(dvidif, col=cld) # the amount of energy loss is high and it's the red part 

# final plot: original images, dvis, final dvi difference
# we are gonna use the par function with 3 rows and 2 columns 
par(mfrow=c(3,2))
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)

# we are creating a pdf in the lab folder with the images obtained with the par function 
pdf("energy.pdf")
plotRGB(l1992, r=1, g=2, b=3, stretch="Lin")
plotRGB(l2006, r=1, g=2, b=3, stretch="Lin")
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off()

pdf("dvi.pdf")
par(mfrow=c(3,1))
plot(dvi1992, col=cl)
plot(dvi2006, col=cl)
plot(dvidif, col=cld)
dev.off()

