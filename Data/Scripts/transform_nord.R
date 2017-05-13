# Required libraries
library(tidyr)
library(dplyr)
library(stringr)

# Load data from CSV into data frame
nord1 <- read.csv2("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/nordstromResults1.csv")
nord2 <- read.csv2("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/nordstromResults2.csv")
nord3 <- read.csv2("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/nordstromResults3.csv")



## ---------------- DATA CLEANUP  ----------------

# Transpose the table
nord1 <- nord1 %>%
  gather(product, value, 2:ncol(nord1)) %>%
  spread(X, value)

nord2 <- nord2 %>%
  gather(product, value, 2:ncol(nord2)) %>%
  spread(X, value)

nord3 <- nord3 %>%
  gather(product, value, 2:ncol(nord3)) %>%
  spread(X, value)

##----- bind tables --
nord <- rbind(nord1, nord2, nord3)

# Adjust column names
colnames(nord) <- c("product.id", "type", "name", "color", "material", "price.original", "price.sale", "reviews", "source", "brand")

# Clean up 'product id'
nord$product.id <- as.numeric(str_replace(nord$product.id, "V", ""))

# Clean up 'reviews'
nord$reviews <- str_trim(nord$reviews)

# Convert 'color' and 'material' to list
nord$color <- str_to_lower(str_replace_all(nord$color, "(c\\(|\\)|\"| )", ""))
nord$color <- as.list(strsplit(nord$color, ","))
nord$material <- str_replace_all(nord$material, "(c\\(|\\)|\"| )", "")
nord$material <- as.list(strsplit(nord$material, ","))

# Remove observations without 'name'
nord$name <- str_trim(nord$name)
nord <- filter(nord, !is.na(name))

# Clean up 'type' column and add missing values
nord$type <- str_replace(nord$type, "c\\(\"briefs\", \"boxer briefs\"\\)", "boxer briefs")
nord$type[is.na(nord$type) & str_detect(str_to_lower(nord$name), "trunk")] <- "trunks"
nord$type[is.na(nord$type) & str_detect(str_to_lower(nord$name), "boxer brief")] <- "boxer briefs"
nord$type[is.na(nord$type) & str_detect(str_to_lower(nord$name), "brief")] <- "briefs"
nord <- filter(nord, !is.na(type))

# Remove observations without 'price'
nord <- filter(nord, !is.na(price.original))

## ---------------- CONVERT TO TIDY FORMAT ----------------

nord_tidy <- nord %>% 
  gather(key, value, 2:10) %>% 
  unnest(value) %>% 
  filter(!is.na(value))

## ---------------- SAVE FOR FUTURE ANALYSIS  ----------------

write.csv(nord_tidy, "nord-tidy.csv", row.names = FALSE)
saveRDS(nord, "nord.rds")
