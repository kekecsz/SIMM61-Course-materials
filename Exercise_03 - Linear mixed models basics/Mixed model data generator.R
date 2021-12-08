library(psych) # for describe

##################################################################
#         Generate data for random intercept and slope           #
##################################################################

# Data gneeration script for the mixed effects lecture
# study on bullying

nobs = 160
nclass = 8
rnd_int = T
rnd_slope = T
test_score_pre = rnorm(mean = 7, sd = 2, n = nobs)
if(rnd_int == T){class_effect_int = rep(rnorm(mean = 0, sd = 4, n = nclass), each = nobs/nclass)} else {class_effect_int = 0}
if(rnd_slope == T){class_effect_slope = rep(rnorm(mean = 1, sd = 2, n = nclass), each = nobs/nclass)} else {class_effect_slope = 1}
class_vect = rep(1:nclass, each = nobs/nclass)
IQ = ((-1*test_score_pre) + rnorm(mean = 0, sd = 15, n = nobs) + 110)
test_score = test_score_pre * class_effect_slope + class_effect_int
data = as.data.frame(cbind(test_score, IQ, class_vect))
names(data) = c("test_score", "IQ", "class")
data$class = factor(data$class)
describe(data)

write.csv(data, "C:\\Users\\User\\Dropbox\\Lund\\_Teaching\\PSYP13 Advanced Scientific Methods in Psychology\\2017\\Subcourse 1 - Data Analysis with R\\R codes\\sandwich_taken_slope.csv", row.names = F)




##################################################################
#            Generate data  for repeated measures                #
##################################################################


# number of observations to simulate
n_population = 1000000
n_obs = 60

variables = c("day_1",	"day_2", "day_3",	"day_4", "day_5",	"day_6",	"day_7",	"distance_window",	"location")
predictors = variables[-c(which(variables %in% c("day_1",	"day_2", "day_3",	"day_4", "day_5",	"day_6",	"day_7")))]
variables_with_ID = c("ID", variables)
predictors_with_ID = c("ID", predictors)

M = matrix(c(1, 0.9, 0.8, 0.7, 0.6, 0.5, 0.4, -0.3, -0.2, 
             0.9, 1, 0.9, 0.8, 0.7, 0.6, 0.5, -0.3, -0.2, 
             0.8, 0.9, 1, 0.9, 0.8, 0.7, 0.6, -0.3, -0.2, 
             0.7, 0.8, 0.9, 1, 0.9, 0.8, 0.7, -0.3, -0.2, 
             0.6, 0.7, 0.8, 0.9, 1, 0.9, 0.8, -0.3, -0.2, 
             0.5, 0.6, 0.7, 0.8, 0.9, 1, 0.9, -0.3, -0.2, 
             0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1, -0.3, -0.2, 
             -0.3, -0.3, -0.3, -0.3, -0.3, -0.3, -0.3, 1, 0, 
             -0.2, -0.2, -0.2, -0.2, -0.2, -0.2, -0.2, 0, 1), nrow=length(variables), ncol=length(variables))






# Cholesky decomposition
L = chol(M)
nvars = dim(L)[1]

# R chol function produces an upper triangular version of L
# so we have to transpose it.
# Just to be sure we can have a look at t(L) and the
# product of the Cholesky decomposition by itself

t(L)


t(L) %*% L


# Random variables that follow an M correlation matrix
r = t(L) %*% matrix(rnorm(nvars*n_population, mean = 0, sd = 1), nrow=nvars, ncol=n_population)
r = t(r)













###########################################################
#                  Data for assignment 1                  #
###########################################################





sample_1 = sample(1:n_population, n_obs)

participant_ID = as.data.frame(paste("ID_", 1:n_obs, sep = ""))
rdata_sample_1 = cbind(participant_ID, as.data.frame(r[sample_1,]))
names(rdata_sample_1) = variables_with_ID

# Plotting and basic stats
cor(rdata_sample_1[,variables])



data_sample_1 = rdata_sample_1

data_sample_1$day_1 = round(rdata_sample_1$day_1*1.5+9, 2)
data_sample_1$day_2 = round(rdata_sample_1$day_2*1.5+6, 2)
data_sample_1$day_3 = round(rdata_sample_1$day_3*1.5+4, 2)
data_sample_1$day_4 = round(rdata_sample_1$day_4*1.5+3.5, 2)
data_sample_1$day_5 = round(rdata_sample_1$day_5*1.5+3, 2)
data_sample_1$day_6 = round(rdata_sample_1$day_6*1.5+2.75, 2)
data_sample_1$day_7 = round(rdata_sample_1$day_7*1.5+2.5, 2)
data_sample_1$location = as.numeric(rdata_sample_1$location>0)
data_sample_1$distance_window = round(rdata_sample_1$distance_window*5+15,2)
data_sample_1[data_sample_1[,"location"] == 0,"location"] = "north_wing"
data_sample_1[data_sample_1[,"location"] == 1,"location"] = "south_wing"

describe(data_sample_1[,-which(names(data_sample_1) == "location")])
table(data_sample_1[,which(names(data_sample_1) == "location")])


write.csv(data_sample_1, "C:\\Users\\kekec\\Dropbox\\ELTE\\Teaching\\Statisztika Gyakorlat - BA\\2020 osz\\Seminar_10\\data_woundhealing_repeated.csv", row.names = F)
