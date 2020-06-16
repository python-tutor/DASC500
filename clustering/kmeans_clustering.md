



As we don’t want the clustering algorithm to depend to an arbitrary variable unit, we start by scaling/standardizing the data using the R function `scale`:




The choice of distance measures is very important, as it has a strong influence on the clustering results. For most common clustering software, the default distance measure is the Euclidean distance.  However, depending on the type of the data and the research questions, other dissimilarity measures might be preferred and you should be aware of the options.

Within R it is simple to compute and visualize the distance matrix using the functions `get_dist` and `fviz_dist` from the `factoextra` R package.  This starts to illustrate which states have large dissimilarities (red) versus those that appear to be fairly similar (teal).

- `get_dist`: for computing a distance matrix between the rows of a data matrix. The default distance computed is the Euclidean; however, `get_dist` also supports distanced described in equations 2-5 above plus others.
- `fviz_dist`: for visualizing a distance matrix



## K-Means Clustering {#kmeans}

K-means clustering is the most commonly used unsupervised machine learning algorithm for partitioning a given data set into a set of *k* groups (i.e. *k* clusters), where *k* represents the number of groups pre-specified by the analyst. It classifies objects in multiple groups (i.e., clusters), such that objects within the same cluster are as similar as possible (i.e., high intra-class similarity), whereas objects from different clusters are as dissimilar as possible (i.e., low inter-class similarity). In k-means clustering, each cluster is represented by its center (i.e, centroid) which corresponds to the mean of points assigned to the cluster.

### The Basic Idea

The basic idea behind k-means clustering consists of defining clusters so that the total intra-cluster variation (known as total within-cluster variation) is minimized. There are several k-means algorithms available. The standard algorithm is the
Hartigan-Wong algorithm (1979), which defines the total within-cluster variation as the sum of squared distances Euclidean distances between items and the corresponding centroid:

$$W(C_k) = \sum_{x_i \in C_k}(x_i - \mu_k)^2 \tag{6}$$

where:

- $$x_i$$ is a data point belonging to the cluster $$C_k$$
- $$\mu_k$$ is the mean value of the points assigned to the cluster $$C_k$$

Each observation ($$x_i$$) is assigned to a given cluster such that the sum of squares (SS) distance of the observation to their assigned cluster centers ($$\mu_k$$) is minimized.

We define the total within-cluster variation as follows:

$$tot.withiness = \sum^k_{k=1}W(C_k) = \sum^k_{k=1}\sum_{x_i \in C_k}(x_i - \mu_k)^2 \tag{7} $$

The *total within-cluster sum of square* measures the compactness (i.e goodness) of the clustering and we want it to be as small as possible.

### K-means Algorithm

The first step when using k-means clustering is to indicate the number of clusters (k) that will be generated in the final solution.  The algorithm starts by randomly selecting k objects from the data set to serve as the initial centers for the clusters. The selected objects are also known as cluster means or centroids. Next, each of the remaining objects is assigned to it’s closest centroid, where closest is defined using the Euclidean distance (Eq. 1) between the object and the cluster
mean. This step is called “cluster assignment step”. After the assignment step, the algorithm computes the new mean value of each cluster. The term cluster “centroid update” is used to design this step. Now that the centers have been recalculated, every observation is checked again to see if it might be closer to a different cluster. All the objects are reassigned again using the updated cluster means.  The cluster assignment and centroid update steps are iteratively repeated until the
cluster assignments stop changing (i.e until *convergence* is achieved). That is, the clusters formed in the current iteration are the same as those obtained in the previous iteration.

K-means algorithm can be summarized as follows:

1. Specify the number of clusters (K) to be created (by the analyst)
2. Select randomly k objects from the data set as the initial cluster centers or means
3. Assigns each observation to their closest centroid, based on the Euclidean distance between the object and the centroid
4. For each of the k clusters update the cluster centroid by calculating the new mean values of all the data points in the cluster. The centroid of a Kth cluster is a vector of length *p* containing the means of all variables for the observations
in the kth cluster; *p* is the number of variables.
5. Iteratively minimize the total within sum of square (Eq. 7). That is, iterate steps 3 and 4 until the cluster assignments stop changing or the maximum number of iterations is reached. By default, the R software uses 10 as the default value
for the maximum number of iterations.

### Computing k-means clustering in R

We can compute k-means in R with the `kmeans` function. Here will group the data into two clusters (`centers = 2`). The `kmeans` function also has an `nstart` option that attempts multiple initial configurations and reports on the best one. For example, adding `nstart = 25` will generate 25 initial configurations. This approach is often recommended. 



