import psycopg2
import pandas as pd

class conectar:
    def __init__(self):
        self.info_h = input('Informe o host:')
        self.info_s = input('Informe a senha:')
        try:
            self.conn = psycopg2.connect(host=self.info_h,database='renda_variavel',user='postgres',password=self.info_s);
            self.cur = self.conn.cursor;

        except:
            print('Erro ao se conectar a base de dados!');

    def consultar(self,query):
        sql = self.cur()
        sql.execute(query)
        return sql.fetchall()

    def manipular(self,query):
        sql = self.cur()
        sql.execute(query);
        sql.execute('commit');

    def cons_pandas(self,query):
        df = pd.read_sql_query(query,con=self.conn);
        return df

if __name__ == '__main__':
    cn = conectar()

    c = cn.cons_pandas('select * from temp_hist where id_hist <= 20;')
    print(c)
    m = cn.manipular("update temp_hist set cod = 'BBDC3' where id_hist < 4;")

    p = cn.cons_pandas('select * from temp_hist where id_hist <= 20;')
    print(p)
