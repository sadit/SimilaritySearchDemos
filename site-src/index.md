@def title = "SimilaritySearch.jl demonstrations"
@def tags = ["Similarity search"]

# Demonstrations for the `SimilaritySearch.jl` package

Demos for the [SimilaritySearch.jl](https://github.com/sadit/SimilaritySearch.jl) package. We use popular notebooks like Jupyter and Pluto. This notebooks can be accessed from Github's [repository](https://github.com/sadit/SimilaritySearchDemos).

~~~<img src="/umap-primes-1M.png" />~~~


## Problem statement

Given a finite dataset, $S \subseteq U$ where $n = |S|$, and a metric distance function $d$ working with any pair of elements in $U$, the similarity search problem consists on retrieving similar items to a given query $q$, for example, the $k$ most similar items to $q$ in $S$ ($k$ nearest neighbors).

At first glance, the problem is simple since it can be solved using an exhaustive evaluation of all possible results $d(u_1, q), \cdots, d(u_n, q)$ (that is, for all $u_i \in S$) and select those $k$ items $\{u_i\}$ having the least distance to $q$. This solution is impractical when $n$ is large or when the number of expected queries is high. In these cases, it is necessary to create a datastrucure that preprocess the dataset and reduce the cost of solving queries, it is often called a metric index. When the dataset is pretty large or the metric space is quite complex, sometimes we can loose the ability of retrieving the exact solution to gain speed, clearly, the approximation quality becomes a major concern and these approximate methods require a lot of knowledge to trade speed retrieval process also kept high the solution's quality. Additionally, the amount of memory used by the index and the construction time are also concerns whenever $n$ is big.

The `SearchGraph` index in the `SimilaritySearch.jl` package is a competitive alternative for solving search queries that automatically tune search speed and quality and also remains very competitive in memory and construction costs. Here we show some demostrations of how using `SimilaritySearch.jl` in several synthetic and real problems.
