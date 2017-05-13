# Required libraries
library(tidyr)
library(dplyr)
library(stringr)

# Load data from CSV into data frame
bloom <- read.csv2("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/bloomingdales-scraped.csv")

## ---------------- DATA CLEANUP  ----------------

# Transpose the table
bloom <- bloom %>%
  gather(product, value, 2:ncol(bloom)) %>%
  spread(X, value)

# Adjust column names
colnames(bloom) <- c("product.id", "type", "name", "color", "material", "price.original", "price.sale", "reviews", "source")

# Clean up 'product id'
bloom$product.id <- as.numeric(str_replace(bloom$product.id, "V", ""))

# Clean up 'reviews'
bloom$reviews <- str_trim(bloom$reviews)

# Convert 'color' and 'material' to list
bloom$color <- str_to_lower(str_replace_all(bloom$color, "(c\\(|\\)|\"| )", ""))
bloom$color <- as.list(strsplit(bloom$color, ","))
bloom$material <- str_replace_all(bloom$material, "(c\\(|\\)|\"| )", "")
bloom$material <- as.list(strsplit(bloom$material, ","))

# Remove observations without 'name'
bloom$name <- str_trim(bloom$name)
bloom <- filter(bloom, !is.na(name))

# Clean up 'type' column and add missing values
bloom$type <- str_replace(bloom$type, "c\\(\"briefs\", \"boxer briefs\"\\)", "boxer briefs")
bloom$type[is.na(bloom$type) & str_detect(str_to_lower(bloom$name), "trunk")] <- "trunks"
bloom$type[is.na(bloom$type) & str_detect(str_to_lower(bloom$name), "boxer brief")] <- "boxer briefs"
bloom$type[is.na(bloom$type) & str_detect(str_to_lower(bloom$name), "brief")] <- "briefs"
bloom <- filter(bloom, !is.na(type))

# Remove observations without 'price'
bloom <- filter(bloom, !is.na(price.original))

## ---------------- CONVERT TO TIDY FORMAT ----------------

bloom_tidy <- bloom %>% 
  gather(key, value, 2:9) %>% 
  unnest(value) %>% 
  filter(!is.na(value))

## ---------------- SAVE FOR FUTURE ANALYSIS  ----------------

write.csv(bloom_tidy, "bloomingdales-tidy.csv", row.names = FALSE)
saveRDS(bloom, "bloomingdales.rds")
