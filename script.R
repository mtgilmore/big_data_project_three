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

freq = termFreq(indexed_doc)
freq

# Tokenization
# Words
tokens = tokens(indexed_doc$content)
tokenlist = as.character(tokens)
tokenlist = tokenlist[order(nchar(tokenlist), decreasing=TRUE)]
tokenlist[1:10]

# Sentences
sentences = as.String(indexed_doc$content)
sentences = tokenize_sentences(sentences)
sentences = sentences[order(nchar(sentences), decreasing=TRUE)]
sentences[[1]][1:10]

# Cleaning corpus
removeNumPunc = function(x) gsub("[^[:alpha:][:space:]]*", "", x)
doc = tm_map(doc, content_transformer(removeNumPunc))
myStopWords = c(stopwords("english"))
doc = tm_map(doc, removeWords, myStopWords)
doctf = termFreq(doc[[2]])
docdf = as.data.frame(doctf)

# Wordcloud
pal = brewer.pal(9, "BuGn")
pal = pal[-(1:4)]
wordcloud(row.names(docdf), docdf[[1]], colors=pal, max.words=50, scale=c(3,.1))
