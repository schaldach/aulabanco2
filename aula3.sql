ALTER TABLE produtos ADD saldo INTEGER;
 
CREATE OR REPLACE PROCEDURE atualizar_saldo()
LANGUAGE plpgsql
AS $$
DECLARE v_reg_produto RECORD;
BEGIN
	FOR v_reg_produto IN SELECT p.id_produto, p.nome_produto, COALESCE(q_c, 0), COALESCE(q_v, 0), COALESCE(q_c, 0) - COALESCE(q_v, 0) as saldo
	FROM produtos p
	LEFT JOIN (SELECT sum(quantidade) as q_c, id_produto FROM compras GROUP BY id_produto) c ON c.id_produto = p.id_produto
	LEFT JOIN (SELECT sum(quantidade) as q_v, id_produto FROM vendas GROUP BY id_produto) v ON v.id_produto = p.id_produto
	LOOP
		UPDATE produtos SET saldo = v_reg_produto.saldo WHERE id_produto = v_reg_produto.id_produto;
		-- RAISE NOTICE 'Produto: %, Comprado: %, Vendido: %, Saldo: %', v_reg_produto.nome_produto, v_reg_produto.q_c, v_reg_produto.q_v, v_reg_produto.saldo;
	END LOOP;
END;
$$;
CALL atualizar_saldo();

ALTER TABLE produtos ADD saldo INTEGER;
CREATE TABLE logs_saldo(
  id_log SERIAL PRIMARY KEY,
  id_produto INTEGER,
  q_compras INTEGER,
  q_vendas INTEGER,
  saldo_inicial INTEGER,
  saldo_final INTEGER,
  data_hora TIMESTAMP
)

CREATE OR REPLACE PROCEDURE atualizar_saldo_log()
LANGUAGE plpgsql
AS $$
DECLARE
    v_reg_produto RECORD;
    v_compras INTEGER;
    v_vendas INTEGER;
    saldo_antigo INTEGER;
BEGIN
    FOR v_reg_produto IN SELECT id_produto, nome_produto FROM produtos LOOP
  
        SELECT COALESCE(SUM(quantidade), 0)  INTO v_compras FROM compras WHERE id_produto = v_reg_produto.id_produto;
        SELECT COALESCE(SUM(quantidade), 0)  INTO v_vendas FROM vendas WHERE id_produto = v_reg_produto.id_produto;
        SELECT saldo INTO saldo_antigo FROM produtos WHERE id_produto = v_reg_produto.id_produto;

        UPDATE produtos SET saldo = v_compras - v_vendas WHERE id_produto = v_reg_produto.id_produto;
        INSERT INTO logs_saldo(id_produto, q_compras, q_vendas, saldo_inicial, saldo_final, data_hora) 
          VALUES (v_reg_produto.id_produto, v_compras, v_vendas, saldo_antigo, v_compras - v_vendas, NOW());
        -- esqueci de levantar um erro quando q_compras é maior que q_vendas
    END LOOP;
END;
$$;

CALL atualizar_saldo_log();
-- única diferença para uma FUNCTION é o nome e a cláusula RETURNS "tipo", ela sempre retornará um valor, podendo ser também do tipo VOID. e ao invés de CALL, é SELECT
 -- "in" é opcional, determina que o parâmetro é de entrada, e "out" significaria de saída
CREATE OR REPLACE FUNCTION dif_salario_medio (in cod int) returns double precision
AS
$$
DECLARE
	media double precision;
	diferenca double precision;
	reg_professor RECORD;
BEGIN
	SELECT AVG(salario) FROM professor into media;
	SELECT salario, id, nome FROM professor WHERE id = cod INTO reg_professor;
	IF(reg_professor.id IS NULL) THEN
		RAISE NOTICE 'Professor não existe';
		RETURN 0;
	ELSE
		diferenca := ABS(media - reg_professor.salario);
		RAISE NOTICE 'Diferença do salário do Prof. % e o salário médio é %', reg_professor.nome, diferenca;
		RETURN diferenca;
	END IF;
END;
$$ language plpgsql;

SELECT dif_salario_medio(1);
