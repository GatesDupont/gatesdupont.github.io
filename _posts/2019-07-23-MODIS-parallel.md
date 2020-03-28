---
title: "Parallel downloading of MODIS land cover"
layout: post
published: true
use_code: true
---

<center>
  <div>
    <img src="{{ site.baseurl }}/images/banners/banner_nlcd.png" style="width:100%;">
  </div>
</center>

<br>

<i>Efficiently downloading mcd12q1 v.006 for a large spatial extent using parallel computing.</i>

<br>

## Introduction
---
The following R code is something I wrote during my Fellowship at the San Diego Zoo's Institute for Conservation Research, where I put together the [JAGSMAP](http://www.JAGSMAP.org) initiative, a data-sharing platform that brings together a range-wide, trans-boundary network of Jaguar biologists to address important challenges in jaguar conservation. Part of my work was compiling spatial covariates for throughout Central and South America. Downloading this data can take a while, so I implemented an easy parallel computing framework in R to speed up the process. All of this code relies on only a few functions from the `doParallel` and `foreach` packages, leaving little else that needs explaining outside of the general framework, which is rather apparent, but I provided a fairly thorough amount of commenting throughout this script. I hope it helps! 


```r
library(MODIS)
library(dplyr)
library(purrr)
library(doParallel)
library(foreach)


#----Create(?) and set dir----

sdm_dir <- "~/sdm"
if (!dir.exists(sdm_dir)) {
  dir.create(sdm_dir)
}
setwd(sdm_dir)
```

```r
#----Read in manually-selected tiles----

# could instead use MODIS::getTiles() 
# or feed an extent object to MODIS::runGdal()

tiles = read.csv("data/GIS/modis/MODIS_tiles.csv")
tilesH = tiles$H
tilesV = tiles$V
```

```r
#----Loop through tiles and download----

# making parallel cluster
ncores = round(detectCores() * 0.75) # using 75% of available cores
cl = makeCluster(ncores)
registerDoParallel(cl)

# donwload each of the 42 tiles individually
foreach(i = 1:42,
        .packages = c('MODIS', 'rgeos', 'purrr', 'dplyr')) %dopar% {
          # download tiles and combine into a single raster for each year
          tifs = runGdal(
            product = "MCD12Q1",
            collection = "006",
            SDSstring = "01",
            tileH = tilesH[i],
            tileV = tilesV[i],
            begin = "2001.01.01",
            end = "2017.12.31",
            outDirPath = "data/GIS/modis",
            job = paste0("modis_", tilesH[i], "_", tilesV[i])) %>%
            
            pluck("MCD12Q1.006") %>%
            unlist()
          
  # rename tifs to have more descriptive names
  new_names = format(as.Date(names(tifs)), "%Y") %>%
    sprintf(paste0("modis_mcd12q1_h", tilesH[i], "_v", tilesV[i], "_umd_%s.tif"), .) %>%
    file.path(dirname(tifs), .)
  file.rename(tifs, new_names)
}
stopCluster(cl)
```

```r
#---Re-run to mosaic tiles by year----

# FIRST, COPY THE MODIS TILES FROM THEIR ORIGINAL ARC PATH
# e.g.: C:\Users\dupont\AppData\Local\Temp\Rtmpu4ZXW2\MODIS_ARC\MODIS

# could use file.copy("C:\\Users\\dupont\\AppData\\Local\\Temp\\Rtmpu4ZXW2\\MODIS_ARC\\MODIS\\MCD12Q1.006",
#                     "data/GIS/modis")

tifs = runGdal(
  product = "MCD12Q1",
  collection = "006",
  SDSstring = "01",
  tileH = tilesH,
  tileV = tilesV,
  begin = "2001.01.01",
  end = "2017.12.31",
  localArcPath = "data/GIS/modis/MCD12Q1.006",
  outDirPath = "data/GIS/modis",
  forceDownload = F,
  job = "annual_mosaic_tifs") %>%
  
  pluck("MCD12Q1.006") %>%
  unlist()

# If everything is set up correctly, you should see:
# "Local structure is up-to-date. Using offline information!"
# This tells you that runGdal has all the hdf files and will
# just start mosaicing them and converting to tifs.
```

```r
# rename tifs by year
new_names = format(as.Date(names(tifs)), "%Y") %>% 
  sprintf("modis_mcd12q1_umd_%s.tif", .) %>% 
  file.path(dirname(tifs), .)
file.rename(tifs, new_names)
```
