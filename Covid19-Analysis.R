01-# cleaned up death column
02-## AGE # claim: people who die are older
03-# Statistical significance test in 95% confidence label
04-# confidence label , P- value analysis
05-##Gende # Claim - Gender has no effect
06-#Statistical significance test in 99% confidence label
07-# confidence label , P- value analysis

------------------------ xxx ------------------------------------
------------------------ xxx ------------------------------------

rm(list = ls())
library(Hmisc)
data <- read.csv("C:/Users/Jahid/Downloads/COVID19_line_list_data.csv")
describe(data)

# cleaned up death column
sum(data$death_dummy) / nrow(data)

# AGE
# claim: people who die are older
dead = subset(data,death_dummy == 1)
alive = subset(data,death_dummy == 0)
mean(dead $age, na.rm = TRUE)
mean(alive $age, na.rm = TRUE)

# is this statistically significant?
t.test(alive$age, dead$age, alternative ="two.sided",conf.level = 0.95)
# normally, if p-value < 0.05, we reject null hypothesis
# here, p-value ~ 0, so we reject the null hypothesis and 
# conclude that this is statistically significant


#Gender
# Claim - Gender has no effect
men = subset(data,gender == "male")
women = subset(data,gender == "female")
mean(men $death_dummy, na.rm = TRUE)
mean(women $death_dummy, na.rm = TRUE)

# is this statistically significant?
t.test(men $death_dummy, women $death_dummy, alternative ="two.sided",conf.level = 0.99)

# 99% confidence: men have from 0.8% to 8.8% higher chance
# of dying.
# p-value = 0.002 < 0.05, so this is statistically
# significant

