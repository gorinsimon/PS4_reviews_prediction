here::i_am("functions/get_reviews_script.R") # Initialize the project root

library(tidyverse)
library(rvest)
library(here)

# Function to collect info on reviews from IGN based on a URL
source(here("functions", "get_review.R"))

# Collect all the link of video game reviews on the page referenced below
link_reviews <- read_csv(here("data", "ps4_games_url.csv"))

safe_get_review <- safely(get_review)

# Collect the reviews from all pages referenced in 'link_reviews'
all_reviews <-
  map_df(link_reviews$url, get_review) %>%
  distinct()

write_csv(all_reviews, here("data", "ps4_reviews.csv"))