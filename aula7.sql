-- EXERCICIOS

CREATE TABLE Departamentos (
    id_depto SERIAL PRIMARY KEY,
    nome_depto VARCHAR(100) NOT NULL,
    localizacao VARCHAR(50)
);

CREATE TABLE Empregados (
    id_emp SERIAL PRIMARY KEY,
    nome_emp VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    salario DECIMAL(10, 2),
    id_depto INT,
    CONSTRAINT fk_depto FOREIGN KEY (id_depto) REFERENCES Departamentos(id_depto)
);

CREATE TABLE Projetos (
    id_proj SERIAL PRIMARY KEY,
    nome_proj VARCHAR(100) NOT NULL,
    orcamento DECIMAL(12, 2)
);

CREATE TABLE Emp_Proj (
    id_emp INT,
    id_proj INT,
    horas_alocadas INT,
    PRIMARY KEY (id_emp, id_proj),
    CONSTRAINT fk_emp FOREIGN KEY (id_emp) REFERENCES Empregados(id_emp),
    CONSTRAINT fk_proj FOREIGN KEY (id_proj) REFERENCES Projetos(id_proj)
);

-- Departamentos
INSERT INTO Departamentos (id_depto, nome_depto, localizacao) VALUES
(1, 'Engenharia', 'Bloco A'),
(2, 'Marketing', 'Bloco B'),
(3, 'Vendas', 'Bloco C'),
(4, 'RH', 'Bloco A');

-- Empregados
INSERT INTO Empregados (id_emp, nome_emp, cargo, salario, id_depto) VALUES
(101, 'Alice Silva', 'Engenheira Software', 7000.00, 1),
(102, 'Bruno Costa', 'Analista Marketing', 5500.00, 2),
(103, 'Carla Lima', 'Vendedora Sênior', 6500.00, 3),
(104, 'Daniel Moreira', 'Engenheiro Dados', 7200.00, 1),
(105, 'Eduarda Souza', 'Estagiária Marketing', 2500.00, 2),
(106, 'Fernando Alves', 'Gerente Vendas', 9000.00, 3),
(107, 'Gabriela Rocha', 'Recrutadora', 4800.00, 4);

-- Projetos
INSERT INTO Projetos (id_proj, nome_proj, orcamento) VALUES
(1001, 'Sistema Alpha', 50000.00),
(1002, 'Campanha Beta', 20000.00),
(1003, 'Plataforma Gamma', 120000.00),
(1004, 'Feira Delta', 15000.00);

-- Emp_Proj (Alocação de Empregados em Projetos)
INSERT INTO Emp_Proj (id_emp, id_proj, horas_alocadas) VALUES
(101, 1001, 120), -- Alice no Sistema Alpha
(101, 1003, 80),  -- Alice na Plataforma Gamma
(102, 1002, 100), -- Bruno na Campanha Beta
(103, 1004, 150), -- Carla na Feira Delta
(104, 1003, 160), -- Daniel na Plataforma Gamma
(105, 1002, 60),  -- Eduarda na Campanha Beta
(101, 1002, 20);  -- Alice na Campanha Beta (para ter um empregado em múltiplos projetos com marketing)

-- Selecione o nome do empregado, nome do departamento, nome do projeto e horas alocadas
-- do depto com localizacao = 'Bloco A.orcamento do projerto > 30000.00;
EXPLAIN ANALYZE
SELECT nome_emp, nome_depto, nome_proj, horas_alocadas
FROM Empregados 
JOIN Departamentos USING (id_depto)
JOIN Emp_Proj USING (id_emp)
JOIN Projetos USING (id_proj)
WHERE localizacao = 'Bloco A' AND orcamento > 30000.00;
-- Em álgebra relacional:
-- π nome_emp, nome_depto, nome_proj, horas_alocadas(σ localizacao = 'Bloco A', orcamento > 30000.00 (Empregados ⨝ Departamentos ⨝ Emp_Proj ⨝ Projetos))

-- Faça a tabela de execução (pelo resultado do explain analyze) (olhamos de baixo para cima!):
--	π nome_emp, nome_depto, nome_proj, horas_alocadas
--					|
-- σ localizacao = 'Bloco A' AND orcamento > 30000.00
--					|
--					⨝ Empregados
--				 |
--				 ⨝ Depto
-- 			  |
-- Proj ⨝ Emp_Proj

-- Por qual tabela você começaria a ler os dados? Por quê?
-- R: Pela tabelas "Departamentos" ou "Projetos", pois são usados no WHERE.

-- O filtro D.localizacao = 'Bloco A' pode ser aplicado antes de qual JOIN?
-- R:

-- O filtro P.orcamento > 30000.00 pode ser aplicado antes de qual JOIN?
-- R:

-- Se você filtrar Departamentos primeiro, quantas linhas sobram?
-- R:

-- Se você filtrar Projetos primeiro, quantas linhas sobram?
-- R:

-- Considerando os resultados dos filtros, qual JOIN faria sentido executar primeiro?
-- R:
