# webscraping_fundamentus

## Descrição

Pega os dados financeiros do site [Fundamentus](www.fundamentus.com.br) referentes as empresas listadas na B3.

### passo-a-passo


1. Crie um banco de dados no PostgreSql usando o script do arquivo criacao_banco.sql

2. Rode o arquivo **baixar_lista_papeis.py** para baixar todos os papeis com informações no site

3. Rode o arquivo **baixar_precos_info** para abrir cada empresa no site, pegar os dados e colocar banco

**OBS:** 
1. Veja a necessidade de alterar no arquivo fundamentus_bot3.py os nomes das tabelas do banco (pode haver um número "2" por exemplo). Costuma-se usar uma tabela paralela para evitar erro durante o insert e comprometer os dados já salvos.
2. O arquivo **nao_baixar.txt** pode ser atualizado manualmente com os dados do arquivo **nao_baixados.txt** onde cada linha deve conter um papel. Desrta forma os papeis contidos em  **nao_baixar.txt** serão ignorados. Atualmente este recurso não está em uso pois as empresas recentemente listadas dão erro por falta de dados mas no futuro quando tiverem dados no site não dará erro e, caso esteja na lista para não baixar, serão equivocadamente ignoradas. 

## resultados

* O arquivo listadas_b3.txt terá todas as empresas listadas que constam no site;
* O arquivo **nao_baixados.txt** terá todas as empresas que por algum motivo deu erro no insert  (geralmente dados faltantes por serem empresas recentes ou estarem impedidas de negociar);
* O banco de dados será atualizado com as informações dos site.



