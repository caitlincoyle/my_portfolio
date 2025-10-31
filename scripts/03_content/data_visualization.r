#Load packages------------------------------------
library(tidyverse)
library(cowplot)
library(dplyr)
library(stringr)

#Load Data-----------------------------------------
turtle_bycatch <- read_rds("data/processed/turtle_bycatch_clean.rds")
view(turtle_bycatch)

# Fix a capitalization error
turtle_bycatch <- turtle_bycatch |>
  mutate(species_common_name = str_to_sentence(species_common_name))
view(turtle_bycatch) #only noticed when I made the plot

## VISUALIZING THE DATA

# Building a plot that shows bycatch per species
p1 <- ggplot(data = turtle_bycatch,
             mapping = aes(x = total_bycatch, y = species_common_name)) +
  geom_col(fill = "cadetblue", color = "black") +
  labs(
    title = "Turtle Bycatch by Species (2017-2023)",
    x = "total bycatch",
    y = "species",
    caption = "data from ICES survey, 2023") +
  theme_minimal(base_size = 12)

print(p1)


p2 <- ggplot(turtle_bycatch,
             mapping = aes(x = total_bycatch, y = gear_type,
                           fill = species_common_name)) +
  geom_col() +
  labs(
    title = "Total Turtle Bycatch by Gear Type",
    x = "Bycatch",
    y = "Gear type",
    fill = "Species"
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold"),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )
print(p2)
