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
create view vw_fund_web as
 SELECT q1.id_fund,
    q1.papel,
    q1.cotacao,
    q1.tipo,
    q1.data_ult_cot,
    q1.empresa,
    q1.min_52_sem,
    q1.setor,
    q1.max_52_sem,
    q1.subsetor,
    q1.vol_med_2m,
    q1.valor_de_mercado,
    q1.ult_balanco_processado,
    q1.valor_da_firma,
    q1.nro_acoes,
    q1.dia_p,
    q1.pl,
    q1.lpa,
    q1.mes_p,
    q1.p_vp,
    q1.vpa,
    q1.dias_30_p,
    q1.p_ebit,
    q1.marg_bruta_p,
    q1.meses_12_p,
    q1.psr,
    q1.marg_ebit_p,
    q1.ano_2021_p,
    q1.p_ativos,
    q1.marg_liquida_p,
    q1.ano_2020_p,
    q1.p_cap_giro,
    q1.ebit_ativo_p,
    q1.ano_2019_p,
    q1.p_ativ_circ_liq,
    q1.roic_p,
    q1.ano_2018_p,
    q1.div_yield_p,
    q1.roe_p,
    q1.ano_2017_p,
    q1.ev_ebitda,
    q1.liquidez_corr,
    q1.ano_2016_p,
    q1.ev_ebit,
    q1.div_br_patrim,
    q1.cres_rec_5a_p,
    q1.giro_ativos,
    q1.ativo,
    q1.div_bruta,
    q1.disponibilidades,
    q1.div_liquida,
    q1.ativo_circulante,
    q1.patrim_liq,
    q1.receita_liquida_12,
    q1.receita_liquida_3,
    q1.ebit_12,
    q1.ebit_3,
    q1.lucro_liquido_12,
    q1.lucro_liquido_3
   FROM (fund_web q1
     LEFT JOIN ( SELECT ((q2.papel)::text || q2.mdata_ult_cot) AS ch1,
            q2.papel,
            q2.ult_balanco_processado,
            q2.mdata_ult_cot
           FROM ( SELECT DISTINCT t1.papel,
                    t1.ult_balanco_processado,
                    max(t1.data_ult_cot) AS mdata_ult_cot
                   FROM fund_web t1
                  GROUP BY t1.papel, t1.ult_balanco_processado
                  ORDER BY t1.papel, (max(t1.data_ult_cot))) q2) q3 ON ((((q1.papel)::text || q1.data_ult_cot) = q3.ch1)))
  WHERE (q3.ch1 IS NOT NULL);
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
-------------------------------------------------------------------------------------------------------------------------------
----Passa da fund_web2 para a fund_web-----------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
insert into fund_web (papel,
cotacao,
tipo,
data_ult_cot,
empresa,
min_52_sem,
setor,
max_52_sem,
subsetor,
vol_med_2m,
valor_de_mercado,
ult_balanco_processado,
valor_da_firma,
nro_acoes,
dia_p,
pl,
lpa,
mes_p,
p_vp,
vpa,
dias_30_p,
p_ebit,
marg_bruta_p,
meses_12_p,
psr,
marg_ebit_p,
ano_2021_p,
p_ativos,
marg_liquida_p,
ano_2020_p,
p_cap_giro,
ebit_ativo_p,
ano_2019_p,
p_ativ_circ_liq,
roic_p,
ano_2018_p,
div_yield_p,
roe_p,
ano_2017_p,
ev_ebitda,
liquidez_corr,
ano_2016_p,
ev_ebit,
div_br_patrim,
cres_rec_5a_p,
giro_ativos,
ativo,
div_bruta,
disponibilidades,
div_liquida,
ativo_circulante,
patrim_liq,
receita_liquida_12,
receita_liquida_3,
ebit_12,
ebit_3,
lucro_liquido_12,
lucro_liquido_3)   
select papel,
cotacao,
tipo,
data_ult_cot,
empresa,
min_52_sem,
setor,
max_52_sem,
subsetor,
vol_med_2m,
valor_de_mercado,
ult_balanco_processado,
valor_da_firma,
nro_acoes,
dia_p,
pl,
lpa,
mes_p,
p_vp,
vpa,
dias_30_p,
p_ebit,
marg_bruta_p,
meses_12_p,
psr,
marg_ebit_p,
ano_2021_p,
p_ativos,
marg_liquida_p,
ano_2020_p,
p_cap_giro,
ebit_ativo_p,
ano_2019_p,
p_ativ_circ_liq,
roic_p,
ano_2018_p,
div_yield_p,
roe_p,
ano_2017_p,
ev_ebitda,
liquidez_corr,
ano_2016_p,
ev_ebit,
div_br_patrim,
cres_rec_5a_p,
giro_ativos,
ativo,
div_bruta,
disponibilidades,
div_liquida,
ativo_circulante,
patrim_liq,
receita_liquida_12,
receita_liquida_3,
ebit_12,
ebit_3,
lucro_liquido_12,
lucro_liquido_3
from fund_web2

