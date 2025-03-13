CREATE OR REPLACE PROCEDURE relatorio_produtos()
LANGUAGE plpgsql
AS $$
DECLARE v_reg_produto RECORD;
BEGIN
	RAISE NOTICE 'Relatório';
	FOR v_reg_produto IN SELECT p.nome_produto, sum(c.quantidade) as q_c, sum(v.quantidade) as q_v, sum(c.quantidade) - sum(v.quantidade) as saldo
	FROM produtos p
	JOIN compras c ON c.id_produto = p.id_produto
	JOIN vendas v ON v.id_produto = p.id_produto
	GROUP BY p.id_produto
	LOOP
		RAISE NOTICE 'Produto: %, Comprado: %, Vendido: %, Saldo: %', v_reg_produto.nome_produto, v_reg_produto.q_c, v_reg_produto.q_v, v_reg_produto.saldo;
	END LOOP;
END;
$$;
CALL relatorio_produtos();
