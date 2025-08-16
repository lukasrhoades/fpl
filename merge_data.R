library(tidyverse)
source("import_player_data.R")
source("import_fpl_data.R")

complete_data <- left_join(player_stats, fpl_data, by = join_by(player == name)) |> 
  mutate_at(
    names(player_stats[-c(2:5)]),
    as.numeric
  ) |> 
  select(!matches) |> 
  filter(playing_time_90s > 18) |> 
  rename(
    goals = per_90_minutes_gls,
    xg = per_90_minutes_x_g,
    assists = per_90_minutes_ast,
    xa = per_90_minutes_g_a,
    mins = playing_time_90s
  ) |> 
  mutate(
    clean_sheets = clean_sheets / mins,
    clinical = goals / xg,
    support = assists / xa,
    yc = performance_crd_y / mins
  ) |> 
  select(c(player, position, price, points, clean_sheets, goals, xg, assists, xa, mins, clinical, support, yc))

gk <- complete_data |> 
  filter(position == 1) |> 
  select(!c(position, clinical, support)) |> 
  mutate(score = (((((4 * (clean_sheets) - yc) / 5 ) * (points / mean(points)) / price)))) |> 
  relocate(score, .after = player) |> 
  arrange(desc(score))

def <- complete_data |> 
  filter(position == 2)|> 
  select(!c(position, clinical, support)) |> 
  mutate(
    score = (((((6 * goals) + (3 * assists) + (4 * clean_sheets)) / 13) * (points / mean(points))) / price)
  ) |> 
  relocate(score, .after = player) |> 
  arrange(desc(score))
  
mid <- complete_data |> 
  filter(position == 3) |> 
  select(!c(position, clean_sheets)) |> 
  mutate(
    score = (((((5 * goals * (0.25 * clinical)) + (3 * assists * (0.5 * support))) / 8) * (points / mean(points))) / price)
  ) |> 
  relocate(score, .after = player) |> 
  arrange(desc(score))

fwd <- complete_data |> 
  filter(position == 4) |> 
  select(!c(position, clean_sheets)) |> 
  mutate(
    score = (((((4 * goals * (0.5 * clinical)) + (3 * assists * (0.25 * support))) / 7) * (points / mean(points))) / price)
  ) |> 
  relocate(score, .after = player) |> 
  arrange(desc(score))

