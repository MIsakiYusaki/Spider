aapl <- read.csv('Documents/aapl1.csv',encoding = 'utf-8')
aapl <- aapl1

head(aapl)
aapl_content <- aapl$Content
#aapl_content
#colnames(aapl)[3] <- 'Content'
#colnames(aapl)[1] <- 'Date_'
#colnames(aapl)
#install.packages('NLP')
#install.packages('tm')
#install.packages('tidytext')
library(NLP)

library(tm)

library(tidytext)

pol_cp <- Corpus(VectorSource(aapl_content))
print(pol_cp)
inspect(pol_cp[1])

stopwords()

pol_clearn <- tm_map(pol_cp,removeNumbers)
pol_clearn <- tm_map(pol_clearn,removePunctuation)
pol_clearn <- tm_map(pol_clearn,tolower)
pol_clearn<- tm_map(pol_clearn,removeWords,stopwords())

mylist <- c('span', '<p>', 'apple', 'stock','stocks','will','the','shares','company','views',
            'thats', 'may', 'going', 'now', 'inc', 'said', 'think', 'years','year','just','one','sampp', 'also', 'like','pthe', 'classbodydisclaimerthe',
            ' ¡¯s','herein','herein','author','incp')
pol_clearn <- tm_map(pol_clearn,removeWords,mylist)
pol_clearn<- tm_map(pol_clearn,stripWhitespace)

for(i in seq(pol_clearn)){
  pol_clearn[[i]] <- gsub('span','',pol_clearn[[i]])
  pol_clearn[[i]] <- gsub('<p>','',pol_clearn[[i]])
  pol_clearn[[i]] <- gsub('apple','',pol_clearn[[i]])
  pol_clearn[[i]] <- gsub('stock','',pol_clearn[[i]])
  pol_clearn[[i]] <- gsub('will','',pol_clearn[[i]])
  pol_clearn[[i]] <- gsub('stocks','',pol_clearn[[i]])
  pol_clearn[[i]] <- gsub('the','',pol_clearn[[i]])
}



inspect(pol_clearn[1])






pol_500 <- pol_clearn[1:500]
inspect(pol_clearn[1])


a <- pol_clearn[1]
print(pol_clearn[1])

dtm <- DocumentTermMatrix(pol_500)

swords <- get_sentiments('bing')
head(swords)
swords <- as.data.frame(swords)
swords


swords_pos <- swords[swords['sentiment'] == 'positive']
swords_neg <- swords[swords['sentiment'] == 'negative']
swords_pos
swords_neg




freq.terms <- sort(colSums(as.matrix(dtm)),decreasing = TRUE)

freq.terms <- data.frame(name = names(freq.terms),fre = freq.terms,row.names = NULL)

head(freq.terms,50)

install.packages('RColorBrewer')
install.packages('wordcloud')
library(RColorBrewer)
library(wordcloud)
set.seed(375)
wordcloud(word = freq.terms$name, freq = freq.terms$fre, min.freq = 350, random.color = FALSE, scale = c(4,0.5), colors = brewer.pal(8,'Dark2'))
