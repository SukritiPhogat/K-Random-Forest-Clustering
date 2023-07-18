library(isotree)
library(cluster)

## Load and standardize the datasets

#1. Iris data 
irisData<-as.data.frame(iris)
irisData.class<-irisData$Species

irisData<-irisData[,c(1,2,3,4)]
irisData<-scale(irisData)

#2. Wine data
wineData <- read.csv("wine.data",header=TRUE,col.names =  
                      c("WineType","Alcohol","Malic_acid","Ash","Alcalinity_of_ash","Magnesium",
                       "Total_phenols","Flavanoids","Nonflavanoid_phenols","Proanthocyanins",
                       "Color_intensity","Hue","OD280/OD315_of_diluted_wines","Proline"))
wineData.class<-wineData$WineType

wineData<-wineData[,-1]
wineData<-scale(wineData)

## The Basic Version of K-RF Clustering Algorithm

# Inputs:X - data
#        Yinit - initial labellings
#        K - number of clusters
#        maxiter

# Output:A list of
#        Y - Final cluster assignments
#        iter - number of iterations required to converge
#        Energy - An optimization measure

kRandomForestsBasic <- function(X,Yinit,K,maxiter)
{
  ## Initialization
  
  t<-0 #iteration Counter 
  Energy<-0.0
  numberOfSamples<-nrow(X)
  
  Y<-Yinit
  membership<-matrix(1.0/K,nrow=n,ncol=K)
  membership<-as.data.frame(membership)
  
  
  while(t!=maxiter)
  {
      # Stop if already Converged
      if(t>0 && identical(Y[,t+1],Y[,t]))
        break;
    
      t<- t+1 #Update
      
      for(k in 1:K)
      {
        #Find which points were assigned to this cluster k in previous iteration
        Z<-as.data.frame(Y[,t])
        Xk<-X[Z[,1]==k,]
        
        #Also find the closest outlier
        x0<-X[1,]
        memb<-0.0
        for(i in 1:n)
        {
          if(!Z[i,1]==k && membership[i,k]>=memb)
          {
            memb<-membership[i,k]
            x0<-X[i,]
          }
        }
        
        Xk<-rbind(Xk,x0)
        isoForestmodel<-isolation.forest(Xk, output_score=TRUE, output_dist=TRUE,max_depth=NULL)
        
        #Calculate membership scores
        anomaly_scores<-predict(isoForestmodel$model,X,type='score')
        membership[,k]<-1-anomaly_scores
      }
      
      # Update cluster assignments and Energy
      Y<-cbind(Y,rep(0,n))
      E=0.0
      
      for(i in 1:n)
      {
         Y[i,t+1]=which.max(membership[i,])
         E=E+ (max(membership[i,]) / sum(membership[i,]))
      }
  } 
  
  Result<-list("Y"=Y[t],"iter"=t,"Energy"=E)
  
  return(Result)
  
}

## Calling the Function

# 1.IRIS
K<-3
n<-nrow(irisData)
n1<-n/3
n2<-(2*n)/3
Yinit1<-rep(3,n)
for(i in 1:n1) Yinit1[i]=1
for(i in n1:n2) Yinit1[i]=2
Yinit1<-as.data.frame(Yinit1)

irisData.Result<-kRandomForestsBasic(irisData,Yinit1,K,15)

table(irisData.class)
table(irisData.Result$Y)

irisData.Result$Y<-unlist(irisData.Result$Y)
clusplot(irisData,irisData.class,main="Iris Species Actual")
clusplot(irisData,irisData.Result$Y,main="Clustering Result on IrisData")

irisData.Result$Energy
irisData.Result$iter

# 2.WINE
K<-3
n<-nrow(wineData)
n1<-n/3
n2<-(2*n)/3
Yinit2<-rep(3,n)
for(i in 1:n1) Yinit2[i]=1
for(i in n1:n2) Yinit2[i]=2
Yinit2<-as.data.frame(Yinit2)

wineData.Result<-kRandomForestsBasic(wineData,Yinit2,K,15)
table(wineData.class)
table(wineData.Result$Y)

wineData.Result$Y<-unlist(wineData.Result$Y)
clusplot(wineData,wineData.class,main="Wine Types Actual")
clusplot(wineData,wineData.Result$Y,main="Clustering Result on WineData")

wineData.Result$Energy
wineData.Result$iter