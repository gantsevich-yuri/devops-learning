CREATE EXTENSION postgres_fdw;

/* SHARD 1 */
CREATE SERVER server1
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_s1', port '5432', dbname 'users');

CREATE USER MAPPING FOR "postgres"
    SERVER server1
    OPTIONS (user 'postgres', password 'P@ssw0rd');

CREATE FOREIGN TABLE users1
(
    id bigint not null,
    firstname character varying not null,
    lastname character varying not null,
    city character varying not null
) SERVER server1
  OPTIONS (schema_name 'public', table_name 'users');


/* SHARD 2 */
CREATE SERVER server2
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_s2', port '5432', dbname 'users');

CREATE USER MAPPING FOR "postgres"
    SERVER server2
    OPTIONS (user 'postgres', password 'P@ssw0rd');

CREATE FOREIGN TABLE users2
(
    id bigint not null,
    firstname character varying not null,
    lastname character varying not null,
    city character varying not null
) SERVER server2
  OPTIONS (schema_name 'public', table_name 'users');

/* SHARD 3 */
CREATE SERVER server3
    FOREIGN DATA WRAPPER postgres_fdw
    OPTIONS (host 'db_s3', port '5432', dbname 'users');

CREATE USER MAPPING FOR "postgres"
    SERVER server3
    OPTIONS (user 'postgres', password 'P@ssw0rd');

CREATE FOREIGN TABLE users3
(
    id bigint not null,
    firstname character varying not null,
    lastname character varying not null,
    city character varying not null
) SERVER server3
  OPTIONS (schema_name 'public', table_name 'users');

/* CREATE VIEW */
CREATE VIEW users AS
SELECT *
FROM users1
UNION ALL
SELECT *
FROM users2
UNION ALL
SELECT *
FROM users3;

/* COMMON RULES */
CREATE RULE users_insert AS ON INSERT TO users
    DO INSTEAD NOTHING;
CREATE RULE users_update AS ON UPDATE TO users
    DO INSTEAD NOTHING;
CREATE RULE users_delete AS ON DELETE TO users
    DO INSTEAD NOTHING;

/* INSERT RULES */
CREATE RULE users_insert_to_1 AS ON INSERT TO users
    WHERE (id > 0 and id <= 2)
    DO INSTEAD INSERT INTO users1
               VALUES (NEW.*);

CREATE RULE users_insert_to_2 AS ON INSERT TO users
    WHERE (id > 2 and id <= 4)
    DO INSTEAD INSERT INTO users2
               VALUES (NEW.*);

CREATE RULE users_insert_to_3 AS ON INSERT TO users
    WHERE (id > 4)
    DO INSTEAD INSERT INTO users3
               VALUES (NEW.*);