# Required libraries
library(RCurl)
library(tidyr)
library(dplyr)
library(ggplot2)

# Load data into data frame
bloom <- readRDS(gzcon(url("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/bloomingdales.rds")))
bloom$price.original <- as.double(bloom$price.original)



## ------------------- DATA ANALYSIS -------------------

# Histogram
ggplot(bloom, aes(price.original)) + 
  geom_histogram() + 
  xlab("Price") + ylab("")

# Popular colors (top 15)
u <- bloom %>% 
  select(color) %>% 
  unnest(color) %>% 
  count(color) %>% 
  arrange(n) %>% 
  top_n(15)
u$color <- factor(u$color, levels = unique(u$color))
ggplot(u, aes(u$color, u$n)) + 
  geom_bar(stat = "identity") + 
  coord_flip() + 
  xlab("Color") + ylab("No of Items")

# Color box plots
collapse_color = function(x){
  if (x!="white" && x!="black" && x!="pattern")
    return("solid color")
  else 
    return(x)
}

bloom %>% 
  select(color, price.original) %>% 
  unnest(color) %>% 
  transmute(price = price.original, color = lapply(color, collapse_color)) %>% 
  ggplot(aes(x = as.factor(unlist(color)), y = price)) + 
  geom_boxplot() + geom_point() + 
  xlab("Color") + ylab("Price")

# Material box plots with points
bloom %>% 
  select(material, price.original) %>% 
  unnest(material) %>% 
  filter(!is.na(material)) %>% 
  ggplot(aes(x = as.factor(unlist(material)), y = price.original)) + 
  geom_boxplot() + geom_point() + 
  xlab("Material") + ylab("Price")

# Type box plots with points
bloom %>% 
  select(type, price.original) %>% 
  ggplot(aes(x = as.factor(unlist(type)), y = price.original)) + 
  geom_boxplot() + geom_point() + 
  xlab("Type") + ylab("Price")

# Tile plot of material by type with count
bloom %>% 
  select(material, type) %>% 
  unnest(material) %>% 
  filter(!is.na(material)) %>% 
  count(material, type) %>% 
  ggplot(aes(x = as.factor(material), y = as.factor(type), fill = n)) + 
  geom_tile() + 
  coord_flip() + 
  xlab("Material") + ylab("Type") + 
  scale_fill_continuous(guide = guide_legend(title = "No of Items"))

# Number of colors by price
bloom %>% 
  select(color, price.original) %>% 
  transmute(price = price.original, color.count = lapply(color, length)) %>% 
  ggplot(aes(x = as.factor(unlist(color.count)), y = price)) + 
  geom_boxplot() + geom_point() + 
  xlab("No of Colors Offered") + ylab("Price")

bloomsub <- select(bloom, type, price.original)

#
model <- lm(price.original ~ type, data = bloomsub)
summary(model)
anova(model)

class.mod = data.frame(Fitted = fitted(model),
                       Residuals = resid(model), Treatment = bloomsub$type)


p1 = ggplot(bloomsub, aes(x = type, y = price.original)) +
  geom_boxplot(fill = "grey80", colour = "blue") +
  scale_x_discrete() + xlab("Type") +
  ylab("Price")

p2 = ggplot(class.mod, aes(Fitted, Residuals, colour = Treatment)) + geom_point()
grid.arrange(p1, p2, ncol=2)
