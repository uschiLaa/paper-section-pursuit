# neighbourhood traces
# for dataset d, starting projection start we calculate the slice index
# when moving along n randomly selected geodesic paths up to pi/2 away from start
# h defines slice thickness
# the results also store the random seed used to generate the random direction,
# so that we can reproduce interesting paths
getNeighbourhoodTrace <- function(d, index, start, h, n){

  # initialise results storage
  res <- tibble::tibble(n = numeric(), alpha = numeric(), value = numeric(), s = numeric())

  # loop over path and index functions
  i <- 1
  seeds <- sample(1:999999999, n)
  alphas <- sort(c(seq(-pi/2, pi/2, length.out = 50), 0))
  while (i <= n){
    s <- seeds[i]
    set.seed(s)
    new <- tourr::basis_random(ncol(d))
    interpolator <- tourr:::geodesic_info(start, new)
    index_pos <- function(alpha){
      p <- tourr:::step_angle(interpolator, alpha)
      dist_data <- tourr:::anchored_orthogonal_distance(p, d)
      index(as.matrix(d) %*% p, dist_data, h)
    }
    for (a in alphas) {
      res <- dplyr::add_row(res, n = i, alpha = a, value = index_pos(alpha), s = s)
    }
    i <- i+1
  }
  res
}

# Plot the neighbourhood traces
plotNeighbourhoodTrace <- function(res, rescY=TRUE){
  resMelt <- tibble::as_tibble(res) %>%
    ggplot2::ggplot(ggplot2::aes(x=alpha, y=value, group=factor(n))) +
    ggplot2::geom_line(alpha=0.1) +
    ggplot2::geom_vline(xintercept = 0, color="black") +
    ggplot2::theme(legend.position="none") +
    ggplot2::xlab(latex2exp::TeX("$\\alpha$")) +
    ggplot2::theme_bw() +
    ggplot2::ylab("PPI value")
  if (rescY) {
    resMelt <- resMelt +
      ggplot2::ylim(c(0,1)) # usually we want index values between 0 and 1
  }
  resMelt
}
