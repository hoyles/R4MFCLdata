reform <- function(a) {
  a <- as.character(a)
  a <- gsub(" ","",a)
  a <- gsub(",$","",a)
  return(a)
  }
