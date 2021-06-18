# 本地不同实例
bucardo add database local dbname=postgres dbhost=172.17.0.3 dbport=5432 dbpass=lumi6666 dbuser=postgres
bucardo add database inside dbname=postgres dbhost=localhost dbport=5432 dbpass=lumi6666 dbuser=postgres
bucardo add all tables db=local --relgroup=test --verbose
bucardo add sync delta relgroup=test dbs=local,inside

# 本地相同实例
bucardo add database test1 dbname=test1 dbhost=172.17.0.3 dbport=5432 dbpass=lumi6666 dbname=test1 dbuser=postgres
bucardo add database test2 dbname=test2 dbhost=172.17.0.3 dbport=5432 dbpass=lumi6666 dbname=test2 dbuser=postgres
bucardo add all tables db=test1 -T pgbench_history --relgroup=pgbench --verbose
bucardo add sync benchdelta relgroup=pgbench dbs=test1,test2

# 金山云->本地
