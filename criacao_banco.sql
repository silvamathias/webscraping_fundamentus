-------------------------------------------------------------------------------------------------------------------------------
----já criada------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--drop table fund_web;
create table fund_web (
id_fund bigserial primary key,
papel varchar(8),
cotacao decimal,
tipo varchar(255),
data_ult_cot date,
empresa varchar(255),
min_52_sem decimal,
setor varchar(255),
max_52_sem decimal,
subsetor varchar(255),
vol_med_2m decimal,
valor_de_mercado decimal,
ult_balanco_processado date,
valor_da_firma decimal,
nro_acoes decimal,
dia_p decimal,
pl decimal,
lpa decimal,
mes_p decimal,
p_vp decimal,
vpa decimal,
dias_30_p decimal,
p_ebit decimal,
marg_bruta_p decimal,
meses_12_p decimal,
psr decimal,
marg_ebit_p decimal,
ano_2021_p decimal,
p_ativos decimal,
marg_liquida_p decimal,
ano_2020_p decimal,
p_cap_giro decimal,
ebit_ativo_p decimal,
ano_2019_p decimal,
p_ativ_circ_liq decimal,
roic_p decimal,
ano_2018_p decimal,
div_yield_p decimal,
roe_p decimal,
ano_2017_p decimal,
ev_ebitda decimal,
liquidez_corr decimal,
ano_2016_p decimal,
ev_ebit decimal,
div_br_patrim decimal,
cres_rec_5a_p decimal,
giro_ativos decimal,
ativo decimal,
div_bruta decimal,
disponibilidades decimal,
div_liquida decimal,
ativo_circulante decimal,
patrim_liq decimal,
receita_liquida_12 decimal,
receita_liquida_3 decimal,
ebit_12 decimal,
ebit_3 decimal,
lucro_liquido_12 decimal,
lucro_liquido_3 decimal
);
--
-------------------------------------------------------------------------------------------------------------------------------
----Já criada. Mostra as empresas e seus respectivos setores e subsetores------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
--drop view vw_seg_web;
create view vw_seg_web as
select distinct papel, empresa , setor, subsetor from fund_web
order by setor, subsetor, empresa;
-------------------------------------------------------------------------------------------------------------------------------
----Comparatifvo entre os setores da base site B3 e do site fundamentus--------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
/*
--esta só vai funcionar se criar um banco de dados com os dados do arquivo https://bvmf.bmfbovespa.com.br/InstDados/InformacoesEmpresas/ClassifSetorial.zip
--que também pode ser baixado no site https://www.b3.com.br/pt_br/produtos-e-servicos/negociacao/renda-variavel/empresas-listadas.htm
select (graham/preofv) - 1 as ganho_graham,
(vpa/preofv) - 1 as ganho_vpa,
t3.* from (select t2.preofv,
case when 22.55 * t1.lpa * t1.vpa > 0 then (|/22.55 * t1.lpa * t1.vpa) else 0 end as graham,
t1.* from fund_web as t1
left join base_bov as t2
on t1.papel = t2.codneg) as t3
--where papel in ('PETZ3', 'OIBR3', 'WEGE3', 'PETR4', 'ITSA3', 'TAEE4','BBDR3','VALE3')
order by id_fund;
*/
-------------------------------------------------------------------------------------------------------------------------------
----Selecionar último balanço divulgado de cada papel. incluir filtro de mes ou ano para evitar trazer empresas antigas--------
-------------------------------------------------------------------------------------------------------------------------------
--futura view
--validar se só terá os papeis mais atuais e usar na média abaixo
/*
select q1.* from fund_web as q1
left join (select papel, max(ult_balanco_processado) as dt from fund_web group by papel) as q2
on q1.papel = q2.papel where q2.dt = q1.ult_balanco_processado;
*/
-------------------------------------------------------------------------------------------------------------------------------
----Médias de todas as colunas por setor. Trocar por subsetor e colocar fíltro de data de acordo com a necessidade-------------
-------------------------------------------------------------------------------------------------------------------------------
/*
select setor,
count(papel) as qnt,
avg(valor_de_mercado) as m_valor_de_mercado,
avg(valor_da_firma) as m_valor_da_firma,
avg(nro_acoes) as m_nro_acoes,
avg(dia_p) as m_dia_p,
avg(pl) as m_pl,
avg(lpa) as m_lpa,
avg(p_vp) as m_p_vp,
avg(vpa) as m_vpa,
avg(p_ebit) as m_p_ebit,
avg(marg_bruta_p) as m_marg_bruta_p,
avg(psr) as m_psr,
avg(marg_ebit_p) as m_marg_ebit_p,
avg(p_ativos) as m_p_ativos,
avg(marg_liquida_p) as m_marg_liquida_p,
avg(p_cap_giro) as m_p_cap_giro,
avg(ebit_ativo_p) as m_ebit_ativo_p,
avg(p_ativ_circ_liq) as m_p_ativ_circ_liq,
avg(roic_p) as m_roic_p,
avg(div_yield_p) as m_div_yield_p,
avg(roe_p) as m_roe_p,
avg(ev_ebitda) as m_ev_ebitda,
avg(liquidez_corr) as m_liquidez_corr,
avg(ev_ebit) as m_ev_ebit,
avg(div_br_patrim) as m_div_br_patrim,
avg(cres_rec_5a_p) as m_cres_rec_5a_p,
avg(giro_ativos) as m_giro_ativos,
avg(ativo) as m_ativo,
avg(div_bruta) as m_div_bruta,
avg(disponibilidades) as m_disponibilidades,
avg(div_liquida) as m_div_liquida,
avg(ativo_circulante) as m_ativo_circulante,
avg(patrim_liq) as m_patrim_liq,
avg(receita_liquida_12) as m_receita_liquida_12,
avg(receita_liquida_3) as m_receita_liquida_3,
avg(ebit_12) as m_ebit_12,
avg(ebit_3) as m_ebit_3,
avg(lucro_liquido_12) as m_lucro_liquido_12,
avg(lucro_liquido_3) as m_lucro_liquido_3
from fund_web group by setor;
*/
--
-------------------------------------------------------------------------------------------------------------------------------
----Não sei pq criei isto!-----------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
/*
select papel, tipo, empresa, setor, subsetor, ult_balanco_processado, p_ebit, ev_ebitda, roe_p, roic_p from fund_web
where ult_balanco_processado >= '2021-08-31'
order by ult_balanco_processado, setor, subsetor;
*/
