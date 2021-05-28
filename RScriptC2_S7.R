library(tidyr)

#Tidying the rows
drinks #from the fivethirtyeight package
?drinks #the help file for the drinks database

#First data wrangle and get the specific data that we want out of it
drinks_smaller <- drinks %>%
  filter(country %in% c("USA", "China", "Italy", "Saudi Arabia")) %>% #only considers these countries
  select(-total_litres_of_pure_alcohol) %>%
  rename(beer = beer_servings, spirit = spirit_servings, wine = wine_servings)
drinks_smaller

#Now tidy data follows this format:
#Each variable is a column, each observation is a row, and each unit type is a table
#so you can't have country, beer, spirit, wine, but rather country, type, servings
#This is because beer, spirit, and wine are observations
drink_smaller_tidy <- drinks_smaller %>%
  pivot_longer(names_to = "type", #Changes the observation column name to "type"
               values_to = "servings", #Changes the value column name to "servings"
               cols = -country) #Tidy everything except country
drink_smaller_tidy

drinks_smaller %>%
  pivot_longer(names_to = "type", #Changes the observation column name to "type" 
               values_to = "servings", #Changes the value column name to "servings
               cols = c("beer", "spirit", "wine")) #Tidy columns beer, spirit, and wine

drinks_smaller %>%
  pivot_longer(names_to = "type", #Changes the observation column name to "type" 
               values_to = "servings", #Changes the value column name to "servings
               cols = beer:wine) #Tidy all columns from beer to wine