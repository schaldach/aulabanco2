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

-- A ordem de escrita da álgebra relacional reflete muito melhor a forma que o sistema 
-- processa a consulta, primeiro o FROM, depois o WHERE, e depois o SELECT
-- (ver ordem completa, mas esses 3 acontecem nessa ordem)

-- τ Title asc π Title, ReleaseDate, Budget σ Budget > 200000000 Movies
SELECT Title, ReleaseDate, Budget
FROM Movies
WHERE Budget>200000000
ORDER BY Title ASC
-- A árvore é de baixo para cima (ver exemplo no site)
-- e ela representa muito bem a ordem da consulta realizada pelo sistema

-- τ Title asc π Title, Name, ReleaseDate, Budget σ Budget > 200000000 and Name = 'Sci-Fi' ( Movies ⨝ Genres )
SELECT Title, Name, ReleaseDate, Budget
FROM Movies
INNER JOIN Genres USING (Genre_ID)
WHERE Budget>200000000 AND Name = 'Sci-Fi'
ORDER BY Title ASC
-- pensando nessa consulta, podemos ver que seria muito melhor filtrar os filmes e os gêneros desejados 
-- pelo WHERE antes de fazer o JOIN das 2 tabelas, reduziria muito a memória necessária e tornaria a consulta muito mais eficiente,
-- uma vez que o JOIN é feito antes no processamento da consulta, juntamente com o FROM
-- além disso, as colunas desejadas poderiam ser selecionadas antes de fazer o JOIN, tornaria mais eficiente
-- o único detalhe é que além das colunas desejadas também seria necessário o Genre_ID, para fazer o JOIN

-- entre tirar linhas ou colunas, o mais rápido simplesmente depende da tabela, e é o que o otimizador faz
-- se mais memória é poupada tirando linhas, ela irá tirar as linhas primeiro, mas se tirar as colunas poupa mais a memória ele irá tirar as colunas

-- exercício: SELECIONAR O NOME DO CURSO, NOME DO ESTUDANTE, TITULO DOS LIVROS RECOMENDADOS ORDENADO POR CURSO E ESTUDANTE SOMENTE DO CURSO 9
-- τ Cname asc, Name asc (π Cname, Name, Book_Title (σ CourseId=9 (STUDENT ⨝ ENROLL ⨝ COURSE ⨝ BOOK_RECOMMENDATION ⨝ BOOK)))
-- bom observar a árvore montada para entender a ordem da consulta
-- forma mais otimizada:
-- τ Cname asc, Name asc (π Cname, Name, Book_Title (ENROLL ⨝ (σ CourseId=9(COURSE)) ⨝ STUDENT ⨝ BOOK_RECOMMENDATION ⨝ BOOK))
-- A ideia é usar as tabelas usadas no WHERE primeiro
