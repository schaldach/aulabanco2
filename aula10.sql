-- Data warehouse (armazém) = dados já processados para finalidade específica
-- Data lake = dados brutos, sem finalidade definida ainda
-- os dados nelas são duplicados/replicados! para não disputar recursos com a base de dados fonte/de produção, 
-- já usada por outros usuários... para não concorrer com as transações, e não comprometer a performance do banco de produção

-- Várias fontes -> ETL -> Data Warehouse -> Casos de uso (análise, ...)

-- star schema: modelo SQL para uma Data Warehouse
-- Temos uma tabela central, a tabela "fato" (com as vendas, por exemplo) e várias tabelas
-- "dimensões", que acrescentam a tabela central. É menos normalizado (desnormalização da base normalizada), 
-- e acaba deixando certas consultas muito mais rápidas em um banco de dados gigante

-- Também chamado de modelagem dimensional, onde temos "dimensões" e "fatos"
-- essa modelagem é em um outro banco de dados além do já existente/produção, somente para leitura
-- serve muito bem para, por exemplo, dados "derivados" dos dados brutos, como dia da semana, feriado, etc. a partir do DATETIME
-- No star schema, todas as dimensões se relacionam diretamente com o fato, diferente do snowflake, onde existem dimensões auxiliares 

-- Fato -> Transação
-- Dimensão -> Perguntas que são respondidas
-- Medidas são os atributos numéricos que representam um fato, na tabela principal

-- OLAP: tecnologia de banco de dados que foi otimizada para consulta e relatório, em vez de processar transações.
-- Os dados de origem do OLAP são bancos de dados OLTP (Processamento Transacional Online) que são comumente armazenados em data warehouses.

-- Operações mais feitas em um sistema OLAP:
-- Drill down = diminuindo a granularidade, de ano para trimestre para mês...
-- Drill up = aumentando a granularidade, de mês para trimestre para ano...
-- Slice = filtrar os dados de acordo com algum atributo

-- se toda vez que precisarmos extrair, executarmos todos os comandos, é muito custoso
-- se já tivermos uma tabela e apenas consultarmos nela, é muito mais rápido
-- por isso que existe o modelo estrela, por exemplo
