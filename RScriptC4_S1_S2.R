#' ---
#' title: "Rubin Causal Model Notes"
#' author: "Anmay Gupta"
#' output: html_document
#' ---


#' This chapter is about the Rubin Causal Model  
#' Essentially, when you remove something from a list, we need to find the effect  
library(gt)
library(rmarkdown)
library(tidyverse)

#' <br>
#' Take this data set
#' <br>
tibble(ID = c("Robert", "Andy", "Beau", "Ishan", "Nicolas"),
       Heights = c("178", "?", "172", "173", 165)) %>%
  gt() # Just a way to make tables out of tibbles

#' <br>
#' If I told you to get the average height of all 5 people, you'd need to estimate Andy's height  
#' There are a variety of ways to do this, but the easiest is just taking the average of the other heights  
#' Thing is, that's not really realistic and leaves a lot to be desired
#' Take something more complicated
#' <br>

tibble(ID = c("Student 1", "Student 2", "...", "Student 473", "Student 474",
              "...", "Student 3,258", "Student 3,259", "...", "Student 6,700"),
       Heights = c("?", "?", "...", "172", "?", "...", "?", "162", "...", "?")) %>%
  gt()

#' <br> 
#' There's a bunch of problems here, so the methods that we might try are going to be completely wrong    
#' <br> 

tibble(ID = c("Student 1", "Student 2", "...", "Student 473", "Student 474", 
              "...", "Student 3,258", "Student 3,259", "...", "Student 6,700"),
       Age = c("?", "?", "...", "19", "?", "...", "?", "20", "...", "?"), 
       Sex = c("?", "?", "...", "M", "?", "...", "?", "F", "...", "?"),
       Heights = c("?", "?", "...", "172", "?", "...", "?", "162", "...", "?")) %>%
  gt() %>%
  tab_spanner(label = "Outcome", columns = Heights) %>%
  tab_spanner(label = "Covariates", columns = c(Age, Sex))

#' <br> 
#' However, once we start adding other variables, like covariates, we might be able to predict a little bit better  
#' A 7 year old girl definitely has a lower height than a 27 year old man.  
#' So the Rubin Causal Model measures the amount of change that happens when we change these covariates  
#' If I change the gender to a girl, there is a 4cm change in height  
#' That kind of stuff, but actually standardized and in math format  
#'So take a hypothetical Yao who had a +4 attitude change when he was treated  
#' <br>

tibble(ID = "Yao", ytreat = "13", ycontrol = "9") %>% gt()

#' <br>
#' This is a nicer graph that shows the estimand  
#' The estimand is the variable that you're trying to calculate  
#' <br>

tibble(subject = "Yao",
       ytreat = "13",
       ycontrol = "9",
       ydiff = "+4") %>%
  gt() %>%
  cols_label(subject = md("ID"),
             ytreat = md("Y_t"),
             ycontrol = md("Y_c"),
             ydiff = md("Y_t - Y_c")) %>%
  fmt_markdown(columns = everything()) %>%
  tab_spanner(label = "Outcomes", c(ytreat, ycontrol)) %>%
  tab_spanner(label = "Estimand", ydiff)

#' <br> 
#' This is another table but with more people  
#' <br> 

tibble(subject = c("Yao", "Emma", "Cassidy", "Tahmid", "Diego"),
       ytreat = c("13", "11", "11", "9", "6"),
       ycontrol = c("9", "11", "10", "12", "4"),
       ydiff = c("+4", "0", "+1", "-3", "+2")) %>%
  gt() %>%
  tab_spanner(label = "Outcomes", c(ytreat, ycontrol))  %>%
  tab_spanner(label = "Estimand", c(ydiff))

#' <br>
#' From this, there are a lot of variables that you care about  
#' For example the median estimand, the median percentage change, the average treatment effect, etc  
#' <br>

tibble(subject = c("Yao", "Emma", "Cassidy", "Tahmid", "Diego"),
       ytreat = c("13", "11", "?", "?", "6"),
       ycontrol = c("?", "?", "10", "12", "?"),
       ydiff = c("?", "?", "?", "?", "?")) %>%
  gt() %>%
  tab_spanner(label = "Outcomes", c(ytreat, ycontrol))  %>%
  tab_spanner(label = "Estimand", c(ydiff))

#' <br> 
#' But for something weird like this, it gets a lot more complex  
#' So causal is going forward and counterfactual is going backwards  
#' The main problem is that you have to infer counterfactuals  
#' If I have data on how dogs are better than cats because they bark.  
#' This is a causal. Dogs bark so they are better.  
#' Now, I have to assume that if cats barked they'd be better than dogs  
#' So little kitty can now bark its displeasure at you.   
#' Not exactly the funnest thing. That's what a counterfactual is.  
#' You have to assume that the counterfactual exists.  
#' But we can still mess up and choose the wrong counterfactual.  
#' <br>

#' So let's create a mini experiment. I asked 10000 people what personality they like their pets to have  
#' We do this by bringing in a few cats and a few dogs and having the people play around with them  
#' They then answer a survey about whether they like the personality and how the pet acted  
#' Someone might like a cat that sits in your lap and someone might like a smart dog  
#' So just that kind of thing.  
#' We're trying to see if there's a causal relationship between personality and somebody liking the pet  
#' Now, we have a few variables to talk about  
#' Unit (Indexed by i): The person's review  
#' Treatment variable T_i: Whether the pet's personality was cold and distant or warm and fuzzy (only 2 possibilities)  
#' Treatment group: The pets with a cold personality  
#' Control group: The pets with a warm personality  
#' Outcome variable Y_i: Whether they liked the pet or not  
#' <br>

#' So what does "T_i causes Y_i" mean?  
#' Would a person like a warm personality or a cold personality more?  


#' <!-- In order to render this, use rmarkdown::render("RScriptC4_S1_S2.R") -->