-------------------------------------------------------------------------------------------------------------------------------
----copiar do csv para uma tabela no postgresql--------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
copy fund_web_txt
FROM '/mnt/samba_doc/local/fund_web_202303282332.csv'
DELIMITER ';'
CSV HEADER;
----antes criar a tabela abaixo------------------------------------------------------------------------------------------------
-------------------------------------------------------------------------------------------------------------------------------
create table fund_web_txt (
id_fund Varchar(500),
papel Varchar(500),
cotacao Varchar(500),
tipo Varchar(500),
data_ult_cot Varchar(500),
empresa Varchar(500),
min_52_sem Varchar(500),
setor Varchar(500),
max_52_sem Varchar(500),
subsetor Varchar(500),
vol_med_2m Varchar(500),
valor_de_mercado Varchar(500),
ult_balanco_processado Varchar(500),
valor_da_firma Varchar(500),
nro_acoes Varchar(500),
dia_p Varchar(500),
pl Varchar(500),
lpa Varchar(500),
mes_p Varchar(500),
p_vp Varchar(500),
vpa Varchar(500),
dias_30_p Varchar(500),
p_ebit Varchar(500),
marg_bruta_p Varchar(500),
meses_12_p Varchar(500),
psr Varchar(500),
marg_ebit_p Varchar(500),
ano_2021_p Varchar(500),
p_ativos Varchar(500),
marg_liquida_p Varchar(500),
ano_2020_p Varchar(500),
p_cap_giro Varchar(500),
ebit_ativo_p Varchar(500),
ano_2019_p Varchar(500),
p_ativ_circ_liq Varchar(500),
roic_p Varchar(500),
ano_2018_p Varchar(500),
div_yield_p Varchar(500),
roe_p Varchar(500),
ano_2017_p Varchar(500),
ev_ebitda Varchar(500),
liquidez_corr Varchar(500),
ano_2016_p Varchar(500),
ev_ebit Varchar(500),
div_br_patrim Varchar(500),
cres_rec_5a_p Varchar(500),
giro_ativos Varchar(500),
ativo Varchar(500),
div_bruta Varchar(500),
disponibilidades Varchar(500),
div_liquida Varchar(500),
ativo_circulante Varchar(500),
patrim_liq Varchar(500),
receita_liquida_12 Varchar(500),
receita_liquida_3 Varchar(500),
ebit_12 Varchar(500),
ebit_3 Varchar(500),
lucro_liquido_12 Varchar(500),
lucro_liquido_3 Varchar(500));

