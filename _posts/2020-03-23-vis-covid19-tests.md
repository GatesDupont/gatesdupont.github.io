---
title: "Visualizing state-level testing for COVID-19"
layout: post
published: true
use_code: true
---

<i>Introducing some tips and tricks for accessing and visualizing testing data from the COVID-19 pandemic.</i>

<br>


This is a quick post to introduce a few useful tips and tricks that are readily available in R to efficiently produce a state-level visualization of reported testing data.



```r
library(usmap)
library(dplyr)
library(RCurl)
library(ggplot2)
library(ggpubr)
library(geofacet)

# State population data
data(statepop)

# Get testing data from covid19 tracking
URL <- "https://covidtracking.com/api/states/daily.csv"
download <- getURL(URL)
df <- read.csv (text = download)

# Convert to per capita
df <- merge.data.frame(df, statepop, by.x = "state", by.y = "abbr")
df$perthousand <- 1000* (df$total/df$pop_2015)

# Convert to julian date
df$date <- as.POSIXlt(as.character(df$date), format = "%Y%m%d")$yday

# Total tests
df = df %>%
  group_by(state) %>%
  mutate(overall_total = max(perthousand)) %>%
  ungroup()

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
