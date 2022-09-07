from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from bs4 import BeautifulSoup as bs
from time import sleep
import pdb
#salva em um arquivo de texto todas as empresas cadastradas no site Fundamentus.com
# norma PEP8
class fundamentus:

    def __init__(self, driver):
        self.driver = driver
        self.url = 'http://fundamentus.com.br'
        self.search_bar = 'completar'  # id
        self.search_field = 'buscar' # form
        self.btn_search = 'botao'  # class

    def navigate(self):
        self.driver.get(self.url)

    def search_tab(self):
        self.driver.find_element_by_class_name(
            self.btn_search).click()

    def search_cia(self, word='None'):
        self.driver.find_element_by_id(
            self.search_bar).send_keys(word)
        self.driver.find_element_by_class_name(
            self.btn_search).click()

    def url_atu(self):
        url = self.driver.current_url
        return url()

    def fechar(self):
        self.driver.quit()

ff = webdriver.Firefox()
fu = fundamentus(ff)
fu.navigate()
fu.search_tab()

html = ff.page_source
ficha = bs(html, 'html.parser')
tabela = ficha.findAll('tr')


lista = []
for tb in tabela:
    vlr = tb.findAll('td')
    if vlr:
        lin = [v.text for v in vlr]
        lista += [lin]

with open('listados_b3.txt','w') as arq_txt:
    arq_txt.write ('papel;nome_comercial;razao_social')
    for papel in lista:
        primeiro = True
        arq_txt.write ('\n')
        for col in papel:
            if primeiro == False:
                arq_txt.write (';' + col)
            else:
                arq_txt.write (col)
                primeiro = False

fu.fechar()