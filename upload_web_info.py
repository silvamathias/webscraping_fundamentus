import dbpg as db
import os
import dotenv as dot_env
import shutil

dot_env.load_dotenv(dot_env.find_dotenv())

local = os.getcwd() + '/'
arq_csv = 'web_fun.csv'

#shutil.copy(local + arq_csv, os.getenv('smb_folder') + 'web_info.csv')

cn = db.conectar(os.getenv('pg_server'), os.getenv('pg_key'))
cn.manipular('delete from lp_fund_web')

query_upload_csv = '''
copy lp_fund_web
FROM '/mnt/samba_doc/local/web_info.csv'
DELIMITER ';'
CSV HEADER;
'''

cn.manipular(query_upload_csv)