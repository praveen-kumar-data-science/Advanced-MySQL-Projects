use mavenfuzzyfactory;

CREATE TABLE my_table(
table_id BIGINT NOT NULL,
char_field VARCHAR(50),
my_text_field TEXT,
created_at TIMESTAMP,
PRIMARY KEY (table_id)

);
SELECT * FROM my_table;