##pre-proceed
install.packages('NLP')
install.packages("grep1")
library(NLP)
library(tm)
library(readr)
library(stringr)

#载入初始数据
Data_of_AAPL <- read_csv('C:/Users/Yuki/AAPL/dataofaapl1.csv')

#去除无关列
Data_of_AAPL <- Data_of_AAPL[2:4]


#去除含有NA值的行
df1 <- as.data.frame(Data_of_AAPL)
df1
b <- na.omit(df1)

#由于抓取问题部分日期含有字符串
strlist <- c(str_detect(b$Date,'2020') | str_detect(b$Date,'2019'))
strlist
b$Date
#得到去除NA值且去除无关字符串的各列
b1 <- b$Date[strlist]
b1
length(b1)
b2 <- b$Title[strlist]
b2
b3 <- b$Content[strlist]

#重新构建一个数据框
final_data <- data.frame(Date_ = b1,Title = b2, Content = b3,stringsAsFactors = FALSE)

summary(final_data)
final_data$Date_
final_data$Title




#整理日期格式函数
correctdate <- function(str1){
  loca2 <- str_locate(str1,'2020')[2]
  loca3 <- str_locate(str1,'2019')[2]
  if (is.na(loca2)==FALSE)
    {str1 <- substr(str1,1,loca2)}
  else if (is.na(loca3)==FALSE)
    {str1 <- substr(str1,1,loca3)}
  else
    {print('error')}
  return(str1)
}

#去除，函数
dateremove <- function(str1){
  str1 <- str_replace(str1,',','')
  return(str1)
}

#整理日期列的格式
final_data$Date_ <- lapply(final_data$Date_,correctdate)
final_data$Date_ <- lapply(final_data$Date_,dateremove)

tail(final_data$Date_)
#将日期列转换为列表
final_data$Date_ <- as.character(final_data$Date_)
final_data <- as.data.frame(final_data)
class(final_data$Date_)
summary(final_data)
head(final_data)

#写入CSV文件
write_excel_csv(final_data,'aapl.csv')