The output of `kmeans` is a list with several bits of information.  The most important being:

- `cluster`: A vector of integers (from 1:k) indicating the cluster to which each point is allocated.
- `centers`: A matrix of cluster centers.
- `totss`: The total sum of squares.
- `withinss`: Vector of within-cluster sum of squares, one component per cluster.
- `tot.withinss`: Total within-cluster sum of squares, i.e. sum(withinss).
- `betweenss`: The between-cluster sum of squares, i.e. $totss-tot.withinss$.
- `size`: The number of points in each cluster.

If we print the results we'll see that our groupings resulted in 2 cluster sizes of 30 and 20.  We see the cluster centers (means) for the two groups across the four variables (*Murder, Assault, UrbanPop, Rape*). We also get the cluster assignment for each observation (i.e. Alabama was assigned to cluster 2, Arkansas was assigned to cluster 1, etc.).  



We can also view our results by using `fviz_cluster`.  This provides a nice illustration of the clusters.  If there are more than two dimensions (variables) `fviz_cluster` will perform principal component analysis (PCA) and plot the data points according to the first two principal components that explain the majority of the variance.



Alternatively, you can use standard pairwise scatter plots to illustrate the clusters compared to the original variables.



Because the number of clusters (k) must be set before we start the algorithm, it is often advantageous to use several different values of k and examine the differences in the results. We can execute the same process for 3, 4, and 5 clusters, and the results are shown in the figure:



Although this visual assessment tells us where true dilineations occur (or do not occur such as clusters 2 & 4 in the k = 5 graph) between clusters, it does not tell us what the optimal number of clusters is.

## Determining Optimal Clusters {#optimal}

As you may recall the analyst specifies the number of clusters to use; preferably the analyst would like to use the optimal number of clusters.  To aid the analyst, the following explains the three most popular methods for determining the optimal clusters, which includes: 

