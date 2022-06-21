+++
title = "Demonstrations"
hascode = false

+++
@def tags = ["Demos", "Glove", "MNIST", "Wiktionary", "WIT", "Emojispace", "UMAP"]

\tableofcontents

## Introduction

Our demonstrations are Pluto and Jupyter notebooks that can be used to replicate and interactively use `SimilaritySearch`.
To make the demonstrations more attractive, we also make intensive use of visualizations based on non-linear dimensional reduction,
These kind of algorithms use `k` nearest neighbors of a database as input to produce the low dimensional embedding.
In particular, we use the [`SimSearchManifoldLearning`](https://github.com/sadit/SimSearchManifoldLearning.jl) which 
provides an implementation of `UMAP` and also defines the necessary functions to interoperate with the `ManifoldLearning` package.

We provide two kinds of examples:
- `Pluto` reactive notebooks that can run locally or online.
- `Jupyter` notebooks are less reactive but they are great to visualize directly on github without running.


## List of examples
We separate the examples by the kind of data, since some of the datasets are quite large and will require a lot of computer power. We also list how to connect `SimilaritySearch` with other packages that require solving `k` nearest neighbor queries.

### Indexing and visualizing synthetic and easily generated data 

- [Synthetic 8D](https://github.com/sadit/SimilaritySearchDemos/blob/main/synthetic/random-dataset.ipynb): A tutorial-like Jupyter notebook that shows how to create an index on synthetic data and search it. Synthetic 8-dimensional dataset under L2.
- [Synthetic 2D](https://github.com/sadit/SimilaritySearchDemos/blob/main/synthetic/2d.ipynb): A tutorial-like Jupyter notebook working on 2D synthetic dataset, also shows how the index works on different density regions of the database. Synthetic 2-dimensional dataset under L2.

### Indexing and visualizing real high dimensional datasets

All Pluto notebooks can work on mybinder and run without install anything in your computer, however, some examples uses large datasets and some of them require high computational resources (as many threads as you have); they could run slow in cloud computing services.

- Integers as prime factors: A tutorial-like Jupyter notebook that produces an UMAP visualization of integers represented by its prime factors. It uses UMAP 2D and 3D projections. Very high dimension, based on the number of factors under the $n$ integers; different user defined distances.
    - [Primes](https://github.com/sadit/SimilaritySearchDemos/blob/main/primes/primes-umap.ipynb)
- Prime gaps: A Pluto notebook that represents sequences of prime gaps to visualize them for searching patterns in this infinity source of objects. It uses 2D and 3D projections.
    - Search and UMAP projection [Prime Gaps demo](/demos-pluto/primegaps-demo.jl/). It generates the dataset.
- WIT: This example shows how to navigate, query, and visualize a small subset of the WIT dataset using Clip embeddings (vision \& language). ~300K 512-dimensional vectors using the cosine distance.
    - Jupyter-based [WIT demo](https://github.com/sadit/SimilaritySearchDemos/blob/main/WIT/WIT.ipynb), SimilaritySearch v0.9.
    - Pluto-based [WIT demo](/demos-pluto/wit-demo.jl/), SimilaritySearch v0.8.
- Glove: Navigate and visualize semantic representations (Glove word embeddings), also can solve analogies. The vocabulary consists of 400K tokens represented as 100-dimensional vectors under the cosine distance.
    - Jupyter-based [GloVe demo](https://github.com/sadit/SimilaritySearchDemos/blob/main/Glove/Glove.ipynb), SimilaritySearch v0.9.
    - Pluto-based [GloVe demo](/demos-pluto/glove-demo.jl/), SimilaritySerach v0.8.
- MNIST: Navigation and visualization of the MNIST dataset of hand drawing numbers. It uses images directly as objects (28x28 matrices).
    - Jupyter-based [MNIST demo](https://github.com/sadit/SimilaritySearchDemos/blob/main/MNIST/MNIST.ipynb), SimilaritySearch v0.9.
    - Pluto-based [MNIST demo](/demos-pluto/mnist-demo.jl/), SimilaritySearch v0.8.
    - Pluto-based [MNIST animated projections](/demos-pluto/mnist-demo-iterated.jl/), SimilaritySearch v0.8.
- Wiktionary: Pluto notebook to navigate and query the Wiktionary vocabulary using Levenshtein distance  (~1M words)
    - Jupyter-based [Wiktionary demo](https://github.com/sadit/SimilaritySearchDemos/blob/main/wiktionary/Wiktionary.ipynb), SimilaritySearch v0.9.
    - Pluto-based [Wiktionary demo](/demos-pluto/wiktionary-demo.jl/), SimilaritySearch v0.8.
- Tweets: Pluto notebook to visualize a collection of Twitter's Spanish messages with emojis using bag of words representations. 50K items.
    - Search and UMAP projection [Emojispace demo](/demos-pluto/emojispace-demo.jl/).


TODO: Cites and references
### Interoperating with other packages
- Working with `ManifoldLearning`. This Pluto [notebook](/demos-pluto/primegaps-manifoldlearning.jl/) implements the necessary structs and functions to solve `knn` queries for `ManifoldLearning` algorithms. We used two datasets, the first corresponding to the scurve and the second is for `Prime gaps` as time series. 

## Search demos and UMAP visualization
The demos are [Pluto](https://github.com/fonsp/Pluto.jl) and [Jupyter](https://jupyter.org/] notebooks. Inside the repo's root run the following commands.

```bash

$ JULIA_NUM_THREADS=auto julia --project=.
...

julia> using Pluto
...
julia> Pluto.run(notebook="WIT/wit-demo.jl")
...
```

or 
```bash

$ JULIA_NUM_THREADS=auto jupyter-lab .
```
Please recall that the first time you load a package Julia compiles it. _Pluto notebooks_ also save its own environments and therefore it can use different package versions that those listed in the repo environment, which will cause installing and compiling packages the first time the notebooks run. Hopefully, this strategy improves the reproducibility at the cost of increasing loading times. _Jupyter notebooks_ also contain the necessary package-manager instructions to improve reproducibility. 

Note: Pluto interface also allows loading notebooks, so you don't need to exit and re-run to explore examples.


### Visualization

Most visualizations are made with UMAP models using the `SimSearchManifoldLearning` package. These can be expensive and it is always recommended to run notebooks with all available threads.

## Initializing the environment
`SimilaritySearch.jl` is writen in the [Julia language](https://julialang.org/) you need to install it first in order to run them. After this it is necessary to install Pluto and/or IJulia (for Jupyter notebooks). If you need more information about how to install and use these notebooks, please see their respective sites.

- [Pluto](https://github.com/fonsp/Pluto.jl)
- [IJulia](https://github.com/JuliaLang/IJulia.jl)


