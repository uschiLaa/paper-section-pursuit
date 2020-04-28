library(tidyverse)

# bin all points, separating inside and outside the slice of thickness h
# need to provide breaks because we want this to be fixed (should not change for
# each new projection)
# NOTE: we always center the columns of mat before binning!
# two types of binning are implemented:
# square binning: cutting along x and y axis
# polar binning: cut in radial and angular bins, in this case
# breaks_x should be radial breaks, breaks_y should be angular breaks (in  radians)
# results will have NA entries if points outside the defined breaks are found in mat
slice_binning <- function(mat, dists, h, breaks_x, breaks_y, bintype="square"){
  
  # names and centering
  colnames(mat) <- c("x","y")
  mat <- apply(mat, 2, function(x) (x-mean(x)))
  mat <- as_tibble(mat)
  
  if (bintype == "square") {
    mat$xbin <- cut(mat$x, breaks_x)
    mat$ybin <- cut(mat$y, breaks_y)
  } 
  else if (bintype == "polar") {
    rad <- sqrt(mat$x^2+mat$y^2)
    ang <- atan2(mat$y, mat$x)
    mat$xbin <- cut(rad, breaks_x)
    mat$ybin <- cut(ang, breaks_y)
  }
  else {
    cat(bintype, " is not a recognised bin type\n")
    return(0)
  }
  
  # track which points are inside the current slice
  mat$inSlice <- factor(if_else(dists > h, 0, 1))
  
  # return binned data
  mat %>%
    count(xbin, ybin, inSlice, .drop=FALSE) %>%
    dplyr::filter(!is.na(xbin))
}

# utility function to find n radial breaks such that a p-dim uniform ball
# will have similar number of points in each bin of the 2D projection
radial_breaks <- function(n, p, R){
  break_points_f <- seq(0, 1, length.out = n+1)
  break_points_r <- sqrt(1 - (1-break_points_f)^(2/p)) * R
  break_points_r
}

# utility, n equidistant bins between -pi and pi
angular_breaks <- function(n){
  seq(-pi, pi, length.out = n+1)
}

# utility, n equidistant bins between a and b
linear_breaks <- function(n, a, b){
  seq(a, b, length.out = n+1)
}

# calculate relative binwise difference between inside and outside slice binned data
# relative means that the bin count is normalised to the total number of points
# in the inside and outside histogram respectively
# as input provide result from slice_binning
# keeping positive relative difference for both inside - outside (rel_diff_in)
# and outside - inside (rel_diff_out)
binwise_diff <- function(binned_data, invert=FALSE){
  binned_data <- pivot_wider(binned_data, id_cols = c(xbin, ybin),
                             names_from = inSlice, values_from = n) %>%
    rename(outside=`0`) %>%
    rename(inside=`1`)
  tot_in <- sum(binned_data$inside)
  tot_out <- sum(binned_data$outside)
  rel_diff_in <- - (binned_data$outside / tot_out) + (binned_data$inside / tot_in)
  rel_diff_out <- (binned_data$outside / tot_out) - (binned_data$inside / tot_in)
  rel_diff_in_2 <- - sqrt(binned_data$outside / tot_out) + sqrt(binned_data$inside / tot_in)
  rel_diff_out_2 <- sqrt(binned_data$outside / tot_out) - sqrt(binned_data$inside / tot_in)
  add_column(binned_data,
             rel_diff_in = pmax(rel_diff_in, 0),
             rel_diff_out = pmax(rel_diff_out, 0),
             rel_diff_in_2 = pmax(rel_diff_in_2, 0),
             rel_diff_out_2 = pmax(rel_diff_out_2, 0))
}

# building a big tibble that holds coordinates to draw the polar histogram
# as a ggplot polygon
# use e.g. as
# out <- polar_plotting(binned_data)
# ggplot(out, aes(x, y)) +
#   geom_polygon(aes(fill = outside, group = factor(id))) +
#   theme(aspect.ratio=1, legend.position="none", axis.text = element_blank())
polar_plotting <- function(binned_data, n=60){
  resMat <- matrix(ncol = 9, nrow = 0)
  for (i in 1:nrow(binned_data)){
    # first extract the bin boundaries, x is radius, y is angle
    x1 <- as.numeric( sub("\\((.+),.*", "\\1", binned_data$xbin[[i]]))
    x2 <- as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", binned_data$xbin[[i]]))
    y1 <- as.numeric( sub("\\((.+),.*", "\\1", binned_data$ybin[[i]]))
    y2 <- as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", binned_data$ybin[[i]]))
    
    alpha <- seq(y1, y2, length.out = n)
    theta <- c(alpha, rev(alpha), alpha[0])
    
    r <- c(rep(x1, n), rep(x2, n))
    
    x <- cos(theta) * r
    y <- sin(theta) * r
    
    res <- matrix(c(x, y, rep(binned_data$outside[[i]],2*n),
                    rep(binned_data$inside[[i]],2*n),
                    rep(binned_data$rel_diff_out[[i]],2*n),
                    rep(binned_data$rel_diff_in[[i]],2*n),
                    rep(binned_data$rel_diff_out_2[[i]],2*n),
                    rep(binned_data$rel_diff_in_2[[i]],2*n),
                    rep(i, 2*n)), ncol=9)

    resMat <- rbind(resMat, res)
  }
  colnames(resMat) <- c("x", "y", "outside", "inside",
                        "rel_diff_out", "rel_diff_in",
                        "rel_diff_out_2", "rel_diff_in_2", "id")
  as_tibble(resMat)
}

# cumulative distribution, fraction of points within radius r
# given 2D projection of hypersphere with radius R in p dimensions
cumulative_radial <- function(r, R, p){
  1 - (1 - (r/R)^2)^(p/2)
}

# the inverse of the weight is a difference between values
# of the cumulative distribution
radial_bin_weight_inv <- function(r1, r2, R, p){
  cumulative_radial(r2, R, p) - cumulative_radial(r1, R, p)
}

# calculate weights for all radial bins as function of p
# returns vector of weights sorted as the bin definitions in the input histogram h
weights_bincount_radial <- function(h, p){
  #store weights in vector w
  w <- rep(0, nrow(h))
  # extract maximum radius from all bins
  R <- max(as.numeric(sub("[^,]*,([^]]*)\\]", "\\1", h$xbin)))
  n <- length(unique(h$xbin))
  for (i in 1:nrow(h)){
    r1 <- as.numeric( sub("\\((.+),.*", "\\1", h$xbin[[i]]))
    r2 <- as.numeric( sub("[^,]*,([^]]*)\\]", "\\1", h$xbin[[i]]))
    # bins inside the slice are rescaled with weights for p=2
    if (h$inSlice[[i]] == 1){
      w[i] <-  radial_bin_weight_inv(r1, r2, R, 2)
    }
    else {
      w[i] <-  radial_bin_weight_inv(r1, r2, R, p)
    }
  }
  1 / (n*w)
}
