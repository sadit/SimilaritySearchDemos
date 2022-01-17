# SimilaritySearchDemos

Demos for the [SimilaritySearch.jl](https://github.com/sadit/SimilaritySearch.jl) package. We use popular notebooks like Jupyter and Pluto

The examples contains three main parts: the index construction, the umap projection, and a search demo

## Initializing the environment
`SimilaritySearch.jl` is writen in the [Julia language](https://julialang.org/) you need to install it first in order to run them.

The repo has two files: `Project.toml` and `Manifest.toml`, both lists the packages, and their versions, used by the demos; both describe the working environment. Note for Julia usesrs: it is quite important to use the `Manifest.toml` since the examples use a modified [UMAP.jl version](https://github.com/sadit/UMAP.jl) of the Dillon's [UMAP.jl](https://github.com/dillondaudert/UMAP.jl) that uses `SimilaritySearch.jl` instead of the `NearestNeighborDescend.jl`. If you want to change Manifest.toml just make sure you use the correct `UMAP.jl` (https://github.com/sadit/UMAP.jl).

The environment needs to be instantiated and this is done with the following commands:

```bash

$julia --project=.
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

Please recall that the first time you load a package Julia compiles it. Pluto notebooks also save its own environments and therefore it can use different package versions that those listed in the repo environment, this will cause installing and compiling this packages. Hopefully, this strategy improves the reproducibility at the cost of increasing loading times.

Note: Pluto interface also allows loading notebooks, so you don't need to exit and re-run to explore examples.

## UMAP visualization
The UMAP visualization is also a Pluto notebook called `visualize-umap.jl`. The example looks for umap-projections in sub-directories. Note that even when projections are already created, they are plotted and some datasets contains many points. Please be patient.

## Datasets
- Glove - From [Glove site](https://nlp.stanford.edu/projects/glove/), it corresponds to the 100d, 6B tokens. We use the `Embeddings.jl` package to simplify downloading and loading it.
- MNIST - From [MNIST site](http://yann.lecun.com/exdb/mnist/), it corresponds to 60k 28x28 handwritten numbers. We use the `MLDatasets.jl` package to simplify downloading and loading it.
- Wiktionary. Took from [Wiktionary site](https://en.wiktionary.org/wiki/Wiktionary:Main_Page), we select English terms from the english wiktionary. 
- WIT-300K. From Clip and WIT, we downloaded the first 300K annotated images for the Spanish Wikipedia and take the Clip embeddings of them. Available from the demo subfolder.


### Dataset partitions
The versions used in the demonstrations are not splitted in train and test, but those used in the paper are splitted. If you want to reproduce the same results, please use the datasets by [ann-benchmarks](http://ann-benchmarks.com/) and [its repo](https://github.com/erikbern/ann-benchmarks/).

For WIT and Twitter-2M, please use the following HDF5 files, they follow a similar structure than those found in the ann-benchmarks.

- [WIT-300K](http://ingeotec.mx/~sadit/similarity-search-demos/WIT-Clip-angular.h5)
- [Twitter-2M](http://ingeotec.mx/~sadit/similarity-search-demos/twitter-es-300d-angular.h5). These word embeddings corresponds to that model labeled as LARGE in the [Regional Spanish Models](https://ingeotec.github.io/regional-spanish-models/) site, yet partitioned for using as similarity search benchmark.