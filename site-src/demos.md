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
- `Jupyter` notebooks are less interactive but they are great to visualize directly on github without running.


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
- WIT: Pluto notebook to navigate, query, and visualize a small subset of the WIT dataset using Clip embeddings (vision \& language). ~300K 512-dimensional vectors using the cosine distance. 
    - Search and UMAP projection [WIT demo](/demos-pluto/wit-demo.jl/).
- Glove: Pluto notebook to navigate and visualize semantic representations (Glove word embeddings). The vocabulary consists of 400K tokens represented as 100-dimensional vectors under the cosine distance.
    - Search and UMAP projection [GloVe demo](/demos-pluto/glove-demo.jl/).
- MNIST: Pluto notebooks to navigate and visualize the MNIST dataset of hand drawing numbers. It uses images directly as objects (28x28 matrices).
    - Search and UMAP projection [MNIST demo](/demos-pluto/mnist-demo.jl/).
    - Animation of UMAP projections [MNIST animated projections](/demos-pluto/mnist-demo-iterated.jl/).
- Wiktionary: Pluto notebook to navigate and query the Wiktionary vocabulary using Levenshtein distance  (~1M words)
    - Search and UMAP projection [Wiktionary demo](/demos-pluto/wiktionary-demo.jl/).
- Tweets: Pluto notebook to visualize a collection of Twitter's Spanish messages with emojis using bag of words representations. 50K items.
    - Search and UMAP projection [Emojispace demo](/demos-pluto/emojispace-demo.jl/).


TODO: Cites and references
### Interoperating with other packages
- Working with `ManifoldLearning`. This Pluto [notebook](/demos-pluto/primegaps-manifoldlearning.jl/) implements the necessary structs and functions to solve `knn` queries for `ManifoldLearning` algorithms. We used two datasets, the first corresponding to the scurve and the second is for `Prime gaps` as time series. 

## Search demos and UMAP visualization
The demos are [Pluto](https://github.com/fonsp/Pluto.jl) notebooks and work over the previously created indexes and projections. Inside the repo's root run the following commands.

```bash

$ julia --project=.
...

julia> using Pluto
...
julia> Pluto.run(notebook="WIT/wit-demo.jl")
...
```

Please recall that the first time you load a package Julia compiles it. Pluto notebooks also save its own environments and therefore it can use different package versions that those listed in the repo environment, which will cause installing and compiling packages the first time the notebooks run. Hopefully, this strategy improves the reproducibility at the cost of increasing loading times.

Note: Pluto interface also allows loading notebooks, so you don't need to exit and re-run to explore examples.


### Visualization

Some examples only create indexes and and UMAP projections without any kind of graphical interface. Mostly, because they could require a lot of time, even in multithreading. environments. We develop notebooks for navigation and visualization of the computed structures, in particular, the [visualization notebook](https://github.com/sadit/SimilaritySearchDemos/blob/main/visualize-umap.jl) may work for all saved embeddings for all examples. 


## Initializing the environment
`SimilaritySearch.jl` is writen in the [Julia language](https://julialang.org/) you need to install it first in order to run them.

The goal is that all demostrations contain a full specification of the packages such that they work out-of-the-box. Pluto has this feature natively and Jupyter notebooks use `PackageSpec` inside each notebook, both describe the working environment. While this may require extra time to always check/install the necessary packages, the examples should work out of the box. This is a work in progress.

For now, there are a few scripts that should be run, for these the environment needs to be instantiated and this is made with the following commands:

```bash

$ julia --project=.
...

julia> ] instantiate
```

The `--project=.` tells julia that our enviroment/project is described in the current directory, so you must call this inside the root of the repository. Note: you need an active internet connection to do this.

The `]` character inits the package manager of Julia. You can output using ctrl+d (repeat it to get out of Julia)


## Index construction and umap projection
Some examples contain a `create-index-and-umap.jl` script. It should be run using all your cores, to achieve faster computing times.


```bash 
$ julia -t64 --project=.. create-index-and-umap.jl
```
or alternatively from the julia's REPL

```
julia> include("create-index-and-umap.jl")
```

The first time you run a script Julia will load and compile packages, this take some time.
The `-t64` flag says julia to use 64 threads; the `--project=..` also tells that the parent directory describes the environment (previosly instantiated).

The index construction and umap projection may be quite time costly if you have few cores in your machine, so be patitient.

When the `create-index-and-umap.jl` is present, then it will download dataset, create the index, and create the UMAP projections (2d and 3d). 


