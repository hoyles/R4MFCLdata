
# Run this section in 32 bit
require(RODBC)
require(R4MFCL)
setwd("I:/assessments/Pop dy modeling/R/R4MFCLdata/")
source("I:/assessments/Pop dy modeling/R/R4MFCLdata/R4mfclRdata.r")

channel_lf <- odbcDriverConnect("DSN=Visual FoxPro Database;UID=;PWD=;SourceDB=G:\\Tuna_dbs\\LWFreq\\dbf\\lfreq.DBC;SourceType=DBC;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;Null=Yes;Deleted=Yes;")
channel_wf <- odbcDriverConnect("DSN=Visual FoxPro Database;UID=;PWD=;SourceDB=G:\\Tuna_dbs\\LWFreq\\dbf\\lfreq.DBC;SourceType=DBC;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;Null=Yes;Deleted=Yes;")
channel_mfd <- odbcDriverConnect("DSN=Visual FoxPro Database;UID=;PWD=;SourceDB=G:\\Tuna_dbs\\Mufdager\\DBF\\mufdager.dbc;SourceType=DBC;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;Null=Yes;Deleted=Yes;")
channel_log <- odbcDriverConnect("DSN=Visual FoxPro Database;UID=;PWD=;SourceDB=G:\\Tuna_dbs\\Log_dbs\\DBF\\logsheet.dbc;SourceType=DBC;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;Null=Yes;Deleted=Yes;")
channel <- odbcDriverConnect("DSN=Visual FoxPro Database;UID=;PWD=;SourceDB=G:\\Tuna_dbs\\reference\\DBF\\ofp_reference.dbc;SourceType=DBC;Exclusive=No;BackgroundFetch=Yes;Collate=Machine;Null=Yes;Deleted=Yes;")
sqlTables(channel_mfd)
sqlTables(channel_log)
sqlTables(channel_wf)

# Load fishery definitions from mufdager
all_fishery_defs <- sqlQuery(channel_mfd, "SELECT * from fishery")
write.csv(all_fishery_defs,"all_fishery_defs.csv")
# or load them from the csv file
# all_fishery_defs <- read.csv("all_fishery_defs.csv")

strat <- sqlQuery(channel, "select * from stratification where strat_type = 'A'", max=0)
strat$lat <- rep(NA, length(strat$strat_id))
strat$long <- rep(NA, length(strat$strat_id))
strat$lat <- ifelse(strat$strat_id == "T", 10, strat$lat)
strat$long <- ifelse(strat$strat_id == "T", 20, strat$long)
strat$lat <- ifelse(strat$strat_id == "F", 5, strat$lat)
strat$long <- ifelse(strat$strat_id == "F", 10, strat$long)
strat$lat <- ifelse(strat$strat_id == "4", 4, strat$lat)
strat$long <- ifelse(strat$strat_id == "4", 10, strat$long)
strat$lat <- ifelse(strat$strat_id == "0", 10, strat$lat)
strat$long <- ifelse(strat$strat_id == "0", 10, strat$long)
strat$lat <- ifelse(strat$strat_id == "5", 5, strat$lat)
strat$long <- ifelse(strat$strat_id == "5", 5, strat$long)
strat$lat <- ifelse(strat$strat_id == "1", 1, strat$lat)
strat$long <- ifelse(strat$strat_id == "1", 1, strat$long)
save(strat,file="strat.RData")

standard_areas <- sqlQuery(channel_mfd, "SELECT * from standard_areas")
save(standard_areas,file="standard_areas.RData")
write.csv(standard_areas,"standard_areas.csv")


# Get raw data
query <- "SELECT gr_id,flag_id,fleet_id,yy,mm,mondate,lat_short,lon_short,ocean_id,spc,sch_id,days,sets,hhooks,stdeff,yft_stdeff,bet_stdeff,alb_stdeff,skj_stdeff,"
query <- paste(query,"skj_c,yft_c,bet_c,alb_c,skj_n,yft_n,bet_n,alb_n,id,area_id,astrat,disc_only,bet_stdef3,yft_stdef3,bet_stdef4,yft_stdef4,mls_stdeff")
query <- paste(query,"from a_model")
a <- sqlQuery(channel_log, query)
amodel <- a
save(amodel,file="amodel.RData")

query <- paste("SELECT * from lf_master")
a <- sqlQuery(channel_lf, query)
lfdata <- a
save(lfdata,file="lfdata.RData")

query <- paste("SELECT * from wt_master")
a <- sqlQuery(channel_lf, query)
wtdata <- a
save(wtdata,file="wtdata.RData")

save(standard_areas,strat,amodel,lfdata,wtdata,file="MFDdata.RData")

