# ------------------ #
# Set the directories 
# ------------------ #
setwd("~/Desktop/spook_n_play_data_for_processing/Chronos_19_01_2022/PRG")
# ------------------ #
source("f_load_packages.R")
f_load_packages(I_need = c("fitdistrplus","sjPlot","jtools","lmerTest","emmeans","effects","sjstats","tidyverse","psych", "gtools", "magrittr", "DescTools","ggpubr","reshape", "pastecs", "ggplot2", "ggpubr", "tibble", "rstatix", "lme4","nlme"))

#disable scientific numbering
options(scipen=999)

#EMO_Delay_GROUP
setwd("~/Desktop/spook_n_play_data_for_processing/Chronos_19_01_2022/DAT")
colheaderChronos <-c("T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12","T13","T14","T15","T16","T17","T18","T19","T20","T21","T22","T23","T24","T25","T26","T27","T28","T29","T30","T31","T32","T33","T34","T35","T36","T37","T38","T39","T40","T41","T42","T43","T44","T45","T46","T47","T48","T49","T50","T51","T52","T53","T54")
GR<-c("G1","G2","G3","G4","G5","G6","G7","G8","G9","G10","G11","G12","G13","G14","G15")
colheaderChronosGR <-c("GROUP","PARTICIPANT..group_number.sound_order","ORDER","SEX","T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12","T13","T14","T15","T16","T17","T18","T19","T20","T21","T22","T23","T24","T25","T26","T27","T28","T29","T30","T31","T32","T33","T34","T35","T36","T37","T38","T39","T40","T41","T42","T43","T44","T45","T46","T47","T48","T49","T50","T51","T52","T53","T54")
dumP1a<- read_delim("SIMG_2P1.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
names(dumP1a)[6] <- "SYNCIX_P1"
dumP1<-select(dumP1a,1,2,3,4,6)
dumP2a<- read_delim("SIMG_2P2.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
names(dumP2a)[6] <- "ISI_P2"
dumP2<-select(dumP2a,2,3,6)
dumP3a<- read_delim("SIMG_2P3.csv", delim = ";", escape_double = FALSE, trim_ws = TRUE)
names(dumP3a)[6] <- "ISI_P3"
dumP3<-select(dumP3a,2,3,6)
dumP12=merge(dumP1, dumP2, by=c('TrialNr','ParticipantNr'))
dum=merge(dumP12, dumP3, by=c('TrialNr','ParticipantNr'))

ISI_2period<-data.frame(dum)
ISI_2period$EMO[ISI_2period$EMO==-1]="Negative"
ISI_2period$EMO[ISI_2period$EMO==0]="Neutral"
ISI_2period$EMO[ISI_2period$EMO==1]="Positive"
ISI_2period$EMO = factor(ISI_2period$EMO, levels=c("Negative", "Neutral", "Positive"))
ISI_2period$ParticipantNr= as.factor(ISI_2period$ParticipantNr)
ISI_2period$GrNr= as.factor(ISI_2period$GrNr)


SEX_EC<-read.csv(file="ID_SEX_EC.csv", sep = ";", header=TRUE)
SexEC=SEX_EC[,c("ParticipantNr","Sex","EC_sum_75")]

INDIE0=merge(ISI_2period,SexEC, by='ParticipantNr')
INDIE0$Sex = as.factor(INDIE0$Sex)
INDIE0$Sex = factor(INDIE0$Sex, levels=c("M", "F"))

INDIE=INDIE0[complete.cases(INDIE0), ]
myData = INDIE[INDIE$TrialNr > 1,]

#looking at the distribution of ISI P2 and ISI P3
df=myData
DV2=df$ISI_P2
fit.norm<-fitdist(DV2,'norm')
fit.wb<-fitdist(DV2,"weibull")
plot(fit.wb)
plot(fit.norm)
boxplot(DV2)$out

(plotdist(DV2, histo=TRUE, demp=TRUE, width=10))
descdist(DV2, boot=1000)
fw <- fitdist(DV2, "weibull")
summary(fw)
fg <- fitdist(DV2, "gamma")
fln <- fitdist(DV2, "lnorm")
par(mfrow = c(2, 2))
plot.legend <- c("Weibull", "lognormal", "gamma")
denscomp(list(fw, fln, fg), legendtext = plot.legend)
qqcomp(list(fw, fln, fg), legendtext = plot.legend)
cdfcomp(list(fw, fln, fg), legendtext = plot.legend)
ppcomp(list(fw, fln, fg), legendtext = plot.legend)


##LMER
options(contrasts = c("contr.sum","contr.poly"))

m_ISIP2<- lmer(ISI_P2 ~as.factor(relevel(EMO, ref="Neutral"))*EC_sum_75*Sex  + (1 | ParticipantNr), data=myData, REML=FALSE)
m_ISIP3<- lmer(ISI_P3 ~as.factor(relevel(EMO, ref="Neutral"))*EC_sum_75*Sex  + (1 | ParticipantNr), data=myData, REML=FALSE)

by(myData$ISI_P2, myData$Sex, stat.desc, basic = FALSE, norm = TRUE)
by(myData$ISI_P3, myData$Sex, stat.desc, basic = FALSE, norm = TRUE)


sjPlot::plot_model(m_ISIP2, axis.labels=c("Positive Induction*Emotional Contagion Scale*Sex", "Negative Induction*Emotional Contagion Scale*Sex", "Emotional Contagion Scale*Sex", "Positive induction*Sex", "Negative induction*Sex", "Positive induction * Emotional Contagion Scale", "Negative induction * Emotional Contagion Scale", "Sex", "Emotional Contagion Scale", "Positive induction", "Negative induction"),show.values=TRUE, show.p=TRUE,title="P2: Effect of Negative and Positive induction, Emotional Contagion Scale and Sex on the Synchronisation Index ")
sjPlot::plot_model(m_ISIP3, axis.labels=c("Positive Induction*Emotional Contagion Scale*Sex", "Negative Induction*Emotional Contagion Scale*Sex", "Emotional Contagion Scale*Sex", "Positive induction*Sex", "Negative induction*Sex", "Positive induction * Emotional Contagion Scale", "Negative induction * Emotional Contagion Scale", "Sex", "Emotional Contagion Scale", "Positive induction", "Negative induction"),show.values=TRUE, show.p=TRUE,title="P3: Effect of Negative and Positive induction, Emotional Contagion Scale and Sex on the Synchronisation Index ")

anova(m_ISIP2)
anova(m_ISIP3)

qqnorm(resid(m_ISIP2))
qqnorm(resid(m_ISIP3))
       


##### standard deviation of the OPA is higher for high pleasure trials ###
###regardless of pleasure rating, but in the robust correction does not show up due to heterscasity being violated

plotty <- ggplot(myData, aes(x=ISI_P2, y=EMO)) +
  geom_boxplot() +
  stat_summary(fun=mean, geom="point", shape=20, size=7, color="red", fill="red") +
  theme(legend.position="top") +
  scale_fill_brewer(palette="Set1") +
  #facet_wrap(~EMO)+
  theme(axis.title = element_text (size = 18 ,face="bold"),
        axis.text = element_text(size = 14), 
        strip.text.x = element_text(size = 18, face = "bold"))
print(plotty)

plotty <- ggplot(myData, aes(x=Sex, y=ISI_P2)) +
  geom_boxplot(alpha=0.7,outlier.colour = "blue", outlier.shape = 5, outlier.size = 4) +
  stat_summary(fun=mean, geom="point", shape=20, size=7, color="red", fill="red") +
  theme(legend.position="top") +
  scale_fill_brewer(palette="Set1") +
  theme(axis.title = element_text (size = 18 ,face="bold"),
        axis.text = element_text(size = 14), 
        strip.text.x = element_text(size = 18, face = "bold"))+
xlab("Sex") +   # x axis title
ylab("ISI_P2") 
print(plotty)


tab_model(
  m_ISIP2, 
  show.std = "std",
  vcov.fun = "CR", 
  vcov.type = "CR1", 
  vcov.args = list(cluster = myData$ParticipantNr))

tab_model(
  m_ISIP3, 
  show.std = "std",
  vcov.fun = "CR", 
  vcov.type = "CR1", 
  vcov.args = list(cluster = myData$ParticipantNr))



m_SP2effect<- lmer(ISI_P2 ~EMO:EC_sum_75:Sex  + (1 | ParticipantNr), data=myData, REML=FALSE)
m_SP3effect<- lmer(ISI_P3 ~EMO:EC_sum_75:Sex  + (1 | ParticipantNr), data=myData, REML=FALSE)
e3.lm1 <- predictorEffect("EC_sum_75", m_SP2effect)
plot(e3.lm1, lines=list(multiline=TRUE, col=c("springgreen4","palevioletred3")), confint=list(style="bars"), main = "Period 3: Predictor effect plot", xlab = "Emotional Contagion Score", ylab = "ISI", lattice=list(layout=c(3, 1)))

e3.lm2 <- predictorEffect("EC_sum_75", m_SP3effect)
plot(e3.lm2, lines=list(multiline=TRUE, col=c("springgreen4","palevioletred3")), confint=list(style="bars"), main = "Period 3: Predictor effect plot", xlab = "Emotional Contagion Score", ylab = "ISI", lattice=list(layout=c(3, 1)))
