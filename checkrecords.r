checkrecords <- function(frq,m,f,yr,mon,cols) {
  x <- frq$mat
  ch <- rbind(c(rep(0,6,),seq(frq$dl$lffirst,by=frq$dl$lfwidth,length.out=frq$dl$lfint),seq(frq$dl$wffirst,by=frq$dl$wfwidth,length.out=frq$dl$wfint)),
  c(rep(0,7,),seq(frq$dl$wffirst,by=frq$dl$wfwidth,length.out=frq$dl$wfint),rep(0,frq$dl$wfint - 1)),
  x[x[,4]==f & x[,1]==yr & x[,2]==mon,],m[m[,4]==f & m[,1]==yr & m[,2]==mon,])
  return(ch[,cols])
  }
