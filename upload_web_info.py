import dbpg as db
import os
import dotenv as dot_env

dot_env.load_dotenv(dot_env.find_dotenv())

print(os.getenv('SENHA'))
