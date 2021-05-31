(m <- matrix(c(3, 4, 8, 9, 12, 13, 0, 15, -1), ncol = 3)) #Matrix with 3 columns
m[, 2:3] #gets all rows and columns 2:3
m[, 2] #'collapses' into a single vector
m %>% as_tibble() #turns it into a tibble but have to include x

(tbl <- tribble(
  ~a, ~b, ~c,
  2,   3,  5,
  4,  NA,  8,
  NA,  7,  9,
))  

tbl %>% summarize(avg_a = mean(a)) #NA values can make it bad
tbl %>% summarize(avg_a = mean(a, na.rm = TRUE)) #Can ignore NA values though
tbl %>% drop_na(a) #Can just remove the row
tbl %>% drop_na() #drops all rows with NA inside
tbl %>% mutate(a_missing = is.na(a)) #determines if a value is missing in a

#All of the tidyverse commands go column by column, but you can change that
tbl %>% rowwise()
tbl %>% rowwise() %>%
  mutate(sum_a_c = sum(c_across(c(a, c)))) %>%
  mutate(largest = max(c_across())) %>%
  mutate(largets_na = max(c_across(), na.rm = TRUE))
