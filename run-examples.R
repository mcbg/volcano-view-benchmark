library(data.table)

run_in_bg = function(script) {
  tmp = tempfile()
  writeLines(script, tmp)
  rstudioapi::jobRunScript(tmp, workingDir = getwd())
  script
}

# run volcano.view examples ------------------------------------------------------------

run_in_bg("volcano.view::serve_static('volcano-view-examples')")

# run shiny examples ------------------------------------------------------------
# load
setup.shiny = readRDS('shiny-setup.rds') |> data.table()

method_function = c(
  'plotly' = 'shiny.example.plotly() |>',
  'ggplotly' = 'shiny.example.ggplot() |>',
  'shiny.empty' = 'shiny.empty() |>'
)

# run
setup.shiny[, {
  FUN.line = method_function[[method]]
  ds.line = ifelse(dataset == 9, '', paste0("datasets[[", dataset, "]] |> "))
  port.line = paste0("  runApp(port = ", port, ")")
  script = c(
    "source('benchmark-setup.R'); ",
    ds.line,
    FUN.line,
    port.line
  )
  run_in_bg(script)
}, by = seq_len(nrow(setup.shiny))]
