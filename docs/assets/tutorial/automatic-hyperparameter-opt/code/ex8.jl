# This file was generated, do not modify it. # hide
G3 = SearchGraph(; dist, db=MatrixDatabase(X), verbose)
callbacks3 = SearchGraphCallbacks(MinRecall(0.95))
@elapsed index!(G3; callbacks=callbacks3)