library(rvest)
library(stringr)

url <- "https://fbref.com/en/comps/9/2024-2025/stats/2024-2025-Premier-League-Stats"

text <- readLines(url, warn = FALSE) |> 
  paste(collapse = "\n")
cleaned <- str_replace_all(text, "<!--", "") |> 
  str_replace_all("--!>", "")
html <- read_html(cleaned)

table <- html |> 
  html_element("#stats_standard") |> 
  html_table(header = FALSE)
player_stats <- table

var_names <- c()
for (col in names(player_stats)) {
  var_name <- paste(player_stats[1, col], player_stats[2, col])
  var_names <- append(var_names, var_name)
}
names(player_stats) <- var_names
player_stats <- player_stats[-1:-2,]
player_stats <- janitor::clean_names(player_stats)




