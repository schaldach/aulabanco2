SELECT
    tablename,
    indexname,
    indexdef
FROM
    pg_indexes
WHERE
    schemaname = 'public'
ORDER BY
    tablename,
    indexname;

-- 1.
EXPLAIN ANALYZE SELECT * FROM payment ORDER BY amount DESC;
-- DROP INDEX payment_amount_idx;
CREATE INDEX payment_amount_idx ON payment(amount);
EXPLAIN ANALYZE SELECT * FROM payment ORDER BY amount DESC;
-- deu certo

EXPLAIN ANALYZE SELECT * FROM film ORDER BY rating DESC;
-- DROP INDEX film_rating_idx;
CREATE INDEX film_rating_idx ON film(rating);
EXPLAIN ANALYZE SELECT * FROM film ORDER BY rating DESC;
-- deu errado? porque? acho que tem a ver com a 2

EXPLAIN ANALYZE SELECT * FROM customer ORDER BY create_date DESC;
-- DROP INDEX customer_create_date_idx;
CREATE INDEX customer_create_date_idx ON customer(create_date);
EXPLAIN ANALYZE SELECT * FROM customer ORDER BY create_date DESC;
-- deu certo... ok...

-- 2.
-- https://www.metisdata.io/blog/why-doesnt-postgres-use-my-index
