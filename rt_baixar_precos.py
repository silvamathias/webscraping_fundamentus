import requests as rt 
headers = {'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36'}

url = 'https://www.fundamentus.com.br/detalhes.php?papel=BBDC3'

fund = rt.get(url, headers=headers)

print(fund.text)