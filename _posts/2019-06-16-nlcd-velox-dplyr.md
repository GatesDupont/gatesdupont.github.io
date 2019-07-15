---
title: "Calcluating Pland Using Velox & Dplyr"
layout: post
published: true
use_code: true
---
<i>Efficiently calculating proportional landcover in R using velox and dplyr.</i>

<br>

## <span style="color:#881c1c">Introduction</span>
---
Environmental covariates are fundamental to spatially-explicit modeling in ecology. There are hundreds of metrics that have been used to characterize landscapes in ways that are biologically relevant, from average rainfall to net primary production. One such environmental covariate that is particularly popular in distribution modeling is proportional landcover. Calculated using a buffer around each point, this metric describes the composition of the surrounding landscape in terms of the proportion of each represented landcover class. The historical context for this metric comes from the well-known software, FRAGSTATS (McGarigal and Marks 1995), which includes this calculation -- termed <i>"pland."</i>

- NLCD (widely used)
- velox (fast)
- dplyr (C++, etc.)

## <span style="color:#881c1c">Methods</span>
---
### Generating sample coordinates

```r
library(dplyr)
library(rnaturalearth)
library(sf)
state = ne_states(iso_a2 = "US", returnclass = "sf") %>%  # pull admin. bounds. for US
  filter(iso_3166_2 == "US-MA") %>% # select Massachusetts
  st_transform(crs = "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=23 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80
+towgs84=0,0,0,0,0,0,0 +units=m +no_defs") # nlcd crs

pts = st_sample(state, size = 10, type = "regular") # sample 10 points in polygon

plot(pts, col="red", pch=20)
```

Image of MA with sample coordinates

### Fetching NLCD data

```r
library(FedData)

nlcd = get_nlcd(
  template = state,
  label = "4pland",
  year = 2011,
  force.redo = F
) # pulling nlcd data

plot(nlcd)
plot(pts, col="black", pch=20, cex=1.5, add=T)
```
<img src="{{ site.baseurl }}/images/nlcd_extract_pts.png" align="middle" style="width:500px;">

### Extract using raster:extract()

```r
library(raster)

ex.mat.r = extract(nlcd, as(pts, 'Spatial'), buffer=1000, df=T) # raster extract
```

### Extract using velox

```r
library(velox)
library(sp)

nlcd.vx = velox(stack(nlcd)) # raster for velox
sp.buff = gBuffer(as(pts, 'Spatial'), width=1000, byid=TRUE) # spatial buffer, radius in meters
buff.df = SpatialPolygonsDataFrame(sp.buff,
                                   data.frame(id=1:length(sp.buff)), # set ids
                                   FALSE) # df of buffers
ex.mat.vx = nlcd.vx$extract(buff.df, df=T) # extract buffers from velox raster
rm(nlcd.vx) # free up space
```

### Calculate pland

```r
library(dplyr)

prop.lc = ex.mat.vx %>%
  setNames(c("ID", "lc_type")) %>% # rename for ease
  group_by(ID, lc_type) %>% # group by point (ID) and lc class 
  summarise(n = n()) %>% # count the number of occurences of each class
  mutate(pland = n / sum(n)) %>% # calculate percentage
  ungroup() %>%
  dplyr::select(ID, lc_type, pland) %>% # keep only these vars
  complete(ID, nesting(lc_type), fill = list(pland = 0)) %>% # Fill in implicit landcover 0s
  spread(lc_type, pland) # convert to long format
```

### Assign landcover class names

```r
nlcd_cover_df = as.data.frame(nlcd@data@attributes[[1]]) %>% # reference the name attributes
  subset(NLCD.2011.Land.Cover.Class != "") %>% # only those that are named
  dplyr::select(ID, NLCD.2011.Land.Cover.Class) # keep only the ID and the lc class name
lc.col.nms = data.frame(ID = as.numeric(colnames(prop.lc[-1]))) # select landcover classes
matcher = merge.data.frame(x = lc.col.nms,
                           y = nlcd_cover_df,
                           by.x = "ID",
                           all.x = T) # analogous to VLOOKUP in Excel
colnames(prop.lc) = c("ID", as.character(matcher[,2])) # assign new names
```

## <span style="color:#881c1c">Results</span>
---

```r
print(prop.lc)
```
```txt
# A tibble: 9 x 16
  ID    `Open Water` `Developed, Ope… `Developed, Low… `Developed, Med… `Developed, Hig… `Barren Land`
  <fct>        <dbl>            <dbl>            <dbl>            <dbl>            <dbl>         <dbl>
1 1          0                 0.288           0.314            0.300           0.0437         0.00175
2 2          0.00729           0.132           0.103            0.0545          0.00933        0      
3 3          0.0140            0.130           0.0998           0.0692          0.0131         0.00146
4 4          0.00320           0.0300          0.0116           0.00146         0              0      
5 5          0.00291           0.0921          0.0752           0.0807          0.0245         0      
6 6          0.257             0.0364          0.105            0.0489          0.000582       0.143  
7 7          0.00320           0.0501          0.00815          0.00844         0              0      
8 8          0.00292           0.128           0.151            0.0814          0.00787        0      
9 9          0.991             0               0                0               0              0.00437
# … with 9 more variables: `Deciduous Forest` <dbl>, `Evergreen Forest` <dbl>, `Mixed Forest` <dbl>,
#   `Shrub/Scrub` <dbl>, Herbaceuous <dbl>, `Hay/Pasture` <dbl>, `Cultivated Crops` <dbl>, `Woody
#   Wetlands` <dbl>, `Emergent Herbaceuous Wetlands` <dbl>
```

<br>

## <span style="color:#881c1c">References</span>
---
1. McGarigal, K. andBJ Marks. 1994. FRAGSTATS v2: Spatial Pattern Analysis Program for Categorical and Continuous Maps. Computer software program produced by the authors at the University of Massachusetts, Amherst. Available at the following web site: http://www.umass.edu/landeco/research/fragstats/fragstats.html

2. Johnston, A. et al. Best practices for making reliable inferences from citizen science data: case study using eBird to estimate species distributions. bioRxiv (2019). doi:10.1101/574392