############################################
# Run from here in 64 bit. Needs a PC with > 4GB of RAM
require(R4MFCL)
setwd("I:/assessments/Pop dy modeling/R/R4MFCLdata/")
source("I:/assessments/Pop dy modeling/R/R4MFCLdata/R4mfclRdata.r")

load("MFDdata.RData")
load("standard_areas.RData")
standard_areas <- clean_stdareas(standard_areas)
amodel <- clean_locations(amodel,strat,standard_areas)
lfdata <- clean_locations(lfdata,strat,standard_areas)
wtdata <- clean_locations(wtdata,strat,standard_areas)
lfdata <- lfdata[!is.na(lfdata$maxlat) & !is.na(lfdata$maxlong),]
wtdata <- wtdata[!is.na(wtdata$maxlat) & !is.na(wtdata$maxlong),]
sch_codes <- data.frame(lfcode = c(" ","A","F","L","M","O","U"),
                        mdcode = c( 0,  3, 4, 3, 6, 8, 1))
lfdata$sch_id <- sch_codes[match(lfdata$schtype_id,sch_codes$lfcode),"mdcode"]
wtdata$sch_id <- sch_codes[match(wtdata$schtype_id,sch_codes$lfcode),"mdcode"]


########## Put it all together #########
fishdefs_yft1 <- load_fishdefs("all_fishery_defs.csv",sp="YFT",scheme_id=1,standard_areas)
fishdefs_yft2 <- load_fishdefs("all_fishery_defs.csv",sp="YFT",scheme_id=2,standard_areas)
fishdefs_yft3 <- load_fishdefs("all_fishery_defs.csv",sp="YFT",scheme_id=3,standard_areas)
fishdefs_bet1 <- load_fishdefs("all_fishery_defs.csv",sp="BET",scheme_id=1,standard_areas)
fishdefs_bet2 <- load_fishdefs("all_fishery_defs.csv",sp="BET",scheme_id=2,standard_areas)
fishdefs_bet3 <- load_fishdefs("all_fishery_defs.csv",sp="BET",scheme_id=3,standard_areas)
fishdefs_bet4 <- load_fishdefs("all_fishery_defs.csv",sp="BET",scheme_id=4,standard_areas)
fishdefs_bet5 <- load_fishdefs("all_fishery_defs.csv",sp="BET",scheme_id=5,standard_areas)
fishdefs_bet6 <- load_fishdefs("all_fishery_defs.csv",sp="BET",scheme_id=6,standard_areas)
fishdefs_skj1 <- load_fishdefs("all_fishery_defs.csv",sp="SKJ",scheme_id=1,standard_areas)
fishdefs_skj2 <- load_fishdefs("all_fishery_defs.csv",sp="SKJ",scheme_id=2,standard_areas)
fishdefs_skj3 <- load_fishdefs("all_fishery_defs.csv",sp="SKJ",scheme_id=3,standard_areas)
fishdefs_skj4 <- load_fishdefs("all_fishery_defs.csv",sp="SKJ",scheme_id=4,standard_areas)
fishdefs_skj5 <- load_fishdefs("all_fishery_defs.csv",sp="SKJ",scheme_id=5,standard_areas)
fishdefs_skj6 <- load_fishdefs("all_fishery_defs.csv",sp="SKJ",scheme_id=6,standard_areas)
fishdefs_alb4 <- load_fishdefs("all_fishery_defs.csv",sp="ALB",scheme_id=4,standard_areas)

lfd_bet <- lfdata[lfdata$sp_id==as.character(fishdefs_bet3[[1]]$fdx$sp_id),]
wtd_bet <- wtdata[wtdata$sp_id==as.character(fishdefs_bet3[[1]]$fdx$sp_id),]
lfd_yft <- lfdata[lfdata$sp_id==as.character(fishdefs_yft2[[1]]$fdx$sp_id),]
wtd_yft <- wtdata[wtdata$sp_id==as.character(fishdefs_yft2[[1]]$fdx$sp_id),]
lfd_skj <- lfdata[lfdata$sp_id==as.character(fishdefs_skj5[[1]]$fdx$sp_id),]
lfd_alb <- lfdata[lfdata$sp_id==as.character(fishdefs_alb4[[1]]$fdx$sp_id),]
save(lfd_skj,amodel,fishdefs_skj1,fishdefs_skj2,fishdefs_skj3,fishdefs_skj4,fishdefs_skj5,fishdefs_skj6,file="SKJ_defs_and_data.RData")
save(lfd_bet,amodel,fishdefs_bet1,fishdefs_bet2,fishdefs_bet3,fishdefs_bet4,fishdefs_bet5,fishdefs_bet6,file="BET_defs_and_data.RData")
#load("BET3.RData")

