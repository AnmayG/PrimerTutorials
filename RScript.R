library(gapminder)
library(ggplot2)
library(tidyverse)
p <- ggplot(gapminder %>% filter(continent != "Oceania"), aes(gdpPercap, lifeExp, colour = continent)) +
     geom_point(alpha = 0.7, show.legend = FALSE) +
     scale_size(range = c(2, 12)) +
     scale_x_log10() +
     facet_wrap(~continent, nrow = 1) +
     labs(title = 'Year: {frame_time}', subtitle = 'Life Expectancy and GDP per Capita (1952-2007)', x = 'GDP per capita', y = 'life expectancy') +
     transition_time(year) +
     ease_aes('linear')
anim_save("CoolGIF2.gif")
