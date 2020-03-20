---
title: "State Manager's Guide to eBird Status & Trend "
layout: post
published: true
use_code: true
---
<i>A quick-start guide to accessing and analyzing eBird Status & Trends data at the state level.</i>

<br>

## <span style="color:#881c1c">Introduction</span>
---
Understanding species distributions is one of the most important aspects of ecology. Improving this knowldege is critical for local and state agencies to inform decision making and management, especially for species of conservation concern.
<br>

## <span style="color:#881c1c">Methods</span>
---
### Setup

Text about setup

The packages we'll need:

```r
install.packages("ebirdst")
```
```r
library(ebirdst)
library(raster)
library(sf)
library(rnaturalearth)
library(ggplot2)
library(ggpubr)
library(viridisLite)
library(dplyr)
# handle namespace conflicts
extract <- raster::extract
```
Next, we'll need a polygon of the state.

```r
"STATE DATA"

# Get all data
us <- getData("GADM", country="USA", level=1)

# Subset to MA only
ma = us[match(toupper("Massachusetts"),toupper(us$NAME_1)),]
```

We'll need to download the eBird data in this species format. This requires GB of space and takes time to download. Go get a coffee!

```r
"GETTING EBIRD DATA"

# Download data (this takes time (~20 mins for me), and space)
sp_path <- ebirdst_download(species =  "easmea", tifs_only = FALSE)
```

Text

<br>

### Title

Text

```r
test = c(1,2,3,4)
```

Text

<br>

### Title

Text

```r
test = c(1:4)
```

Text

<br>

## <span style="color:#881c1c">Discussion</span>
---

Text

```r
test = c(1:4)
```

Text

<br>

## <span style="color:#881c1c">References</span>
---
1. Fink, D., T. Auer, A. Johnston, M. Strimas-Mackey, O. Robinson, S. Ligocki, B. Petersen, C. Wood, I. Davies, B. Sullivan, M. Iliff, S. Kelling (2020). eBird Status and Trends, Data Version: 2018; Released: 2020. Cornell Lab of Ornithology, Ithaca, New York. https://doi.org/10.2173/ebirdst.2018

2. Auer T, Fink D, Strimas-Mackey M (2020). ebirdst: Tools for loading, plotting, mapping and analysis of eBird Status and Trends data products. R package version 0.2.0, https://cornelllabofornithology.github.io/ebirdst/.
 

<br>

## <center><a href="https://github.com/GatesDupont/gatesdupont.github.io/blob/master/post-source-code/ReproAutoNested.R" target="_blank">Source Code</a></center>
