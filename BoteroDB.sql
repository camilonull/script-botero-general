-- Table Creation --

-- Person Table --
CREATE TABLE Person (
    id_person INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    nickname VARCHAR(250),
    phone VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    birthdate DATE,
    gender ENUM('Male', 'Female', 'Other')
);

CREATE TABLE PersonType (
    id_person_type INT AUTO_INCREMENT PRIMARY KEY,
    type_name ENUM('Artist', 'User', 'Restorer', 'Student', 'Teacher') NOT NULL
);

CREATE TABLE Person_PersonType (
    id_person INT,
    id_person_type INT,
    PRIMARY KEY (id_person, id_person_type),
    FOREIGN KEY (id_person) REFERENCES Person(id_person),
    FOREIGN KEY (id_person_type) REFERENCES PersonType(id_person_type)
);

-- Artist Table --
CREATE TABLE Artist (
id_artist INT AUTO_INCREMENT PRIMARY KEY,
id_person INT NOT NULL,
CONSTRAINT foreign_key_person FOREIGN KEY (id_person)
REFERENCES Person (id_person)
);

-- User Table --
CREATE TABLE User (
    id_user INT AUTO_INCREMENT PRIMARY KEY,
    id_person INT NOT NULL,
    username VARCHAR(45) NOT NULL,
    user_password VARCHAR(15) NOT NULL,
    status ENUM('verified', 'blocked', 'reported', 'active') NOT NULL DEFAULT 'active',
    CONSTRAINT foreign_key_user FOREIGN KEY (id_person)
    REFERENCES Person (id_person)
);


-- Restorer Table --
CREATE TABLE Restorer (
id_restorer INT AUTO_INCREMENT PRIMARY KEY,
id_person INT NOT NULL,
CONSTRAINT foreign_key_restorer FOREIGN KEY (id_person)
REFERENCES Person (id_person)
);

-- Restoration Table --
CREATE TABLE Restoration (
id_restoration INT AUTO_INCREMENT PRIMARY KEY,
id_restorer INT NOT NULL,
start_date_restoration DATE NOT NULL,
end_date_restoration DATE NOT NULL,
restoration_reason TEXT NOT NULL,
budget FLOAT NOT NULL,
CONSTRAINT fk_restorer FOREIGN KEY (id_restorer)
REFERENCES Restorer (id_restorer)
);

-- Technique Table --
CREATE TABLE Technique (
id_technique INT AUTO_INCREMENT PRIMARY KEY,
technique_name VARCHAR(250) NOT NULL,
description TEXT NOT NULL
);

-- Provenance Table --
CREATE TABLE Provenance (
id_provenance INT AUTO_INCREMENT PRIMARY KEY,
city VARCHAR(100) NOT NULL,
postal_code VARCHAR(20) NOT NULL,
legal_status VARCHAR(150) NOT NULL
);

-- Historical Context Table --
CREATE TABLE HistoricalContext (
id_historical_context INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(250) NOT NULL,
description TEXT
);

-- ArtWork Type Table --
CREATE TABLE ArtWorkType (
id_art_work_type INT AUTO_INCREMENT PRIMARY KEY,
type VARCHAR(250),
description TEXT
);

-- Artistic Style Table --
CREATE TABLE ArtisticStyle (
id_artistic_style INT AUTO_INCREMENT PRIMARY KEY,
style_name VARCHAR(250) NOT NULL,
description TEXT NOT NULL
);

-- Table Location --
CREATE TABLE Location (
id_location INT AUTO_INCREMENT PRIMARY KEY,
location_name VARCHAR(250) NOT NULL,
altitude FLOAT NOT NULL,
latitude FLOAT NOT NULL,
longitude FLOAT NOT NULL
);

-- Table ArtWork_Person --
CREATE TABLE ArtWork_Person (
id_art_work INT,
id_person INT,
CONSTRAINT fk_art_work_person FOREIGN KEY (id_art_work)
REFERENCES artwork (id_art_work),
CONSTRAINT fk_person_art_work FOREIGN KEY (id_person)
REFERENCES person (id_person)
);

-- Message Work User Table --
CREATE TABLE MessageArtWorkUser (
id_message INT AUTO_INCREMENT PRIMARY KEY,
id_art_work INT,
id_user INT,
CONSTRAINT fk_art_work FOREIGN KEY (id_art_work)
REFERENCES ArtWork (id_art_work),
CONSTRAINT fk_user FOREIGN KEY (id_user)
REFERENCES User (id_user),
message TEXT
);

