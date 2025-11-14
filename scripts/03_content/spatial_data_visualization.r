# Using spatial data to view geographical data
## Assignment No.4 for EVR 628
#--------------------------------------------------------------
# LOAD PACKAGES
library(ggspatial) #for ggplot visualization
library(rnaturalearth) #for mapping baselayer
library(viridis) #for the final ggplot
library(janitor) #for cleaning capitalization error
library(tidyverse)
library(readxl) #used to read rds from files
library(sf) #used for vector data from ICES ecoregions shapefile
library(mapview) #for visualization
library(stringr) #for joining data sets by ecoregion label

# LOAD DATA
## Load data for ecoregions from ICES using sf
ecoregions <- read_sf("data/raw/ICES_ecoregions /ICES_ecoregions_20171207_erase_ESRI.shp")

## Loading data from visualization assignment
turtle_data <- read_rds("data/processed/turtle_bycatch_clean.rds") |>
  clean_names() |>
  rename(Ecoregion = ecoregion)

# Clean the ecoregion names to avoid mismatch issues
ecoregions <- ecoregions |>
  mutate(Ecoregion = str_to_lower(str_trim(Ecoregion)))

turtle_data <- turtle_data |>
  mutate(Ecoregion = str_to_lower(str_trim(Ecoregion)))

# Clean the turtle data to ensure no duplicates for the ecoregions (mismatched values)
turtle_data_clean <- turtle_data |>
  group_by(Ecoregion, species_common_name) |>
  summarize(
    total_bycatch = sum(total_bycatch, na.rm = TRUE),
    .groups = "drop")

# Join the two files since turtle_bycatch has no spatial data to plot
eco_turtle <- ecoregions |>
  left_join(turtle_data_clean, by = "Ecoregion")

# Showing only polygons with bycatch data
eco_turtle_bycatch <- eco_turtle |>
  filter(!is.na(total_bycatch)) |>
  st_make_valid()

# Filtering the data to show only green sea turtles due to vast size and detail of the data (too large)
green_turtle <- eco_turtle_bycatch |>
  filter(species_common_name == "Green Sea Turtle") |>
  st_make_valid()  # to check and ensure it works!

# Filtering the data to separate loggerhead and green sea turtle (most commonly caught)
loggerhead <- eco_turtle_bycatch |>
  filter(species_common_name == "Loggerhead") |>
  st_make_valid()

# Combine into one sf object for easier plotting
both_species <- bind_rows(green_turtle, loggerhead)

# Simplifying geometry for easier and faster vector plotting
both_species_simple <- st_simplify(both_species, dTolerance = 0.05)

# Loading the world basemap before setting zoom
world <- ne_countries(scale = "medium", returnclass = "sf")

#make a bounding box for the polygons
bbox_all <- st_bbox(both_species_simple)
x_pad <- (bbox_all$xmax - bbox_all$xmin) * 0.1
y_pad <- (bbox_all$ymax - bbox_all$ymin) * 0.1

#Create the faceted map in order to show both polygons in different species
p <- ggplot() +
  geom_sf(data = world, fill = "grey92", color = "white", size = 0.3) +
  geom_sf(
    data = both_species_simple,
    aes(fill = total_bycatch),
    color = "black",
    size = 0.5,
    alpha = 0.85) +
  scale_fill_viridis_c(option = "D", direction = 1,
                       name = "Total\nBycatch") +
# Scale bar + north arrow
annotation_scale(location = "bl", width_hint = 0.25, line_width = 0.8) +
annotation_north_arrow(location = "tl",
                       height = unit(1.2, "cm"),
                       width = unit(1.2, "cm"),
                       pad_x = unit(0.4, "cm"),
                       pad_y = unit(0.4, "cm"),
                       style = north_arrow_fancy_orienteering) +
# Zoom into needed area
coord_sf(
  xlim = c(bbox_all$xmin - x_pad, bbox_all$xmax + x_pad),
  ylim = c(bbox_all$ymin - y_pad, bbox_all$ymax + y_pad),
  expand = FALSE) +
# Facet by species for easier visualization
facet_wrap(~ species_common_name) +
# Adding labels
labs(
  title = "Sea Turtle Bycatch by ICES Ecoregion 2017-2023",
  subtitle = "Comparison of Loggerhead and Green Sea Turtle Bycatch",
  caption = "Data: ICES Ecoregions & Turtle Bycatch Monitoring Dataset") +
theme_minimal(base_size = 14) +
theme(
  plot.title = element_text(face = "bold", size = 18),
  plot.subtitle = element_text(size = 13, margin = margin(b = 10)),
  legend.position = "right",
  panel.grid = element_line(color = "grey90"),
  axis.title = element_blank())

ggsave("results/img/turtle_bycatch_map.png",p)