create table lp_fund_web (
papel VARCHAR(500),
cotacao VARCHAR(500),
tipo VARCHAR(500),
data_ult_cot VARCHAR(500),
empresa VARCHAR(500),
min_52_sem VARCHAR(500),
setor VARCHAR(500),
max_52_sem VARCHAR(500),
subsetor VARCHAR(500),
vol_med_2m VARCHAR(500),
valor_de_mercado VARCHAR(500),
ult_balanco_processado VARCHAR(500),
valor_da_firma VARCHAR(500),
nro_acoes VARCHAR(500),
dia_p VARCHAR(500),
pl VARCHAR(500),
lpa VARCHAR(500),
mes_p VARCHAR(500),
p_vp VARCHAR(500),
vpa VARCHAR(500),
dias_30_p VARCHAR(500),
p_ebit VARCHAR(500),
marg_bruta_p VARCHAR(500),
meses_12_p VARCHAR(500),
psr VARCHAR(500),
marg_ebit_p VARCHAR(500),
ano_atu VARCHAR(500),
p_ativos VARCHAR(500),
marg_liquida_p VARCHAR(500),
ano_m1 VARCHAR(500),
p_cap_giro VARCHAR(500),
ebit_ativo_p VARCHAR(500),
ano_m2 VARCHAR(500),
p_ativ_circ_liq VARCHAR(500),
roic_p VARCHAR(500),
ano_m3 VARCHAR(500),
div_yield_p VARCHAR(500),
roe_p VARCHAR(500),
ano_m4 VARCHAR(500),
ev_ebitda VARCHAR(500),
liquidez_corr VARCHAR(500),
ano_m5 VARCHAR(500),
ev_ebit VARCHAR(500),
div_br_patrim VARCHAR(500),
cres_rec_5a_p VARCHAR(500),
giro_ativos VARCHAR(500),
ativo VARCHAR(500),
div_bruta VARCHAR(500),
disponibilidades VARCHAR(500),
div_liquida VARCHAR(500),
ativo_circulante VARCHAR(500),
patrim_liq VARCHAR(500),
depositos VARCHAR(500),
cart_de_credito VARCHAR(500),
receita_liquida_12 VARCHAR(500),
receita_liquida_3 VARCHAR(500),
ebit_12 VARCHAR(500),
ebit_3 VARCHAR(500),
lucro_liquido_12 VARCHAR(500),
lucro_liquido_3 VARCHAR(500),
result_int_financ_12 VARCHAR(500),
result_int_financ_3 VARCHAR(500),
rec_servicos_12 VARCHAR(500),
rec_servicos_3 VARCHAR(500));

copy lp_fund_web
FROM '/mnt/samba_doc/local/web_fun.csv'
DELIMITER ';'
CSV HEADER;

--de-para do que já esta no banco para  o novo formato de tabela

--obs: verificar colunas rec_servicos_12 e rec_servicos_3 apagadas 

select 
papel,
cotacao,
tipo,
data_ult_cot,
empresa,
min_52_sem,
setor,
max_52_sem,
subsetor,
vol_med_2m,
valor_de_mercado,
ult_balanco_processado,
valor_da_firma,
nro_acoes,
dia_p,
pl,
lpa,
mes_p,
p_vp,
vpa,
dias_30_p,
p_ebit,
marg_bruta_p,
meses_12_p,
psr,
marg_ebit_p,
ano_2021_p as ano_atu,
p_ativos,
marg_liquida_p,
ano_2020_p as ano_m1,
p_cap_giro,
ebit_ativo_p,
ano_2019_p as ano_m2,
p_ativ_circ_liq,
roic_p,
ano_2018_p as ano_m3,
div_yield_p,
roe_p,
ano_2017_p as ano_m4,
ev_ebitda,
liquidez_corr,
ano_2016_p as ano_m5,
ev_ebit,
div_br_patrim,
cres_rec_5a_p,
giro_ativos,
ativo,
div_bruta as depositos,
disponibilidades as cart_de_credito,
patrim_liq,
0 as ativo_circulante,
0 as patrim_liq,
0 as depositos,
0 as cart_de_credito,
0 as receita_liquida_12,
0 as receita_liquida_3,
0 as ebit_12,
0 as ebit_3,
lucro_liquido_12,
lucro_liquido_3,
receita_liquida_12 as result_int_financ_12,
receita_liquida_3 as result_int_financ_3,
ebit_12 as rec_servicos_12,
ebit_3 as rec_servicos_3
from fund_web where papel in (select papel from lp_fund_web lfw where result_int_financ_12 is not null);

