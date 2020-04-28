## small variation of the guided tour where both the projected data
## and a distance vector are passed to the index function

guided_section_tour <- function(index_f, d = 2, alpha = 0.5, cooling = 0.99,
                                max.tries = 25, max.i = Inf, v_rel = NULL, anchor=NULL,
                                search_f = tourr:::search_geodesic, stepS = 0.9, ...) {
  
  h <- NULL
  
  generator <- function(current, data) {
    if (is.null(current)) return(basis_init(ncol(data), d))
    
    if (is.null(h)) {
      half_range <- tourr:::compute_half_range(NULL, data, FALSE)
      v_rel <- tourr:::compute_v_rel(v_rel, half_range, ncol(data))
      h <<- v_rel^(1/(ncol(data)-2))
    }
    
    index <- function(proj) {
      dist_data <- tourr:::anchored_orthogonal_distance(proj, data, anchor)
      index_f(as.matrix(data) %*% proj, dist_data, h)
    }
    
    cur_index <- index(current)
    
    if (cur_index > max.i){
      cat("Found index ", cur_index, ", larger than selected maximum ", max.i, ". Stopping search.\n",
          sep="")
      cat("Final projection: \n")
      if (ncol(current)==1) {
        for (i in 1:length(current))
          cat(sprintf("%.3f",current[i])," ")
        cat("\n")
      }
      else {
        for (i in 1:nrow(current)) {
          for (j in 1:ncol(current))
            cat(sprintf("%.3f",current[i,j])," ")
          cat("\n")
        }
      }
      return(NULL)
    }
    
    basis <- search_f(current, alpha, index, max.tries, cur_index=cur_index, ...)$target
    print(basis)
    alpha <<- alpha * cooling

    basis
  }
  
  new_geodesic_path("guided", generator)
}
