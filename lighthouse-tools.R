lighthouse = function(url) {
  # Construct the command to run Lighthouse
  tmp = gsub('\\\\', '/', tempfile())
  command <- paste0("lighthouse ", url, " --output=json --output-path=", tmp)

  # Execute the command using the system shell
  system(command)

  # Read the Lighthouse report
  lighthouse_report <- jsonlite::fromJSON(tmp)
  speed.parameters = c('first-contentful-paint', 'first-meaningful-paint', 'largest-contentful-paint', 'speed-index')
  ds = lapply(speed.parameters, \(nm)
     lighthouse_report$audits[[nm]] |> as.data.table() |> head(n = 1)
  ) |>
    rbindlist(fill = TRUE)

  this_url = lighthouse_report$finalUrl

  return(data.table(url = this_url, ds))
}

# threshold ---------------------------------------------------------------

lighthouse.thresholds = read.table(text = "id,colour,low,high
first-contentful-paint,green,0,1.8
first-contentful-paint,orange,1.8,3
first-contentful-paint,red,3,Inf
speed-index,green,0,3.4
speed-index,orange,3.4,5.8
speed-index,red,5.8,Inf
largest-contentful-paint,green,0,2.5
largest-contentful-paint,orange,2.5,4
largest-contentful-paint,red,4,Inf
", header=TRUE, sep=',')