----------------------------------------------------------------------------------------------------------------
create table tb_fund_web as 
select q1.*from (
select
papel,
cotacao,
tipo,
data_ult_cot,
empresa,
min_52_sem,
setor,
max_52_sem,
subsetor,
vol_med_2m,
valor_de_mercado,
ult_balanco_processado,
valor_da_firma,
nro_acoes,
dia_p,
pl,
lpa,
mes_p,
p_vp,
vpa,
dias_30_p,
p_ebit,
marg_bruta_p,
meses_12_p,
psr,
marg_ebit_p,
ano_2021_p as ano_atu,
p_ativos,
marg_liquida_p,
ano_2020_p as ano_m1,
p_cap_giro,
ebit_ativo_p,
ano_2019_p as ano_m2,
p_ativ_circ_liq,
roic_p,
ano_2018_p as ano_m3,
div_yield_p,
roe_p,
ano_2017_p as ano_m4,
ev_ebitda,
liquidez_corr,
ano_2016_p as ano_m5,
ev_ebit,
div_br_patrim,
cres_rec_5a_p,
giro_ativos,
ativo,
0 as div_bruta,
0 as disponibilidades,
0 as div_liquida,
0 as ativo_circulante,
patrim_liq,
div_bruta as depositos,
disponibilidades as cart_de_credito,
0 as receita_liquida_12,
0 as receita_liquida_3,
0 as ebit_12,
0 as ebit_3,
lucro_liquido_12,
lucro_liquido_3,
receita_liquida_12 as result_int_financ_12,
receita_liquida_3 as result_int_financ_3,
ebit_12 as rec_servicos_12,
ebit_3 as rec_servicos_3
from fund_web where papel in (select distinct papel from lp_fund_web lfw where result_int_financ_12 is not null)
union all 
select
papel,
cotacao,
tipo,
data_ult_cot,
empresa,
min_52_sem,
setor,
max_52_sem,
subsetor,
vol_med_2m,
valor_de_mercado,
ult_balanco_processado,
valor_da_firma,
nro_acoes,
dia_p,
pl,
lpa,
mes_p,
p_vp,
vpa,
dias_30_p,
p_ebit,
marg_bruta_p,
meses_12_p,
psr,
marg_ebit_p,
ano_2021_p as ano_atu,
p_ativos,
marg_liquida_p,
ano_2020_p as ano_m1,
p_cap_giro,
ebit_ativo_p,
ano_2019_p as ano_m2,
p_ativ_circ_liq,
roic_p,
ano_2018_p as ano_m3,
div_yield_p,
roe_p,
ano_2017_p as ano_m4,
ev_ebitda,
liquidez_corr,
ano_2016_p as ano_m5,
ev_ebit,
div_br_patrim,
cres_rec_5a_p,
giro_ativos,
ativo,
div_bruta,
disponibilidades,
div_liquida,
ativo_circulante,
patrim_liq,
0 as depositos,
0 as cart_de_credito,
receita_liquida_12,
receita_liquida_3,
ebit_12,
ebit_3,
lucro_liquido_12,
lucro_liquido_3,
0 as result_int_financ_12,
0 as result_int_financ_3,
0 as rec_servicos_12,
0 as rec_servicos_3
from fund_web where papel not in (select distinct papel from lp_fund_web lfw where result_int_financ_12 is not null and papel is not null)
) as q1;
--------------------------------------------------------------------------------------------------------------------------------------------------------
--select count(*) from fund_web;
select 
papel,
cast(replace(replace(cotacao, '.', ''), ',', '.') as float) as cotacao,
tipo,
case 
	when data_ult_cot = '-' then null
else cast(	substring(data_ult_cot from 7 for 4) || '-' || 
			substring(data_ult_cot from 4 for 2) || '-' || 
			substring(data_ult_cot from 0 for 3) as date) end as data_ult_cot,
