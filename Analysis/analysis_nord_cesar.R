# Required libraries
library(RCurl)
library(tidyr)
library(dplyr)
library(ggplot2)

# Load data into data frame
##setwd("/Users/cesarespitia/Google Drive/CUNYMSDA/Data 607/CUNYDATA607/FinalProject/DATA-607---Final-Project-/Data")
##nord<- readRDS("nord.rds")
nord <- readRDS(gzcon(url("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/nord.rds")))
nord$price.original <- as.double(nord$price.original)



## ------------------- DATA ANALYSIS -------------------

# Histogram
ggplot(nord, aes(price.original)) + 
  geom_histogram() + 
  xlab("Price") + ylab("")

# Popular colors (top 15)
u <- nord %>% 
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

nord %>% 
  select(color, price.original) %>% 
  unnest(color) %>% 
  transmute(price = price.original, color = lapply(color, collapse_color)) %>% 
  ggplot(aes(x = as.factor(unlist(color)), y = price)) + 
  geom_boxplot() + geom_point() + 
  xlab("Color") + ylab("Price")

# Material box plots with points
nord %>% 
  select(material, price.original) %>% 
  unnest(material) %>% 
  filter(!is.na(material)) %>% 
  ggplot(aes(x = as.factor(unlist(material)), y = price.original)) + 
  geom_boxplot() + geom_point() + 
  xlab("Material") + ylab("Price")

# Type box plots with points
nord %>% 
  select(type, price.original) %>% 
  ggplot(aes(x = as.factor(unlist(type)), y = price.original)) + 
  geom_boxplot() + geom_point() + 
  xlab("Type") + ylab("Price")

# Tile plot of material by type with count
nord %>% 
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
nord %>% 
  select(color, price.original) %>% 
  transmute(price = price.original, color.count = lapply(color, length)) %>% 
  ggplot(aes(x = as.factor(unlist(color.count)), y = price)) + 
  geom_boxplot() + geom_point() + 
  xlab("No of Colors Offered") + ylab("Price")

nordsub <- select(nord, type, price.original)

#
model <- lm(price.original ~ type, data = nordsub)
summary(model)
anova(model)

class.mod = data.frame(Fitted = fitted(model),
                       Residuals = resid(model), type = nordsub$type)


p1 = ggplot(nordsub, aes(x = type, y = price.original, colour = type)) +
  geom_boxplot(fill = "grey80") +
  scale_x_discrete() + xlab("Type") +
  ylab("Price")

p2 = ggplot(class.mod, aes(Fitted, Residuals, colour = type)) + geom_point()
grid.arrange(p1, p2, ncol=2)
