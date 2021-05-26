library(tidyverse, fivethirtyeight, dplyr)
library(primer.data, lubridate, janitor, skimr, nycflights13, gapminder)
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



