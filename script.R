install.packages("tm")
library(tm)
install.packages("quanteda")
library(quanteda)
install.packages("tokenizers")
library(tokenizers)
install.packages("wordcloud")
library(wordcloud)

path = "C:/Users/mtgil/OneDrive/Documents/GitHub/big_data_project_three/docs"
doc = VCorpus(DirSource(path, ignore.case=TRUE, mode="text"))

# Test out functions from slides
inspect(doc)
str(doc)
indexed_doc = doc[[2]]
str(indexed_doc)

docdtm = DocumentTermMatrix(doc)
inspect(docdtm)
str(docdtm)

doctdm = TermDocumentMatrix(doc)
inspect(doctdm)
str(doctdm)

doctf = termFreq(indexed_doc)
docdf = as.data.frame(doctf)

# Tokenization
# Words
tokens = tokens(indexed_doc$content)
tokenlist = as.character(tokens)
tokenlist = tokenlist[order(nchar(tokenlist), decreasing=TRUE)]

# Sentences
sentences = as.String(indexed_doc$content)
sentences = tokenize_sentences(sentences)
sentences = sentences[order(nchar(sentences), decreasing=TRUE)]
