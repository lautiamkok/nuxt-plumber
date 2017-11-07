#!/usr/bin/Rscript

# http://ggplot2.tidyverse.org/reference/geom_point.html
plotScatter <- function(data, measurement) {

  # Compare both - sepal and petal.
  measurement.length <- data$Petal.Length
  measurement.width <- data$Sepal.Width

  # Overwrite the default if 'petal only' selected.
  if (!is.na(measurement) && measurement == 'petal') {
    measurement.length <- data$Petal.Length
    measurement.width <- data$Petal.Width
  }

  # Overwrite the default if 'sepal only' selected.
  if (!is.na(measurement) && measurement == 'sepal') {
    measurement.length <- data$Sepal.Length
    measurement.width <- data$Sepal.Width
  }

  # Create an empty array.
  xlabel <- c()
  ylabel <- c()
  ggtitle <- c()

  # Append/ push an item into the vector.
  if (!is.na(measurement) && measurement == 'petal') {
    xlabel <- append(xlabel, 'Petal')
    ylabel <- append(ylabel, 'Petal')
  } else if (!is.na(measurement) && measurement == 'sepal') {
    xlabel <- append(xlabel, 'Sepal')
    ylabel <- append(ylabel, 'Sepal')
  } else {
    xlabel <- append(xlabel, 'Petal')
    ylabel <- append(ylabel, 'Sepal')
  }
  # Join array items.
  xlabel <- paste(xlabel, 'Length', collapse = '')
  ylabel <- paste(ylabel, 'Width', collapse = '')
  ggtitle <- paste(xlabel, 'Vs', ylabel, collapse = '')

  # Create a group-means data set
  sum <- data %>%
          group_by(Species) %>%
          summarise(measurement.length = mean(measurement.length),
                    measurement.width  = mean(measurement.width))

  scatter <- ggplot(data = data, aes(x = measurement.length, y = measurement.width, color = Species))
  scatter +

    # Fade out the observation-level geom layer (using alpha)
    geom_point(alpha = 0.6, aes(shape = Species)) +

    # Add another layer and increase the size of the group means:
    # geom_point(data = sum, size = 4, aes(shape = Species)) +

    # To set the symbols manually, we can use the symbol codes in
    # scale_shape_manual() added to your print function.
    scale_shape_manual(values = c(0, 16, 3)) +

    # Polish the plot labels and titles.
    xlab(xlabel) +
    ylab(ylabel) +
    ggtitle(ggtitle)
}

# http://ggplot2.tidyverse.org/reference/geom_histogram.html
plotHistogram <- function(data, measurement) {

  # Petal.
  if (!is.na(measurement) && measurement == 'petal.width') {
    measurement <- data$Petal.Width
    xlabel <- 'Petal Width'
  }
  if (!is.na(measurement) && measurement == 'petal.length') {
    measurement <- data$Petal.Length
    xlabel <- 'Petal Length'
  }

  # Sepal.
  if (!is.na(measurement) && measurement == 'sepal.width') {
    measurement <- data$Sepal.Width
    xlabel <- 'Sepal Width'
  }
  if (!is.na(measurement) && measurement == 'sepal.length') {
    measurement <- data$Sepal.Length
    xlabel <- 'Sepal Length'
  }
  ggtitle <- paste('Histogram', 'for', xlabel, collapse = '')

  histogram <- ggplot(data = data, aes(measurement, fill = Species))
  histogram +
    geom_histogram(bins = 30, binwidth = 0.05) +

    # Polish the plot labels and titles.
    xlab(xlabel) +
    ylab('Count') +
    ggtitle(ggtitle)
}

# http://ggplot2.tidyverse.org/reference/geom_density.html
plotDensity <- function(data, measurement) {
  # Petal.
  if (!is.na(measurement) && measurement == 'petal.width') {
    measurement <- data$Petal.Width
    xlabel <- 'Petal Width'
  }
  if (!is.na(measurement) && measurement == 'petal.length') {
    measurement <- data$Petal.Length
    xlabel <- 'Petal Length'
  }

  # Sepal.
  if (!is.na(measurement) && measurement == 'sepal.width') {
    measurement <- data$Sepal.Width
    xlabel <- 'Sepal Width'
  }
  if (!is.na(measurement) && measurement == 'sepal.length') {
    measurement <- data$Sepal.Length
    xlabel <- 'Sepal Length'
  }
  ggtitle <- paste('Density Curve', 'of', xlabel, collapse = '')

  density2 <- ggplot(data = data, aes(x = measurement, fill = Species, colour = Species))
  density2 +
    geom_density(alpha = 0.1) +

    # Polish the plot labels and titles.
    xlab(xlabel) +
    ylab('Density') +
    ggtitle(ggtitle)
}

# http://ggplot2.tidyverse.org/reference/geom_smooth.html
# http://ggplot2.tidyverse.org/reference/facet_grid.html
plotFacet <- function(data, grid) {
  facet <- ggplot(data = data, aes(Sepal.Length, y = Sepal.Width, color = Species)) +
    geom_point(aes(shape = Species), size = 1.5) +

    # Polish the plot labels and titles.
    geom_smooth(method = 'lm') +
    xlab('Sepal Length') +
    ylab('Sepal Width') +
    ggtitle('Faceting')

  if (!is.na(grid) && grid == 'rows') {
    # Along rows
    facet + facet_grid(. ~ Species)
  } else {
    # Along columns
    facet + facet_grid(Species ~ .)
  }
}
