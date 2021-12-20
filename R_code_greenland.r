# Ice melt in Greenland
# Proxy: LST (Land Surface Temperature): if LST increase we associate that with ice melting

library(raster)

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