m_bet5 <- build_matrix(fishdefs_bet5,amodel,lfd_bet,wtd_bet,lf_minsize=10,lf_binwidth=2,lf_nbins=95,wt_minsize=1,wt_binwidth=1,wt_nbins=200) 
m_bet5_gt75 <- build_matrix(fishdefs_bet5,amodel,lfd_bet,wtd_bet,lf_minsize=10,lf_binwidth=2,lf_nbins=95,wt_minsize=1,wt_binwidth=1,wt_nbins=200) 
m_yft3 <- build_matrix(fishdefs_yft3,amodel,lfd_yft,wtd_yft,lf_minsize=10,lf_binwidth=2,lf_nbins=95,wt_minsize=1,wt_binwidth=1,wt_nbins=200) 
m_skj1 <- build_matrix(fishdefs_skj1,amodel,lfd_skj,NA,lf_minsize=2,lf_binwidth=2,lf_nbins=54,wt_minsize=1,wt_binwidth=1,wt_nbins=0) 
m_skj3 <- build_matrix(fishdefs_skj3,amodel,lfd_skj,NA,lf_minsize=2,lf_binwidth=2,lf_nbins=54,wt_minsize=1,wt_binwidth=1,wt_nbins=0) 
m_skj6 <- build_matrix(fishdefs_skj6,amodel,lfd_skj,NA,lf_minsize=2,lf_binwidth=2,lf_nbins=54,wt_minsize=1,wt_binwidth=1,wt_nbins=0) 
m_skj5 <- build_matrix(fishdefs_skj5,amodel,lfd_skj,NA,lf_minsize=2,lf_binwidth=2,lf_nbins=54,wt_minsize=1,wt_binwidth=1,wt_nbins=0) 
m_bet3 <- build_matrix(fishdefs_bet3,amodel,lfd_bet,wtd_bet,lf_minsize=10,lf_binwidth=2,lf_nbins=95,wt_minsize=1,wt_binwidth=1,wt_nbins=200) 
m_yft1 <- build_matrix(fishdefs_yft1,amodel,lfd_yft,wtd_yft,lf_minsize=10,lf_binwidth=2,lf_nbins=95,wt_minsize=1,wt_binwidth=1,wt_nbins=200) 
m_yft2 <- build_matrix(fishdefs_yft2,amodel,lfd_yft,wtd_yft,lf_minsize=10,lf_binwidth=2,lf_nbins=95,wt_minsize=1,wt_binwidth=1,wt_nbins=200) 
m_alb4 <- build_matrix(fishdefs_alb4,amodel,lfd_alb,NA,lf_minsize=30,lf_binwidth=1,lf_nbins=100,wt_minsize=1,wt_binwidth=1,wt_nbins=0) 


compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_BET_3.TXT",m=m_bet3)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_BET_5.TXT",m=m_bet5)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_YFT_1.TXT",m=m_yft1)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_YFT_2.TXT",m=m_yft2)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_YFT_3.TXT",m=m_yft3)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_SKJ_5.TXT",m=m_skj5)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_SKJ_6.TXT",m=m_skj6)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_ALB_4.TXT",m=m_alb4)
compare_frq_and_m(frq_file="G:/Tuna_dbs/Mufdager/OUTPUT/MFCL_BET_5.TXT",m=m_bet5_gt75)

# Make the frq object from the m matrixc and the header stuff
# read in an existing frq as a template
bet_frq <- read.frq("L:/bet/2010/results/bet.frq")
bet_frq$mat <- m_bet3
write.frq("bet3.frq",bet_frq)
bet_frq$mat <- m_bet5
write.frq("bet5.frq",bet_frq)

yft_frq <- read.frq("L:/yft/2007/final/yft.frq")
yft_frq$mat <- m_yft3
write.frq("yft3.frq",yft_frq)

yft_frq$mat <- m_yft2
write.frq("yft2.frq",yft_frq)
yft_frq$mat <- m_yft1
write.frq("yft1.frq",yft_frq)

skj_frq <- read.frq("L:/assessments/skj/2011/Model_runs_fix2/ref/skj.frq")
skj_frq$mat <- m_skj5
write.frq("skj5.frq",skj_frq)
skj_frq$mat <- m_skj1
write.frq("skj1.frq",skj_frq)
skj_frq$mat <- m_skj3
write.frq("skj3.frq",skj_frq)

skj_frq$mat <- m_skj6
write.frq("skj6.frq",skj_frq)

alb_frq <- read.frq("L:/alb/2011/assessment/Runs/0.init/alb.frq")
alb_frq$mat <- m_alb4
write.frq("alb4.frq",alb_frq)

