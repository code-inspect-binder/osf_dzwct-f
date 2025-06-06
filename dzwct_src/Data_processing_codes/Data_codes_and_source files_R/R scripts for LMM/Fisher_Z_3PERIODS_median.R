# ------------------ #
# Set the directories 
# ------------------ #
#Change the repository to the one with the datafiles from OSF
setwd("~/Desktop/spook_n_play_data_for_processing/Chronos_19_01_2022/PRG")

# ------------------ #
source("f_load_packages.R")
f_load_packages(I_need = c("fitdistrplus","sjPlot","jtools","lmerTest","emmeans","effects","sjstats","tidyverse","psych", "gtools", "magrittr", "DescTools","ggpubr","reshape", "pastecs", "ggplot2", "ggpubr", "tibble", "rstatix", "lme4","nlme"))

#disable scientific numbering
options(scipen=999)

#EMO_P1_GROUP
setwd("/Users/marta.bienkiewicz/Desktop/spook_n_play_data_for_processing/Chronos_19_01_2022/DAT")
colheaderChronos <-c("T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12","T13","T14","T15","T16","T17","T18","T19","T20","T21","T22","T23","T24","T25","T26","T27","T28","T29","T30","T31","T32","T33","T34","T35","T36","T37","T38","T39","T40","T41","T42","T43","T44","T45","T46","T47","T48","T49","T50","T51","T52","T53","T54")
GR<-c("G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","G13","G14","G15")
colheaderChronosGR <-c("GR","T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12","T13","T14","T15","T16","T17","T18","T19","T20","T21","T22","T23","T24","T25","T26","T27","T28","T29","T30","T31","T32","T33","T34","T35","T36","T37","T38","T39","T40","T41","T42","T43","T44","T45","T46","T47","T48","T49","T50","T51","T52","T53","T54")

##P1 COUNTED as 6 seconds until sound event to normalize across trials
##P2 COUNTED AS FROM SOUND ONSENT (6SECONDS) plus 9 SECONDS - 15 SECONDS
##P3 COUNTED AS 20 SECONDS FROM P2 TO ALMOST END OF THE TRIAL
## ORDER PAPAMETER - 'OPA', FISHER Z TRANSFORMED ORDER PARAMETER - 'FOPA'

##P2 processing
OPAmedianP2<-read.csv(file="OPAmedianP2.csv", sep = "", header=FALSE)
colnames(OPAmedianP2)<-c(colheaderChronos)
DW_OPAmedianP2=add_column(OPAmedianP2, GR, .before = 1)
FOPAmedianP2=FisherZ(OPAmedianP2)
DW_FOPAmedianP2=add_column(FOPAmedianP2, GR, .before = 1)
DL_OPAmedianP2=melt(DW_OPAmedianP2, id=c("GR"), measured=c("colheaderChronos"))
DL_FOPAmedianP2=melt(DW_FOPAmedianP2, id=c("GR"), measured=c("colheaderChronos"))
colnames(DL_OPAmedianP2)<-c("GrNr", "TrialNr","OPAmedianP2")
colnames(DL_FOPAmedianP2)<-c("GrNr", "TrialNr","FOPAmedianP2")

##P3 processing
OPAmedianP3<-read.csv(file="OPAmedianP3.csv", sep = "", header=FALSE)
colnames(OPAmedianP3)<-c(colheaderChronos)
DW_OPAmedianP3=add_column(OPAmedianP3, GR, .before = 1)
FOPAmedianP3=FisherZ(OPAmedianP3)
DW_FOPAmedianP3=add_column(FOPAmedianP3, GR, .before = 1)
DL_OPAmedianP3=melt(DW_OPAmedianP3, id=c("GR"), measured=c("colheaderChronos"))
DL_FOPAmedianP3=melt(DW_FOPAmedianP3, id=c("GR"), measured=c("colheaderChronos"))
colnames(DL_OPAmedianP3)<-c("GrNr", "TrialNr","OPAmedianP3")
colnames(DL_FOPAmedianP3)<-c("GrNr", "TrialNr","FOPAmedianP3")

