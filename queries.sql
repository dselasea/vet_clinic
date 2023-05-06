/*Queries that provide answers to the questions from all projects.*/

-- All animals whose name ends in "mon".
SELECT * FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals
WHERE neutered = TRUE AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals
WHERE weight_kg > 10.5;

-- All animals that are neutered.
SELECT * FROM animals
WHERE neutered=TRUE;

-- All animals not named Gabumon.
SELECT * FROM animals
WHERE name <> 'Gabumon';

-- All animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

-- Inside a transaction update the animals table by setting the species column to unspecified. Verify that change was made. Then roll back the change and verify that the species columns went back to the state before the transaction.
BEGIN;
UPDATE animals SET species = 'unspecified';
SELECT * FROM animals;
ROLLBACK;
SELECT * FROM animals;



-- Update the animals table by setting the species column to digimon for all animals that have a name ending in mon.
BEGIN;
UPDATE animals SET species='digimon' WHERE name LIKE '%mon';
COMMIT;
SELECT * FROM animals;


-- Update the animals table by setting the species column to pokemon for all animals that don't have species already set
BEGIN;
UPDATE animals SET species = 'pokemon' WHERE species IS NULL;
COMMIT;
SELECT * FROM animals;

-- delete all records in the animals table, then roll back the transaction.
BEGIN;
DELETE FROM animals;
ROLLBACK;
SELECT * FROM animals;


-- Delete all animals born after Jan 1st, 2022
BEGIN;
DELETE FROM animals WHERE date_of_birth > '2022-01-01';
COMMIT;
SELECT * FROM animals;

-- SAVE POINT
BEGIN;
SAVEPOINT save_animals_data;
COMMIT;

-- Update all animals' weight to be their weight multiplied by -1
UPDATE animals SET weight = weight * -1;

-- ROllback to savepoint
BEGIN;
SAVEPOINT save_animals_data;
COMMIT;

-- Update all animals' weights that are negative to be their weight multiplied by -1
UPDATE animals SET weight_kg = weight_kg * -1 WHERE weight_kg < 0;

-- How many animals are there?
SELECT COUNT(*) FROM animals;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight) FROM animals;

-- Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_escapes
FROM animals
GROUP BY neutered;

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escapes
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;

-- JOIN

-- What animals belong to Melody Pond?
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Melody Pond'

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
WHERE species.name = 'Pokemon'

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name, animals.name
FROM owners
LEFT JOIN animals ON owners.id = animals.owner_id


-- How many animals are there per species?
SELECT species.name, COUNT(*) AS num_animals
FROM animals
JOIN species ON animals.species_id = species.id
GROUP BY species.name


-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name
FROM animals
JOIN species ON animals.species_id = species.id
JOIN owners ON animals.owner_id = owners.id
WHERE species.name = 'Digimon' AND owners.full_name = 'Jennifer Orwell'


-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name
FROM animals
JOIN owners ON animals.owner_id = owners.id
WHERE owners.full_name = 'Dean Winchester' AND animals.escape_attempts = 0


-- Who owns the most animals?
SELECT owners.full_name, COUNT(*) AS num_animals
FROM animals
JOIN owners ON animals.owner_id = owners.id
GROUP BY owners.full_name
ORDER BY num_animals DESC
LIMIT 1

-- RELATIONSHIPS
SELECT a.name AS last_animal_seen
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

SELECT COUNT(DISTINCT v.animal_id) AS number_of_animals_seen
FROM visits AS v
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez';


SELECT v.name AS vet_name, s.name AS specialty
FROM vets AS v
LEFT JOIN specializations AS sp ON sp.vet_id = v.id
LEFT JOIN species AS s ON s.id = sp.species_id;

SELECT a.name AS animal_name
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'Stephanie Mendez'
AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';


SELECT a.name AS animal_name, COUNT(*) AS visit_count
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;

SELECT a.name AS animal_name, MIN(v.visit_date) AS first_visit_date
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'Maisy Smith'
GROUP BY a.name;

SELECT a.name AS animal_name, v.visit_date, vt.name AS vet_name
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN vets AS vt ON vt.id = v.vet_id
ORDER BY v.visit_date DESC
LIMIT 1;

SELECT COUNT(*) AS visits_with_non_specialist
FROM visits AS v
JOIN animals AS a ON a.id = v.animal_id
JOIN vets AS vt ON vt.id = v.vet_id
LEFT JOIN specializations AS sp ON sp.vet_id = vt.id AND sp.species_id = a.species_id
WHERE sp.vet_id IS NULL;

SELECT s.name AS suggested_specialty
FROM animals AS a
JOIN visits AS v ON v.animal_id = a.id
JOIN species AS s ON s.id = a.species_id
JOIN vets AS vt ON vt.id = v.vet_id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY COUNT(*) DESC
LIMIT 1;