-- Work Artistic Style Union Table --
CREATE TABLE ArtWorkArtisticStyle (
id_art_work INT,
id_artistic_style INT,
CONSTRAINT fk_art_work_style FOREIGN KEY (id_art_work)
REFERENCES ArtWork (id_art_work),
CONSTRAINT fk_artistic_style FOREIGN KEY (id_artistic_style)
REFERENCES ArtisticStyle (id_artistic_style)
);

-- Documentation Table --
CREATE TABLE Documentation (
id_documentation INT AUTO_INCREMENT PRIMARY KEY,
id_user INT,
documentation_type VARCHAR(150) NOT NULL,
metadata TEXT NOT NULL,
capture_device VARCHAR(250) NOT NULL,
CONSTRAINT fk_documentation_user FOREIGN KEY (id_user)
REFERENCES User (id_user)
);

-- Materials Table --
CREATE TABLE Materials (
id_materials INT AUTO_INCREMENT PRIMARY KEY,
name_material VARCHAR(250) NOT NULL,
description Text NOT NULL
);

-- DevelopmentSurface --
CREATE TABLE DevelopmentSurface (
id_dev_surface INT AUTO_INCREMENT PRIMARY KEY,
name_dev_surface VARCHAR(250) NOT NULL,
description TEXT NOT NULL
);

-- Relational Table DevSurf_Materials --
CREATE TABLE devSurf_Materials (
id_surface INT,
id_materials INT,
CONSTRAINT fk_surface_materials FOREIGN KEY (id_surface)
REFERENCES DevelopmentSurface (id_dev_surface),
CONSTRAINT fk_materials_surface FOREIGN KEY (id_materials)
REFERENCES Materials (id_materials)
);

-- Work Table --
CREATE TABLE ArtWork (
id_art_work INT AUTO_INCREMENT PRIMARY KEY,
id_technique INT,
id_art_work_type INT,
id_historical_context INT,
id_restoration INT,
id_dev_surface INT,
id_location INT,
art_work_title VARCHAR(250) NOT NULL,
creation_date DATE NOT NULL,
height FLOAT NOT NULL,
width FLOAT NOT NULL,
depth FLOAT NOT NULL,
description TEXT NOT NULL,
CONSTRAINT fk_technique FOREIGN KEY (id_technique)
REFERENCES Technique (id_technique),
CONSTRAINT fk_art_work_type FOREIGN KEY (id_art_work_type)
REFERENCES ArtWorkType (id_art_work_type),
CONSTRAINT fk_historical_context FOREIGN KEY (id_historical_context)
REFERENCES HistoricalContext (id_historical_context),
CONSTRAINT fk_restoration FOREIGN KEY (id_restoration)
REFERENCES Restoration (id_restoration) ON DELETE SET NULL,
CONSTRAINT fk_dev_surface FOREIGN KEY (id_dev_surface)
REFERENCES DevelopmentSurface (id_dev_surface),
CONSTRAINT fk_location_art_work FOREIGN KEY (id_location)
REFERENCES Location (id_location)
);



-- DROP TABLES --
DROP TABLE Person;
DROP TABLE Artist;
DROP TABLE User;
DROP TABLE Restorer;
DROP TABLE Materials;
DROP TABLE artwork;
DROP TABLE artisticstyle;
DROP TABLE documentation;
DROP TABLE provenance;
DROP TABLE artworkartisticstyle;
DROP TABLE artworktype;
DROP TABLE historicalcontext;
DROP TABLE messageartworkuser;
DROP TABLE restoration;
DROP TABLE technique;

-- Creation of test persons --
INSERT INTO Person (name, nickname, phone, email, person_type) VALUES("Erik", "EM", "3222647865", "erikmol8903@gmail.com", "User");
INSERT INTO Person (name, nickname, phone, email, person_type) VALUES("", "LEO", "","", "Artist");

-- Deleting a record --
DELETE FROM Person WHERE nickname = "LEO";

-- Deactivate safe mode -- 
SET SQL_SAFE_UPDATES = 0;

-- Saving Artists --
INSERT INTO Artist (id_person) SELECT id_person FROM Person WHERE person_type = "Artist";

-- Querying artist data --
SELECT p.id_person, p.name, p.nickname, p.phone, p.email FROM Person p JOIN Artist a ON p.id_person = a.id_person;