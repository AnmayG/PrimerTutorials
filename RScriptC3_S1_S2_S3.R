library(tidyverse)
library(primer.data)
library(lubridate)
library(janitor)
library(skimr)

#Includes all stuff from chapter 3
#Use read_csv
happiness_data <- read_csv("data/happiness_report.csv") #Don't run this
file_1 <- "https://raw.githubusercontent.com/PPBDS/primer.tutorials/master/inst/www/test_2.csv"
read_csv(file_1) #Most times there's going to be information or something at the top of the file
read_csv(file = file_1, skip = 2) #So you can use this to skip it
read_csv(file = file_1,
         skip = 2,
         col_types = cols(a = col_double(),
                          b = col_double(),
                          c = col_double())) #This just gets rid of the column specifications message that we don't want
#You can also use read_delim() that uses tabs as the delimiter instead of columns

#Reading from an Excel file
library(readxl)

#Creates a new temporary file, downloads the excel file into it, and then reads it
url <- "https://raw.githubusercontent.com/PPBDS/primer.tutorials/master/inst/www/excel_1.xlsx"
tf = tempfile()
download.file(url, tf, mode = "wb")
readxl::read_excel(tf)

#Reading from an RDS file is just like reading from a csv

#Reading from a .json file is like this:
library(jsonlite)
(example_1 <- tibble(name= c("Miguel", "Sofia", "Aya", "Cheng"), 
                    student_id = 1:4, exam_1 = c(85, 94, 87, 90), 
                    exam_2 = c(86, 93, 88, 91)))
toJSON(example_1, pretty = TRUE) #Turns the tibble into a .json

json_format_ex <-
  '[
  {"Name" : "Mario", "Age" : 32, "Occupation" : "Plumber"}, 
  {"Name" : "Peach", "Age" : 21, "Occupation" : "Princess"},
  {},
  {"Name" : "Bowser", "Occupation" : "Koopa"}
]'
fromJSON(json_format_ex) #Turns the .json format into a tibble 

#Reading from an SQLite database
#These are normally stored on a computer
#The tutorial is very lacking on this
library(DBI)
con_lang_data <- dbConnect(RSQLite::SQLite(), "can_lang.db") #Create a connection with the SQLite database
(tables <- dbListTables(con_lang_data)) #Get the list of tables in the database
(lang_db <- tbl(con_lang_data, "lang")) #Get the table named lang
(aboriginal_lang_db <- filter(lang_db, category == "Aboriginal languages")) #Filters so only aboriginal languages remain
(aboriginal_lang_data <- collect(aboriginal_lang_db)) #Finally loads it in as a tibble
#Do this so that you can do things like nrow() and tail()

#Reading from a PostgreSQL database
library(RPostgres)
can_mov_db_con <- dbConnect(RPostgres::Postgres(), dbname = "can_mov_db",
                            host = "r7k3-mds1.stat.ubc.ca", port = 5432,
                            user = "user0001", password = '################') #This doesn't work, connection's dead
dbListTables(can_mov_db_con)
#it's the same thing as SQLite from now on
(ratings_db <- tbl(can_mov_db_con))
avg_rating_db <- select(ratings_db, average_rating)
min(avg_rating_db) #doesn't work
avg_rating_data <- collect(avg_rating_db)
min(avg_rating_data)

#Webscraping
#First we have to use the selector gadget tool from Chrome
#Keep in mind that you can't break the law and check the terms and conditions
#So things like Wikipedia are very useful
#Selector gadget basically lets you click on an element in order to find the path
#So that stuff lets you find the css selectors which you can then put in your computer
library(rvest) #This is the library that we'll be using
#This doesn't work very well due to having the wrong css selectors
page <- read_html("https://en.wikipedia.org/wiki/Canada") #this is the page that we'll be using
#This gets the HTML nodes through the css selectors
population_nodes <- html_nodes(page, "td:nth-child(5) , td:nth-child(7) , 
                               .infobox:nth-child(122) td:nth-child(1) , 
                               .infobox td:nth-child(3)") #These are the css selectors that we found through selector gadget
head(population_nodes, 6L) #Prints the first 6 lines of the CSS info we found
(population_text <- html_text(population_nodes)) #Gets the text from the HTML nodes, but it looks really bad and isn't formatted nicely

#APIs
#It's a really bad idea to have API keys publicly for obvious reasons
#So the way that we do this is by storing things in the .Renviron file
#It basically stores any environmental variables
#This file isn't outright listed, so you have to run the following command:
#usethis::edit_r_environ()
#Put the thing as a normal variable (this = "api key") and save
#Once this is done, restart r (you can do this by pressing Ctrl-Shift-F10)
#and the things can be saved. You then access the thing by doing Sys.getenv("variable name")
#Like this!
nasa_api_key <- Sys.getenv("NASA_API_KEY")
#Keep in mind that not everything is going to need an API key but it's still useful
#Now let's actually get some data from our API
#You can do this in 1 of 2 ways
#Way #1: Use the library associated with the network
library(riem) #This one is a weather station API that basically has the tables
france_airports <- riem_stations(network = "FR__ASOS") #Look at french airport stations
(marseilles_airport <- filter(france_airports, grepl("MARSEILLE", name) | grepl("Marseille", name))) #Get the marseille station
marseille <- riem_measures(station = marseilles_airport$id,
                           date_start = "2010 01 01") #Get the temperature info from 2010
marseille <- group_by(marseille, day = as.Date(valid)) #Group it by whether the date is valid or not
marseille <- summarize(marseille, temperature = mean(tmpf)) #Organize it so that the temperature is the average temperature by day
view(marseille)
marseille <- mutate(marseille, temperature = weathermetrics::fahrenheit.to.celsius(temperature)) #Change temperature to Celsius
ggplot(marseille, aes(x = day, y = temperature)) + geom_line() #Graph the tibble

#Way #2: Use an HTTP request to pull out the data forcibly
library(httr)
original_url <- "https://mesonet.agron.iastate.edu/cgi-bin/request/asos.py/"
denver <- GET(url = original_url, #Send the request to this URL with these parameters
              query = list(station = "DEN", #These parameters can vary based on the API
                           data = "sped",
                           year1 = "2016",
                           month1 = "6",
                           day1 = "1",
                           year2 = "2016",
                           month2 = "6",
                           day2 = "30",
                           tz = "America/Denver",
                           format = "comma")) %>%
  content() %>% #Get the CSV file from the GET request
  read_csv(skip = 5, na = "M") #Read the csv file and chop off the useless 5 rows at the beginning
denver <- group_by(denver, day = as.Date(valid)) #Group the things by the date (they take multiple measurements per day)
denver <- summarize(denver, speed = mean(sped, na.rm = TRUE)) #Organize it so that we just get wind speed points for each day
ggplot(denver, aes(x = day, y = speed)) + geom_line() #Graph the tibble

#Here's an example of getting the Astronomy image of the Day from NASA
#Based on here: https://github.com/eringrand/astropic/
nasa <- GET(url = "https://api.nasa.gov/planetary/apod",
            query = list(date = "2020-01-02", #The date to pull the image from
                         api_key = Sys.getenv("NASA_API_KEY"))) %>% content() #Get's today's APOD using the NASA API key
image_url <- nasa$hdurl #Gets the url
image <- try(magick::image_read(image_url), silent = FALSE) #Tries to get the image and if it doesn't it yells at you
image_name <- gsub(".*/([^/]+$)", '\\1', image_url) #Uses a regex to get the name
image_loc <- here::here("APODs", image_name) #Creates a location
if(class(image) != "try-error") image %>% magick::image_write(image_loc) #If it wasn't an error write to the location