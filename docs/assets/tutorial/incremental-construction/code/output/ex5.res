SimilaritySearch.SearchGraph{SimilaritySearch.L1Distance, SimilaritySearch.DynamicMatrixDatabase{Float32, 8}, SimilaritySearch.BeamSearch}
  dist: SimilaritySearch.L1Distance SimilaritySearch.L1Distance()
  db: SimilaritySearch.DynamicMatrixDatabase{Float32, 8}
  links: Array{Vector{Int32}}((20000,))
  locks: Array{Base.Threads.SpinLock}((20000,))
  hints: Array{Int32}((99,)) Int32[98, 190, 328, 710, 819, 922, 923, 962, 1002, 1059  …  3239, 3245, 3257, 3263, 3274, 3282, 3323, 3330, 3331, 3336]
  search_algo: SimilaritySearch.BeamSearch
  neighborhood: SimilaritySearch.Neighborhood
  verbose: Bool true