#EMOCOUNT
EMO_dummy_count<-read_delim("Chronos_trial_order_updated.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
EMO_count<-EMO_dummy_count[c(1,7,9)]
dummyproto1=merge(DL_OPAmedianP1, DL_FOPAmedianP1, by=c('TrialNr','GrNr'))
dummyproto2=merge( DL_OPAmedianP2, DL_FOPAmedianP2, by=c('TrialNr','GrNr'))
dummyproto3=merge( DL_OPAmedianP3, DL_FOPAmedianP3, by=c('TrialNr','GrNr'))
dummyproto12= merge(dummyproto1,dummyproto2, by=c('TrialNr','GrNr'))
dummy= merge(dummyproto12,dummyproto3, by=c('TrialNr','GrNr'))
dummy2=merge(dummy,EMO_count, by='TrialNr')

dummy2$TrialNr=gsub(" ", "",dummy2$TrialNr)
dummy2$TrialNr=gsub("T", "",dummy2$TrialNr)

myData = dummy2[dummy2$TrialNr > 1,]
STAT_DL_OPAmedianP123_EMO=myData[complete.cases(myData), ]


#histogram
histogramOPA<-ggplot(STAT_DL_OPAmedianP123_EMO, aes(OPAmedianP1)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "OPAmedianP1", y = "Density") 
histogramOPA
histogramFOPA<-ggplot(STAT_DL_OPAmedianP123_EMO, aes(FOPAmedianP1)) + theme(legend.position = "none") + geom_histogram(aes(y = ..density..), colour = "black", fill = "white") + labs(x = "FOPAmedianP1", y = "Density") 
histogramFOPA

STAT_DL_OPAmedianP123_EMO$GrNr<-as.factor(STAT_DL_OPAmedianP123_EMO$GrNr)
STAT_DL_OPAmedianP123_EMO$GrNr<-factor(STAT_DL_OPAmedianP123_EMO$GrNr, levels=c("G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","G13","G14","G15"))
STAT_DL_OPAmedianP123_EMO$count_neg_group<-as.factor(STAT_DL_OPAmedianP123_EMO$Nbm1)
STAT_DL_OPAmedianP123_EMO$count_neg_group<-factor(STAT_DL_OPAmedianP123_EMO$Nbm1, levels=c("0","1","2","3"))
STAT_DL_OPAmedianP123_EMO$count_pos_group<-as.factor(STAT_DL_OPAmedianP123_EMO$Nbp1)
STAT_DL_OPAmedianP123_EMO$count_pos_group<-factor(STAT_DL_OPAmedianP123_EMO$Nbp1, levels=c("0","1","2","3"))

#outlier removal
df=STAT_DL_OPAmedianP123_EMO
DV2=df$FOPAmedianP2
DV3=df$FOPAmedianP3

dim(df)
#find Q1, Q3, and interquartile range for values in column A
Q1 <- quantile(DV2, .25)
Q3 <- quantile(DV2, .75)
IQR2 <- IQR(DV2)

#only keep rows in dataframe that have values within 1.5*IQR of Q1 and Q3
no_outliers2 <- subset(df, DV2> (Q1 - 1.5*IQR2) & DV2< (Q3 + 1.5*IQR2))

#view row and column count of new data frame
dat2=(no_outliers2)
DVout2=dat2$FOPAmedianP2

Q1 <- quantile(DV3, .25)
Q3 <- quantile(DV3, .75)
IQR3 <- IQR(DV3)

#only keep rows in dataframe that have values within 1.5*IQR of Q1 and Q3
no_outliers3 <- subset(df, DV3> (Q1 - 1.5*IQR3) & DV3< (Q3 + 1.5*IQR3))

#view row and column count of new data frame
dim(no_outliers3)
dat3=(no_outliers3)
DVout3=dat3$FOPAmedianP3

##LMER
options(contrasts = c("contr.sum","contr.poly"))
m_FOPA_P2 <- lmer(DVout2 ~count_neg_group + count_pos_group + (1 | GrNr), data=dat2, REML=FALSE)
m_FOPA_P3 <- lmer(DVout3 ~count_neg_group + count_pos_group + (1 | GrNr), data=dat3, REML=FALSE)

anova(m_FOPA_P2)
anova(m_FOPA_P3)

plot(effect("count_neg_group", m_FOPA_P2, multiline=TRUE))

plotty <- ggplot(dat2, aes(x=count_neg_group, y=DVout2)) +
       geom_violin(alpha=0.7,outlier.colour = "blue", outlier.shape = 5, outlier.size = 4) +
       stat_summary(fun=mean, geom="point", shape=20, size=7, color="red", fill="red") +
       theme(legend.position="top") +
       scale_fill_brewer(palette="Set1") +
       theme(axis.title = element_text (size = 18 ,face="bold"),
                         axis.text = element_text(size = 14), 
                         strip.text.x = element_text(size = 18, face = "bold"))+
       xlab("Count negative inductions per group in a trial") +   # x axis title
       ylab("PERIOD 2
+        Transformed Fisher Z order parameter") 

 print(plotty)

 plotty <- ggplot(dat3, aes(x=count_neg_group, y=DVout3)) +
   geom_violin(alpha=0.7,outlier.colour = "blue", outlier.shape = 5, outlier.size = 4) +
   stat_summary(fun=mean, geom="point", shape=20, size=7, color="red", fill="red") +
   theme(legend.position="top") +
   scale_fill_brewer(palette="Set1") +
   theme(axis.title = element_text (size = 18 ,face="bold"),
         axis.text = element_text(size = 14), 
         strip.text.x = element_text(size = 18, face = "bold"))+
   xlab("Count negative inductions per group in a trial") +   # x axis title
   ylab("PERIOD 2
+        Transformed Fisher Z order parameter") 
 
 print(plotty)

tab_model(m_FOPA_P2)
tab_model(m_FOPA_P3)
by(dat2$FOPAmedianP2, dat2$count_neg_group, stat.desc, basic = FALSE, norm = TRUE)
by(dat3$FOPAmedianP3, dat3$count_neg_group, stat.desc, basic = FALSE, norm = TRUE)
