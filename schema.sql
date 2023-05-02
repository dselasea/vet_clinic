/* Database schema to keep the structure of entire database. */

CREATE TABLE animals (
id SERIAL PRIMARY KEY,
name VARCHAR(60) NOT NULL,
date_of_birth DATE NULL,
escape_attempts INT NOT NULL,
neutered BOOLEAN NOT NULL,
weight_kg FLOAT NOT NULL
);

ALTER TABLE animals ADD COLUMN species VARCHAR(255);
