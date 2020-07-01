# -*- coding: utf-8 -*-
"""
Created on Wed Jul  1 15:46:36 2020

@author: Yuki
"""
import requests
import pandas as pd
from bs4 import BeautifulSoup
pd.options.display.max_columns = 30
user_agent = 'Mozilla/4.0 (compatible; MSIE 5.5; Windows NT)'
headers={'User-Agent':user_agent}

#Get all pages of news list
rooturllist = []
for i in range(1250):
    rooturl = 'https://www.nasdaq.com/api/v1/news-headlines-fetcher/aapl/{0}/8'.format(i*8)
    rooturllist.append(rooturl)

rooturllist


newslinks_list = []

for rootlink in rooturllist:
    soup_list = BeautifulSoup(requests.get(rootlink,headers = headers).text)
    news_links = soup_list.select('a.quote-news-headlines__link')
    linklist = []
    for i in range(len(news_links)):
        linklist.append('https://www.nasdaq.com' + news_links[i].get('href'))
        newslinks_list.append(linklist[i])
newslinks_list = ['https://www.nasdaq.com' + x for x in newslinks_list]
# newslist = pd.DataFrame(newslinks_list)

# newslist.to_csv('newslist.csv')
#Get all information

def GetTitle(soup):
    title = soup.select('h1.article-header__headline > span')[0].text
    return title

    #get date
def GetDate(soup):
    date = soup.select('.timestamp__date')[0].text
    return date

    #get content
def GetContent(soup):
    content = soup.select('div.body__content > p')
    contentstr = ''
    for i in range(len(content)):
        contentstr += content[i].text + "\n"
    return content    
#initialize list

titlelist = []
datelist = []
contentlist = []       
 
for link in newslinks_list:
    html = requests.get(link,headers = headers).text
    soup = BeautifulSoup(html,'lxml')
    titlelist.append(GetTitle(soup))
    datelist.append(GetDate(soup))
    contentlist.append(GetContent(soup)) 
    
#Integrate into dataframe
DataOfAAPL = pd.DataFrame({'Date':datelist,'Title':titlelist,'Content':contentlist})

#write to csv

DataOfAAPL.to_csv('dataofaapl.csv')


