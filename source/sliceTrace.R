
# Variation of the spinebil::getTrace function that works for slices
getSliceTrace <- function(d, m, indexList, indexLabels, h){
  mX <- m[[1]]
  if(ncol(mX) != 2){
    print("Each projection matrix must have exactly two columns!")
    return(NULL)
  }
  # problem with planned tour: skipping first two entries
  # so we generate proxies (not used)
  mSkip1 <- tourr::basis_random(nrow(mX))
  mSkip2 <- tourr::basis_random(nrow(mX))
  mList <- append(list(mSkip1, mSkip2), m)
  # get tour path object
  tPath <- tourr::save_history(d, tour_path=tourr::planned_tour(mList))
  # get interpolated path and unformat to list
  tFullPath <- as.list(tourr::interpolate(tPath))

  # initialise results storage
  resMat <- matrix(ncol = length(indexLabels)+1, nrow = length(tFullPath))
  colnames(resMat) <- c(indexLabels, "t")

  # loop over path and index functions
  for (i in seq_along(tFullPath)){
    dprj <- as.matrix(d) %*% tFullPath[[i]]
    dist_data <- tourr:::anchored_orthogonal_distance(tFullPath[[i]], d, anchor=rep(0, ncol(d)))
    res <- c()
    for (idx in indexList){
      res <- c(res, idx(dprj, dist_data, h))
    }
    resMat[i,] <- c(res, i)
  }
  resMat
}

