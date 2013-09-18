clean_stdareas <- function(dat) {
#  code_table <- table(dat$area_code)     # remove duplicates in the standard_areas table
#  code_table <- code_table[code_table==1]
#  dat <- dat[dat$area_code %in% names(code_table),]
  dat$area_code <- gsub(" ","",as.character(dat$area_code))
  dat$area_code <- as.factor(as.character(dat$area_code))
  dat <- dat[substring(dat$lat_low, 1, 1) != " ",]
  dat$minlat <- as.numeric(substring(dat$lat_low, 1, 2))
  dat$minlat <- ifelse(substring(dat$lat_low, 3, 3) == "S", -1 * dat$minlat, dat$minlat)
  wc <- a <- substring(dat$lon_low, 3, 3)
  wc[a %in% as.character(0:9)] <- 4
  wc[a %in% c("E","W")] <- 3
  wc <- as.numeric(wc)
  dat$minlong <- as.numeric(substring(dat$lon_low, 1, wc - 1))
  dat$minlong <- ifelse(substring(dat$lon_low, wc, wc) == "W", 360-dat$minlong, dat$minlong)
  dat$maxlat <- as.numeric(substring(dat$lat_high, 1, 2))
  dat$maxlat <- ifelse(substring(dat$lat_high, 3, 3) == "S", -1 * dat$maxlat, dat$maxlat)
  wc <- a <- substring(dat$lon_high, 3, 3)
  wc[a %in% as.character(0:9)] <- 4
  wc[a %in% c("E","W")] <- 3
  wc <- as.numeric(wc)
  dat$maxlong <- as.numeric(substring(dat$lon_high, 1, wc - 1))
  dat$maxlong <- ifelse(substring(dat$lon_high, wc, wc) == "W", 360-dat$maxlong, dat$maxlong)
  return(dat)
  }

