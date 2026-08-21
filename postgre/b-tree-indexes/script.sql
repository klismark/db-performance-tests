explain analyze select * from users u where document = '316.318.536-74'

--------- RESULTADO ANTES DO INDICE
-- Gather  (cost=1000.00..19744.43 rows=1 width=78) (actual time=0.565..19.238 rows=1 loops=1)
--   Workers Planned: 2
--   Workers Launched: 2
--   ->  Parallel Seq Scan on users u  (cost=0.00..18744.33 rows=1 width=78) (actual time=9.782..15.545 rows=0 loops=3)
--         Filter: ((document)::text = '316.318.536-74'::text)
--         Rows Removed by Filter: 333333
-- Planning Time: 0.040 ms
-- Execution Time: 19.249 ms


-- CRIAÇÃO DO INDICE
CREATE INDEX users_document_idx ON public.users ("document");


explain analyze select * from users u where document = '316.318.536-74'

--------- RESULTADO DEPOIS DO INDICE
-- Index Scan using users_document_idx on users u  (cost=0.42..8.44 rows=1 width=78) (actual time=0.023..0.023 rows=1 loops=1)
--   Index Cond: ((document)::text = '316.318.536-74'::text)
-- Planning Time: 0.124 ms
-- Execution Time: 0.032 ms