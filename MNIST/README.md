# Using MNIST

This directory contains the Pluto MNIST searching demo `searchmnist.jl` and a UMAP construction demo `umapmnist.jl`.


Before using both demos you must create the index and the UMAP embeddings running the following script.

```
julia -t64 --project=. create-index-and-umap.jl
```


You will be asked to accept MNIST terms and conditions before downloading. The `-t64` specifies the number of threads to use; you can omit for using one thread or specify any other number to take advantage of your hardware.
