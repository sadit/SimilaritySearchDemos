+++
title = "Demonstrations"
hascode = false

+++
@def tags = ["Demos", "Glove", "MNIST", "Wiktionary", "WIT", "Emojispace", "UMAP"]

tableofcontents

## Introduction

Our demonstrations are Pluto and Jupyter notebooks that can be used to replicate and interactively use `SimilaritySearch`.
To make the demonstrations more attractive, we also make use intensive use of `UMAP` visualization.
More detailed, UMAP is a non-linear dimension reduction technique that uses the graph of all-nearest neighbors,
and here is the place for `SimilaritySearch`.

- `Pluto` notebooks require to run firstly an script to work, and use already computed structures.
- `Jupyter` notebooks are less interactive but they are great to visualize directly on github without running.


## List of examples
We separate the examples by the kind of data, since some of the datasets are quite large and will require a lot of computer power. We also list how to connect `SimilaritySearch` with other packages that require solving `k` nearest neighbor queries.

### Indexing and visualizing synthetic and easily generated data 

- [Synthetic 8D](https://github.com/sadit/SimilaritySearchDemos/blob/main/synthetic/random-dataset.ipynb): A tutorial-like Jupyter notebook that shows how to create an index on synthetic data and search it. Synthetic 8-dimensional dataset under L2.
- [Synthetic 2D](https://github.com/sadit/SimilaritySearchDemos/blob/main/synthetic/2d.ipynb): A tutorial-like Jupyter notebook working on 2D synthetic dataset, also shows how the index works on different density regions of the database. Synthetic 8-dimensional dataset under L2.
- [Integers as prime factors](https://github.com/sadit/SimilaritySearchDemos/blob/main/primes/primes-umap.ipynb): A tutorial-like Jupyter notebook that produces an UMAP visualization of integers represented by its prime factors. It uses UMAP 2D and 3D projections. Very high dimension, based on the number of factors under the $n$ integers; different user defined distances.
- [Prime gaps](https://github.com/sadit/SimilaritySearchDemos/blob/main/primes/): A Pluto notebook that represents sequences of prime gaps to visualize them for searching patterns in this infinity source of objects. It uses 2D and 3D projections. A static version of the notebook is available here [primegaps-demo.jl](/demos-pluto/primegaps-demo.jl/), you can run it on mybinder.

### Indexing and visualizing real high dimensional datasets

The followin examples work on large and high dimensional datasets. It is recommended to work locally since they could be costly to compute and requires to download large databases.

- [WIT](https://github.com/sadit/SimilaritySearchDemos/tree/main/WIT/): Pluto notebook to navigate, query, and visualize the WIT dataset using Clip embeddings (vision \& language). ~300K 512-dimensional vectors using the cosine distance. It also produces UMAP maps. A static version of the demo is available here [wit-demo](/demos-pluto/wit-demo.jl/), you can also run it on mybinder, but it can take a long time since it requires large downloads.
- [Glove](https://github.com/sadit/SimilaritySearchDemos/tree/main/Glove/): Pluto notebook to navigate and visualize semantic representations (Glove word embeddings). A vocabulary of 400K 100-dimensional vectors; cosine distance. It also produces UMAP maps. A static version of the demo is available here [glove-demo](/demos-pluto/glove-demo.jl/), you can also run it on mybinder, but it can take a long time since it requires large downloads.
- [MNIST](https://github.com/sadit/SimilaritySearchDemos/tree/main/MNIST/): Pluto notebook to navigate and visualize the MNIST dataset of hand drawing numbers. It uses images directly as objects (28x28 matrices). It also produces UMAP maps. A static version of the demo is available here [mnist-demo](/demos-pluto/mnist-demo.jl/), you can also run it on mybinder, but it can take a long time since it requires large downloads. 
- [Wiktionary](https://github.com/sadit/SimilaritySearchDemos/tree/main/wiktionary/): Pluto notebook to navigate and query Wiktionary vocabulary using Levenshtein distance. ~1M words. It also produces UMAP maps.
- [Emojispace](https://github.com/sadit/SimilaritySearchDemos/tree/main/emojispace/) Produces UMAP maps for a document collection of Twitter's Spanish messages with emojis using bag of words representations. 50K items.

TODO: References and cites
### Interoperating with other packages
- Working with `ManifoldLearning`. This Pluto [notebook](/demos-pluto/primegaps-manifoldlearning.jl/) implements the necessary structs and functions to solve `knn` queries for `ManifoldLearning` algorithms. We used two datasets, the first corresponding to the scurve and the second is for `Prime gaps` as time series. 

### Visualization

Some examples only create indexes and and UMAP projections without any kind of graphical interface. Mostly, because they could require a lot of time, even in multithreading. environments. We develop notebooks for navigation and visualization of the computed structures, in particular, the [visualization notebook](https://github.com/sadit/SimilaritySearchDemos/blob/main/visualize-umap.jl) may work for all saved embeddings for all examples. 


## Initializing the environment
`SimilaritySearch.jl` is writen in the [Julia language](https://julialang.org/) you need to install it first in order to run them.

The repo has two files: `Project.toml` and `Manifest.toml`, both lists the packages, and their versions, used by the demos; both describe the working environment. Note: it is quite important to use the `Manifest.toml` since the examples use a modified [UMAP.jl version](https://github.com/sadit/UMAP.jl) of the Dillon's [UMAP.jl](https://github.com/dillondaudert/UMAP.jl) that uses `SimilaritySearch.jl` instead of the `NearestNeighborDescend.jl`. If you want to change Manifest.toml just make sure you use the correct `UMAP.jl` (https://github.com/sadit/UMAP.jl).

The environment needs to be instantiated and this is made with the following commands:

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

## UMAP visualization
The UMAP visualization is also a Pluto notebook called `visualize-umap.jl`. The example looks for umap-projections in sub-directories. Note that even when projections are already created, they are plotted and some datasets contains many points. Please be patient.
