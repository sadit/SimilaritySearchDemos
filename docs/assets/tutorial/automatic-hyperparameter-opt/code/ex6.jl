# This file was generated, do not modify it. # hide
G1 = SearchGraph(; dist, db=MatrixDatabase(X))
callbacks1 = SearchGraphCallbacks(hyperparameters=OptimizeParameters(kind=ParetoRecall()))  # ParetoRecall is the default
@elapsed index!(G1; callbacks=callbacks1)