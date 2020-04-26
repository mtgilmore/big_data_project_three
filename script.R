install.packages("tm")
library(tm)

path = "C:/Users/mtgil/OneDrive/Documents/GitHub/big_data_project_three/docs"

doc = VCorpus(DirSource(path, ignore.case=TRUE, mode="text"))
