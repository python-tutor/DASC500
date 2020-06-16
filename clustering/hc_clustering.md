
In the [k-means cluster analysis tutorial](kmeans_clustering) I provided a solid introduction to one of the most popular clustering methods. 



## Hierarchical Clustering Algorithms {#algorithms}







## Hierarchical Clustering with R {#kmeans}

There are different functions available in R for computing hierarchical clustering. The commonly used functions are:

- `hclust` [in stats package] and `agnes` [in cluster package] for agglomerative hierarchical clustering (HC)
- `diana` [in cluster package] for divisive HC

### Agglomerative Hierarchical Clustering

We can perform agglomerative HC with `hclust`.  First we compute the dissimilarity values with `dist` and then feed these values into `hclust` and specify the agglomeration method to be used (i.e. "complete", "average", "single", "ward.D").  We can then plot the dendrogram.



Alternatively, we can use the `agnes` function.  These functions behave very similarly; however, with the `agnes` function you can also get the agglomerative coefficient, which measures the amount of clustering structure found (values closer to 1 suggest strong clustering structure).



This allows us to find certain hierarchical clustering methods that can identify stronger clustering structures.  Here we see that Ward's method identifies the strongest clustering structure of the four methods assessed.




Similar to before we can visualize the dendrogram:



### Divisive Hierarchical Clustering

The R function `diana` provided by the cluster package allows us to perform divisive hierarchical clustering. `diana` works similar to `agnes`; however, there is no method to provide.



## Working with Dendrograms {#dendro}

In the dendrogram displayed above, each leaf corresponds to one observation. As we move up the tree, observations that are similar to each other are combined into branches, which are themselves fused at a higher height.

The height of the fusion, provided on the vertical axis, indicates the (dis)similarity between two observations. The higher the height of the fusion, the less similar the observations are.  __*Note that, conclusions about the proximity of two observations can be drawn only based on the height where branches containing those two observations first are fused. We cannot use the proximity of two observations along the horizontal axis as a criteria of their similarity.*__ 

The height of the cut to the dendrogram controls the number of clusters obtained. It plays the same role as the k in k-means clustering. In order to identify sub-groups (i.e. clusters), we can cut the dendrogram with `cutree`:



We can also use the `cutree` output to add the the cluster each observation belongs to to our original data.



It’s also possible to draw the dendrogram with a border around the 4 clusters. The argument border is used to specify the border colors for the rectangles:


As we saw in the [k-means tutorial](#kmeans_clustering), we can also use the `fviz_cluster` function from the `factoextra` package to visualize the result in a scatter plot.



To use `cutree` with `agnes` and `diana` you can perform the following:


Lastly, we can also compare two dendrograms.  Here we compare hierarchical clustering with complete linkage versus Ward's method. The function `tanglegram` plots two dendrograms, side by side, with their labels connected by lines. 



The output displays “unique” nodes, with a combination of labels/items not present in the other tree, highlighted with dashed lines.  The quality of the alignment of the two trees can be measured using the function `entanglement`. Entanglement is a measure between 1 (full entanglement) and 0 (no entanglement). A lower entanglement coefficient corresponds to a good alignment.  The output of `tanglegram` can be customized using many other options as follow:


## Determining Optimal Clusters {#optimal}

Similar to how we [determined optimal clusters with k-means clustering](kmeans_clustering#optimal), we can execute similar approaches for hierarchical clustering:

### Elbow Method

To perform the [elbow method](kmeans_clustering#elbow) we just need to change the second argument in `fviz_nbclust` to `FUN = hcut`. 




### Average Silhouette Method

To perform the [average silhouette method](kmeans_clustering#silo) we follow a similar process. 



### Gap Statistic Method

And the process is quite similar to perform the [gap statistic method](kmeans_clustering#gap).



## Additional Comments

Clustering can be a very useful tool for data analysis in the unsupervised setting. However, there are a number of issues that arise in performing clustering. In the case of hierarchical clustering, we need to be concerned about:

- What dissimilarity measure should be used?
- What type of linkage should be used?
- Where should we cut the dendrogram in order to obtain clusters?

Each of these decisions can have a strong impact on the results obtained. In practice, we try several different choices, and look for the one with the most useful or interpretable solution. With these methods, there is no single right answer - any solution that exposes some interesting aspects of the data should be considered.

So, keep in mind that although hierarchical clustering can be performed quickly in R, there are many important variables to consider.  However, this tutorial gets you started performing the hierarchical clustering approach and you can learn more with:

- [An Introduction to Statistical Learning](http://www-bcf.usc.edu/~gareth/ISL/)
- [Applied Predictive Modeling](http://appliedpredictivemodeling.com/)
- [Elements of Statistical Learning](https://statweb.stanford.edu/~tibs/ElemStatLearn/)
- [A Practical Guide to Cluster Analysis in R](https://www.amazon.com/Practical-Guide-Cluster-Analysis-Unsupervised/dp/1542462703/ref=sr_1_1?ie=UTF8&qid=1493169647&sr=8-1&keywords=practical+guide+to+cluster+analysis)
