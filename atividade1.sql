-- Questão 1 – Criando uma Procedure
-- Crie uma procedure chamada registrar_pedido que insira um novo pedido na tabela pedidos.
-- A procedure deve receber como parâmetros o nome do cliente e o valor do pedido.
-- O status inicial deve ser sempre "Pendente".
-- A data do pedido deve ser a data e hora atuais.
-- Após a inserção, exibir o ID do pedido criado

-- SQL
-- DROP TABLE pedidos;
CREATE TABLE pedidos (
  id SERIAL PRIMARY KEY,
  cliente VARCHAR(100) NOT NULL,
  data_pedido TIMESTAMP,
  valor NUMERIC(10,2) ,
  status_pedido VARCHAR(20)
);

CREATE OR REPLACE PROCEDURE registrar_pedido(nome_cliente VARCHAR(100), valor_pedido NUMERIC(10,2))
LANGUAGE plpgsql
AS $$
DECLARE
    id_pedido_inserido INTEGER;
BEGIN
    INSERT INTO pedidos(cliente, data_pedido, valor, status_pedido)
      VALUES (nome_cliente, NOW(), valor_pedido, 'Pendente')
      RETURNING id INTO id_pedido_inserido;
    RAISE NOTICE 'Pedido de ID % foi inserido', id_pedido_inserido;
END;
$$;

-- Testes
CALL registrar_pedido('SÉRGIO', 123.21);
CALL registrar_pedido('ATLAS', 765.43);
CALL registrar_pedido('DINA', 5432312.1);

SELECT * FROM pedidos;

-- Questão 2 – Criando Triggers para Monitoramento
-- Crie triggers separados para monitorar cada operação na tabela pedidos:
CREATE TABLE log_pedidos (
  id SERIAL PRIMARY KEY,
  pedido_id INT,
  operacao VARCHAR(50),
  data_log TIMESTAMP
);

-- 1. Trigger para INSERT
-- Sempre que um novo pedido for inserido, registre a ação em uma tabela de log chamada log_pedidos, incluindo o ID do pedido, a operação realizada e a data.
-- SQL
CREATE OR REPLACE FUNCTION insert_pedidos_log()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 AS
$$
BEGIN
	INSERT INTO log_pedidos(pedido_id, operacao, data_log)
	  VALUES(NEW.id, 'Inserção', NOW());
	RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER t_insert_pedidos_log
 AFTER INSERT
 ON pedidos
 FOR EACH ROW
 EXECUTE PROCEDURE insert_pedidos_log();

-- Testes
CALL registrar_pedido('HERNANES', 54.19);

SELECT * FROM pedidos;
SELECT * FROM log_pedidos;

-- 2. Trigger para UPDATE
-- Se o status de um pedido for alterado para "Processado" ou "Cancelado", registre a alteração na tabela log_pedidos.
-- SQL
CREATE OR REPLACE FUNCTION update_pedidos_log()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 AS
$$
BEGIN
	IF NEW.status_pedido = 'Processado' OR NEW.status_pedido = 'Cancelado' THEN
    INSERT INTO log_pedidos(pedido_id, operacao, data_log)
	    VALUES(NEW.id, 'Alterado para ' || NEW.status_pedido, NOW());
  END IF;
	RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER t_update_pedidos_log
 AFTER UPDATE
 ON pedidos
 FOR EACH ROW
 EXECUTE PROCEDURE update_pedidos_log();

-- Testes

UPDATE pedidos SET status_pedido = 'Processado' WHERE id = 3;

SELECT * FROM pedidos;
SELECT * FROM log_pedidos;

-- 3. Trigger para DELETE
-- Somente podem ser deletados pedidos com situação "Pendente"
-- Se nao deletar, emitir um alerta na tela
-- SQL
CREATE OR REPLACE FUNCTION delete_pedidos()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 AS
$$
BEGIN
	IF OLD.status_pedido <> 'Pendente' THEN
		RAISE EXCEPTION 'Só é possível deletar pedidos com situação Pendente';
	END IF;
	RETURN OLD;
END;
$$;

CREATE OR REPLACE TRIGGER t_delete_pedidos
 BEFORE DELETE
 ON pedidos
 FOR EACH ROW
 EXECUTE PROCEDURE delete_pedidos();

-- Testes

DELETE FROM pedidos WHERE id = 1;

SELECT * FROM pedidos;
