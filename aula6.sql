-- traduzindo álgebra relacional para como usamos no SQL
-- união, seria quando juntamos 2 consultas SQL, irá juntar as linhas
-- (feito com o próprio UNION, básico mas quase nunca uso, ambas devem ter as mesmas colunas)
-- ⋈ = join, seria quando juntamos 2 tabelas, irá juntar as colunas 
-- (pelo que eu entendi é meio que genérico)
-- π = projeção, escolher as colunas
-- σ = seleção, escolher as linhas com base em uma condição

SELECT * FROM empregado WHERE salario<2000;
-- σ salario<2000 (empregado)

SELECT nome, idade FROM empregado;
-- π nome, idade (empregado)

SELECT nome, idade FROM empregado WHERE salario<2000;
-- π nome, idade(σ salario<2000 (empregado))

-- exercício
DROP TABLE R;
CREATE TABLE R(x int, y int, z int);
DROP TABLE S;
CREATE TABLE S(x int, y int, z int);
INSERT INTO R VALUES (1,1,1), (1,2,2), (2,2,3), (3,1,1);
INSERT INTO S VALUES (1,1,1), (1,2,1), (3,1,1);
SELECT * FROM R INNER JOIN S USING (x,y,z);

-- usando https://dbis-uibk.github.io/relax/calc/gist/d37f667154aec34f5c4954723ae01db9/DBS1_MovieDB/0
-- π Title, Name (Movies ⨝ Genres)
SELECT Title, Name FROM Movies JOIN Genres USING (Genre_ID); -- esse símbolo de JOIN meio que faz automático com base no ID

-- Exercícios

-- Listar os filmes por genero
-- π Title, Name (Movies ⨝ Genres)

-- Listas as pessoas e que filmes assistiram
-- π Lastname, Title (Persons ⨝ (PersonsMovies ⨝ Movies))

-- Listas as pessoas e que filmes e gereno assistiram
-- π Lastname, Title, Name (Persons ⨝ (PersonsMovies ⨝ (Movies ⨝ Genres)))
