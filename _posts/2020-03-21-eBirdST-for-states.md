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

### Abundance

Text

```r
"ABUNDANCE"

# load trimmed mean abundances
abunds <- load_raster("abundance_umean", path = sp_path)
```

```r
# Cropping to an area rougly the size of MA
# (Week 23 = June 6-12)
abunds_23_cr =  crop(
  abunds[[23]], 
  extent(c(-6.2e6, -5.6e6,  4.5e6, 4.85e6)))
```

```r
# define mollweide projection
mollweide <- "+proj=moll +lon_0=-90 +x_0=0 +y_0=0 +ellps=WGS84"
```

```r
# project single layer from stack to mollweide
week23_moll <- projectRaster(
  abunds_23_cr, 
  crs = mollweide, method = "ngb")
```

```r
# Mask to MA and crop
ma_moll = spTransform(ma, mollweide)
r = mask(week23_moll, ma_moll) %>%
  crop(., ma_moll) %>%
  projectRaster(., crs = crs(ma), method = "ngb")
```

Text

<br>

### Variable importance

Text

```r
"VARIABLE IMPORTANCE"

# Load predictor importance
pis = load_pis(sp_path)
```

```r
# Select region and season
lp_extent <- ebirdst_extent(
  st_as_sf(ma), 
  t = c("2016-06-06", "2016-06-12")) # Models assumed 2016
```

```r
# Plot centroids and extent of analysis
par(mfrow = c(1, 1), mar = c(0, 0, 0, 6))
calc_effective_extent(sp_path, ext = lp_extent)
```

Text

<br>

### Final plot

Text

```r
"FINAL PLOT"

# Convert raster to data frame for ggplot
r_spdf <- as(r, "SpatialPixelsDataFrame")
r_df <- as.data.frame(r_spdf)
colnames(r_df) <- c("value", "x", "y")
```

```r
# RELATIVE ABUNDANCE
ggplot() +
  geom_raster(data = r_df , aes(x = x, y = y, fill = value)) + 
  scale_fill_gradientn(colors = abundance_palette(10, season = "breeding")) +
  coord_quickmap() +
  theme_bw() +
  theme(legend.position = "right") +
  labs(title = "Eastern Meadowlark",
       subtitle = "Relative Abundance, June 6-12",
       caption = "Data source: eBird Status and Trends",
       fill = "RA", y = "Latitude", x = "Longitude")
```

<center>
  <figure>
    <img src="{{ site.baseurl }}/images/eame_map.png" style="width:800px;">
    <figcaption>Fig. 1: Text needed here.</figcaption>
  </figure>
</center>

```r
# VARIABLE IMPORTANCE
plot_pis(pis, ext = lp_extent, by_cover_class = TRUE, n_top_pred = 15)
```

<center>
  <figure>
    <img src="{{ site.baseurl }}/images/eame_pi.png" style="width:800px;">
    <figcaption>Fig. 2: Text needed here.</figcaption>
  </figure>
</center>


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

## <center><a href="https://github.com/GatesDupont/gatesdupont.github.io/blob/master/post-source-code/eame_ebirdst.R" target="_blank">Source Code</a></center>
