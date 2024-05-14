library(tictoc)
library(data.table)
source('lighthouse-tools.R')

# load --------------------------------------------------------------------
setup = local({
  shiny = readRDS('shiny-setup.rds')
  vw = readRDS('volcano-view-setup.rds')
  list(shiny, vw) |> rbindlist(fill = TRUE)
})

# config ------------------------------------------------------------------

iterations = rep(setup$url, 3)

tic()
report = lapply(iterations, lighthouse) |> rbindlist()
toc()

# processing --------------------------------------------------------------


# plot --------------------------------------------------------------------

report[id !='first-meaningful-paint', .(url, id, displayValue, numericValue)] |>
  ggplot(aes(numericValue / 1000, url)) +
  labs(x='time (seconds)') +
  facet_wrap(~ id) +
    geom_point()  +
  geom_rect(data=th, aes(
    x=low, y=1,
    xmin=low, xmax=high,
    ymin = -Inf, ymax=Inf,
    fill = colour
  ), colour=NA) +
    geom_jitter(width=0) +
  theme_bw() +
  scale_fill_manual(values = c('green' = '#e3ffd4', 'orange'='#ffd7b4','red'='#ffcbcb'))


report[id !='first-meaningful-paint', .(url, id, displayValue, numericValue)] |>
  ggplot(aes(numericValue / 1000, url)) +
  labs(x='time (seconds)') +
  facet_wrap(~ id) +
  geom_point()  +
  geom_rect(data=th, aes(
    x=low, y=1,
    xmin=low, xmax=high,
    ymin = -Inf, ymax=Inf,
    fill = colour
  ), colour=NA) +
  geom_jitter(width=0) +
  theme_bw() +
  scale_fill_manual(values = c('green' = '#e3ffd4', 'orange'='#ffd7b4','red'='#ffcbcb'))
