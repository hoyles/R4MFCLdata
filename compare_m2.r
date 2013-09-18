compare_m2 <- function(mufdfrq,mat,f) {
  x <- mufdfrq$mat
  mf <- x[x[,4]==f,]
  dimmmf <- dim(mf)
  dimmat <- dim(mat)
  if(!is.null(dimmmf) & !is.null(dimmat)) {
    flmatch <- mat[match(apply(mf[,1:4],1,paste,collapse=" "),apply(mat[,1:4],1,paste,collapse=" ")),]
    d <- mf - flmatch
    } else d <- NULL
  return(list(d=d,mf=mf))
  }

