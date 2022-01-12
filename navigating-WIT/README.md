# Navigating the WIT dataset

The dataset is composed of more than 300K embeddings for the (URL)[WIT dataset] that capture visual and language semantics of several wikipedia articles.


We use the Spanish sample of WIT to demostrate a simple navigation on it using the Pluto notebook. Pluto must retrive the correct package versions so it must work out of the box.


## Usage:
Install the [Julia](https://julialang.org/downloads/) language (recommended v1.6 or later) and also install the Pluto notebook (lastest version)


```
julia> ] add Pluto

...

julia> using Pluto
...
julia> Pluto.run()
```


If you use Julia v1.7 then the first instruction is not necessary. The demostration need to retrieve the dataset and the index to work (>1G), so please start and be calm while these files are retrieved.

Use the notebook, test and change the code as you wish. Happy navigation!


