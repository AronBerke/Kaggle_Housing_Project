getwd()
setwd("/Users/aronberke/Desktop/ML_Project_copy/data")
df_train = read.csv('AronCleaned.csv')
library(dplyr)
library(car)

#evaluate impact on mosold, yrsold, and porch, pool, and deck binaries on log SalePrice

df_train$MoSold <- as.factor(df_train$MoSold)
model.saturated = lm(log(SalePrice) ~ X3SsnPorch+EnclosedPorch+OpenPorchSF+
                       PoolArea+ScreenPorch+WoodDeckSF+YrSold+
                       MoSold, data = df_train)
summary(model.saturated)
plot(model.saturated)

vif(model.saturated)
model.saturated$fitted.values

#evaluate impact on mosold, yrsold, and porch, pool, and deck continuous on log SalePrice

df_train2 = read.csv('train.csv')
df_train2$MoSold <- as.factor(df_train2$MoSold)

model.saturated2 = lm(log(SalePrice) ~ X3SsnPorch+EnclosedPorch+OpenPorchSF+
                       PoolArea+ScreenPorch+WoodDeckSF+YrSold+
                       MoSold, data = df_train2)

summary(model.saturated2)
plot(model.saturated2)

vif(model.saturated2)

#put in overall quality to test impact of adding something more continuous
model.saturated3 = lm(log(SalePrice) ~ X3SsnPorch+EnclosedPorch+OpenPorchSF+
                       PoolArea+ScreenPorch+WoodDeckSF+YrSold+OverallQual+OverallCond+
                       MoSold, data = df_train)
summary(model.saturated3)
plot(model.saturated3)
vif(model.saturated3)

#create a reduced model and compare with saturated
model.reduced = lm(log(SalePrice) ~ X3SsnPorch+EnclosedPorch+OpenPorchSF+
                     ScreenPorch+WoodDeckSF+OverallQual+OverallCond, data = df_train)
summary(model.reduced)
plot(model.reduced)
anova(model.reduced,model.saturated3)

