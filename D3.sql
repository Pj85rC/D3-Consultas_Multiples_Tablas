--Creacion Base de Datos
CREATE DATABASE desafio3_patricio_ramirez_g21;

--Conexion a Base de Datos
\c desafio3_patricio_ramirez_g21

--Creacio tabla users:
CREATE TABLE users(
    id SERIAL,
    email VARCHAR UNIQUE,
    names VARCHAR,
    last_name VARCHAR,
    rol VARCHAR NOT NULL
);

--Igreso de datos a la tabla usuarios:
INSERT INTO users(email, names, last_name, rol) VALUES('pj85rc@gmail.com', 'patricio', 'ramirez', 'admin');
INSERT INTO users(email, names, last_name, rol) VALUES('jack@gmail.com', 'jack', 'torrance', 'user');
INSERT INTO users(email, names, last_name, rol) VALUES('nosferatu@gmail.com', 'graf', 'orlok', 'user');
INSERT INTO users(email, names, last_name, rol) VALUES('vladiii@gmail.com', 'vlad', 'tepes', 'user');
INSERT INTO users(email, names, last_name, rol) VALUES('alucard@gmail.com', 'akado ', 'randakyuu', 'user');

--Consulta para comprobar datos ingresados:
SELECT * FROM users;

--Creacion tabla posts:
CREATE TABLE posts(
    id SERIAL,
    tittle VARCHAR ,
    contents TEXT,
    creation_date TIMESTAMP NOT NULL DEFAULT NOW(),
    update_date TIMESTAMP NOT NULL DEFAULT NOW(),
    featured BOOLEAN,
    users_id BIGINT
);

--Ingreso de datos en tabla posts:
INSERT INTO posts(tittle, contents, creation_date, update_date, featured, users_id) VALUES('hey ho lets go', 'managing', '1985-08-21', '2022-11-19', true, 1);
INSERT INTO posts(tittle, contents, creation_date, update_date, featured, users_id) VALUES('earthquake', 'terremotoooo', '2010-02-27', '2022-11-19', true, 1);
INSERT INTO posts(tittle, contents, creation_date, update_date, featured, users_id) VALUES('weeendy', 'give me the bat', '1980-05-23', '2022-11-19', true, 2 );
INSERT INTO posts(tittle, contents, creation_date, update_date, featured, users_id) VALUES('gary oldman quote', 'ive crossed oceans of time...', '1922-03-15', '2022-11-19', false, 3);
INSERT INTO posts(tittle, contents, creation_date, update_date, featured) VALUES('...', '... ...', '1922-03-15', '2022-11-19', false);

--Consulta para comprobar datos ingresados tabla posts:
SELECT * FROM posts;

--Creacio tabla comments:
CREATE TABLE comments(
    id SERIAL,
    contents TEXT,
    creation_date TIMESTAMP NOT NULL DEFAULT NOW(),
    users_id BIGINT,
    post_id BIGINT
);

--Ingreso de datos en tabla comments 
INSERT INTO comments(contents, creation_date, users_id, post_id) VALUES ('Hey ho, lets go! Hey ho, lets go! ', '1976-04-24', 1, 1);
INSERT INTO comments(contents, creation_date, users_id, post_id) VALUES ('i shall rise from my own death, to avenge hers with all the powers of darkness', '2022-02-02', 2, 1);
INSERT INTO comments(contents, creation_date, users_id, post_id) VALUES ('..............', '2022-03-14', 3, 1);
INSERT INTO comments(contents, creation_date, users_id, post_id) VALUES ('lala lala lala', '2003-08-28', 1, 2);
INSERT INTO comments(contents, creation_date, users_id, post_id) VALUES ('wendy im home! ', '1980-05-24', 2, 2);


--Consulta para comprobar datos ingresados tabla comments:
SELECT * FROM comments;

--2.Cruza los datos de la tabla usuarios y posts mostrando las siguientes columnas.nombre e email del usuario junto al título y contenido del post.
SELECT u.names, u.email, p.tittle, p.contents 
FROM users AS u
INNER JOIN posts AS p
ON u.id = p.users_id;

--3.Muestra el id, título y contenido de los posts de los administradores. El administrador puede ser cualquier id y debe ser seleccionado dinámicamente.
SELECT u.id, p.tittle, p.contents 
FROM users AS u
INNER JOIN posts AS p
ON u.id = p.users_id
WHERE u.rol = 'admin';

--4.Cuenta la cantidad de posts de cada usuario. La tabla resultante debe mostrar el id e email del usuario junto con la cantidad de posts de cada usuario.
SELECT u.id, u.email, COUNT(u.id) 
FROM users AS u
LEFT JOIN posts AS p
ON u.id = p.users_id
GROUP BY u.id, u.email;

--5.Muestra el email del usuario que ha creado más posts. Aquí la tabla resultante tiene un único registro y muestra solo el email.
SELECT u.email
FROM users AS u
INNER JOIN posts AS p
ON u.id = p.users_id
GROUP BY u.email
ORDER BY COUNT(p.users_id) DESC LIMIT 1;

--6.Muestra la fecha del último post de cada usuario.
SELECT u.names, MAX(p.creation_date) AS fecha
FROM USERS AS u
INNER JOIN posts AS p
ON u.id = p.users_id
GROUP BY u.names
ORDER BY fecha DESC LIMIT 1;

--7.Muestra el título y contenido del post (artículo) con más comentarios.
SELECT p.tittle, p.contents
FROM posts AS p
INNER JOIN comments AS c
ON p.id = c.post_id
GROUP BY p.tittle, p.contents
ORDER BY COUNT(c.post_id) DESC LIMIT 1;

SELECT p.tittle, p.contents
FROM posts AS p
JOIN (
    SELECT c.post_id, COUNT(c.post_id) AS psts 
    FROM comments AS c 
    GROUP BY c.post_id 
    ORDER BY  psts DESC LIMIT 1
    ) AS res ON p.id = res.post_id;

--8.Muestra en una tabla el título de cada post, el contenido de cada post y el contenido de cada comentario asociado a los posts mostrados, junto con el email del usuario que lo escribió.
SELECT p.tittle, p.contents,c.contents, u.email
FROM posts AS p
    JOIN comments AS c
        ON p.id = c.post_id
    JOIN users AS u
        ON u.id = c.users_id;     

--9.Muestra el contenido del último comentario de cada usuario.
SELECT u.id, u.names, c.contents, c.creation_date
FROM users as u
    JOIN (select users_id AS uid, MAX(id) AS last_one FROM comments group by users_id) AS c1
        ON c1.uid = u.id
    JOIN comments c 
      on c.id = c1.last_one;

--10.Muestra los emails de los usuarios que no han escrito ningún comentario.
SELECT u.email
FROM users AS u
    LEFT JOIN comments AS c
    ON u.id = c.users_id
GROUP BY u.email
HAVING COUNT(c.users_id) = 0;