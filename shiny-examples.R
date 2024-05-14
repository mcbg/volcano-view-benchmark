library(data.table)

# define examples ------------------------------------------------------------------

setup = CJ(
  dataset = 1:2,
  method = c('plotly', 'ggplotly')
) |>
  rbind(
    data.table(method = 'shiny.empty', dataset=9)
  )

method_index = c('plotly' = 1, 'ggplotly' = 2, 'shiny.empty' = 3)

setup[, port := paste0("90", method_index[method], dataset)]
setup[, url := paste0('http://localhost:', port)]

# export ------------------------------------------------------------------

saveRDS(setup, 'shiny-setup.rds')

