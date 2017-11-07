#!/usr/bin/Rscript

# Load packages.
library(jsonlite)
library(ggplot2)
library(magrittr)
library(dplyr)
library(urltools)

# Import dependencies.
source('iris/plots.R')

# https://github.com/trestletech/plumber/issues/66
#* @filter cors
function(res) {
  res$setHeader('Access-Control-Allow-Origin', '*') # Or whatever
  plumber::forward()
}

# https://www.rplumber.io/docs/rendering-and-output.html#boxed-vs-unboxed-json
# https://www.rplumber.io/docs/rendering-and-output.html#response-object
#* Result:
#* {"status":200,"data":{"message":"Hello World"}}
#* @serializer unboxedJSON
#* @get /
function(){
  status <- 200
  message <- 'Hello World'

  list(
    status = 200,
    data = list(
      message = message
    )
  )
}

#* Plot out data from the iris dataset
#* @serializer contentType list(type='image/png')
#* @post /iris
function(req, res) {
  dataset <- iris
  title <- 'All Species'
  raw <- req$postBody

  str(req$postBody)

  # Filter if the raw was specified.
  if (length(raw) == 0) {
    str('stop now!')
    message <- "Missing params."
    status <- 400 # Bad request

    output <- list(
      status = jsonlite::unbox(status),
      data = list(
        message = jsonlite::unbox(message)
      )
    )

    res$setHeader('Content-type', 'application/json')
    res$status <- status
    res$body <- toJSON(output)
    return(res)
  }

  # Parse the query.
  # https://cran.r-project.org/web/packages/urltools/vignettes/urltools.html
  params <- param_get(
    raw,
    parameter_names = c(
      'plot',
      'species',
      'measurement',
      'grid'
    )
  )
  plot <- params$plot
  species <- params$species
  measurement <- params$measurement
  grid <- params$grid

  # Handle errors.
  # https://www.rplumber.io/docs/rendering-and-output.html#error-handling

  # Filter if the plot was specified.
  if (is.na(plot) || plot == '') {
    str('stop!')
    message <- "Plot is required."
    status <- 400 # Bad request

    output <- list(
      status = jsonlite::unbox(status),
      data = list(
        message = jsonlite::unbox(message)
      )
    )

    res$setHeader('Content-type', 'application/json')
    res$status <- status
    res$body <- toJSON(output)
    return(res)
  }

  # Filter if the species was specified
  if (!is.na(species) && !species == '') {
    title <- paste0("Only the '", species, "' Species")
    dataset <- subset(iris, Species == species)
  }

  # Modify the default png size.
  tmp <- tempfile()
  png(tmp, width = 8, height = 8, units = 'in', res = 100)

  # Render scatter plot
  if (!is.na(plot) && plot == 'scatter') {
    str('scatter!')
    print(plotScatter(dataset, measurement))
  }

  # Render histogram plot
  if (!is.na(plot) && plot == 'histogram') {
    str('histogram!')
    print(plotHistogram(dataset, measurement))
  }

  # Render density plot
  if (!is.na(plot) && plot == 'density') {
    str('density!')
    print(plotDensity(dataset, measurement))
  }

  # Render facet plot
  if (!is.na(plot) && plot == 'facet') {
    str('facet!')
    print(plotFacet(dataset, grid))
  }

  # Vanilla plot for testing.
  # plot(dataset$Sepal.Length, dataset$Petal.Length,
  #   pch=22, bg=c("red","green3","blue"),
  #   main=title, xlab="Sepal Length", ylab="Petal Length")

  dev.off()
  readBin(tmp, "raw", n = file.info(tmp)$size)
}
