from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup as bs
import ipdb
from time import sleep
#import dbpg as db
import pandas as pd
from datetime import datetime
import json
import os

#salva no banco de dados todos os dados das empresas cadastradas no site fundamentus.com
#ipdb.set_trace()
agr = datetime.now()
mdu = datetime.strptime('1/' + str(agr.month) + '/' + str(agr.year), '%d/%m/%Y').date()
#sql = db.conectar()
arq_txt = open('nao_baixados.txt', 'w')
class fundamentus:
    def __init__(self, driver):
        self.driver = driver
        self.url = 'http://fundamentus.com.br'
        self.search_bar = 'completar'  # id
        self.search_field = 'buscar'  # form
        self.btn_search = 'botao'  # class

    def navigate(self):
        self.driver.get(self.url)

    def search(self, word='None'):
        
        self.driver.find_element(By.ID,self.search_bar).send_keys(word)
        self.driver.find_element(By.CLASS_NAME,self.btn_search).click()

    def url_atu(self):
        url = self.driver.current_url
        return url()

    def fechar(self):
        self.driver.quit()

local = os.getcwd()
dic_col = {'Papel':'papel','Cotação':'cotacao','Tipo':'tipo','Data últ cot':'data_ult_cot','Empresa':'empresa','Min 52 sem':'min_52_sem','Setor':'setor','Max 52 sem':'max_52_sem','Subsetor':'subsetor','Vol $ méd (2m)':'vol_med_2m','Valor de mercado':'valor_de_mercado','Últ balanço processado':'ult_balanco_processado','Valor da firma':'valor_da_firma','Nro. Ações':'nro_acoes','Dia':'dia_p','P/L':'pl','LPA':'lpa','Mês':'mes_p','P/VP':'p_vp','VPA':'vpa','30 dias':'dias_30_p','P/EBIT':'p_ebit','Marg. Bruta':'marg_bruta_p','12 meses':'meses_12_p','PSR':'psr','Marg. EBIT':'marg_ebit_p','2023':'ano_atu','P/Ativos':'p_ativos','Marg. Líquida':'marg_liquida_p','2022':'ano_m1','P/Cap. Giro':'p_cap_giro','EBIT / Ativo':'ebit_ativo_p','2021':'ano_m2','P/Ativ Circ Liq':'p_ativ_circ_liq','ROIC':'roic_p','2020':'ano_m3','Div. Yield':'div_yield_p','ROE':'roe_p','2019':'ano_m4','EV / EBITDA':'ev_ebitda','Liquidez Corr':'liquidez_corr','2018':'ano_m5','EV / EBIT':'ev_ebit','Div Br/ Patrim':'div_br_patrim','Cres. Rec (5a)':'cres_rec_5a_p','Giro Ativos':'giro_ativos','Ativo':'ativo','Dív. Bruta':'div_bruta','Disponibilidades':'disponibilidades','Dív. Líquida':'div_liquida','Ativo Circulante':'ativo_circulante','Patrim. Líq':'patrim_liq','Depósitos':'depositos','Cart. de Crédito':'cart_de_credito','receita_liquida_12':'receita_liquida_12','receita_liquida_3':'receita_liquida_3','ebit_12':'ebit_12','ebit_3':'ebit_3','lucro_liquido_12':'lucro_liquido_12','lucro_liquido_3':'lucro_liquido_3','result_int_financ_12':'result_int_financ_12','result_int_financ_3':'result_int_financ_3','rec_servicos_12':'rec_servicos_12','rec_servicos_3':'rec_servicos_3'}

tb_cod = pd.read_table('listados_b3.txt',';')
lista_cod = tb_cod.papel

tb_nb = []

sem_info = []
for nb in tb_nb:
    sem_info += [nb.replace('\n','')]

ff = webdriver.Firefox()
fu = fundamentus(ff)
fu.navigate()
d = 0

list_web = []
for cod in lista_cod:
    dic_info = {}
    antigo = False
    papel = cod.replace(' ','')
    if papel not in sem_info:
        if antigo == True:
            break
        '''
        d += 1
        if d >= 20:
            break
        '''

        fu.search(papel)
        url = ff.current_url
        html = ff.page_source
        ficha = bs(html, 'html.parser')
        tabela = ficha.findAll('table')

        par = True
        titulos = ['Dados Balanço Patrimonial','Dados demonstrativos de resultados','Oscilações','Indicadores fundamentalistas','Últimos 12 meses','Últimos 3 meses','?','']
        n = 0
        comum = False
        qweb = ''
        for tb in tabela:
            if antigo == True:
                break
            celula = tb.findAll('td')
            for td in celula:
                span = td.findAll('span')
                for s in span:
                    if antigo == True:
                        break
                    txt = s.text
                    txt = txt.replace('?','')
                    txt = txt.replace('\n','')

                    if txt in ('Ativo Circulante','Dív. Líquida'):
                        comum = True
                    if txt not in titulos:
                        if par == True:
                            if txt == str(agr.year):    
                                key_dic = 'ano_atu'
                            elif txt == str(agr.year - 1):
                                key_dic = 'ano_m1'
                            elif txt == str(agr.year - 2):    
                                key_dic = 'ano_m2'
                            elif txt == str(agr.year - 3):
                                key_dic = 'ano_m3'
                            elif txt == str(agr.year - 4):
                                key_dic = 'ano_m4'
                            elif txt == str(agr.year - 5):
                                key_dic = 'ano_m5'
                            elif txt == 'EBIT':
                                if 'ebit_12' in dic_info:
                                    key_dic = 'ebit_3'
                                else:
                                    key_dic = 'ebit_12'

                            elif txt == 'Lucro Líquido':
                                if 'lucro_liquido_12' in dic_info:
                                    key_dic = 'lucro_liquido_3'
                                else:
                                    key_dic = 'lucro_liquido_12'
                            
                            elif txt == 'Rec Serviços':
                                if 'rec_servicos_12' in dic_info:
                                    key_dic = 'rec_servicos_3'
                                else:
                                    key_dic = 'rec_servicos_12'

                            elif txt == 'Receita Líquida':
                                if 'receita_liquida_12' in dic_info:
                                    key_dic = 'receita_liquida_3'
                                else:
                                    key_dic = 'receita_liquida_12'

                            elif txt == 'Result Int Financ':
                                if 'result_int_financ_12' in dic_info:
                                    key_dic = 'result_int_financ_3'
                                else:
                                    key_dic = 'result_int_financ_12'
                            
                            else:
                                key_dic = txt

                            if txt == 'Data últ cot':
                                dt_du = True

                            par = False
                        else:
                            #print(txt)
                            vlr_dic = txt
                            dic_info[key_dic] = vlr_dic
                            
                            par = True

        dic_web = {}
        for x,y in dic_col.items():
            #print('chave: {}; valor: {}'.format(x,y))
            try:
                dic_web[y] = dic_info[x]
            except:
                dic_web[y] = ''

        list_web += [dic_web]

json_web = json.dumps(list_web)
df = pd.read_json(json_web)

df.to_csv(local + '//web_fun.csv', sep = ';', decimal = ',', index = False)
