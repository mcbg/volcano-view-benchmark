library(data.table)
library(volcano.view)
library(glue)

source('benchmark-setup.R')


# define setup ------------------------------------------------------------

setup = data.table(dataset = 1:3, method = c('volcano.view'))
setup[, url := paste0('http://localhost:8998/example-', dataset, '.html')]

# export ------------------------------------------------------------------

saveRDS(setup, 'volcano-view-setup.rds')

gen.vw.json = function(dataset) {
  fn = glue('volcano-view-examples/example-{dataset}.json')
  message(nrow(datasets[[dataset]]))
  volcano.view(
    datasets[[dataset]],
    x='x', y='y', id='id'
  ) |>
    write.json(fn)
}

# write json --------------------------------------------------------------

sapply(setup$dataset, gen.vw.json)

# populate
populate.dashboard('volcano-view-examples')
