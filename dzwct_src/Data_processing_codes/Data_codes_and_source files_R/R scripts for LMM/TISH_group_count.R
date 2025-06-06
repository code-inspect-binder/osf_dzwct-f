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
##TIS_HP2/TIS_HP3
TIS_HP2<-read.csv(file="TIS_HP2.csv", sep = "", header=FALSE)
colnames(TIS_HP2)<-c(colheaderChronos)
DW_TIS_HP2=add_column(TIS_HP2, GR, .before = 1)
DL_TIS_HP2=melt(DW_TIS_HP2, id=c("GR"), measured=c("colheaderChronos"))
colnames(DL_TIS_HP2)<-c("GrNr", "TrialNr","TIS_HP2")

TIS_HP3<-read.csv(file="TIS_HP3.csv", sep = "", header=FALSE)
colnames(TIS_HP3)<-c(colheaderChronos)
DW_TIS_HP3=add_column(TIS_HP3, GR, .before = 1)
DL_TIS_HP3=melt(DW_TIS_HP3, id=c("GR"), measured=c("colheaderChronos"))
colnames(DL_TIS_HP3)<-c("GrNr", "TrialNr","TIS_HP3")
TIS_Hdummy= merge(DL_TIS_HP2,DL_TIS_HP3, by=c("GrNr", "TrialNr"))
  
#EMOCOUNT
EMO_dummy_count<-read_delim("Chronos_trial_order_updated.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
EMO_count<-EMO_dummy_count[c(1,7,9)]
colnames(EMO_count)<-c("TrialNr", "Count_neg_group","Count_pos_group")
dummy=merge(TIS_Hdummy,EMO_count, by='TrialNr')
dummy$TrialNr=gsub(" ", "",dummy$TrialNr)
dummy$TrialNr=gsub("T", "",dummy$TrialNr)

myData = dummy[dummy$TrialNr > 1,]


myData$GrNr<-as.factor(myData$GrNr)
myData$GrNr<-factor(myData$GrNr, levels=c("G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","G13","G14","G15"))
myData$Count_neg_group<-as.factor(myData$Count_neg_group)
myData$Count_neg_group<-factor(myData$Count_neg_group, levels=c("0","1","2","3"))
myData$Count_pos_group<-as.factor(myData$Count_pos_group)
myData$Count_pos_group<-factor(myData$Count_pos_group, levels=c("0","1","2","3"))

dim(myData)
DV2=myData$TIS_HP2
#find Q1, Q3, and interquartile range for values in column A
Q1 <- quantile(DV2, .25)
Q3 <- quantile(DV2, .75)
IQR2 <- IQR(DV2)

#only keep rows in dataframe that have values within 1.5*IQR of Q1 and Q3
no_outliers2 <- subset(myData, DV2> (Q1 - 1.5*IQR2) & DV2< (Q3 + 1.5*IQR2))

#view row and column count of new data frame
dim(no_outliers2)

dat2=no_outliers2
DVoutP2=dat2$TIS_HP2

dim(myData)

DV3=myData$TIS_HP3
#find Q1, Q3, and interquartile range for values in column A
Q1 <- quantile(DV3, .25)
Q3 <- quantile(DV3, .75)
IQR3 <- IQR(DV3)

#only keep rows in dataframe that have values within 1.5*IQR of Q1 and Q3
no_outliers3 <- subset(myData, DV3> (Q1 - 1.5*IQR3) & DV3< (Q3 + 1.5*IQR3))

#view row and column count of new data frame
dim(no_outliers3)

dat3=(no_outliers3)
DVoutP3=dat3$TIS_HP3
##LMER
options(contrasts = c("contr.sum","contr.poly"))

m_TIS_HP2 <- lmer(DVoutP2 ~ Count_neg_group + Count_pos_group + (1 | GrNr), data=dat2, REML=FALSE)
m_TIS_HP3 <- lmer(DVoutP3 ~ Count_neg_group + Count_pos_group + (1 | GrNr), data=dat3, REML=FALSE)

tab_model(m_TIS_HP2)
tab_model(m_TIS_HP3)

by(dat2$TIS_HP2, dat2$Count_neg_group, stat.desc, basic = FALSE, norm = TRUE)
by(dat3$TIS_HP3, dat3$Count_pos_group, stat.desc, basic = FALSE, norm = TRUE)

plotty <- ggplot(dat2, aes(x=Count_neg_group, y=DVoutP2)) +
  geom_violin(alpha=0.7,outlier.colour = "blue", outlier.shape = 5, outlier.size = 4) +
  stat_summary(fun=mean, geom="point", shape=20, size=7, color="red", fill="red") +
  theme(legend.position="top") +
  scale_fill_brewer(palette="Set1") +
  theme(axis.title = element_text (size = 18 ,face="bold"),
        axis.text = element_text(size = 14), 
        strip.text.x = element_text(size = 18, face = "bold"))+
  xlab("Count of negative inductions in the trial") +   # x axis title
  ylab("Period 2:
       Time spent in H synchrony band") 
print(plotty)

plotty <- ggplot(dat3, aes(x=Count_pos_group, y=DVoutP3)) +
  geom_violin(alpha=0.7,outlier.colour = "blue", outlier.shape = 5, outlier.size = 4) +
  stat_summary(fun=mean, geom="point", shape=20, size=7, color="red", fill="red") +
  theme(legend.position="top") +
  scale_fill_brewer(palette="Set1") +
  theme(axis.title = element_text (size = 18 ,face="bold"),
        axis.text = element_text(size = 14), 
        strip.text.x = element_text(size = 18, face = "bold"))+
  xlab("Count of positive inductions in the trial") +   # x axis title
  ylab("Period 3:
       Time spent in H synchrony band") 
print(plotty)