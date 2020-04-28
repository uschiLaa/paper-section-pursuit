# breaks are necessary input, it is up to the user to define a
# binning that works over different projections of the input data
# eps is the vector of cutoff values, smaller differences are not counted
# (needs to be sorted to match the order in which the bins appear)
slice_index <- function(breaks_x, breaks_y, eps, bintype="square", power=1, flip=1,
                        reweight=FALSE, p = 4){
  
  if (reweight){
    if (bintype != "polar"){
      print("Reweighting is only defined for polar binning and will be ignored.")
    }
    else print(paste0("Reweighting assuming p=", p))
  }
  
  resc <- 1
  
  if (bintype == "polar"){
    resc <- 1 / (1 - (1/10)^(1/power))^power
    print(paste0("Rescaling raw index by a factor ", resc))
  }

  function(mat, dists, h){
    
    # call binner, return zero if binning is not recognised
    mat_tab <- slice_binning(mat, dists, h, breaks_x, breaks_y, bintype=bintype)
    if (mat_tab==0) return(0)

    # no result if no points inside the slice
    if (length(mat_tab$n[mat_tab$inSlice=="1"])==0) return(0)
    
    if (bintype == "polar" && reweight){
      mat_tab <- mat_tab %>%
        add_column(w = weights_bincount_radial(mat_tab, p)) %>%
        group_by(inSlice) %>%
        mutate(n_tot = n/sum(n)) %>%
        mutate(n = n_tot * w)
    }
    else{
      mat_tab <- mat_tab %>%
        group_by(inSlice) %>%
        mutate(n = n/sum(n))
    }
    
    # getting binwise density differences
    if (power!=1) {
      x <- flip*(mat_tab$n[mat_tab$inSlice=="0"]^(1/power) -
              mat_tab$n[mat_tab$inSlice=="1"]^(1/power))
      y <- flip*(mat_tab$n[mat_tab$inSlice=="0"] -
                 mat_tab$n[mat_tab$inSlice=="1"])
      x <- if_else(y>eps, x, 0) # dropping bins based on y
    }
    else {
      x <- flip*(mat_tab$n[mat_tab$inSlice=="0"] - mat_tab$n[mat_tab$inSlice=="1"])
      x <- if_else(x>eps, x, 0)
    }
    if (power!=1)
      resc * sum(x^power)
    else
      resc * sum(x)
  }
}

# estimating the right cutoff for difference assuming uniform hypersphere
# N is total number of sample points
# p is the number of dimensions
# res is the resolution, (slice radius)/(sphere radius)
# K is the total number of bins
# K_theta is the number of angular bins
# r_breaks are the bin boundaries used
estimate_eps <- function(N, p, res, K, K_theta, r_breaks){
  r_max <- max(r_breaks)
  ret <- c()
  for (i in 2:length(r_breaks)){
    r1 <- r_breaks[i-1]
    r2 <- r_breaks[i]
    delta_i <- (r_max / sqrt(r2^2 - r1^2)) * sqrt(2 * K_theta / N) *
      res^((2-p)/2) / sqrt(p - (p-2)*res^2)
    eps <- delta_i/K
    ret <- c(ret, rep(eps, K_theta))
  }
  ret
}
