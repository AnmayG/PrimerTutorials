library(lubridate)
#You use lubridate when dealing with dates and times

#There are 3 data types that refer to an instant in time
#dates (<date>), a time within a day (<time>), or date-time (<dttm>)
today() #Returns today's date
now() #Returns today's date-time
#Otherwise you just use a string, individual components, or existing objects

#From strings:
#You need to organize ymd in the order of the date and it'll put it in standard y/m/d
ymd("2017-01-31")
mdy("January 31st, 2017")
dmy("31-Jan-2017")
ymd(20170131) #You can also use unquoted numbers

#In order to create date-times, you do the same thing but with _hms in the time order
ymd_hms("2017-01-31 20:11:59")
mdy_hm("01/31/2017 08:01")
ymd(20170131, tz="UTC") #You can also use unquoted numbers with a timezone

#From individual components:
flights %>% select(year, month, day, hour, minute) #Shows flights data with only dates and times
flights %>% select(year, month, day, hour, minute) %>% #Shows flights data with only dates and times
  mutate(departure = make_datetime(year, month, day, hour, minute)) #Creates a new column named departure with datetime components

#From other types:
as_datetime(today()) #Turns a date-time into a date
as_date(now()) #Turns a date-time into a date
as_datetime(60 * 60 * 10) #Gets date-time from the offset in seconds from 1970-01-1
as_date(365*10 + 2) #Gets date from the offset to 1970-01-01 in days (including leap years)

#This is how you can use date-time data
datetime <- ymd_hms("2016-07-08 12:34:56")
year(datetime) #Year
month(datetime) #Month
mday(datetime) #Day of the month
yday(datetime) #Day of the year
wday(datetime) #Day of the week
month(datetime, label = TRUE) #Shows the abbreviated name as a string
wday(datetime, label = TRUE, abbr = FALSE) #Shows the full name as a string

#You can also update the date time by doing this
update(datetime, year = 2020, month = 2, mday = 2, hour = 2) #Updates the values to what you coded in
ymd("2015-02-01") %>% update(mday=30) #It will roll over if it's not in there. February doesn't have 30 days so it's March 2nd
ymd("2015-02-01") %>% update(hour = 400) #Also rolls over for times

#Timezones are weird
OlsonNames() #See all timezones
(x1 <- ymd_hms("2015-06-01 12:00:00", tz = "America/New_York"))
(x2 <- ymd_hms("2015-06-01 18:00:00", tz = "Europe/Copenhagen"))
(x3 <- ymd_hms("2014-06-02 04:00:00", tz = "Pacific/Auckland"))



















