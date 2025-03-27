CREATE OR REPLACE FUNCTION id_existe (in cod int) returns void
AS
$$
BEGIN
	IF (SELECT id_professor FROM professor WHERE id_professor = cod) IS NULL THEN
		RAISE NOTICE 'O professor não existe';
	END IF;
END;
$$ language plpgsql;

SELECT id_existe(0);

-- Uma TRIGGER é uma função invocada automaticamente sempre que ocorre um evento associado a uma tabela. (para qualquer linha)
-- Um evento pode ser qualquer um de: INSERT, UPDATE, DELETE, TRUNCATE (equivalente a um DELETE sem WHERE)
-- Primeiro criamos uma "trigger function" e depois associamos ela a uma tabela, a trigger em si
-- a diferença para uma FUNCTION é que a TRIGGER é invocada automaticamente, a FUNCTION é quando queremos
-- podemos especificar se queremos a TRIGGER invocada antes ou depois de um evento (BEFORE ou AFTER)
-- é muito bom para gravar logs, e permite manter regras complexas e acrescentar regras de negócio sem mudar a aplicação, apenas no banco
-- uma coisa ruim é que perdemos o controle de versão dos códigos fonte, e é preciso que todos saibam delas (perde o controle facilmente)

-- a criação da trigger function é igual uma function, mas vai ter "RETURNS TRIGGER", e não recebe nenhum argumento
-- referenciaremos a linha que estava na tabela e a nova linha como NEW e OLD na trigger function
-- (em um UPDATE teremos os 2, em um DELETE teremos apenas OLD, em um INSERT teremos apenas NEW)
-- pode existir mas AFTER um DELETE e BEFORE um INSERT não são geralmente usados

-- exemplo
-- setup
DROP TABLE IF EXISTS employees;
CREATE TABLE employees(
 id INT GENERATED ALWAYS AS IDENTITY,
 first_name VARCHAR(40) NOT NULL,
 last_name VARCHAR(40) NOT NULL,
 PRIMARY KEY(id)
);

CREATE TABLE employee_audits (
 id INT GENERATED ALWAYS AS IDENTITY,
 employee_id INT NOT NULL,
 last_name_before VARCHAR(40) NOT NULL,
 last_name_after VARCHAR(40) NOT NULL,
 changed_on TIMESTAMP(6) NOT NULL
);

-- trigger
CREATE OR REPLACE FUNCTION log_last_name_changes()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 AS
$$
BEGIN
	IF NEW.last_name <> OLD.last_name THEN
		--INSERT INTO employee_audits(employee_id,last_name,changed_on)
		--VALUES(OLD.id,OLD.last_name,now());
		INSERT INTO employee_audits(employee_id,last_name_before,last_name_after,changed_on)
		VALUES(OLD.id,OLD.last_name,NEW.last_name,now());
	END IF;
	RETURN NEW; -- parece ser um padrão, não sei o que significa mas se não tiver dará um erro
END;
$$;

CREATE TRIGGER last_name_changes
 BEFORE UPDATE
 ON employees
 FOR EACH ROW
 EXECUTE PROCEDURE log_last_name_changes();
 
-- executando 
 INSERT INTO employees (first_name, last_name)
VALUES ('John', 'Doe');
INSERT INTO employees (first_name, last_name)
VALUES ('Lily', 'Bush');

SELECT * FROM employees;

UPDATE employees
SET last_name = 'Brown'
WHERE ID = 2;

SELECT * FROM employees;
SELECT * FROM employee_audits;

-- outros exercicios
CREATE OR REPLACE FUNCTION upper_name()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 AS
$$
BEGIN
	UPDATE employees SET first_name = UPPER(NEW.first_name), last_name = UPPER(NEW.last_name) WHERE id = NEW.id;
	RETURN NEW;
END;
$$;
CREATE OR REPLACE TRIGGER name_changes
 AFTER INSERT -- AQUI TEM QUE SER AFTER!
 ON employees
 FOR EACH ROW
 EXECUTE PROCEDURE upper_name();

CREATE OR REPLACE FUNCTION check_name()
 RETURNS TRIGGER
 LANGUAGE PLPGSQL
 AS
$$
BEGIN
	IF LENGTH(NEW.first_name) < 4 THEN
		RAISE EXCEPTION 'nome muito curto';
	END IF;
	RETURN NEW;
END;
$$;
CREATE OR REPLACE TRIGGER first_name_changes
 BEFORE INSERT -- AQUI TEM QUE SER BEFORE!
 ON employees
 FOR EACH ROW
 EXECUTE PROCEDURE check_name();


 INSERT INTO employees (first_name, last_name)
VALUES ('John', 'Makal');

 INSERT INTO employees (first_name, last_name)
VALUES ('Aba', 'Makali');

SELECT * FROM employees;
