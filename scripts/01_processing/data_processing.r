
# Cleaning the data from ICES on turtle bycatch for three species from 2017-2023

## Load packages
library(tidyverse)
library(readxl)
library(janitor) #cleaning and renaming
library(dplyr)

## Load data from raw-> change from spaces to snake case
ices_bycatch <- read_excel("data/raw/bycatch_data_2024.xlsx") |>
  clean_names() |>
  rename (gear_type = metier_l4, #abbr. relate to gear type, not level
          multiannual_bycatch_2017_2023 = reported_bycatch_2017_2023)
colnames(ices_bycatch) #view column names

## Create new object to filter for taxon of turtles only
turtle_bycatch <- ices_bycatch |>
  filter(taxon == "Turtles") |>
  mutate(total_bycatch = multiannual_bycatch_2017_2023 + replace_na(bycatch_2023, 0)) |>
  select(-bycatch_upper_ci, -bycatch_lower_ci, -bpue, -bpue_lower_ci, -bpue_upper_ci,
         -monitoring_effort_da_s_2017_2023, -fishing_effort_da_s_2023) #get rid of columns that make data messy
view(turtle_bycatch)

write_rds(x = turtle_bycatch,
          file = "data/processed/turtle_bycatch_clean.rds")
