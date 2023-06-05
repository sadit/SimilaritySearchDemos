@def title = "SimilaritySearch.jl demonstrations"
@def tags = ["Similarity search"]

# Examples and demos for the `SimilaritySearch.jl` package

Here you will find several examples for the  [SimilaritySearch.jl](https://github.com/sadit/SimilaritySearch.jl) package in Jupyter and Pluto notebooks.
These notebooks can also be accessed from Github's [repository](https://github.com/sadit/SimilaritySearchDemos).

# Installation

You need a Julia installation <https://julialang.org/downloads/>, in particular, we used Julia $v1.9$ for Jupyter notebooks. Pluto notebooks were created with Julia `1.7`. Then you must install `IJulia` and `Pluto` packages, just run the following commands in the REPL

```julia
] add IJulia
```

and/or
```julia
] add Pluto
```

This should be enough to run jupyter and pluto, note that if IJulia has some rules about using a preinstalled Jupyter installation or install a new one.
Please check its [documentation](https://julialang.github.io/IJulia.jl/stable/manual/installation/).

Nearest neighbor search can be computationally expensive and, that is why, `SimilaritySearch` has multithreading support.
You should want to run jupyter and julia using all available threads, that is

```bash
JULIA_NUM_THREADS=auto jupyter-lab .
```

or
```bash
JULIA_NUM_THREADS=auto julia
```

## News

- _june 5th, 2023:_ adds news section, some installation requirements, Jupyter notebookes were updated to work with the `v0.10` and with the current julia release `v1.9`. I also moved most plots to `Makie`.


## Problem statement

Given a finite dataset, $S \subseteq U$ where $n = |S|$, and a metric distance function $d$ working with any pair of elements in $U$, the similarity search problem consists on retrieving similar items to a given query $q$, for example, the $k$ most similar items to $q$ in $S$ ($k$ nearest neighbors).

At first glance, the problem is simple since it can be solved using an exhaustive evaluation of all possible results $d(u_1, q), \cdots, d(u_n, q)$ (that is, for all $u_i \in S$) and select those $k$ items $\{u_i\}$ having the least distance to $q$. This solution is impractical when $n$ is large or when the number of expected queries is high. In these cases, it is necessary to create a data structure that preprocess the dataset and reduce the cost of solving queries, it is often called a metric index. When the dataset is pretty large or the metric space is quite complex, sometimes we can loose the ability of retrieving the exact solution to gain speed, clearly, the approximation quality becomes a major concern and these approximate methods require a lot of knowledge to trade speed retrieval process also kept high the solution's quality. Additionally, the amount of memory used by the index and the construction time are also concerns whenever $n$ is big.

The `SearchGraph` index in the `SimilaritySearch.jl` package is a competitive alternative for solving search queries that automatically tune search speed and quality and also remains very competitive in memory and construction costs. Here we show some demostrations of how using `SimilaritySearch.jl` in several synthetic and real problems.
