# This file was generated, do not modify it. # hide
G3 = SearchGraph(; dist, db=MatrixDatabase(X))
callbacks3 = SearchGraphCallbacks(hyperparameters=OptimizeParameters(kind=MinRecall(0.95)))
@elapsed index!(G3; callbacks=callbacks3)