---
title: "State manager's guide to eBird Status & Trends"
layout: post
published: true
use_code: true
---
<i>A quick-start guide to accessing eBird Status & Trends data and analyzing it at the state level.</i>

<br>

## <span style="color:#881c1c">Introduction</span>
---

The spatial distributiuon of a species is one the most fundamental components of its ecology. Knowledge of this distribution is critical for local and state managers to inform resource management, especially for those efforts related to species of conservation concern. Despite this importance, obtaining reliable and quantitivative descriptions of species distributions can be extremely challenging, and often very expensive. Contrarily, with the rise of citizen science programs such as [iNaturalist](https://www.inaturalist.org/) and [eBird](https://www.ebird.org/), researchers have effectively crowd-sourced the data-collection process, creating a data deluge in a field that had long been data-depirved. 

Not all data is created equally, though, which has lead to rapid analytical advancements. Some examples of this would be extracting only ["semistructured" survey data](10.1093/biosci/biz010) from a primary database, or methods to deal with overdispersion due to an abundance of assumed negative reports. Further, like other fields related to data science, machine learning methods have become increasingly popular for analyzing "big *(survey)* data," as it's often comprised of thousands – if not millions – of observations. So far, these advancements are a promising start to scaling our understanding of species distributions around the world.

The resulting information about species distributions would have the greatest influence when it is readily available to state and local mangers to inform conservation decision-making on the ground. However, this can be a difficult gap to bridge, but recent work by the [eBird science](https://ebird.org/science) team has started making this more of a reality by providing tools to access some of [their data products](https://ebird.org/science/download-ebird-data-products), available to anyone. One of the most impressive tools they provide is the R package, [ebirdst](https://rdrr.io/cran/ebirdst/). This package allows users to download and analyze [eBird Status & Trends](https://ebird.org/science/status-and-trends) data, a data product of spatial distributions and population trends currently for over 600 species in the Western Hemisphere.

The eBird science team has a great reputation of creating user-friendly and thorough documentation for their tools, such as their [best practices guide](https://cornelllabofornithology.github.io/ebird-best-practices/) for distribution modeling with eBird data, and they have continued to do so for [ebirdst](https://cornelllabofornithology.github.io/ebirdst/articles/ebirdst-introduction.html). However, at the time of writing, the documentation and corresponding walkthrough lack a straightforward workflow or advanced functionality to quickly access the status and trends data for any given state, or a way to explore the data at a finer scale. 

This was brought to my attention recently when some friends at [Mass Audubon](https://www.massaudubon.org/)'s [Conservation Science Team](https://www.massaudubon.org/our-conservation-work) asked for my assistance in generating a species distribution model for [Eastern Meadowlark](https://www.massaudubon.org/our-conservation-work/wildlife-research-conservation/grassland-birds/eastern-meadowlark) in the state. This species is in serious decline in Massachusetts, likely due to agircultural practices such as intensive mowing that are degrading and depleting their grassland habitat. For the past few years, Mass Audubon has been conducting [targeted, citizen science surveys for the species](https://www.massaudubon.org/our-conservation-work/wildlife-research-conservation/grassland-birds/eastern-meadowlark-survey). With lots of area to cover, the agency is now looking to use a data-driven process to find more meadowlarks, in order to protect their remaining breeding habitat in the state.

Luckily, eBird has already completed most of [their analysis for Eastern Meadowlark](https://ebird.org/science/status-and-trends/easmea), which is a great place to start for this initiative. The rest of this post is a quick-start guide to accessing this data, analyzing it at the state level, and interacting with it at a finer-scale.

<br>

## <span style="color:#881c1c">Methods</span>
---
### Setup

First, start by downloading and installing the ebirdst package. If you are missing any of the other packages, you can also download them using this command.

```r
install.packages("ebirdst")
```

We will need the following set of packages for this brief analysis. The [`raster`](https://rspatial.org/raster/spatial/8-rastermanip.html) package is the standard choice to work with raster data, which is simply a geo-referenced, matrix-style datatype. For accessing some additional spatial data, we will use [`rnaturalearth`](https://github.com/ropensci/rnaturalearth), which we can then manipulate using the [`sf`](https://r-spatial.github.io/sf/articles/sf1.html) package. The [`ggplot2`](https://ggplot2.tidyverse.org/) package (and its extensions, including `viridisLite` and `ggpubr`) provides a simple yet sophisticated plot framework within the [tidyverse](https://www.tidyverse.org/), along with [`dplyr`](https://dplyr.tidyverse.org/) which is used for efficient data manipulation.

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
Before jumping into the analysis, we need to make sure we have a polygon of the state we are interested in, which here is Massachusetts. There are many ways to get this polygon, but presented below is one of the most straightforward methods I have come across.

```r
"STATE DATA"

# Get all data
us <- getData("GADM", country="USA", level=1)

# Subset to MA only
ma = us[match(toupper("Massachusetts"),toupper(us$NAME_1)),]
```

Now to the eBird data. Here, there's a simple command in the `ebirdst` package that takes a six-letter species code of any of the species [currently available](https://ebird.org/science/status-and-trends). To find the six-letter species code, it's easiest to search for the species on eBird using [Explore Species](https://ebird.org/explore) and then taking the code from the URL. For example, the URL for Eastern Meadowlark is: [https://ebird.org/species/**easmea**](https://ebird.org/species/easmea), and we can use that. Make sure `tifs_only` is set to `FALSE` if you want to include variable importance in your analysis. Depending on the species, the resulting file can be quite large and can take a while to download. Go get a coffee while you wait!

```r
"GETTING EBIRD DATA"

# Download data (this takes time, ~20 mins for me)
sp_path <- ebirdst_download(species =  "easmea", tifs_only = FALSE)
```

Now that we have all of the data downloaded and in our R workspace, we can move on to analyzing it.

<br>

### Abundance

Text

```r
"ABUNDANCE"

# Load trimmed mean abundances
abunds <- load_raster("abundance_umean", path = sp_path)
```

```r
# Crop to an area rougly the size of MA
# (Week 23 = June 6-12)
abunds_23_cr =  crop(
  abunds[[23]], 
  extent(c(-6.2e6, -5.6e6,  4.5e6, 4.85e6)))
```

```r
# Define mollweide projection
mollweide <- "+proj=moll +lon_0=-90 +x_0=0 +y_0=0 +ellps=WGS84"
```

```r
# Project single layer from stack to mollweide
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

```r

# Convert raster to data frame for ggplot
r_spdf <- as(r, "SpatialPixelsDataFrame")
r_df <- as.data.frame(r_spdf)
colnames(r_df) <- c("value", "x", "y")
```

```r
"PLOT ABUNDANCE"
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

<center>
  <figure>
    <img src="{{ site.baseurl }}/images/eame_pipts.png" style="width:800px;">
    <figcaption>Fig. 2: Text needed here.</figcaption>
  </figure>
</center>


```r
plot_pis(pis, ext = lp_extent, by_cover_class = TRUE, n_top_pred = 15)
```

<center>
  <figure>
    <img src="{{ site.baseurl }}/images/eame_pi.png" style="width:800px;">
    <figcaption>Fig. 3: Text needed here.</figcaption>
  </figure>
</center>

Text

<br>


### Interactive map

```r
# Convert to leaflet CRS
map_crs = sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
r4map = projectRaster(r, crs = map_crs, method = "ngb")

# Add some options to the map
basemaps = c("CartoDB.Positron", "OpenStreetMap")
pal <- colorNumeric(abundance_palette(10, season = "breeding"), values(r),
                    na.color = "transparent")
```

Text

```r
# Map
eame_ma_lf <-leaflet() %>% 
  addTiles(urlTemplate = "http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga",
           attribution = 'Google', group  =  "Google") %>%
  addProviderTiles("CartoDB.Positron", group = "CartoDB") %>%
  addProviderTiles("OpenStreetMap", group = "Open Street Map") %>%
  addProviderTiles('Esri.WorldImagery', group = "ESRI") %>%
  addRasterImage(r, colors = pal, opacity = 0.5, group = "Eastern Meadowlark")  %>%
  addLegend(pal = pal, values = values(r),
            title = "Relative abundance") %>%
  leafem::addMouseCoordinates()  %>%
  addLayersControl(
    baseGroups = c("Gray", "Open Street Map", "Google", "ESRI"),
    overlayGroups = "Eastern Meadowlark",
    options = layersControlOptions(collapsed = FALSE)
  )

eame_ma_lf
```

Text 

```r
htmlwidgets::saveWidget(eame_ma_lf, 
                        file = "~/Desktop/eame_ma.html", 
                        selfcontained = TRUE)
```


<div align="center">
  <iframe height="600" width="100%" src="{{ site.baseurl }}/attachments/eame_ma.html" frameborder="0"></iframe>
</div>

<br>

## <span style="color:#881c1c">Discussion</span>
---

Text

```r
test = c(1:4)
```

<br>

## <span style="color:#881c1c">References</span>
---
1. Fink, D., T. Auer, A. Johnston, M. Strimas-Mackey, O. Robinson, S. Ligocki, B. Petersen, C. Wood, I. Davies, B. Sullivan, M. Iliff, S. Kelling (2020). eBird Status and Trends, Data Version: 2018; Released: 2020. Cornell Lab of Ornithology, Ithaca, New York. https://doi.org/10.2173/ebirdst.2018

2. Auer T, Fink D, Strimas-Mackey M (2020). ebirdst: Tools for loading, plotting, mapping and analysis of eBird Status and Trends data products. R package version 0.2.0, https://cornelllabofornithology.github.io/ebirdst/.
 

<br>

## <center><a href="https://github.com/GatesDupont/gatesdupont.github.io/blob/master/post-source-code/eame_ebirdst.R" target="_blank">Source Code</a></center>
