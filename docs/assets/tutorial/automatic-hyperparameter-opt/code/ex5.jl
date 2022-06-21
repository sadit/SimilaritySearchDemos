# This file was generated, do not modify it. # hide
verbose = false
goldI, goldD = searchbatch(ExhaustiveSearch(; db, dist), queries, k)  # `ExhaustiveSearch` solves with brute force
nothing # hide