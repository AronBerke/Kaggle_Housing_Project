library(dplyr)
install.packages('fastDummies')
library(fastDummies)

getwd()
setwd("/Users/aronberke/Desktop/ML_Project_Copy/data")

df = read.csv('standardized_undummified_baseline_df.csv')

nominal_var=c('MSZoning','Street','Alley','LotShape','LandContour','LotConfig','LandSlope',
              'Neighborhood','Condition1','Condition2','BldgType','HouseStyle','RoofStyle','RoofMatl',
              'Exterior1st','Exterior2nd','MasVnrType','Foundation',
              'BsmtFinType1','Heating','CentralAir',
              'Electrical','Functional','GarageType','GarageFinish',
              'PavedDrive','Fence','MiscFeature','SaleType','SaleCondition','MSSubClass', 'SalePrice')

sparse_vars = c('MSZoning','Street','LotShape','LandContour','LotConfig','LandSlope',
                'Neighborhood', 'Condition1','Condition2','HouseStyle','RoofStyle',
                'RoofMatl','Exterior1st','Exterior2nd','MasVnrType','Foundation','Heating',
                'Electrical','Functional','GarageType','Fence','SaleType','SaleCondition',
                'MSSubClass')

#select dataframe of only nominal variables and SalePrice, then scale SalePrice
df = select(df,nominal_var)
df$SalePrice=scale(df$SalePrice)

#define function to look at number of clusters vs w/in cluster variance
wssplot = function(data, nc = 15, seed = 0) {
  wss = (nrow(data) - 1) * sum(apply(data, 2, var))
  for (i in 2:nc) {
    set.seed(seed)
    wss[i] = sum(kmeans(data, centers = i, iter.max = 100, nstart = 100)$withinss)
  }
  plot(1:nc, wss, type = "b",
       xlab = "Number of Clusters",
       ylab = "Within-Cluster Variance",
       main = "Scree Plot for the K-Means Procedure")
}

#create list of data frames with 1 nominal variable dummified vs. SalePrice
dummy_frames = list()

for(i in 1:length(sparse_vars)){
  temp = select(df, sparse_vars[i], SalePrice)
  temp = dummy_cols(temp, sparse_vars[i])[,-1]
  dummy_frames[[i]] = temp
}

#plot var/clusters tradeoff and manully record 'elbow' in each graph
wssplot(dummy_frames[[0]])

num_cluster = c(6,4,6,5,5,4,3,5,4,5,5,4,3,3,5,6,4,5,4,4,4,5,6,4)

#create list of k means models with optimal clustering
kmeans_models = list()

for(i in 1:length(dummy_frames)){
  temp = kmeans(dummy_frames[[i]], centers = num_cluster[i])
  kmeans_models[[i]] = temp
}

#replace variable groups with cluster designation
for(i in 1:length(sparse_vars)){
  df[,sparse_vars[i]] = kmeans_models[[i]]$cluster
}

#read out dataframe
df = select(df, -SalePrice)

cnames = colnames(df)
cnames

a = rep(1,nrow(df))
df2=data.frame(a)

for(col in cnames){
  temp = select(df,col)
  temp = dummy_cols(temp, col, remove_most_frequent_dummy = TRUE)[,-1]
  df2 = cbind(df2,temp)
}

df2=df2[,-1]

write.csv(df2, 'clustered_dummies2.csv')


