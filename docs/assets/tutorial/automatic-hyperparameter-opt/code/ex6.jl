# This file was generated, do not modify it. # hide
G1 = SearchGraph(; dist, db=MatrixDatabase(X), verbose)
callbacks1 = SearchGraphCallbacks(ParetoRecall())  # ParetoRecall is the default, and it will be used unless you change it
@elapsed index!(G1; callbacks=callbacks1)