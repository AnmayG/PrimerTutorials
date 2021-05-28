library(tidyverse)
library(primer.data)
library(lubridate)
library(janitor)
library(skimr)
library(nycflights13)
library(gapminder)
library(fivethirtyeight)
library(plotly)
tibble(a = 2.1, b = "Hello", c = TRUE, d = 9L)
tibble('54abc' = 1, 'my var' = 2, c = 3)
tribble(
  ~var1, ~'var 2', ~myvar,
  1, 3, 5,
  4, 6, 8
)


tbl_fruit <- tibble(fruit = fruit)
# tbl_fruit
# tbl_fruit %>% slice_sample(n=8)
# tbl_fruit %>% slice_sample(prop=0.25)
tbl_fruit %>% mutate(fruit_in_name = str_detect(fruit, pattern = "c"))

tbl_fruit %>% mutate(name_length = str_length(fruit))

tbl_fruit %>% mutate(first_three_letters = str_sub(fruit, 1, 3))

tbl_fruit %>% mutate(name_with_s = str_c(fruit, "s"))

tbl_fruit %>% mutate(capital_A = str_replace(fruit, pattern = "a", 
                                             replacement = "A"))
tbl_fruit %>% filter(str_detect(fruit, pattern = "w"))

#Regex exploration
#The "." means that it has any single character there except a newline.
#So it's looking for b (any character) r in the string
tbl_fruit %>% filter(str_detect(fruit, pattern = "b.r"))

#The "^" means that the character is at the beginning of the string
#So this looks for any string that starts with w
tbl_fruit %>% filter(str_detect(fruit, pattern = "^w"))

#The "$" means that the character is at the end of the string
#So this looks for any string that ends with o
tbl_fruit %>% filter(str_detect(fruit, pattern = "o$"))

#When we want to use regex characters without a regex we need r()
r"(Do you use "airquotes" much?)"
r"(\)"

#Factors are categorical variables
#That means that they only have a few possible values
#Think hair colors (brown, red, etc.) You can't have 7 hair.
#So this just sets factors based on the range in the tibble
#In order to manipulate factors you use the forcats package
#factor() is useful when you need a factor from nothing
#as.factor() is best for simple transformations like that of character variables
#parse_factor() is the most modern and powerful
tibble(X = letters[1:3]) %>% 
  mutate(fac_1 = factor(X)) %>%
  mutate(fac_2 = as.factor(letters[4:6])) %>%
  mutate(fac_3 = parse_factor(X))

#This shows general info about gapminder, including the 1 factor it has
str(gapminder$continent)

#This shows the categories that gapminder has
levels(gapminder$continent)

#This shows the number of categories that gapminder has
nlevels(gapminder$continent)

#This shows that the gapminder continent variable is a factor
class(gapminder$continent)

#This is how you get a frequency table from a tibble
gapminder %>% count(continent)
fct_count(gapminder$continent)

#Gets the number of countries in gapminder
nlevels(gapminder$country)

#Filters out the countries Egypt, Haiti, Romania, Thailand , and Venezuela
h_gap <- gapminder %>% filter(country %in% c("Egypt", "Haiti", "Romania", 
                                            "Thailand", "Venezuela"))
nlevels(h_gap$country)

#There are a bunch of unused levels so we drop those by doing this:
h_gap$country %>% fct_drop() %>% levels()

#Factor levels are normally alphabetical but you can sort them
gapminder$continent %>% levels()
gapminder$continent %>% fct_infreq() %>% levels()
gapminder$continent %>% fct_infreq() %>% fct_rev() %>% levels()

#Make a bar plot that shows the continent and number of entries in a bar plot
gapminder %>% 
  mutate(continent = fct_infreq(continent)) %>% #Sort continent by frequency 
  mutate(continent = fct_rev(continent)) %>%  #Most frequent continent first
  ggplot(aes(x = continent)) + #Create a new plot with the x being the continent
  geom_bar() + #Make it a bar plot
  coord_flip() #Flip the coordinates so it turns sideways

ggplotly(gapminder %>% 
  mutate(continent = fct_infreq(continent)) %>% #Sort continent by frequency 
  ggplot(aes(x = continent)) + #Create a new plot with the x being the continent
  geom_bar() + #Make it a bar plot
  coord_flip() #Flip the coordinates so it turns sideways
)

#You can also order country by another variable
fct_reorder(gapminder$country, gapminder$lifeExp) %>% #Sorts the countries least to highest by median life expectancy
  levels() %>% #Gets the country names by looking at the country factor
  head(n = 6L) #Only shows the first {parameter} country names

#It defaults to median, but you can do it with min
fct_reorder(gapminder$country, gapminder$lifeExp, min) %>% #Sorts the countries least to highest by min life expectancy
  levels() %>% #Gets the country names by looking at the country factor
  head(n = 6L) #Only shows the first {parameter} country names

#Or backwards as well
fct_reorder(gapminder$country, gapminder$lifeExp, .desc = TRUE) %>% #Sorts the countries highest to least by median life expectancy
  levels() %>% #Gets the country names by looking at the country factor
  head(n = 6L) #Only shows the first {parameter} country names

#Here's a demo as to why you want to sort your factors
#This one is sorted alphabetically
gapminder %>% 
  filter(year == 2007, continent == "Americas") %>% #Filter so only 2007 data from the Americas is graphed
  ggplot(aes(x = lifeExp, y = country)) + #new plot with life expectancy as x and country as y
  geom_point() #Scatter plot
#This one is sorted by life expectancy
gapminder %>%
  filter(year == 2007, continent == "Americas") %>% #Filter so only 2007 data from the Americas is graphed
  ggplot(aes(x=lifeExp, #new plot with life expectancy as x and country as y
             y = fct_reorder(country, lifeExp))) + #Countries are sorted by median life expectancy in 2007
  geom_point() #Scatter plot

#You can also rename factors and their levels
i_gap <- gapminder %>% #Store this list into the i_gap variable
  filter(country %in% c('United States', 'Sweden', 'Australia')) %>% #filter so only US, Sweden, and Australia data shows
  droplevels() #Drop everything else
i_gap$country %>% levels() #display the possible values of country
i_gap$country %>% 
  fct_recode("USA" = "United States", "Oz" = "Australia") %>% #Rename the factors to USA and Oz
  levels() #display the possible values of country

#You can also grow factors to combine their possible values
df1 <- gapminder %>%
  filter(country %in% c("United States", "Mexico"), year > 2000) %>% #Filter so only US and Mexico data from 2000+ is displayed
  droplevels() #Drop all of the other possible values
df2 <- gapminder %>%
  filter(country %in% c("France", "Germany"), year > 2000) %>% #Filter so only France and Germany data from 2000+ is displayed
  droplevels() #Drop all of the other possible values

#The country factors in these two tibbles have different levels/possible values
levels(df1$country)
levels(df2$country)

#In order to combine them, you can't use the c() and have to use fct_c()
c(df1$country, df2$country)
fct_c(df1$country, df2$country)