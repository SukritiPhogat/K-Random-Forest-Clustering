# K-Random-Forest-Clustering
This repository contains an R implementation of the K Random Forest Clustering algorithm, a K-means style algorithm for clustering based on Random Forests. The algorithm is based on the research paper by M. Bicego titled "K-Random Forests: a K-means style algorithm for Random Forest clustering," presented at the 2019 IJCNN in Budapest, Hungary.  
## Introduction
The K Random Forest Clustering algorithm combines the concepts of Random Forests and K-means clustering to provide a powerful and effective approach for clustering data. The algorithm utilizes multiple Isolation Forests (or single class Random Forests) to represent the clusters, which are iteratively updated using a K-means style algorithm.
## How Random Forest Clustering works
1. Initialization: The algorithm starts by randomly assigning data points to clusters.
2. Random Forest Construction: For each cluster, a Random Forest is constructed using the data points assigned to that cluster plus one closest outlier. The Random forest algorithm is run in unsupervised mode, which produces a distance metric.
3. Cluster assignment update: Membership scores are calculated from the distance metrics given by previous step. A point is assigned to a cluster in which it has the max membership score.
4. Repeat 2 and 3 till convergence or max iterations specified.
## Research paper reference
M. Bicego, "K-Random Forests: a K-means style algorithm for Random Forest clustering," 2019 International Joint Conference on Neural Networks (IJCNN), Budapest, Hungary, 2019, pp. 1-8, doi: 10.1109/IJCNN.2019.8851820.
