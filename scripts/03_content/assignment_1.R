#For Assignment 1

#Load packages

library(tidyverse)
library(EVR628tools)

#Begin to create plot
data(data_heatwaves)

#Create a simple plot--option + dash button gets <-
p <- ggplot(data_heatwaves,
            aes (x = year , y = temp_mean))+
  geom_point() +
  labs(
    x = "Year", y = "Mean Temperature",
    title = "Mean temperature over time"
  )

p

#Save Plot
ggsave(plot = p, filename = "results/img/first_plot.png")

# Build my vectors
colors <- c("red","blue","green","orange","black") #for five colors
numbers <- c(1, 40, 1, 5, 6) #for five numbers

#Column names are automatically assigned
my_data <- data.frame(colors,
           numbers)


