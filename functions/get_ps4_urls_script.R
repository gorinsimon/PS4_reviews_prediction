here::i_am("functions/get_ps4_urls_script.R") # Initialize the project root

library(tidyverse)
library(rvest)
library(RSelenium)

# Start RSelenium
rsDriver()

# Start the remote driver
remDr <- remoteDriver(
  remoteServerAddr = "localhost",
  port = 4567L,           # user specific, check the console to find yours
  browserName = "firefox" # user specific
)

# Open the remote driver
remDr$open()

# Navigate to the page of PS4 reviews on IGN.com
remDr$navigate("https://www.ign.com/reviews/games/ps4")

# Scroll down 10000 times (should be enough), waiting for the page to load at each time
for(i in 1:10000){
  remDr$executeScript(paste("scroll(0,",i*10000,");"))
  Sys.sleep(2)
}

# Once the page has been scrolled until the bottom, we can read the html content
ps4_page <- remDr$getPageSource()
ps4_page_html <- read_html(ps4_page[[1]])

# Close the remote driver as we have the html content of the page
remDr$close("https://www.ign.com/reviews/games/ps4")

# Collect the url of all the reviews linked on the page
ps4_games_url <-
  ps4_page_html %>%
  html_elements(".item-body") %>%
  html_attr("href")

# Create a tibble with al the url
ps4_games_info <-
  tibble(
    url = glue::glue("https://www.ign.com{ps4_games_url}"),
  )

# Save the table with the url
write_csv(ps4_games_info, here("data", "ps4_games_url.csv"))