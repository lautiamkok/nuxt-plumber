#!/usr/bin/Rscript

library(plumber)
r <- plumb('app.R')  # Where 'app.R' is the location of the file shown above
r$run(port = 8000)
