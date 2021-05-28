#A distribution is a function that shows the possible values of a variable and how often they occur
rolls <- c(5, 5, 1, 5, 4, 2, 6, 2, 1, 5) #These are the results of rolling a dice 10 times.
table(rolls) #This is the vector without duplicates and their frequencies in a table
more_rolls <- rep(rolls, 1000) #repeats rolls 1000 times for an example
table(more_rolls) #creates a table of rolls without having to store 10000 values
#You often normalize distributions so that the y-axis is a percentage rather than an objective value

#The most common distributions we work with are empirical or frequency distributions
#So stuff like age in trains tibble or poverty in Kenya tibble
#But you can also make your own data through things like sample()
die <- c(1, 2, 3, 4, 5, 6)
sample(x = die, size = 1) #Chooses 1 random thing from die
sample(x = die, size = 10, replace = TRUE) #Chooses 10 random things from die, duplicates possible
sample(x = die, size = 10, replace = TRUE, #Chooses 10 random things from die, duplicates possible
       prob = c(0.5, 0.1, 0.1, 0.1, 0.1, 0.1)) #Follows these probabilities
sample(x = die, size = 10000, replace = TRUE,
       prob = c(0.1, 0.2, 0.1, 0.05, 0.05, 0.01)) #Will re-scale probabilities
#Keep in mind that there is no real data. 
#You didn't actually roll a dice, you made some assumptions about what would happen if you did
#With those assumptions, we built a mechanism that you can draw as many values as you like

tibble(result = sample(x = die, size = 10000, replace = TRUE,  #Gets a random distribution from die
              prob = c(0.5, rep(0.1, 5)))) %>% #Uses these probabilities
  ggplot(aes(x = result)) + #Plots the result
  geom_bar() + #Uses a bar graph
  labs(title = "Distribution of Results of an Unfair Die", #Labels title
       x = "Result of One Roll", y = "Count") + #Labels x and y
  scale_x_continuous(breaks = 1:6, labels = as.character(1:6)) + #Sets the x to 1 through 6
  scale_y_continuous(labels = scales::comma_format()) #Sets the y to whatever it is but uses commas instead of scientific notation

#This shows what a distribution is
#A distribution is the thing you see in this plot
#A math object with a set of possible values and the number of times each value appears
#A distribution can also be just the simple vector, like die is
#These are interchangeable but cool
#Sample() is one of the functions that lets you draw a distribution

#r-unif() is another one of these functions
runif(n = 10, min = 4, max = 6) #Generates 10 random decimals between 4 and 6 using a uniform distribution
rbinom(n = 1, size = 1, prob = 0.1) #Generates 1 random 0 or 1 based on the probability of success, like a coin flip
tibble(heads = rbinom(n = 100, size = 1, prob = 0.5)) %>% #100 random 0s and 1s with a 1 appearing 0.5 of the time
  ggplot(aes(x = heads)) + #Plots the result
  geom_bar() + #Uses a bar graph
  labs(title = "Flipping a fair coin 100 times", #Labels title
       x = "Result", y = "Count") + #Labels x and y
  scale_x_continuous(breaks = c(0, 1), #Breaks the x so that it's 0 and 1
                     labels = c("Tails", "Heads")) #Labels 0 "tails" and 1 "heads"

#Another is rbinom()
tibble(heads = rbinom(n = 100, size = 1, prob = 0.75)) %>% #100 random 0s and 1s with a 1 appearing 0.75 of the time
  ggplot(aes(x = heads)) + #Plots the result
  geom_bar() + #Uses a bar graph
  labs(title = "Flipping a fair coin 100 times", #Labels title
       x = "Result", y = "Count") + #Labels x and y
  scale_x_continuous(breaks = c(0, 1), #Breaks the x so that it's 0 and 1
                     labels = c("Tails", "Heads")) #Labels 0 "tails" and 1 "heads"

tibble(heads = rbinom(n = 10000, size = 10, prob = 0.5)) %>% #Flipping a random coin 10 times, adding the results, and repeating to 10000
  ggplot(aes(x = heads)) + #Plots the result
  geom_bar() + #Uses a bar graph
  scale_x_continuous(breaks = 0:10) #Breaks the x to only be values from 0 to 10

#And finally rnorm()
rnorm(10) #Creates 10 values using a normal distribution with a mean of 0 and standard deviation of 1
tibble(value = rnorm(10)) %>% #10 values
  ggplot(aes(x = value)) + #Plots the result
  geom_histogram(bins = 10) #Uses a histogram with 10 bins to put values in

tibble(value = rnorm(100)) %>% #Creates 100 values using normal distribution
  ggplot(aes(x = value)) + #Plots the result
  geom_histogram(bins = 10) #Creates a histogram with 10 bins

tibble(value = rnorm(100000)) %>% #Creates 100000 values
  ggplot(aes(x = value)) + #Plots the result
  geom_histogram(bins = 1000) #Creates a histogram with 1000 bins

tibble(rnorm_5_1 = rnorm(n = 10000, mean = 5, sd = 1), #Creates a tibble with 3 columns of 3 different distributions
       rnorm_0_3 = rnorm(n = 10000, mean = 0, sd = 3),
       rnorm_0_1 = rnorm(n = 10000, mean = 0, sd = 1)) %>%
  pivot_longer(cols = everything(), #Tidies the data to turn the columns into rows because they're observations
               names_to = "distribution",
               values_to = "value") %>%
  ggplot(aes(x = value, fill = distribution)) +  #Has the x be values and the fill be the color
  geom_density(alpha = 0.5) #The fill is slightly transparent

#We can also do operations on these distributions
draws <- rnorm(100, mean = 2, sd = 1)
mean(draws)
sd(draws)
median(draws)
mad(draws)
#However, we won't know the exact distribution that creates our data, so we can use these
#In addition to these values, we may need the quantile
#This is so that we can create intervals which cover portions of the graphs
quantile(draws, probs = c(0.25, 0.75))
quantile(draws, probs = c(0.05, 0.95))
quantile(draws, probs = c(0.025, 0.975))

n <- 100000
tibble(Normal = rnorm(n, mean = 1, sd = 1), #n draws from a normal distribution
       Uniform = runif(n, min = 2, max = 3), #n draws from a uniform distribution
       Combined = Normal + Uniform) %>% #Combines the two values
  pivot_longer(cols = everything(), #Tidy the data to be by distribution and draw
               names_to = "Distribution",
               values_to = "draw") %>%
  ggplot(aes(x = draw, fill = Distribution)) + #Plot the values
  geom_histogram(aes(y = after_stat(count/sum(count))), #Use a histogram with 100 bins, a fill of 0.5, and a percentage
                 alpha = 0.5, 
                 bins = 100,
                 position = "identity") #Everything overlaps, it doesn't do the stacking or whatever

#Runs a 100
games <- 1000
tibble(A_heads = rbinom(n = games, size = 3, prob = 0.5), #Flips 3 coins games times
       B_heads = rbinom(n = games, size = 6, prob = 0.5)) %>% #flips 6 coins games times
  mutate(A_wins = ifelse(A_heads > B_heads, 1, 0)) %>% #Adds a new column that says if A won or not
  summarize(A_chances = mean(A_wins)) #Get the average chance for A to win by taking the average