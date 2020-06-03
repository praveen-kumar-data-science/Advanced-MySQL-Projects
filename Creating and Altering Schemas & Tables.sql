-- USE myfirstcodeschema;
-- CREATE TABLE tabl(
-- id BIGINT NOT NULL,
-- char_field VARCHAR(50),
-- txt_field TEXT,
-- created_at TIMESTAMP,
-- PRIMARY KEY(id)
-- );
CREATE SCHEMA toms_marketing_stuffs DEFAULT CHARACTER SET utf8mb4;
CREATE TABLE toms_marketing_stuffs.publishers(
publisher_id BIGINT NOT NULL,
publisher_name CHAR(65),
PRIMARY KEY (publisher_id)
);
CREATE TABLE toms_marketing_stuffs.publisher_spend(
publisher_spend_id BIGINT NOT NULL,
publisher_id BIGINT NOT NULL,
month DATE,
spend DECIMAL,
PRIMARY KEY (publisher_spend_id));

USE candystore;
