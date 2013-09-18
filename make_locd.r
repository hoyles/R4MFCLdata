make_locd <- function(dat,strat) {
  dat$minlat <- as.numeric(substring(dat$lat_short, 1, 2))
  dat$minlat <- ifelse(substring(dat$lat_short, 3, 3) == "S", -1 * dat$minlat, dat$minlat)
  wc <- a <- substring(dat$lon_short, 3, 3)
  wc[a %in% as.character(0:9)] <- 4
  wc[a %in% c("E","W")] <- 3
  wc <- as.numeric(wc)
  dat$minlong <- as.numeric(substring(dat$lon_short, 1, wc - 1))
  dat$minlong <- ifelse(substring(dat$lon_short, wc, wc) == "W", 360-dat$minlong, dat$minlong)
  dat$maxlat <- rep(NA, length(dat$lat_short))
  dat$maxlat <- dat$minlat + strat$lat[match(dat$astrat, strat$strat_id)]
  dat$maxlong <- rep(NA, length(dat$lon_short))
  dat$maxlong <- dat$minlong + strat$long[match(dat$astrat, strat$strat_id)]
  return(dat)
  }

