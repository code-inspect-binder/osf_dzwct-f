# ------------------ #
# Set the directories 
# ------------------ #

setwd("~/Desktop/spook_n_play_data_for_processing/Chronos_09_09_2021/PRG")

# ------------------ #
source("f_load_packages.R")
f_load_packages(I_need = c("fitdistrplus","sjPlot","jtools","lmerTest","emmeans","effects","sjstats","tidyverse","psych", "gtools", "magrittr", "DescTools","ggpubr","reshape", "pastecs", "ggplot2", "ggpubr", "tibble", "rstatix", "lme4","nlme"))

#disable scientific numbering
options(scipen=999)

#EMO_Delay_GROUP
setwd("~/Desktop/spook_n_play_data_for_processing/Chronos_09_09_2021/DAT")
colheaderChronos <-c("T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12","T13","T14","T15","T16","T17","T18","T19","T20","T21","T22","T23","T24","T25","T26","T27","T28","T29","T30","T31","T32","T33","T34","T35","T36","T37","T38","T39","T40","T41","T42","T43","T44","T45","T46","T47","T48","T49","T50","T51","T52","T53","T54")
GR<-c("G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","G13","G14","G15")
colheaderChronosGR <-c("GR","T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12","T13","T14","T15","T16","T17","T18","T19","T20","T21","T22","T23","T24","T25","T26","T27","T28","T29","T30","T31","T32","T33","T34","T35","T36","T37","T38","T39","T40","T41","T42","T43","T44","T45","T46","T47","T48","T49","T50","T51","T52","T53","T54")

#DELAY counted as 35 seconds post sound event to normalize across trials
EMO_groupdelay<-read.csv(file="EMO_GROUPdelay.csv", sep = "", header=FALSE)
colnames(EMO_groupdelay)<-c(colheaderChronos)
DW_EMO_groupdelay<-add_column(EMO_groupdelay, GR, .before = 1)
DL_EMO_groupdelay<-melt(DW_EMO_groupdelay, id=c("GR"), measured=c("colheaderChronos"))
DL_EMO_groupdelay$GR<-as.factor(DL_EMO_groupdelay$GR)

setwd("~/Desktop/spook_n_play_data_for_processing/Chronos_19_01_2022/DAT")
##TTS_WP2/TTS_WP3
TTS_WP2<-read.csv(file="TTS_WP2.csv", sep = "", header=FALSE)
colnames(TTS_WP2)<-c(colheaderChronos)
DW_TTS_WP2=add_column(TTS_WP2, GR, .before = 1)
DL_TTS_WP2=melt(DW_TTS_WP2, id=c("GR"), measured=c("colheaderChronos"))
colnames(DL_TTS_WP2)<-c("GrNr", "TrialNr","TTS_WP2")

TTS_WP3<-read.csv(file="TTS_WP3.csv", sep = "", header=FALSE)
colnames(TTS_WP3)<-c(colheaderChronos)
DW_TTS_WP3=add_column(TTS_WP3, GR, .before = 1)
DL_TTS_WP3=melt(DW_TTS_WP3, id=c("GR"), measured=c("colheaderChronos"))
colnames(DL_TTS_WP3)<-c("GrNr", "TrialNr","TTS_WP3")
TIS_Hdummy= merge(DL_TTS_WP2,DL_TTS_WP3, by=c("GrNr", "TrialNr"))
  
#EMOCOUNT
EMO_dummy_count<-read_delim("Chronos_trial_order_updated.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
EMO_count<-EMO_dummy_count[c(1,7,9)]
colnames(EMO_count)<-c("TrialNr", "Count_neg_group","Count_pos_group")
dummy=merge(TIS_Hdummy,EMO_count, by='TrialNr')
dummy$TrialNr=gsub(" ", "",dummy$TrialNr)
dummy$TrialNr=gsub("T", "",dummy$TrialNr)

myData = dummy[dummy$TrialNr > 1,]
myData$TTS_WP2[myData$TTS_WP2==Inf]="15"
myData$TTS_WP3[myData$TTS_WP3==Inf]="20"
myData$TTS_WP2<-as.numeric(myData$TTS_WP2)
myData$TTS_WP3<-as.numeric(myData$TTS_WP3)

"Count_neg_group","Count_pos_group"
myData$GrNr<-as.factor(myData$GrNr)
myData$GrNr<-factor(myData$GrNr, levels=c("G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","G13","G14","G15"))
myData$Count_neg_group<-as.factor(myData$Count_neg_group)
myData$Count_neg_group<-factor(myData$Count_neg_group, levels=c("0","1","2","3"))
myData$Count_pos_group<-as.factor(myData$Count_pos_group)
myData$Count_pos_group<-factor(myData$Count_pos_group, levels=c("0","1","2","3"))

dim(myData)
DV2=myData$TTS_WP2
#find Q1, Q3, and interquartile range for values in column A
Q1 <- quantile(DV2, .25)
Q3 <- quantile(DV2, .75)
IQR2 <- IQR(DV2)

#only keep rows in dataframe that have values within 1.5*IQR of Q1 and Q3
no_outliers2 <- subset(myData, DV2> (Q1 - 1.5*IQR2) & DV2< (Q3 + 1.5*IQR2))

#view row and column count of new data frame
dim(no_outliers2)

dat2=no_outliers2
DVoutP2=dat2$TTS_WP2

dim(myData)

DV3=myData$TTS_WP3
#find Q1, Q3, and interquartile range for values in column A
DV3Q1 <- quantile(DV3, .25)
DV3Q3 <- quantile(DV3, .75)
IQR3 <- IQR(DV3)

#only keep rows in dataframe that have values within 1.5*IQR of Q1 and Q3
no_outliers3 <- subset(myData, DV3> (DV3Q1 - 1.5*IQR3) & DV3< (DV3Q3 + 1.5*IQR3))

#view row and column count of new data frame
dim(no_outliers3)

dat3=(no_outliers3)
DVoutP3=dat3$TTS_WP3
dim(dat3)

##LMER
options(contrasts = c("contr.sum","contr.poly"))

m_TTS_WP2 <- lmer(DVoutP2 ~ Count_neg_group + Count_pos_group + (1 | GrNr), data=dat2, REML=FALSE)
m_TTS_WP3 <- lmer(DVoutP3 ~ Count_neg_group + Count_pos_group + (1 | GrNr), data=dat3, REML=FALSE)

tab_model(m_TTS_WP2)
tab_model(m_TTS_WP3)
