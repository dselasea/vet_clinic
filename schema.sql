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

-- TABLE

-- Create a table named owners with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY)
-- full_name: string
-- age: integer
CREATE TABLE owners (
  id SERIAL PRIMARY KEY,
  full_name VARCHAR(255),
  age INTEGER
);

-- Create a table named species with the following columns:
-- id: integer (set it as autoincremented PRIMARY KEY)
-- name: string
CREATE TABLE species (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255)
);

-- Modify animals table:
-- Make sure that id is set as autoincremented PRIMARY KEY
-- Remove column species
-- Add column species_id which is a foreign key referencing species table
-- Add column owner_id which is a foreign key referencing the owners table
ALTER TABLE animals DROP CONSTRAINT IF EXISTS animals_pkey;

ALTER TABLE animals ADD COLUMN id SERIAL PRIMARY KEY;

ALTER TABLE animals DROP COLUMN IF EXISTS species;

ALTER TABLE animals ADD COLUMN species_id INTEGER REFERENCES species(id);

ALTER TABLE animals ADD COLUMN owner_id INTEGER REFERENCES owners(id);


-- RELATIONSHIPS
CREATE TABLE vets (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  age INTEGER,
  date_of_graduation DATE
);

CREATE TABLE visits (
  id SERIAL PRIMARY KEY,
  vet_id INTEGER REFERENCES vets(id),
  animal_id INTEGER REFERENCES animals(id),
  visit_date DATE
);


CREATE TABLE specializations (
  id SERIAL PRIMARY KEY,
  vet_id INTEGER REFERENCES vets(id),
  species_id INTEGER REFERENCES species(id)
);


ALTER TABLE animals
ADD CONSTRAINT animals_id_unique UNIQUE (id);
