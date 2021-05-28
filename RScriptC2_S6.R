#Combining data from tibbles
data_1 <- tibble(x = 1:2, y = c("A", "B")) #data table 1
data_2 <- tibble(x = 3:4, y = c("A", "B")) #data table 2
data_1
data_2
bind_rows(data_1, data_2) #If the column names aren't the same it's filled with NA

#Joins
superheroes <- tibble::tribble(
  ~name,   ~gender,     ~publisher,
  "Magneto",   "male",       "Marvel",
  "Storm",   "female",     "Marvel",
  "Batman",   "male",       "DC",
  "Catwoman",   "female",     "DC",
  "Hellboy",   "male",       "Dark Horse Comics"
)

publishers <- tibble::tribble( #Use tribble to create quick data tables
  ~publisher, ~yr_founded,
  "DC",       1934L,
  "Marvel",       1939L,
  "Image",       1992L
)

inner_join(superheroes, publishers) #Joins the two tibbles by looking for a common variable and adding those (not sorted)
inner_join(superheroes, publishers, by = "publisher") #Joins the two tibbles by using the "by" input
inner_join(publishers, superheroes, by = "publisher") #Changes the order to follow publishers mainly (still includes extra superhero though)
#We lose Hell-boy in the join because his publisher doesn't show up
full_join(superheroes, publishers, by = "publisher") #full_join includes everything and uses NA as a placeholder
left_join(superheroes, publishers, by = "publisher") #left_join includes all of the rows of x and all columns from x and y
left_join(publishers, superheroes, by = "publisher") #This includes Image because all rows from publishers
semi_join(superheroes, publishers, by = "publisher") #This takes all matching rows from x and keeps just x's columns
semi_join(publishers, superheroes, by = "publisher") #Only has the columns from publishers
anti_join(superheroes, publishers, by = "publisher") #Shows the rows that don't match
anti_join(publishers, superheroes, by = "publisher")

#Examples with NYCflights
flights %>% inner_join(airlines, by = "carrier")
inner_join(flights, airlines, by = "carrier") #Same as above

airports #airport codes for everything but labeled "faa" instead of "dest"
flights %>% inner_join(airports, by = c("dest" = "faa")) #This lets me join by using "dest" in flights instead of "faa" in airports
flights %>%
  group_by(dest) %>% #Groups the flights by their destination
  summarize(num_flights = n(), #Creates a new tibble with the groups acting as the rows 
            .groups = "drop") %>% #Delete the groups afterwards
  arrange(desc(num_flights)) %>% #Sort them by the number of flights descending
  inner_join(airports, by = c("dest" = "faa")) %>%  #Inner join them
  rename(airport_name = name) #Replace the airport_name from flights with name from airports