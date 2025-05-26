-- Active: 1747618095428@@127.0.0.1@5432@conservation_db
CREATE DATABASE conservation_db;

CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    "name" VARCHAR(50) NOT NULL,
    region VARCHAR(100) NOT NULL
)

CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(50) NOT NULL,
    scientific_name VARCHAR(100) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL DEFAULT ('Vulnerable')
)

CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id) ON delete CASCADE,
    species_id INT REFERENCES species(species_id) ON delete CASCADE,
    sighting_time TIMESTAMP without time zone NOT NULL,
    "location" VARCHAR(200) NOT NULL,
    notes TEXT
)

INSERT INTO rangers ("name", region) 
VALUES
('Alice Green', 'Northern Hills'),
('Bob White', 'River Delta'),
('Carol King', 'Mountain Range')

INSERT INTO species (common_name, scientific_name, discovery_date, conservation_status)
VALUES
('Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
('Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
('Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
('Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered')

INSERT INTO sightings (ranger_id, species_id, sighting_time, "location", notes)
VALUES
(1, 1, '2024-05-10 07:45:00', 'Peak Ridge', 'Camera trap image captured'),
(2, 2, '2024-05-12 16:20:00', 'Bankwood Area', 'Juvenile seen'),
(3, 3, '2024-05-15 09:10:00', 'Bamboo Grove East', 'Feeding observed'),
(1, 2, '2024-05-18 18:30:00', 'Snowfall Pass', NULL)


-- Problem 1
INSERT INTO rangers ("name", region) VALUES('Derek Fox', 'Coastal Plains')


-- Problem 2
SELECT count(DISTINCT species_id) as unique_species_count FROM sightings 


-- Problem 3
SELECT * from sightings WHERE "location" LIKE '%Pass%'


-- Problem 4
SELECT rangers.name, count(sightings.ranger_id) as total_sightings FROM sightings JOIN rangers ON sightings.ranger_id = rangers.ranger_id GROUP BY (rangers.name, sightings.ranger_id)


-- Problem 5
SELECT common_name  FROM sightings FULL JOIN species on sightings.species_id = species.species_id WHERE sightings.species_id is NULL


-- Problem 6
select common_name, to_char(sighting_time, 'YYYY-MM-DD HH24:MI:SS') as sighting_time, "name" FROM (sightings JOIN species ON sightings.species_id = species.species_id) as sightingsAndSpecies JOIN rangers ON sightingsAndSpecies.ranger_id = rangers.ranger_id ORDER BY sighting_time DESC LIMIT 2


-- Problem 7
UPDATE species set conservation_status = 'Historic' where extract(YEAR FROM discovery_date) < 1800


-- Problem 8
SELECT sighting_id, 'Morning' AS time_of_day FROM sightings WHERE EXTRACT(HOUR FROM sighting_time) < 12
UNION ALL
SELECT sighting_id, 'Afternoon' AS time_of_day FROM sightings WHERE EXTRACT(HOUR FROM sighting_time) >= 12 AND EXTRACT(HOUR FROM sighting_time) < 17
UNION ALL
SELECT sighting_id, 'Evening' AS time_of_day FROM sightings WHERE EXTRACT(HOUR FROM sighting_time) >= 17;


-- Problem 9
DELETE FROM rangers WHERE ranger_id = (SELECT rangers.ranger_id  FROM sightings FULL JOIN rangers on sightings.ranger_id = rangers.ranger_id WHERE sightings.ranger_id is NULL)
 

































































