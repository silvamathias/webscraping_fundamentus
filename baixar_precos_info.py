from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.common.by import By
from bs4 import BeautifulSoup as bs
import ipdb
from time import sleep
import dbpg as db
import pandas as pd
from datetime import datetime
#salva no banco de dados todos os dados das empresas cadastradas no site fundamentus.com
agr = datetime.now()
mdu = datetime.strptime('1/' + str(agr.month) + '/' + str(agr.year), '%d/%m/%Y').date()
sql = db.conectar()
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

        '''
        self.driver.find_element_by_id(
            self.search_bar).send_keys(word)
        self.driver.find_element_by_class_name(
            self.btn_search).click()
        '''


    def url_atu(self):
        url = self.driver.current_url
        return url()

    def fechar(self):
        self.driver.quit()

tb_cod = pd.read_table('listados_b3.txt',';')
lista_cod = tb_cod.papel

tb_nb = open('nao_baixar.txt','r')

sem_info = []
for nb in tb_nb:
    sem_info += [nb.replace('\n','')]

ff = webdriver.Firefox()
fu = fundamentus(ff)
fu.navigate()
d = 0
for cod in lista_cod:
    antigo = False
    papel = cod.replace(' ','')
    if papel not in sem_info:
        if antigo == True:
            break

        #d += 1
        #if d >= 20:
            #break

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
                if antigo == True:
                    break

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
                        if antigo == True:
                            break
                        if par == True:
                            if txt == 'Data últ cot':
                                dt_du = True

                            par = False
                        else:
                            n += 1
                            if n in (4,12):
                                if txt in ('-',0,''):
                                    qweb += ",'01/01/1901'"
                                else:
                                    dia = txt[:2]
                                    mes = txt[3:5]
                                    ano = txt[6:10]

                                    if dt_du == True:
                                        dt_du = False
                                        du = datetime.strptime(txt, '%d/%m/%Y').date()
                                        if du < mdu:
                                            antigo = True
                                            break

                                    dt = mes + '/' + dia + '/' + ano
                                    qweb += ",'" + dt + "'"
                            elif n in (1,3,5,7,9):
                                if n == 1:
                                    qweb = "'" + txt + "'"
                                else:
                                    if txt in ('-',0,''):
                                        qweb += ",'null'"
                                    else:
                                        qweb += ",'" + txt + "'"
                            else:
                                vlr = txt.replace('%','')
                                vlr = vlr.replace('.','')
                                vlr = vlr.replace(' ','')
                                if vlr in ('-',0,''):
                                    qweb += "," + str(0)
                                else:
                                    qweb += "," + vlr.replace(',','.')
                            par = True

        if comum == True:
            query = 'insert into fund_web2(papel,cotacao,tipo,data_ult_cot,empresa,min_52_sem,setor,max_52_sem,subsetor,vol_med_2m,valor_de_mercado,ult_balanco_processado,valor_da_firma,nro_acoes,dia_p,pl,lpa,mes_p,p_vp,vpa,dias_30_p,p_ebit,marg_bruta_p,meses_12_p,psr,marg_ebit_p,ano_2021_p,p_ativos,marg_liquida_p,ano_2020_p,p_cap_giro,ebit_ativo_p,ano_2019_p,p_ativ_circ_liq,roic_p,ano_2018_p,div_yield_p,roe_p,ano_2017_p,ev_ebitda,liquidez_corr,ano_2016_p,ev_ebit,div_br_patrim,cres_rec_5a_p,giro_ativos,ativo,div_bruta,disponibilidades,div_liquida,ativo_circulante,patrim_liq,receita_liquida_12,receita_liquida_3,ebit_12,ebit_3,lucro_liquido_12,lucro_liquido_3) values('
        else:
            query = 'insert into fund_web2(papel,cotacao,tipo,data_ult_cot,empresa,min_52_sem,setor,max_52_sem,subsetor,vol_med_2m,valor_de_mercado,ult_balanco_processado,valor_da_firma,nro_acoes,dia_p,pl,lpa,mes_p,p_vp,vpa,dias_30_p,p_ebit,marg_bruta_p,meses_12_p,psr,marg_ebit_p,ano_2021_p,p_ativos,marg_liquida_p,ano_2020_p,p_cap_giro,ebit_ativo_p,ano_2019_p,p_ativ_circ_liq,roic_p,ano_2018_p,div_yield_p,roe_p,ano_2017_p,ev_ebitda,liquidez_corr,ano_2016_p,ev_ebit,div_br_patrim,cres_rec_5a_p,giro_ativos,ativo,div_bruta,disponibilidades,patrim_liq,receita_liquida_12,receita_liquida_3,ebit_12,ebit_3,lucro_liquido_12,lucro_liquido_3) values('

        query += qweb + ');'

        try:
            sql.manipular(query)
        except:
            arq_txt.write(papel + ';')
            print(papel)


arq_txt.close
tb_nb.close

fu.fechar()
