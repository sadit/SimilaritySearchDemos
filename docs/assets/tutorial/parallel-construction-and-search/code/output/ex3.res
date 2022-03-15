SimilaritySearch.SearchGraph{SimilaritySearch.SqL2Distance, SimilaritySearch.MatrixDatabase{Matrix{Float32}}, SimilaritySearch.BeamSearch}
  dist: SimilaritySearch.SqL2Distance SimilaritySearch.SqL2Distance()
  db: SimilaritySearch.MatrixDatabase{Matrix{Float32}}
  links: Array{Vector{Int32}}((0,))
  locks: Array{Base.Threads.SpinLock}((0,))
  hints: Array{Int32}((0,)) Int32[]
  search_algo: SimilaritySearch.BeamSearch
  neighborhood: SimilaritySearch.Neighborhood
  verbose: Bool true
