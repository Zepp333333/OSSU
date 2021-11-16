import bs4
import requests

def getAmazonPrice(productURL):

    headers = {'user-agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:69.0) Gecko/20100101 Firefox/69.0'} # to make the server think its a web browser and not a bot

    # res = requests.get('https://ya.ru', headers=headers)
    res = requests.get(productURL, headers=headers)
    res.raise_for_status()

    soup = bs4.BeautifulSoup(res.text, 'lxml')
    # selector = '#mediaNoAccordion > div.a-row > div.a-column.a-span4.a-text-right.a-span-last > span.a-size-medium.a-color-price.header-price'
    selector = '#a-autoid-6-announce > span:nth-child(3) > span:nth-child(1)'
    elems = soup.select(selector)
    # buy_box = soup.find(id='buyNewSection')
    # print(buy_box)
    # elems = buy_box.find('span', class_='a-color-price')
    print(elems)
    return elems

url = 'https://www.amazon.com/Automate-Boring-Stuff-Python-2nd/dp/1593279922/'
price = getAmazonPrice(url)
print(price)
