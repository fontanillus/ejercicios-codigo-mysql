
-- EJERCICIO 3: CARRETERAS
-- Creación de la base de datos

CREATE DATABASE IF NOT EXISTS carreteras;
USE carreteras;

/*
EJERCICIO 3: CARRETERAS

OBJETIVO:
Diseñar una base de datos para gestionar
las carreteras del país y sus características.

CARRETERAS:
- Código, nombre, titularidad y nivel.
- Tipo de vía: autopista, autovía,
  multicarril o convencional.
- Acceso controlado y doble calzada (booleanos).
- Prefijo, color, señal y observaciones.
- Clasificación por categorías.

TITULARIDAD Y NIVELES:
- Estatal: sin nivel.
- Nivel 1: autonómica (naranja).
- Nivel 2: autonómica o provincial (verde).
- Nivel 3: autonómica, provincial o municipal
  (amarillo).

TRAMOS:
- Identificador autogenerado.
- Carretera a la que pertenecen.
- Kilómetro inicial y final.
- Longitud calculada.
- Tipo de terreno: plano, cuesta subida
  o cuesta bajada.
- Entorno: urbano, travesía o extraurbano.
- Velocidad límite y carriles por sentido.
- Observaciones adicionales.

LOCALIZACIÓN GEOGRÁFICA:
- Comunidades autónomas y provincias.
- Provincia de inicio y final de cada tramo.
- Un tramo puede atravesar varias provincias.
- Registro de los intervalos kilométricos
  recorridos por cada provincia.

EXTREMOS DE CARRETERA:
- Identificación del inicio y final.
- Finalización física o confluencia.
- Si existe confluencia, registrar la carretera,
  el kilómetro, tramo y provincia correspondiente.

RESTRICCIONES:
- Cada tramo pertenece a una única carretera.
- Una carretera puede tener varios tramos.
- Cada carretera tiene un inicio y un final.
- La longitud se calcula a partir de los kilómetros.
*/

-- Tabla CATEGORIAS
CREATE TABLE categorias (
    id_categoria VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);

-- Tabla CARRETERAS
CREATE TABLE carreteras (
    codigo VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    prefijo VARCHAR(50) NOT NULL,
    color VARCHAR(20),
    senyal VARCHAR(100),
    observaciones VARCHAR(100),
    titularidad VARCHAR(50),
    nivel TINYINT CHECK (nivel IN (1, 2, 3)),
    tipo_via VARCHAR(20),
    acceso_controlado BOOLEAN,
    doble_calzada BOOLEAN NOT NULL,
    id_categoria VARCHAR(15) NOT NULL,

    FOREIGN KEY (id_categoria)
        REFERENCES categorias(id_categoria)
);

-- Tabla COMUNIDADES_AUTONOMAS
CREATE TABLE comunidades_autonomas (
    id_comunidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- Tabla PROVINCIAS
CREATE TABLE provincias (
    id_provincia INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    id_comunidad INT NOT NULL,

    FOREIGN KEY (id_comunidad)
        REFERENCES comunidades_autonomas(id_comunidad)
);

-- Tabla TRAMOS
CREATE TABLE tramos (
    id_tramo INT AUTO_INCREMENT PRIMARY KEY,
    codigo_carretera VARCHAR(15) NOT NULL,
    km_inicial DECIMAL(8,3) NOT NULL,
    km_final DECIMAL(8,3) NOT NULL,
    tipo_terreno ENUM(
        'Plano',
        'Cuesta subida',
        'Cuesta bajada'
    ) NOT NULL,
    entorno ENUM(
        'Urbano',
        'Travesía',
        'Extraurbano'
    ) NOT NULL,
    velocidad_limite INT NOT NULL,
    numero_carriles_por_sentido TINYINT UNSIGNED NOT NULL,
    observaciones VARCHAR(200),
    id_provincia_inicio INT NOT NULL,
    id_provincia_fin INT NOT NULL,

    FOREIGN KEY (codigo_carretera)
        REFERENCES carreteras(codigo),

    FOREIGN KEY (id_provincia_inicio)
        REFERENCES provincias(id_provincia),

    FOREIGN KEY (id_provincia_fin)
        REFERENCES provincias(id_provincia),

    UNIQUE (codigo_carretera, id_tramo)
);

-- Tabla EXTREMOS_CARRETERA
CREATE TABLE extremos_carretera (
    id_extremo INT AUTO_INCREMENT PRIMARY KEY,
    posicion ENUM('Inicio', 'Final') NOT NULL,
    tipo_extremo ENUM('Fisico', 'Confluencia') NOT NULL,
    km_extremo DECIMAL(8,3) NOT NULL,
    codigo_carretera VARCHAR(15) NOT NULL,
    id_tramo INT NOT NULL,
    id_provincia INT NOT NULL,
    km_confluencia DECIMAL(8,3),
    id_tramo_confluencia INT,
    id_provincia_confluencia INT,

    FOREIGN KEY (codigo_carretera)
        REFERENCES carreteras(codigo),

    FOREIGN KEY (codigo_carretera, id_tramo)
        REFERENCES tramos(codigo_carretera, id_tramo),

    FOREIGN KEY (id_provincia)
        REFERENCES provincias(id_provincia),

    FOREIGN KEY (id_tramo_confluencia)
        REFERENCES tramos(id_tramo),

    FOREIGN KEY (id_provincia_confluencia)
        REFERENCES provincias(id_provincia),

    UNIQUE (codigo_carretera, posicion)
);

-- Tabla TRAYECTOS
CREATE TABLE trayectos (
    id_tramo INT NOT NULL,
    id_paso INT NOT NULL,
    id_provincia INT NOT NULL,
    km_inicio DECIMAL(8,3) NOT NULL,
    km_fin DECIMAL(8,3) NOT NULL,

    PRIMARY KEY (id_tramo, id_paso),

    FOREIGN KEY (id_tramo)
        REFERENCES tramos(id_tramo),

    FOREIGN KEY (id_provincia)
        REFERENCES provincias(id_provincia)
);