1. [Elbow method](#elbow)
2. [Silhouette method](#silo)
3. [Gap statistic](#gap)

### Elbow Method {#elbow}

Recall that, the basic idea behind cluster partitioning methods, such as k-means clustering, is to define clusters such that the total intra-cluster variation (known as total within-cluster variation or total within-cluster sum of square) is minimized:

$$ minimize\Bigg(\sum^k_{k=1}W(C_k)\Bigg) \tag{8}$$

where $$C_k$$ is the $$k^{th}$$ cluster and $$W(C_k)$$ is the within-cluster variation. The total within-cluster sum of square (wss) measures the compactness of the clustering and we want it to be as small as possible.  Thus, we can use the following algorithm to define the optimal clusters:

1. Compute clustering algorithm (e.g., k-means clustering) for different values of *k*. For instance, by varying *k* from 1 to 10 clusters
2. For each *k*, calculate the total within-cluster sum of square (wss)
3. Plot the curve of wss according to the number of clusters *k*.
4. The location of a bend (knee) in the plot is generally considered as an indicator of the appropriate number of clusters.

We can implement this in R with the following code.  The results suggest that 4 is the optimal number of clusters as it appears to be the bend in the knee (or elbow). 



Fortunately, this process to compute the "Elbow method" has been wrapped up in a single function (`fviz_nbclust`):



### Average Silhouette Method {#silo}

In short, the average silhouette approach measures the quality of a clustering. That is, it determines how well each object lies within its cluster. A high average silhouette width indicates a good clustering. The average silhouette method computes the average silhouette of observations for different values of *k*. The optimal number of clusters *k* is the one that maximizes the average silhouette over a range of possible values for *k*.[^kauf]  

We can use the `silhouette` function in the cluster package to compuate the average silhouette width. The following code computes this approach for 1-15 clusters.  The results show that 2 clusters maximize the average silhouette values with 4 clusters coming in as second optimal number of clusters.



Similar to the elbow method, this process to compute the "average silhoutte method" has been wrapped up in a single function (`fviz_nbclust`):


### Gap Statistic Method {#gap}

The gap statistic has been published by [R. Tibshirani, G. Walther, and T. Hastie (Standford University, 2001)](http://web.stanford.edu/~hastie/Papers/gap.pdf). The approach can be applied to any clustering method (i.e. K-means clustering, hierarchical clustering).  The gap statistic compares the total intracluster variation for different values of *k* with their expected values under null reference distribution of the data (i.e. a distribution with no obvious clustering).  The reference dataset is generated using Monte Carlo simulations of the sampling process. That is, for each variable ($$x_i$$) in the data set we compute its range $$[min(x_i), max(x_j)]$$ and generate values for the n points uniformly from the interval min to max.

For the observed data and the the reference data, the total intracluster variation is computed using different values of *k*. The *gap statistic* for a given *k* is defined as follow:

$$ Gap_n(k) = E^*_n{log(W_k)} - log(W_k) \tag{9}$$

Where $$E^*_n$$ denotes the expectation under a sample size *n* from the reference distribution. $$E^*_n$$ is defined via bootstrapping (B) by generating B copies of the reference datasets and, by computing the average $$log(W^*_k)$$.  The gap statistic measures the deviation of the observed $$W_k$$ value from its expected value under the null hypothesis.  The estimate of the optimal clusters ($$\hat k$$) will be the value that maximizes $$Gap_n(k)$$. This means that the clustering structure is far away from the uniform distribution of points.

In short, the algorithm involves the following steps:

1. Cluster the observed data, varying the number of clusters from $$k=1, \dots, k_{max}$$, and compute the corresponding $$W_k$$.
2. Generate B reference data sets and cluster each of them with varying number of clusters $$k=1, \dots, k_{max}$$. Compute the estimated gap statistics presented in eq. 9.
3. Let $$\bar w = (1/B) \sum_b log(W^*_{kb})$$, compute the standard deviation $$sd(k) = \sqrt{(1/b)\sum_b(log(W^*_{kb})- \bar w)^2}$$ and define $$s_k = sd_k \times \sqrt{1 + 1/B}$$.
4. Choose the number of clusters as the smallest k such that $$Gap(k) \geq Gap(k+1) - s_{k+1}$$.

To compute the gap statistic method we can use the `clusGap` function which provides the gap statistic and standard error for an output.




We can visualize the results with `fviz_gap_stat` which suggests four clusters as the optimal number of clusters.



<img src="/public/images/analytics/clustering/kmeans/unnamed-chunk-16-1.png" style="display: block; margin: auto;" />

In addition to these commonly used approaches, the `NbClust` package, published by [Charrad et al., 2014](http://www.jstatsoft.org/v61/i06/paper), provides 30 indices for determining the relevant number of clusters and proposes to users the best clustering scheme from the different results obtained by varying all combinations of number of clusters, distance measures, and clustering methods.

### Extracting Results

With most of these approaches suggesting 4 as the number of optimal clusters, we can perform the final analysis and extract the results using 4 clusters.  



We can visualize the results using `fviz_cluster`:



And we can extract the clusters and add to our initial data to do some descriptive statistics at the cluster level:



## Additional Comments

K-means clustering is a very simple and fast algorithm. Furthermore, it can efficiently deal with very large data sets.  However, there are some weaknesses of the k-means approach.

One potential disadvantage of K-means clustering is that it requires us to pre-specify the number of clusters. Hierarchical clustering is an alternative approach which does not require that we commit to a particular choice of clusters. Hierarchical clustering has an added advantage over K-means clustering in that it results in an attractive tree-based representation of the observations, called a dendrogram. A future tutorial will illustrate the hierarchical clustering approach.

An additional disadvantage of K-means is that it's sensitive to outliers and different results can occur if you change the ordering of your data. The Partitioning Around Medoids (PAM) clustering approach is less sensititive to outliers and provides a robust alternative to k-means to deal with these situations. A future tutorial will illustrate the PAM clustering approach. 

For now, you can learn more about clustering methods with:

- [An Introduction to Statistical Learning](http://www-bcf.usc.edu/~gareth/ISL/)
- [Applied Predictive Modeling](http://appliedpredictivemodeling.com/)
- [Elements of Statistical Learning](https://statweb.stanford.edu/~tibs/ElemStatLearn/)
- [A Practical Guide to Cluster Analysis in R](https://www.amazon.com/Practical-Guide-Cluster-Analysis-Unsupervised/dp/1542462703/ref=sr_1_1?ie=UTF8&qid=1493169647&sr=8-1&keywords=practical+guide+to+cluster+analysis)






[^scale]: Standardization makes the four distance measure methods - Euclidean, Manhattan, Correlation and Eisen - more similar than they would be with non-transformed data.
[^kauf]: [Kaufman and Rousseeuw, 1990](http://onlinelibrary.wiley.com/book/10.1002/9780470316801)
