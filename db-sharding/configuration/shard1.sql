CREATE TABLE users
(
    id bigint not null,
    firstname character varying not null,
    lastname character varying not null,
    city character varying not null,
    CONSTRAINT id_check CHECK (id > 0 and id <= 2)
);

CREATE INDEX id_idx ON users USING btree(id);