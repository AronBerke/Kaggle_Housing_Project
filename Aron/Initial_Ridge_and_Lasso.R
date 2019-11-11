getwd()
setwd("/Users/aronberke/Desktop/ML_Project_copy/data")
housing = read.csv('Version_5_df.csv')
housing2 = read.csv('Version_4_df.csv')

#format dataset for modeling
housing = housing[-1460,]
housing = cbind(housing, housing2$TotalSF)
housing$MoSold = as.factor(housing$MoSold)
X = model.matrix(SalePrice ~ ., housing)[,-c(1,2)]
y = housing$SalePrice

# ridge ----

#develop initial full ridge model and select best alpha with cross validation
grid = 10^seq(5, -2, length = 100)
initial.ridge = glmnet(X, y, alpha = 0, lambda = grid)
plot(initial.ridge, xvar = "lambda", label = TRUE, main = "Ridge Regression")


library(glmnet)
library(dplyr)

set.seed(0)
cv.ridge.out = cv.glmnet(X, y, alpha = 0, nfolds = 10, lambda = grid)
plot(cv.ridge.out, main = "Ridge Regression\n")

bestlambda.ridge = cv.ridge.out$lambda.min
bestlambda.ridge

#Re-run model with best lambda
ridge_best_refit = glmnet(X,y, alpha=0, lambda = bestlambda.ridge)

#check MSE 
ridge_best_predicted = predict(ridge_best_refit, s = bestlambda.ridge, newx = X)
MSE1 = mean((ridge_best_predicted - y)^2)
MSE1

#expoenentialized RMSD - this should basically reflect the average error of the model in $
sqrt(mean((exp(ridge_best_predicted)-exp(y))^2))

#check coefficients
coefs1 = data.frame(coef(ridge_best_refit)[,1])
coefs1=rename(.data = coefs1, 'coefs' =  'coef.ridge_best_refit....1.')
coefs1 = mutate(coefs1, var=rownames(coefs1))
coefs1 = mutate(coefs1, sign = ifelse(coefs > 0,'pos','neg'))
coefs1 = mutate(coefs1, coefs=abs(coefs))
arrange(coefs1, desc(coefs))

# lasso ----

#develop initial full ridge model and select best alpha with cross validation
grid2 = 10^seq(4, -3, length = 100)
initial.lasso = glmnet(X, y, alpha = 1, lambda = grid2)
plot(initial.lasso, xvar = "lambda", label = TRUE, main = "Ridge Regression")


set.seed(0)
cv.lasso.out = cv.glmnet(X, y, alpha = 1, nfolds = 10, lambda = grid2)
plot(cv.lasso.out, main = "Ridge Regression\n")

bestlambda.lasso = cv.lasso.out$lambda.min
bestlambda.lasso

#Re-run model with best lambda
lasso_best_refit = glmnet(X,y, alpha=0, lambda = bestlambda.lasso)

#check MSE 
lasso_best_predicted = predict(lasso_best_refit, s = bestlambda.lasso, newx = X)
MSE2 = mean((lasso_best_predicted - y)^2)
MSE2

#expoenentialized RMSD - this should basically reflect the average error of the model in $
sqrt(mean((exp(lasso_best_predicted)-exp(y))^2))

#check coefficients
coefs2 = data.frame(coef(lasso_best_refit)[,1])
coefs2=rename(.data = coefs2, 'coefs' =  'coef.lasso_best_refit....1.')
coefs2 = mutate(coefs2, var=rownames(coefs2))
coefs2 = mutate(coefs2, sign = ifelse(coefs > 0,'pos','neg'))
coefs2 = mutate(coefs2, coefs=abs(coefs))
arrange(coefs2, desc(coefs))

#compare models
MSE1
MSE2


