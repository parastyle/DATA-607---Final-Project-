# Required libraries
library(tidyr)
library(dplyr)
library(stringr)
library(grid)
library(RCurl)
library(gridExtra)
library(ggplot2)

##----------------------LOAD ALL DATA: BLOOMINGDALES, NORDSTROM, CK AND BUREAU OF LABOR STATISTICS (BLS)---------------
# Load data into data frame

##--- BLOOMINGDALES
bloom <- readRDS(gzcon(url("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/bloomingdales.rds")))
bloom$price.original <- as.double(bloom$price.original)

##--- NORDSTROM
nord <- readRDS(gzcon(url("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/nord.rds")))
nord <- nord[,1:9]
nord$price.original <- as.double(nord$price.original)

##--- CK
ck <- readRDS(gzcon(url("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/ck.rds")))
ck$price.original <- as.double(ck$price.original)

##--- BLS

char_data <- read.csv("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/Consumer%20Survey%20(BLS)/Buying200.csv", stringsAsFactors = F,na.strings=c("NA", "NULL"))
num_data <- data.frame(data.matrix(char_data))
numeric_columns <- sapply(num_data,function(x){mean(as.numeric(is.na(x)))<0.5})
df1 <- data.frame(num_data[,numeric_columns], char_data[,!numeric_columns])

char_data <- read.csv("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/Consumer%20Survey%20(BLS)/BuyingIncClass.csv", stringsAsFactors = F, na.strings=c("NA", "NULL"))
num_data <- data.frame(data.matrix(char_data))
numeric_columns <- sapply(num_data,function(x){mean(as.numeric(is.na(x)))<0.5})
df2 <- data.frame(num_data[,numeric_columns], char_data[,!numeric_columns])

char_data <- read.csv("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/Consumer%20Survey%20(BLS)/classes.csv", stringsAsFactors = F, na.strings=c("NA", "NULL"))
num_data <- data.frame(data.matrix(char_data))
numeric_columns <- sapply(num_data,function(x){mean(as.numeric(is.na(x)))<0.5})
df3 <- data.frame(num_data[,numeric_columns], char_data[,!numeric_columns])

#modify Df2 and Df3 to have same headers
colnames(df3) <- c("INCLASS", "Description")
df23 <- select(left_join(df2, df3, by = "INCLASS"), NEWID, Description)
all <- select(left_join(df1, df23, by = "NEWID"), NEWID, ALCNO, CLOTHMOA, CLOTHXA, Description)

#filter incomplete cases
all <- data.frame(
  NEWID = as.character(all[,1]),
  ALCNO = as.numeric(all[,2]),
  CLOTHMOA = as.numeric(all[,3]),
  CLOTHXA = as.numeric(all[,4]),
  Description = as.character(all[,5])
)

all <- filter(all, is.na(all[,5])==FALSE)
all <- filter(all, is.na(all[,4])==FALSE)

## ------------------- DATA ANALYSIS -------------------

## Combine Bloomingdales, Nordstrom and CK into one table

BNC <- rbind(bloom, nord, ck)

## Average price per underwear type
BNC %>% group_by(type) %>% summarise(avg = mean(price.original))

# Histogram
h<-ggplot(BNC, aes(price.original, fill=..count.., ..count..)) + geom_histogram(bins=20)
p2 = h+facet_grid(. ~type) + xlab("Price") + ylab("")

i<-ggplot(BNC, aes(price.original, fill=..count.., ..count..)) + geom_histogram(bins=20) + xlab("Price") + ylab("")

grid.arrange(i,p2,ncol=1)
  
## Testing for Normalcy on price
qqnorm(BNC$price.original)
qqline(BNC$price.original, col=2)


# Histogram
z<-ggplot(all, aes(CLOTHXA, fill=..count.., ..count..)) + geom_histogram(bins=20)
z2 = z+facet_grid(. ~Description) + xlab("Spend") + ylab("")

zi<-ggplot(all, aes(CLOTHXA, fill=..count.., ..count..)) + geom_histogram(bins=20) + xlab("Spend") + ylab("")

grid.arrange(zi,z2,ncol=1)

## Testing for normalcy on BLS data by spend
qqnorm(all$CLOTHXA)
qqline(all$CLOTHXA, col=2)

# Color box plots for BNC
collapse_color = function(x){
  if (x!="white" && x!="black" && x!="pattern")
    return("solid color")
  else 
    return(x)
}

l1 <- BNC %>% 
  select(color, price.original) %>% 
  unnest(color) %>% 
  transmute(price = price.original, color = lapply(color, collapse_color)) %>% 
  ggplot(aes(x = as.factor(unlist(color)), y = price)) + 
  geom_boxplot() + geom_point() +
  xlab("Color") + ylab("Price")

l2<- BNC %>% 
  select(type, price.original) %>% 
  unnest(type)  %>% 
  ggplot(aes(x = as.factor(unlist(type)), y = price.original)) + 
  geom_boxplot() + geom_point() +
  xlab("Type") + ylab("Price")

grid.arrange(l1,l2,ncol=2)

##--- Statistical Test #1, Is there a difference in pricing between types of underwear?  
BNCsub <- select(BNC, type, price.original)

#
model <- lm(price.original ~ type, data = BNCsub)
summary(model)
anova(model)

class.mod = data.frame(Fitted = fitted(model),
                       Residuals = resid(model), type = BNCsub$type)


p1 = ggplot(BNCsub, aes(x = type, y = price.original, colour = type)) +
  geom_boxplot(fill = "grey80") +
  scale_x_discrete() + xlab("Type") +
  ylab("Price")

p2 = ggplot(class.mod, aes(Fitted, Residuals, colour = type)) + geom_point()
grid.arrange(p1, p2, ncol=2)

## no there is no pricing difference, so they can price accordingly

#linear regression and testing ANOVA to see if different groups have different buying paterns
model2 <- lm(CLOTHXA ~ Description, data = all)
summary(model2)
anova(model2)

#From the model we can see that athere is a difference between the income group,  target marketing to higher income brackets. 

class.mod2 = data.frame(Fitted = fitted(model2),
                       Residuals = resid(model2), IncomeClass = all$Description)


#plotting data
m1 = ggplot(all, aes(x = Description, y = CLOTHXA, colour = Description)) +
  geom_boxplot(fill = "grey80") +
  scale_x_discrete() + xlab("Income Class") +
  ylab("Spend")

m2 = ggplot(class.mod2, aes(Fitted, Residuals, colour = IncomeClass)) + geom_point()
grid.arrange(m1, m2, ncol=2)


