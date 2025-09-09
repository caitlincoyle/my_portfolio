#For Assignment 1

#Load packages

library(tidyverse)
library(EVR628tools)

#Begin to create plot
data(data_heatwaves)

#Create a simple plot
p <- ggplot(data_heatwaves,
            aes (x = year , y = temp_mean))+
  geom_point() +
  labs(
    x = "Year", y = "Mean Temperature"
  )

p

#Save Plot
ggsave(plot = p, filename = "results/img/first_plot.png")

