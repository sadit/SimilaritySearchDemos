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

~~~
<div style="text-align: center;">
<img src="/umap.gif" /><img src="/wit.gif" />
</div>
~~~


## List of demonstrations
- [Synthetic 8D](https://github.com/sadit/SimilaritySearchDemos/blob/main/synthetic/random-dataset.ipynb): A tutorial-like Jupyter notebook that shows how to create an index on synthetic data and search it. Synthetic 8-dimensional dataset under L2.
- [Synthetic 2D](https://github.com/sadit/SimilaritySearchDemos/blob/main/synthetic/2d.ipynb): A tutorial-like Jupyter notebook working on 2D synthetic dataset, also shows how the index works on different density regions of the database. Synthetic 8-dimensional dataset under L2.
- [Integers as prime factors](https://github.com/sadit/SimilaritySearchDemos/blob/main/primes/primes-umap.ipynb): A tutorial-like Jupyter notebook that produces an UMAP visualization of integers represented by its prime factors. It uses UMAP 2D and 3D projections. Very high dimension, based on the number of factors under the $n$ integers; different user defined distances.
- [Glove](https://github.com/sadit/SimilaritySearchDemos/tree/main/Glove/): Pluto notebook to navigate on semantic representations (Glove word embeddings). A vocabulary of 400K 100-dimensional vectors; cosine distance. It also produces UMAP maps.
- [MNIST](https://github.com/sadit/SimilaritySearchDemos/tree/main/MNIST/): Pluto notebook to navigate on MNIST hand drawing numbers. It uses images directly as objects (28x28 matrices). It also produces UMAP maps.
- [Wiktionary](https://github.com/sadit/SimilaritySearchDemos/tree/main/wiktionary/): Pluto notebook to navigate and query Wiktionary vocabulary using Levenshtein distance. ~1M words. It also produces UMAP maps.
- [WIT](https://github.com/sadit/SimilaritySearchDemos/tree/main/WIT/): Pluto notebook to navigate and query the WIT dataset using Clip embeddings (vision \& language). ~300K 512-dimensional vectors using the cosine distance. It also produces UMAP maps.
- [Emojispace](https://github.com/sadit/SimilaritySearchDemos/tree/main/emojispace/) Produces UMAP maps for a document collection of Twitter's Spanish messages with emojis using bag of words representations. 50K items.
- The _Visualize UMAP_ Pluto [notebook](https://github.com/sadit/SimilaritySearchDemos/blob/main/visualize-umap.jl). It visualizes UMAP embeddings created by the rest of the demonstrations (Glove, MNIST, Wiktionary, WIT, and emojispace.)

TODO: References and cites



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
All examples contains a script `create-index-and-umap.jl`. It should be run using al your cores, to achieve faster computing times.

For example you can create MNIST index and UMAP's embeddings using the following commands

```bash 
cd MNIST
$ julia -t64 --project=.. create-index-and-umap.jl
...
```

The first time you run a script Julia will load and compile packages, this take some time.
The `-t64` flag says julia to use 64 threads; the `--project=..` also tells that the parent directory describes the environment (previosly instantiated).

The index construction and umap projection may be quite time costly if you have few cores in your machine, so be patitient.

The script will download dataset, create the index, and create the UMAP projections (2d and 3d).
## Search demos and UMAP visualization
The demos are [Pluto](https://github.com/fonsp/Pluto.jl) notebooks and work over the previously created indexes and projections. Inside the repo's root run the following commands.

```bash

$ julia --project=.
...

julia> using Pluto
...
julia> Pluto.run(notebook="WIT/search.jl")
...
```

Please recall that the first time you load a package Julia compiles it. Pluto notebooks also save its own environments and therefore it can use different package versions that those listed in the repo environment, which will cause installing and compiling packages the first time the notebooks run. Hopefully, this strategy improves the reproducibility at the cost of increasing loading times.

Note: Pluto interface also allows loading notebooks, so you don't need to exit and re-run to explore examples.

## UMAP visualization
The UMAP visualization is also a Pluto notebook called `visualize-umap.jl`. The example looks for umap-projections in sub-directories. Note that even when projections are already created, they are plotted and some datasets contains many points. Please be patient.
