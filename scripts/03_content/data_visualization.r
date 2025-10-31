#Load packages------------------------------------
library(tidyverse)
library(dplyr)
library(stringr) #used for additonal cleaning

#Load Data-----------------------------------------
turtle_bycatch <- read_rds("data/processed/turtle_bycatch_clean.rds")
view(turtle_bycatch) #checking data

# Fix a capitalization error
turtle_bycatch <- turtle_bycatch |>
  mutate(species_common_name = str_to_sentence(species_common_name))
view(turtle_bycatch) #only noticed when I made the plot

## VISUALIZING THE DATA-----------------------------------------

# Building a plot that shows bycatch per ecoregion
p1 <- ggplot(data = turtle_bycatch,
             mapping = aes(x = total_bycatch, y = ecoregion, fill = species_common_name)) +
  geom_col(fill = "cadetblue", color = "black") + #had some issues with the black lines
  facet_wrap(~species_common_name, scales = "free_x") + #showing facet wrap
  labs(
    title = "Turtle Bycatch by Species (2017-2023)",
    x = "Total Bycatch",
    y = "Species",
    caption = "Data from ICES survey, 2024") +
  theme_minimal(base_size = 12) +
   theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1),  # use linewidth instead of size
    panel.spacing = unit(1, "lines")) #additional work for cleanliness

print(p1) #view the new plot

# EXPORT PLOT AS A PNG
ggsave(plot = p1,
       filename = "results/img/turtle_ecoregion.png")

# SECOND PLOT: shows turtle bycatch per gear type used
## Since data for loggerhead > leatherback and green, facet will be used again
p2 <- ggplot(turtle_bycatch, aes(x = total_bycatch, y = gear_type,
                                 color = gear_type)) +
  geom_jitter(width = 0.2, size = 3, alpha = 0.7) +
  facet_wrap(~species_common_name, scale = "free") +
  labs(
    title = "Turtle Bycatch by Gear Type (2017-2023)",
    x = "Total Bycatch",
    y = "Gear Type",
    color = "Gear Type",
    caption = "Data sourced from ICES, 2024"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 1),  # use linewidth instead of size
    panel.spacing = unit(1, "lines"))

print(p2)

ggsave(plot = p2,
       filename = "results/img/turtle_gear_type.png")
