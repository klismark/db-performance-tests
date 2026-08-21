DROP TABLE IF EXISTS tmp_first_names;
DROP TABLE IF EXISTS tmp_last_names;

CREATE TEMP TABLE tmp_first_names (id INT, name TEXT);
CREATE TEMP TABLE tmp_last_names  (id INT, name TEXT);

INSERT INTO tmp_first_names (id, name)
SELECT row_number() OVER () - 1, name FROM (VALUES
('Maria'),('José'),('Ana'),('João'),('Antônio'),('Francisco'),('Carlos'),('Paulo'),('Pedro'),('Lucas'),
('Luiz'),('Marcos'),('Luis'),('Gabriel'),('Rafael'),('Daniel'),('Marcelo'),('Bruno'),('Eduardo'),('Felipe'),
('Raimundo'),('Rodrigo'),('Manoel'),('Fábio'),('Diego'),('André'),('Fernando'),('Ricardo'),('Sérgio'),('Gustavo'),
('Márcia'),('Cláudia'),('Adriana'),('Juliana'),('Fernanda'),('Camila'),('Aline'),('Patrícia'),('Sandra'),('Vanessa'),
('Amanda'),('Bruna'),('Jéssica'),('Letícia'),('Larissa'),('Beatriz'),('Isabela'),('Mariana'),('Renata'),('Tatiane'),
('Vera'),('Rosa'),('Regina'),('Sônia'),('Silvia'),('Débora'),('Cristina'),('Simone'),('Elaine'),('Priscila'),
('Thiago'),('Vinícius'),('Leonardo'),('Alexandre'),('Vitor'),('Caio'),('Igor'),('Otávio'),('Renato'),('Wagner'),
('Helena'),('Alice'),('Sofia'),('Valentina'),('Laura'),('Manuela'),('Lívia'),('Yasmin'),('Isadora'),('Melissa')
) AS t(name);

INSERT INTO tmp_last_names (id, name)
SELECT row_number() OVER () - 1, name FROM (VALUES
('Silva'),('Santos'),('Oliveira'),('Souza'),('Rodrigues'),('Ferreira'),('Alves'),('Pereira'),('Lima'),('Gomes'),
('Costa'),('Ribeiro'),('Martins'),('Carvalho'),('Almeida'),('Lopes'),('Soares'),('Fernandes'),('Vieira'),('Barbosa'),
('Rocha'),('Dias'),('Nascimento'),('Andrade'),('Moreira'),('Nunes'),('Marques'),('Machado'),('Mendes'),('Freitas'),
('Cardoso'),('Ramos'),('Gonçalves'),('Santana'),('Teixeira'),('Araújo'),('Correia'),('Cavalcanti'),('Monteiro'),('Pinto'),
('Reis'),('Batista'),('Campos'),('Cunha'),('Moura'),('Castro'),('Melo'),('Sales'),('Farias'),('Xavier')
) AS t(name);


-- ------------------------------------------------------------
-- Geração: cada linha "i" calcula seu próprio índice via hashtext(i)
-- garantindo variação real linha a linha
-- ------------------------------------------------------------

INSERT INTO users (name, email, document, birthday)
SELECT
    fn.name || ' ' || ln1.name || ' ' || ln2.name AS full_name,
    lower(
        translate(fn.name,  'ÁÀÂÃÉÈÊÍÌÎÓÒÔÕÚÙÛÇ', 'AAAAEEEIIIOOOOUUUC') || '.' ||
        translate(ln1.name, 'ÁÀÂÃÉÈÊÍÌÎÓÒÔÕÚÙÛÇ', 'AAAAEEEIIIOOOOUUUC')
    ) || '.' || g.i || '@' ||
    (ARRAY['gmail.com','hotmail.com','yahoo.com.br','outlook.com','uol.com.br'])
        [1 + (abs(hashtext(g.i::text || '-mail')) % 5)] AS email,
    lpad((abs(hashtext(g.i::text || '-d1')) % 1000)::text, 3, '0') || '.' ||
    lpad((abs(hashtext(g.i::text || '-d2')) % 1000)::text, 3, '0') || '.' ||
    lpad((abs(hashtext(g.i::text || '-d3')) % 1000)::text, 3, '0') || '-' ||
    lpad((abs(hashtext(g.i::text || '-d4')) % 100)::text, 2, '0') AS document,
    (date '1945-01-01' + (abs(hashtext(g.i::text || '-bd')) %
        (date '2006-12-31' - date '1945-01-01')))::date AS birthday
FROM generate_series(1, 10000000) AS g(i)
JOIN tmp_first_names fn  ON fn.id  = abs(hashtext(g.i::text || '-fn'))  % 80
JOIN tmp_last_names  ln1 ON ln1.id = abs(hashtext(g.i::text || '-ln1')) % 50
JOIN tmp_last_names  ln2 ON ln2.id = abs(hashtext(g.i::text || '-ln2')) % 50;

-- ------------------------------------------------------------
-- DROP
-- ------------------------------------------------------------

DROP TABLE tmp_first_names;
DROP TABLE tmp_last_names;