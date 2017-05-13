# Required libraries
library(tidyr)
library(dplyr)
library(stringr)

# Load data from CSV into data frame
ck <- read.csv2("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/ckboxerbriefsResults.csv")

## ---------------- DATA CLEANUP  ----------------

# Transpose the table
ck <- ck %>%
  gather(product, value, 2:ncol(ck)) %>%
  spread(X, value)

# Adjust column names
colnames(ck) <- c("product.id", "type", "name", "color", "material", "price.original", "price.sale", "reviews", "source")

# Clean up 'product id'
ck$product.id <- as.numeric(str_replace(ck$product.id, "V", ""))
ck$product.id <- ck$product.id + 1000

# Clean up 'reviews'
ck$reviews <- str_trim(ck$reviews)

# Convert 'color' and 'material' to list
ck$color <- str_to_lower(str_replace_all(ck$color, "(c\\(|\\)|\"| )", ""))
ck$color <- as.list(strsplit(ck$color, ","))
ck$material <- str_replace_all(ck$material, "(c\\(|\\)|\"| )", "")
ck$material <- as.list(strsplit(ck$material, ","))

# Remove observations without 'name'
ck$name <- str_trim(ck$name)
ck <- filter(ck, !is.na(name))

# Clean up 'type' column and add missing values
ck$type <- "boxer briefs"

# Remove observations without 'price'
ck <- filter(ck, !is.na(price.original))

## ---------------- SAVE AND REPEAT FOR TWO OTHER TYPES ----------------

ck_main <- ck

# Handle CK Briefs
ck <- read.csv2("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/ckbriefsResults.csv")
ck <- ck %>%
  gather(product, value, 2:ncol(ck)) %>%
  spread(X, value)
colnames(ck) <- c("product.id", "type", "name", "color", "material", "price.original", "price.sale", "reviews", "source")
ck$product.id <- as.numeric(str_replace(ck$product.id, "V", ""))
ck$product.id <- ck$product.id + 2000
ck$reviews <- str_trim(ck$reviews)
ck$color <- str_to_lower(str_replace_all(ck$color, "(c\\(|\\)|\"| )", ""))
ck$color <- as.list(strsplit(ck$color, ","))
ck$material <- str_replace_all(ck$material, "(c\\(|\\)|\"| )", "")
ck$material <- as.list(strsplit(ck$material, ","))
ck$name <- str_trim(ck$name)
ck <- filter(ck, !is.na(name))
ck$type <- "briefs"
ck <- filter(ck, !is.na(price.original))

ck_main <- rbind(ck_main, ck)

# Handle CK Trunks
ck <- read.csv2("https://raw.githubusercontent.com/parastyle/DATA-607---Final-Project-/master/Data/ckTrunksResults.csv")
ck <- ck %>%
  gather(product, value, 2:ncol(ck)) %>%
  spread(X, value)
colnames(ck) <- c("product.id", "type", "name", "color", "material", "price.original", "price.sale", "reviews", "source")
ck$product.id <- as.numeric(str_replace(ck$product.id, "V", ""))
ck$product.id <- ck$product.id + 3000
ck$reviews <- str_trim(ck$reviews)
ck$color <- str_to_lower(str_replace_all(ck$color, "(c\\(|\\)|\"| )", ""))
ck$color <- as.list(strsplit(ck$color, ","))
ck$material <- str_replace_all(ck$material, "(c\\(|\\)|\"| )", "")
ck$material <- as.list(strsplit(ck$material, ","))
ck$name <- str_trim(ck$name)
ck <- filter(ck, !is.na(name))
ck$type <- "trunks"
ck <- filter(ck, !is.na(price.original))

ck_main <- rbind(ck_main, ck)

## ---------------- CONVERT TO TIDY FORMAT ----------------

ck_tidy <- ck_main %>% 
  gather(key, value, 2:9) %>% 
  unnest(value) %>% 
  filter(!is.na(value))

## ---------------- SAVE FOR FUTURE ANALYSIS  ----------------

write.csv(ck_tidy, "ck-tidy.csv", row.names = FALSE)
saveRDS(ck_main, "ck.rds")
