##pre-proceed
install.packages('NLP')
install.packages("grep1")
library(NLP)
library(tm)
library(readr)
library(stringr)

#�����ʼ����
Data_of_AAPL <- read_csv('C:/Users/Yuki/AAPL/dataofaapl1.csv')

#ȥ���޹���
Data_of_AAPL <- Data_of_AAPL[2:4]


#ȥ������NAֵ����
df1 <- as.data.frame(Data_of_AAPL)
df1
b <- na.omit(df1)

#����ץȡ���ⲿ�����ں����ַ���
strlist <- c(str_detect(b$Date,'2020') | str_detect(b$Date,'2019'))
strlist
b$Date
#�õ�ȥ��NAֵ��ȥ���޹��ַ����ĸ���
b1 <- b$Date[strlist]
b1
length(b1)
b2 <- b$Title[strlist]
b2
b3 <- b$Content[strlist]

#���¹���һ�����ݿ�
final_data <- data.frame(Date_ = b1,Title = b2, Content = b3,stringsAsFactors = FALSE)

summary(final_data)
final_data$Date_
final_data$Title




#�������ڸ�ʽ����
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

#ȥ��������
dateremove <- function(str1){
  str1 <- str_replace(str1,',','')
  return(str1)
}

#���������еĸ�ʽ
final_data$Date_ <- lapply(final_data$Date_,correctdate)
final_data$Date_ <- lapply(final_data$Date_,dateremove)

tail(final_data$Date_)
#��������ת��Ϊ�б�
final_data$Date_ <- as.character(final_data$Date_)
final_data <- as.data.frame(final_data)
class(final_data$Date_)
summary(final_data)
head(final_data)

#д��CSV�ļ�
write_excel_csv(final_data,'aapl.csv')