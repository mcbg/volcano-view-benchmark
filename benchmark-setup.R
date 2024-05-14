library(shiny); library(data.table); library(plotly)


# generate data --------------------------------------------------------

gen_ds <- function(n) {
  set.seed(123)
  data.table(
    id = seq_len(n) |> as.character(),
    x = rnorm(n),
    y = rnorm(n)
  )
}

datasets = list(
  gen_ds(100),
  gen_ds(7000),
  gen_ds(10000)
)

# define shiny dashboards -------------------------------------------------

shiny.example.plotly = function(ds) {
  ui = \() {
    fluidPage(
      plotlyOutput('plot')
    )
  }
  server = \(input, output) {
    output$plot = renderPlotly(
      plot_ly(
        ds,
        x = ~x,
        y = ~y
      )
    )
  }
  shinyApp(ui, server)
}

shiny.example.ggplot = function(ds) {
  ui = \() {
    fluidPage(
      plotlyOutput('plot')
    )
  }
  server = \(input, output) {
    output$plot = renderPlotly({
      ggplotly(
        ggplot(ds, aes(x, y)) +
          geom_point()
      )
    })
  }
  shinyApp(ui, server)
}

shiny.empty = function() {
  ui = \() {
    fluidPage('test')
  }
  server = \(input, output) { }
  shinyApp(ui, server)
}
