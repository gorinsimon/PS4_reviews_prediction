# Function to collect info on reviews from IGN based on a URL
get_review <- function(url) {
  
  out <- tryCatch(
    {
      
      page <- read_html(url)
      
      game <-
        page %>%
        html_elements(".primary") %>%
        html_elements(".underlined") %>%
        html_text()
      
      author <-
        page %>%
        html_elements(".author-names") %>%
        html_element("a") %>%
        html_text()
      
      review <-
        page %>%
        html_elements(".article-page") %>%
        html_text()
      
      score <-
        page %>%
        html_elements(".article-review-content") %>%
        html_elements(".hexagon-content") %>%
        html_text() %>%
        as.numeric()
      
      date <-
        page %>%
        html_elements(".article-publish-date") %>%
        html_text() %>%
        str_match("\\d\\s[A-Za-z]{3,4}\\s\\d{4}") %>%
        as.character()
      
      review_complete <-
        tibble(
          game = game,
          author = author,
          review = review,
          date = date,
          score = score,
          url = url
          )
      
      return(review_complete)
      
    },
    error = function(e) {
      
      review_complete <-
        tibble(
          game = NA,
          author = NA,
          review = NA,
          date = NA,
          score = NA,
          url = url
        )
      
      return(review_complete)
      
    }
  )
  
  return(out)

}