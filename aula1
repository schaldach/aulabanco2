-- DROP TABLE produtos
CREATE TABLE produtos (
    produto_id INT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    descricao TEXT,
    preco DECIMAL(10, 2)
);

-- DROP TABLE vendas
CREATE TABLE vendas (
    venda_id INT PRIMARY KEY,
    produto_id INT,
    data_venda DATE,
    quantidade INT,
    valor_total DECIMAL(10, 2),
    FOREIGN KEY (produto_id) REFERENCES produtos(produto_id)
);

-- todas as vendas
SELECT 
p.nome, 
COALESCE(sum(valor_total*quantidade), 0) as valor, 
round(COALESCE(sum(valor_total*quantidade), 0) / (SELECT sum(quantidade*valor_total) FROM vendas)*100, 2)||'%' as porcento
FROM produtos p
LEFT JOIN vendas v ON p.produto_id = v.produto_id
GROUP BY p.produto_id ORDER BY valor DESC

-- somente acima de 1000
-- explain analyze cost=24.85..24.96

SELECT 
p.nome, 
COALESCE(sum(valor_total*quantidade), 0) as valor, 
round(COALESCE(sum(valor_total*quantidade), 0) / (SELECT sum(quantidade*valor_total) FROM vendas)*100, 2)||'%' as porcento
FROM produtos p
LEFT JOIN vendas v ON p.produto_id = v.produto_id
GROUP BY p.produto_id HAVING COALESCE(sum(valor_total*quantidade), 0) >= 1000 ORDER BY valor DESC

with vendas_filtradas as (
SELECT sum(quantidade*valor_total) as total_vendas FROM vendas
)

-- uma view não mudaria a performance, mas uma cte melhora                                  
select * from total_vendas

SELECT 
p.nome, 
COALESCE(sum(valor_total*quantidade), 0) as valor, 
round(COALESCE(sum(valor_total*quantidade), 0) / (total_vendas)*100, 2)||'%' as porcento
FROM produtos p, total_vendas -- cross join (só adicionando essa "variável" em cada linha do select)
LEFT JOIN vendas v ON p.produto_id = v.produto_id
GROUP BY p.produto_id HAVING COALESCE(sum(valor_total*quantidade), 0) >= 1000 ORDER BY valor DESC
