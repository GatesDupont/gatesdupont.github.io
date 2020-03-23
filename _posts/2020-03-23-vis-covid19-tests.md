---
title: "Visualizing state-level testing for COVID-19"
layout: post
published: true
use_code: true
---

<i>Introducing some tips and tricks for accessing and visualizing testing data from the COVID-19 pandemic.</i>

<br>


This is a quick post to introduce a few useful tips and tricks that are readily available in R to efficiently produce a state-level visualization of reported testing data. The end-goal here, as you can see in Figure 1, is a geo-facetted map showing the cumulative daily total number of tests administered by state. To make it more intuitive, that number is scaled to the number of tests per thousand people. 

We will start out by getting the packages we need. As usual, we will rely on [`dplyr`](https://dplyr.tidyverse.org/) for efficient data manipulation, and [`ggplot2`](https://ggplot2.tidyverse.org/reference/ggtheme.html) and its extension, [`ggpubr`](https://rpkgs.datanovia.com/ggpubr/), to make plotting a bit easier and more aesthetically pleasing. [`RCurl`](https://www.rdocumentation.org/packages/RCurl/versions/1.98-1.1) is a package that will help us scrape [api data](https://covidtracking.com/api/) of US state testing from [The COVID Tracking Project](https://covidtracking.com/), which we can then compare to data of 2015 state population sizes readily available from the [`usmap`](https://www.rdocumentation.org/packages/usmap/versions/0.5.0/topics/usmap) package. Finally, we'll put this all together into a nice factted plot where each facet represents a state, using the package [`geofacet`](https://hafen.github.io/geofacet/). If you are missing any of these packages, they are all available for download from CRAN, so you can use: `install.packages("dplyr")`, for example.

```r
library(dplyr)
library(ggplot2)
library(ggpubr)
library(RCurl)
library(usmap)
library(geofacet)
```



```r
# State population data
data(statepop)

# Get testing data from covid19 tracking
URL <- "https://covidtracking.com/api/states/daily.csv"
download <- getURL(URL)
df <- read.csv (text = download)
```

```r
# Convert to per capita
df <- merge.data.frame(df, statepop, by.x = "state", by.y = "abbr")
df$perthousand <- 1000* (df$total/df$pop_2015)
```

```r
# Convert to julian date
df$date <- as.POSIXlt(as.character(df$date), format = "%Y%m%d")$yday
```

```r
# Total tests
df = df %>%
  group_by(state) %>%
  mutate(overall_total = max(perthousand)) %>%
  ungroup()
```

```r
# Plotting
ggplot(data = df, aes(x = date, y = perthousand)) +
  geom_line(aes(color = overall_total), size = 1) +
  scale_color_viridis_c(direction = -1, trans = "log") +
  xlab("Julian Date") +
  ylab("Number of tests per 1000 individuals") +
  facet_geo(~state) +
  theme_light() +
  theme(legend.position = "none",
        strip.text = element_text(color = "gray20"),
        panel.grid = element_line(color = "gray90", 
                                  size = 0.35))

```
