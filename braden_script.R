#install.packages("readtext")
library(readtext)
library(tm)

path <- "~/Documents/College/eighth_semester/big_data/big_data_project_three/docs"

#read text file
rt <- readtext(path)

#get actual text
text <- rt[[2]]

################## stringi stuff ######################
#three methods as requested (the three shown in the document)
library(stringi)
ptext <- stri_replace_all(text,"",regex = "<.*?>")    #remove html tags
ptext <- stri_trim(ptext)                             #clean whitespace
ptext <- stri_trans_tolower(ptext)                    #make lowercase
ptext

##############   quanteda stuff       #################
#install.packages("quanteda")
library(quanteda)
#create document term matrix, removing stopwords, removing numbers, removing punctuation, stemming
noPunctText = removePunctuation(ptext)
dtm <- dfm(noPunctText, tolower = TRUE, stem = TRUE, remove = stopwords("english"), remove_numbers = TRUE)
dtm
#do same thing using a quanteda corpus
corp = corpus(rt)
cdtm <- dfm(corp, tolower = TRUE, stem = TRUE, remove = stopwords("english"), remove_numbers = TRUE)
cdtm

#print top 20 features
topfeatures(dtm, 20)

#weighted dtm using tfidf (we only have one document so its a little weird, want to see result though)
wdtm <- dfm_weight(dtm, "tfidf")
wdtm

#once again, since we have only one document we cannot use the machine learning part of quanteda
############## corpustools stuff   ####################
#install.packages("corpustools")
library(corpustools)
tc <- create_tcorpus(rt)

#who is the captain
hits <- tc$search_features('"captain nautilus"~2')
kwic <- tc$kwic(hits, ntokens = 3)
head(kwic$kwic, 5)

hits <- tc$search_features('"captain nemo"~2')
kwic <- tc$kwic(hits, ntokens = 3)
head(kwic$kwic, 5)

#same but for nautilus and ship within 5 words
hits <- tc$search_features('"nautilus boat"~5')
kwic <- tc$kwic(hits, ntokens = 3)
head(kwic$kwic, 5)

#does the nautilus sink
hits <- tc$search_features('"nautilus s?nk*"~10')
kwic <- tc$kwic(hits, ntokens = 3)
head(kwic$kwic, 5)

#is the nautilus a sub
hits <- tc$search_features('"nautilus sub*"~10')
kwic <- tc$kwic(hits, ntokens = 3)
head(kwic$kwic, 5)

#try to see if nautilus actually sinks
hits <- tc$search_features('"hull hole"~10')
kwic <- tc$kwic(hits, ntokens = 3)
head(kwic$kwic, 5)

#does nemo have an enemy/who is he fighting
hits <- tc$search_features('"nemo attack"~10')
kwic <- tc$kwic(hits, ntokens = 5)
head(kwic$kwic, 5)

#who is ned
hits <- tc$search_features('"ned"')
kwic <- tc$kwic(hits, ntokens = 10)
head(kwic$kwic, 5)

hits <- tc$search_features('"ned nemo"~10')
kwic <- tc$kwic(hits, ntokens = 10)
head(kwic$kwic, 5)

#what monster (from negative words)
hits <- tc$search_features('"monster"')
kwic <- tc$kwic(hits, ntokens = 10)
head(kwic$kwic, 5)

#do we find the monster
hits <- tc$search_features('"find monster"~10')
kwic <- tc$kwic(hits, ntokens = 10)
head(kwic$kwic, 5)

#can we figure out if nemo dies
hits <- tc$search_features('"nemo dead"~10')
kwic <- tc$kwic(hits, ntokens = 7)
head(kwic$kwic, 5)

hits <- tc$search_features('"nemo *liv*"~10')
kwic <- tc$kwic(hits, ntokens = 7)
head(kwic$kwic, 5)
############## tidytext stuff ##################
#install.packages("tidytext")
library(tidytext)
library(dplyr)

#setup for tidytext, need one token per row format
#they provide function for going to tidy from dtm
#make dtm without stemming so can use sentiment analysis
tdtm <- dfm(noPunctText, tolower = TRUE, stem = FALSE, remove = stopwords("english"), remove_numbers = TRUE)
tidyBook <- tidy(tdtm)
tidyBook <- tidyBook %>%
  rename(word = term)
tidyBook
#find most positive words in the book
positive <- get_sentiments(lexicon = "bing") %>%
  filter(sentiment == "positive")

tidyBook %>%
  semi_join(positive) %>%
  arrange(desc(count))

#find most positive words in the book
negative <- get_sentiments(lexicon = "bing") %>%
  filter(sentiment == "negative")

tidyBook %>%
  semi_join(negative) %>%
  arrange(desc(count))
