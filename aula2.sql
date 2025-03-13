CREATE OR REPLACE PROCEDURE procedimento_simples()
LANGUAGE plpgsql
AS $$
BEGIN 
	RAISE NOTICE 'primeiro database procedure';
END;
$$;

CALL procedimento_simples();

CREATE OR REPLACE PROCEDURE procedimento_simples_2(num1 integer, num2 integer)
LANGUAGE plpgsql
AS $$
BEGIN 
	RAISE NOTICE 'os números são n1=% e n2=%', num1, num2;
	-- os "%" referenciam os argumentos passados na mesma ordem
END;
$$;

CALL procedimento_simples_2(9, 81);

CREATE OR REPLACE PROCEDURE procedimento_simples_3(custom_text text)
LANGUAGE plpgsql
AS $$
BEGIN 
	RAISE NOTICE '%', custom_text;
	-- tenq passar como parâmetro
END;
$$;

CALL procedimento_simples_3('alohaaaaaaaa');

CREATE OR REPLACE PROCEDURE procedimento_simples_mostrando_dados(p_id_produto integer)
LANGUAGE plpgsql
AS $$
BEGIN
	IF EXISTS (SELECT FROM produtos WHERE id_produto = p_id_produto) THEN
		SELECT 'O nome do produto de código ' || p_id_produto || ' é ' || nome_produto FROM produtos WHERE id_produto = p_id_produto into texto_saida;
		RAISE NOTICE '%', texto_saida;
	ELSE
		RAISE NOTICE 'O produto de código % não existe', p_id_produto;
	END IF;
END;
$$;

CALL procedimento_simples_mostrando_dados(2);

CREATE OR REPLACE PROCEDURE mostra_nome_produtos(preco_limite FLOAT)
LANGUAGE plpgsql
AS $$
DECLARE v_reg_produto RECORD; -- registro, acredito que representa uma linha do banco, select, etc
-- faz sentido, por isso que precisamos especificar a coluna do record mesmo ele tendo só uma coluna (pois ele está representando uma linha, registro)
BEGIN
	RAISE NOTICE 'Produtos com preço superior a % :', preco_limite;
	FOR v_reg_produto IN SELECT nome_produto, id_produto, preco_venda FROM produtos WHERE preco_venda > preco_limite
	LOOP
		RAISE NOTICE 'O produto de id % é o nome % com preço de %', v_reg_produto.id_produto, v_reg_produto.nome_produto, v_reg_produto.preco_venda;
	END LOOP;
END;
$$;

CALL mostra_nome_produtos(30);

CREATE OR REPLACE PROCEDURE mostra_produtos_maiusculo(maiusculo BOOLEAN)
LANGUAGE plpgsql
AS $$
DECLARE v_reg_produto RECORD;
DECLARE nome_produto_final TEXT;
BEGIN
	FOR v_reg_produto IN SELECT nome_produto, id_produto, preco_venda FROM produtos
	LOOP
		IF (maiusculo) THEN
			select upper(v_reg_produto.nome_produto) into nome_produto_final;
		ELSE 
			select lower(v_reg_produto.nome_produto) into nome_produto_final;
		END IF;
		RAISE NOTICE 'O produto de id % é o nome % com preço de %', v_reg_produto.id_produto, nome_produto_final, v_reg_produto.preco_venda;
	END LOOP;
END;
$$;

CALL mostra_produtos_maiusculo(true);

CREATE OR REPLACE PROCEDURE relatorio_produtos()
LANGUAGE plpgsql
AS $$
DECLARE v_reg_produto RECORD;
BEGIN
	RAISE NOTICE 'Relatório';
	FOR v_reg_produto IN SELECT p.nome_produto, q_c, q_v, q_c-q_v as saldo
	FROM produtos p
	JOIN (SELECT sum(quantidade) as q_c, id_produto FROM compras GROUP BY id_produto) c ON c.id_produto = p.id_produto
	JOIN (SELECT sum(quantidade) as q_v, id_produto FROM vendas GROUP BY id_produto) v ON v.id_produto = p.id_produto
	LOOP
		RAISE NOTICE 'Produto: %, Comprado: %, Vendido: %, Saldo: %', v_reg_produto.nome_produto, v_reg_produto.q_c, v_reg_produto.q_v, v_reg_produto.saldo;
	END LOOP;
END;
$$;
CALL relatorio_produtos();
