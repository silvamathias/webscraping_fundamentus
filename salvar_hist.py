import pandas as pd
import dbpg as db

sql = db.conectar()

df1 = sql.cons_pandas('select * from fund_web;')

df1.to_csv('baseweb_csv', sep = ';', index = False)
