CREATE DATABASE sessions;
\c sessions;

CREATE TABLE IF NOT EXISTS session (
    key     CHAR(16) NOT NULL,
    data    BYTEA,
    expiry  INTEGER NOT NULL,
    PRIMARY KEY (key)
);

CREATE USER "${username}" WITH PASSWORD '${password}';
GRANT ALL PRIVILEGES ON DATABASE db, sessions to "${username}";