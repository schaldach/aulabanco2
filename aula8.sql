-- Minha versão
SELECT title, name, film_count
 FROM film f
 JOIN film_category fc USING (film_id)
 JOIN category USING (category_id)
 JOIN (SELECT film_id, count(*) AS film_count FROM inventory GROUP BY film_id) AS inventory USING (film_id);

-- Outra versão
 SELECT title, name, count(*)
 FROM film f
 JOIN film_category fc USING (film_id)
 JOIN category USING (category_id)
 JOIN inventory USING (film_id)
 GROUP BY title, name
 ORDER BY 1, 2;

-- usando explain analyze nesse comando, e construindo a árvore (de baixo para cima)
-- seqscan(category)  -->  
-- seqscan(filme)     -->     wtf?? porque nao teria como unir category e filme sozinhos entre si
-- seqscan(film_category)
