library(jsonlite)

url = "https://fantasy.premierleague.com/api/bootstrap-static"

data <- fromJSON(url)
data$elements

players <- data$elements
fpl_data <- data.frame(
  name = paste(players$first_name, players$second_name),
  price = players$now_cost / 10,
  points = players$total_points,
  clean_sheets = players$clean_sheets,
  position = players$element_type
)