--cast(replace(data_ult_cot,'/','-') as date) as data_ult_cot,
empresa,
cast(replace(replace(min_52_sem, '.', ''), ',', '.') as float) as min_52_sem,
setor,
cast(replace(replace(max_52_sem, '.', ''), ',', '.') as float) as max_52_sem,
subsetor,
cast(replace(replace(vol_med_2m, '.', ''), ',', '.') as float) as vol_med_2m,
cast(replace(replace(valor_de_mercado, '.', ''), ',', '.') as float) as valor_de_mercado,
case 
	when ult_balanco_processado = '-' then null
else cast(	substring(ult_balanco_processado from 7 for 4) || '-' || 
			substring(ult_balanco_processado from 4 for 2) || '-' || 
			substring(ult_balanco_processado from 0 for 3) as date) end as ult_balanco_processado,
case 
	when valor_da_firma = '-' then null
	else cast(replace(replace(valor_da_firma, '.', ''), ',', '.') as float)
end as valor_da_firma,
cast(replace(replace(nro_acoes, '.', ''), ',', '.') as float) as nro_acoes,
cast(replace(replace(replace(dia_p, '%', ''), '.', ''), ',', '.') as float) as dia_p,
pl,
lpa,
--mes_p,
cast(replace(replace(replace(mes_p, '%', ''), '.', ''), ',', '.') as float) as mes_p,
p_vp,
vpa,
--dias_30_p,
cast(replace(replace(replace(dias_30_p, '%', ''), '.', ''), ',', '.') as float) as dias_30_p,
p_ebit,
--marg_bruta_p,
case
	when marg_bruta_p = '-' then null
	else cast(replace(replace(replace(marg_bruta_p, '%', ''), '.', ''), ',', '.') as float)
end as marg_bruta_p,
--meses_12_p,
cast(replace(replace(replace(meses_12_p, '%', ''), '.', ''), ',', '.') as float) as meses_12_p,
psr,
marg_ebit_p,
case
	when marg_ebit_p = '-' then null
	else cast(replace(replace(replace(marg_ebit_p, '%', ''), '.', ''), ',', '.') as float)
end as marg_ebit_p,
ano_atu,
p_ativos,
--marg_liquida_p,
case
	when marg_liquida_p = '-' then null
	else cast(replace(replace(replace(marg_liquida_p, '%', ''), '.', ''), ',', '.') as float) 
end as marg_liquida_p,
ano_m1,
--a partir daqui
--p_cap_giro,
case
	when p_cap_giro = '-' then null
	else cast(replace(replace(p_cap_giro, '.', ''), ',', '.') as float) 
end as p_cap_giro,
--ebit_ativo_p,
case
	when ebit_ativo_p = '-' then null
	else cast(replace(replace(replace(ebit_ativo_p, '%', ''), '.', ''), ',', '.') as float) 
end as ebit_ativo_p,
ano_m2,
--p_ativ_circ_liq,
case
	when p_ativ_circ_liq = '-' then null
	else cast(replace(replace(p_ativ_circ_liq, '.', ''), ',', '.') as float) 
end as p_ativ_circ_liq,
--roic_p,
case
	when roic_p = '-' then null
	else cast(replace(replace(replace(roic_p, '%', ''), '.', ''), ',', '.') as float) 
end as roic_p,
ano_m3,
--div_yield_p,
case
	when div_yield_p = '-' then null
	else cast(replace(replace(replace(div_yield_p, '%', ''), '.', ''), ',', '.') as float) 
end as div_yield_p,
--roe_p,
case
	when roe_p = '-' then null
	else cast(replace(replace(replace(roe_p, '%', ''), '.', ''), ',', '.') as float) 
end as roe_p,
ano_m4,
--ev_ebitda,
case
	when ev_ebitda = '-' then null
	else cast(replace(replace(ev_ebitda, '.', ''), ',', '.') as float) 
end as ev_ebitda,
--liquidez_corr,
case
	when liquidez_corr = '-' then null
	else cast(replace(replace(liquidez_corr, '.', ''), ',', '.') as float) 
end as liquidez_corr,
ano_m5,
--ev_ebit,
case
	when ev_ebit = '-' then null
	else cast(replace(replace(ev_ebit, '.', ''), ',', '.') as float) 
