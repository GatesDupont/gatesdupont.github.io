# Gates Dupont        #
# For MassAudubon     #
# dupont97@gmail.com  #
# Feb. 4, 2020        #
# # # # # # # # # # # # 

# install.packages("ebirdst")
library(ebirdst)
library(raster)
library(sf)
library(rnaturalearth)
library(ggplot2)
library(ggpubr)
library(viridisLite)
library(dplyr)
library(leaflet.opacity)
# handle namespace conflicts
extract <- raster::extract


"STATE DATA"

# Get all data
us <- getData("GADM", country="USA", level=1)

# Subset to MA only
ma = us[match(toupper("Massachusetts"),toupper(us$NAME_1)),]


"GETTING EBIRD DATA"

t0 = Sys.time()
# Download data (this takes time (~20 mins for me), and space)
sp_path <- ebirdst_download(species =  "easmea", tifs_only = FALSE)
tf = Sys.time()
t_total  = tf-t0

"ABUNDANCE"

# load trimmed mean abundances
abunds <- load_raster("abundance_umean", path = sp_path)

# Cropping to an area rougly the size of MA
# (Week 23 = June 6-12)
abunds_23_cr =  crop(
  abunds[[23]], 
  extent(c(-6.2e6, -5.6e6,  4.5e6, 4.85e6)))

# define mollweide projection
mollweide <- "+proj=moll +lon_0=-90 +x_0=0 +y_0=0 +ellps=WGS84"

# project single layer from stack to mollweide
week23_moll <- projectRaster(
  abunds_23_cr, 
  crs = mollweide, method = "ngb")

# Mask to MA and crop
ma_moll = spTransform(ma, mollweide)
r = mask(week23_moll, ma_moll) %>%
  crop(., ma_moll) %>%
  projectRaster(., crs = crs(ma), method = "ngb")


"VARIABLE IMPORTANCE"

# Load predictor importance
pis = load_pis(sp_path)

# Select region and season
lp_extent <- ebirdst_extent(
  st_as_sf(ma), 
  t = c("2016-06-06", "2016-06-12")) # Models assumed 2016

# Plot centroids and extent of analysis
par(mfrow = c(1, 1), mar = c(0, 0, 0, 6))
calc_effective_extent(sp_path, ext = lp_extent)


"FINAL PLOT"

# Convert raster to data frame for ggplot
r_spdf <- as(r, "SpatialPixelsDataFrame")
r_df <- as.data.frame(r_spdf)
colnames(r_df) <- c("value", "x", "y")

# RELATIVE ABUNDANCE
ggplot() +
  geom_raster(data = r_df , aes(x = x, y = y, fill = value)) + 
  scale_fill_gradientn(colors = abundance_palette(10, season = "breeding")) +
  coord_quickmap() +
  theme_bw() +
  # theme(legend.position = "right", # For exporting as png of 2000x1000
  #       plot.title = element_text(size = 80),
  #       plot.subtitle = element_text(size = 50),
  #       plot.caption = element_text(size = 50),
  #       axis.text = element_text(size = 40),
  #       axis.title = element_text(size = 50),
  #       legend.title = element_text(size = 50),
  #       legend.text = element_text(size = 40)) +
  # guides(fill = guide_colourbar(barwidth = 4, barheight = 40)) +
  labs(title = "Eastern Meadowlark",
       subtitle = "Relative Abundance, June 6-12",
       caption = "Data source: eBird Status and Trends",
       fill = "RA", y = "Latitude", x = "Longitude")

# VARIABLE IMPORTANCE
plot_pis(pis, ext = lp_extent, by_cover_class = TRUE, n_top_pred = 15)
# I modified this function separately to produce stylistically similar plots


library(leaflet)

# Convert to leaflet CRS
map_crs = sp::CRS("+proj=longlat +ellps=WGS84 +datum=WGS84 +no_defs")
r4map = projectRaster(r, crs = map_crs, method = "bilinear")

# Add some options to the map
basemaps = c("CartoDB.Positron", "OpenStreetMap")
pal = colorNumeric(abundance_palette(10, season = "breeding"), values(r),
                    na.color = "transparent")
map_attr = "© <a href='https://www.esri.com/en-us/home'>ESRI</a> © <a href='https://www.google.com/maps/'>Google</a> © <a href='https://ebird.org/science/status-and-trends'>eBird / Cornell Lab of Ornithology</a> © <a href='https://www.gatesdupont.com/'>Gates Dupont</a>"


# Map
eame_ma_lf <-leaflet() %>% 
  addTiles(urlTemplate = "http://mt0.google.com/vt/lyrs=m&hl=en&x={x}&y={y}&z={z}&s=Ga",
          group  =  "Google") %>%
  addProviderTiles("CartoDB.Positron", group = "CartoDB") %>%
  addProviderTiles("OpenStreetMap", group = "Open Street Map") %>%
  addProviderTiles('Esri.WorldImagery', group = "ESRI") %>%
  addTiles(urlTemplate = "", attribution = map_attr) %>%
  addRasterImage(r, colors = pal, opacity = 0.5, layerId = "raster",
                 group = "Eastern Meadowlark") %>%
  addOpacitySlider(layerId = "raster")%>%
  addLegend(pal = pal, values = values(r),
            title = "Relative abundance") %>%
  leafem::addMouseCoordinates()  %>%
  addLayersControl(
    baseGroups = c("CartoDB", "Open Street Map", "Google", "ESRI"),
    overlayGroups = "Eastern Meadowlark",
    options = layersControlOptions(collapsed = FALSE)
  )

eame_ma_lf


htmlwidgets::saveWidget(eame_ma_lf, 
                        file = "~/Desktop/eame_ma.html", 
                        selfcontained = TRUE)
