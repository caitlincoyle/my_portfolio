# my_portfolio

## Description 

Analyzing loggerhead, green sea turtle and leatherback turtle bycatch recordings
from 2017-2023. Objective is to understand ecoregions in which high levels of 
bycatch were reported, the gear type used along with the species caught, 
and visualize it using ggplot 

## Data Source

ICES. 2024. Bycatch of endangered, threatened and protected species of marine 
mammals, seabirds and marine turtles, and selected fish species of bycatch relevance. 
In Report of the ICES Advisory Committee, 2024. ICES Advice 2024, 
byc.eu. https://doi.org/10.17895/ices.advice.27999401

## Project structure
* `data`: 
  - `data/raw` contains the `*.csv` file as downloaded
from the ICES website
  - `data/processing` contains the cleaned up version of data for visualization 
* `scripts` : 
  - `scripts/01_processing` shows the importation of the ICES 2024 data in 
  excel format that is then cleaned using `library(tidyverse)` and `library(janitor)`
  to format to snake case and change the column `metier_l4` to `gear_type` to more
  accurately represent the data in that column for clear execution of my final visualizations
        -`data_processing.r` is a script with the object `ices_bycatch` and `turtle_bycatch` 
        that shows reading the original excel file and cleaning it into tidy format to the columns: 
        `ecoregion` for the area it was caught,  `gear_type` to show trawl, purse seine, 
        longline etc., `taxon` to show selection for turtles, `species_latin_name`, 
        `species_common_name`, `multiannual_bycatch_2017_2023`to show the estimates of 
        bycatch made between 2017-2023, `bycatch_2023` to show estimates for bycatch in 2023, 
        and `total_bycatch` which takes the total of the past two columns for simplicity
  - `scripts/02_analysis` 
  - `scripts/03_contents` contains completed scripts for graph production 
* `results/` : outputs for figures and tables

## Author

[Caitlin Coyle]
