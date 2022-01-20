library(raster)
library(ggplot2)
library(RStoolbox)
library(patchwork)
library(viridis)
library(ncdf4)
library(gridExtra)

# Set the working directory
setwd("/Users/matildecervellieri/lab/exam/")

# importing files: first we make a list and then use the lapply function 
lst_list <- list.files(pattern="LST")
lst_list

lst_import <- lapply(lst_list, raster)
lst_import # 3 files imported inside r. 

# stacking them all together
lst <- stack(lst_import)
lst

# Let's change their names
names(lst) <- c("lst_2010", "lst_2015", "lst_2020")
names(lst)
lst

# Let's associate it to an object
lst2010 <- lst$lst_2010
lst2015 <- lst$lst_2015
lst2020 <- lst$lst_2020

cl <- colorRampPalette(c("blue", "light blue", "pink", "yellow"))(100)
plot(lst2010, col=cl) 

ext <- c(40, 60, 30, 50)
lst2010_cropped <- crop(lst2010, ext)
plot(lst2010_cropped, col=cl) 
