-- Creacion de la tabla employees:
CREATE TABLE employees (
    employeeNumber INT NOT NULL,
    lastName VARCHAR(50) NOT NULL,
    firstName VARCHAR(50) NOT NULL,
    extension VARCHAR(10) NOT NULL,
    email VARCHAR(100) NOT NULL,
    officeCode VARCHAR(10) NOT NULL,
    reportsTo INT DEFAULT NULL,
    jobTitle VARCHAR(50) NOT NULL,
    PRIMARY KEY (employeeNumber)
);

INSERT INTO employees
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle)
VALUES
(1002, 'Murphy', 'Diane', 'x5800',
 'dmurphy@classicmodelcars.com', '1', NULL, 'President'),

(1056, 'Patterson', 'Mary', 'x4611',
 'mpatterso@classicmodelcars.com', '1', 1002, 'VP Sales'),

(1076, 'Firrelli', 'Jeff', 'x9273',
 'jfirrelli@classicmodelcars.com', '1', 1002, 'VP Marketing');

-- Ejercicio 1
-- La tabla employees tiene la columna: email VARCHAR(100) NOT NULL
-- Por lo tanto, si intentamos insertar un empleado con email = NULL: La operación falla porque la columna email tiene la restricción NOT NULL
-- La restricción NOT NULL impide que una columna almacene valores NULL
-- Error que aparece: ERROR 1048 (23000): Column 'email' cannot be null

-- Ejercicio 2
UPDATE employees
SET employeeNumber = employeeNumber - 20;
-- La operación modifica la PRIMARY KEY.
-- Esto es posible siempre que los nuevos valores continúen siendo únicos. La PRIMARY KEY debe identificar de forma única cada registro y no puede contener valores NULL.
-- En este caso, los nuevos valores no se repiten, por lo que el UPDATE puede realizarse.

UPDATE employees
SET employeeNumber = employeeNumber + 20;
-- se produce un error porque employeeNumber es la PRIMARY KEY y no puede tener valores repetidos. 
-- Al intentar aumentar los números, uno de los registros intenta tomar el valor 1056, pero ese valor ya existe en otro registro. 
-- Por eso MySQL muestra el error Duplicate entry '1056' for key 'PRIMARY' y no puede completar la actualización.

-- Ejercicio 3
ALTER TABLE employees
ADD age INT CHECK (age BETWEEN 16 AND 70);


-- Ejercicio 4
-- En Sakila, las tablas film, actor y film_actor tienen una relación de integridad referencial mediante claves primarias y foráneas. 
-- La tabla film identifica cada película mediante film_id, mientras que actor identifica cada actor mediante actor_id. 
-- La tabla film_actor funciona como tabla intermedia y contiene ambos campos como claves foráneas, relacionando cada película con los actores que participan en ella. 
-- De esta manera, un actor puede participar en varias películas y una película puede tener varios actores. 
-- Además, la integridad referencial evita que se agreguen en film_actor valores de film_id o actor_id que no existan previamente en las tablas film o actor. 
-- Esto permite mantener la consistencia de los datos entre las tres tablas.


-- Ejercicio 5
ALTER TABLE employees
ADD lastUpdate DATETIME,
ADD lastUpdateUser VARCHAR(100);

DELIMITER $$

CREATE TRIGGER before_employees_insert
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END$$

DELIMITER ;

DELIMITER $$

CREATE TRIGGER before_employees_update
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    SET NEW.lastUpdate = NOW();
    SET NEW.lastUpdateUser = USER();
END$$

DELIMITER ;

-- Comprobacion
INSERT INTO employees
(employeeNumber, lastName, firstName, extension, email, officeCode, reportsTo, jobTitle, age)
VALUES
(1080, 'Perez', 'Juan', 'x1234', 'juan@email.com', '1', 1002, 'Sales Rep', 25);

SELECT
    employeeNumber,
    lastName,
    lastUpdate,
    lastUpdateUser
FROM employees
WHERE employeeNumber = 1080;

UPDATE employees
SET lastName = 'Gomez'
WHERE employeeNumber = 1080;

SELECT
    employeeNumber,
    lastName,
    lastUpdate,
    lastUpdateUser
FROM employees
WHERE employeeNumber = 1080;


