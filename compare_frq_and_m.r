compare_frq_and_m <- function(frq_file,m) {
  frq_obj <- read.frq(frq_file)
  nfish <- length(unique(m[,4]))
  diffs <- as.data.frame(matrix(NA,nrow=nfish,ncol=4))
  names(diffs) <- c("Tot","Catch","Effort","Size")
  for (i in 1:nfish) {
    comp <- compare_m2(frq_obj,m,i)
    if(!is.null(comp$d)) {
      diffs[i,1] <- round(sum(comp$d),1)
      diffs[i,2] <- sum(comp$d[,5])
      diffs[i,3] <- sum(comp$d[,6])
      diffs[i,4] <- sum(comp$d) - sum(comp$d[,1:6])
      }
    }
    print(diffs[,2:4],justify="left")
    flush.console()
  }