end as ev_ebit,
--div_br_patrim,
case
	when div_br_patrim = '-' then null
	else cast(replace(replace(div_br_patrim, '.', ''), ',', '.') as float) 
end as div_br_patrim,
--cres_rec_5a_p,
case
	when cres_rec_5a_p = '-' then null
	else cast(replace(replace(replace(cres_rec_5a_p, '%', ''), '.', ''), ',', '.') as float) 
end as cres_rec_5a_p,
--giro_ativos,
case
	when giro_ativos = '-' then null
	else cast(replace(replace(giro_ativos, '.', ''), ',', '.') as float) 
end as giro_ativos,
--ativo,
case
	when ativo = '-' then null
	else cast(replace(replace(ativo, '.', ''), ',', '.') as float) 
end as ativo,
--div_bruta,
case
	when div_bruta = '-' then null
	else cast(replace(replace(div_bruta, '.', ''), ',', '.') as float) 
end as div_bruta,
--disponibilidades,
case
	when disponibilidades = '-' then null
	else cast(replace(replace(disponibilidades, '.', ''), ',', '.') as float) 
end as disponibilidades,
--div_liquida,
case
	when div_liquida = '-' then null
	else cast(replace(replace(div_liquida, '.', ''), ',', '.') as float) 
end as div_liquida,
--ativo_circulante,
case
	when ativo_circulante = '-' then null
	else cast(replace(replace(ativo_circulante, '.', ''), ',', '.') as float) 
end as ativo_circulante,
--patrim_liq,
case
	when patrim_liq = '-' then null
	else cast(replace(replace(patrim_liq, '.', ''), ',', '.') as float) 
end as patrim_liq,
--depositos,
case
	when depositos = '-' then null
	else cast(replace(replace(depositos, '.', ''), ',', '.') as float) 
end as depositos,
--cart_de_credito,
case
	when cart_de_credito = '-' then null
	else cast(replace(replace(cart_de_credito, '.', ''), ',', '.') as float) 
end as cart_de_credito,
--receita_liquida_12,
case
	when receita_liquida_12 = '-' then null
	else cast(replace(replace(receita_liquida_12, '.', ''), ',', '.') as float) 
end as receita_liquida_12,
--receita_liquida_3,
case
	when receita_liquida_3 = '-' then null
	else cast(replace(replace(receita_liquida_3, '.', ''), ',', '.') as float) 
end as receita_liquida_3,
--ebit_12,
case
	when ebit_12 = '-' then null
	else cast(replace(replace(ebit_12, '.', ''), ',', '.') as float) 
end as ebit_12,
--ebit_3,
case
	when ebit_3 = '-' then null
	else cast(replace(replace(ebit_3, '.', ''), ',', '.') as float) 
end as ebit_3,
--lucro_liquido_12,
case
	when lucro_liquido_12 = '-' then null
	else cast(replace(replace(lucro_liquido_12, '.', ''), ',', '.') as float) 
end as lucro_liquido_12,
--lucro_liquido_3,
case
	when lucro_liquido_3 = '-' then null
	else cast(replace(replace(lucro_liquido_3, '.', ''), ',', '.') as float) 
end as lucro_liquido_3,
--result_int_financ_12,
case
	when result_int_financ_12 = '-' then null
	else cast(replace(replace(result_int_financ_12, '.', ''), ',', '.') as float) 
end as result_int_financ_12,
--result_int_financ_3,
case
	when result_int_financ_3 = '-' then null
	else cast(replace(replace(result_int_financ_3, '.', ''), ',', '.') as float) 
end as result_int_financ_3,
--rec_servicos_12,
case
	when rec_servicos_12 = '-' then null
	else cast(replace(replace(rec_servicos_12, '.', ''), ',', '.') as float) 
end as rec_servicos_12,
--rec_servicos_3
case
	when rec_servicos_3 = '-' then null
	else cast(replace(replace(rec_servicos_3, '.', ''), ',', '.') as float) 
end as rec_servicos_3
from lp_fund_web where papel is not null;