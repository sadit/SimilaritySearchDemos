@def title = "Datasets"
@def hascode = false

@def tags = ["datasets", "Glove", "FastText", "MNIST", "WIT", "Word embeddings"]

# Datasets

## Real world
- Glove - From [Glove site](https://nlp.stanford.edu/projects/glove/), it corresponds to the 100d, 6B tokens. We use the `Embeddings.jl` package to simplify downloading and loading it.
- MNIST - From [MNIST site](http://yann.lecun.com/exdb/mnist/), it corresponds to 60k 28x28 handwritten numbers. We use the `MLDatasets.jl` package to simplify downloading and loading it.
- Wiktionary. Took from [Wiktionary site](https://en.wiktionary.org/wiki/Wiktionary:Main_Page), we select English terms from the english wiktionary. 
- WIT-300K. From Clip and WIT, we downloaded the first 300K annotated images for the Spanish Wikipedia and take the Clip embeddings of them. Available from the demo subfolder.


### Partitions
The versions used in the demonstrations are not splitted in train and test, but those used in the paper are splitted. If you want to reproduce the same results, please use the datasets by [ann-benchmarks](http://ann-benchmarks.com/) and [its repo](https://github.com/erikbern/ann-benchmarks/).

For WIT and Twitter-2M, please use the following HDF5 files, they follow a similar structure than those found in the ann-benchmarks.

- [WIT-300K](http://ingeotec.mx/~sadit/similarity-search-demos/WIT-Clip-angular.h5)
- [Twitter-2M](http://ingeotec.mx/~sadit/similarity-search-demos/twitter-es-300d-angular.h5). These word embeddings corresponds to that model labeled as ALL-2M in the [Regional Spanish Models](https://ingeotec.github.io/regional-spanish-models/) site, yet partitioned for using as similarity search benchmark.

