/*
EJERCICIO 4: SISTEMA DE VUELOS
Curso SOC - Bases de datos MySQL 8.4

OBJETIVO:
Gestionar aeropuertos, ciudades, países,
líneas aéreas, modelos de aviones,
programas de vuelo, vuelos realizados
y escalas técnicas.

MODELO RELACIONAL IMPLEMENTADO:

1. PAISES
2. CIUDADES
3. AEROPUERTOS
4. MODELOS_AVIONES
5. LINEAS_AEREAS
6. AEROPUERTOS_MODELOS_AVIONES
7. PROGRAMAS_VUELOS
8. SCHEDULE_PROGRAMAS_VUELOS
9. VUELOS
10. ESCALAS_TECNICAS

RESTRICCIONES IMPLEMENTADAS:
- Claves primarias y foráneas.
- Número de vuelo único.
- Capacidad de avión positiva.
- Plazas vacías no negativas.
- Origen y destino distintos.
- Día de la semana entre 1 y 7.
- Número de escala positivo.
- Un programa no se repite en la misma
  fecha de vuelo.

RESTRICCIONES PENDIENTES:
- Plazas vacías <= capacidad del modelo.
- Un programa debe operar al menos un día.
- Cada aeropuerto debe tener salidas y llegadas.
- Verificar modelos admitidos en aeropuertos.
- Validar continuidad entre escalas.

AMPLIACIÓN PENDIENTE:
Escalas comerciales con pasajeros
que suben y bajan.

NOTA:
Modelo basado en la implementación de Rita.
*/

CREATE DATABASE IF NOT EXISTS vuelos;
USE vuelos;

-- ==========================================
-- 1. TABLA PAISES
-- ==========================================

CREATE TABLE paises (
    codigo_pais CHAR(2) PRIMARY KEY,
    pais VARCHAR(50) NOT NULL
);

-- ==========================================
-- 2. TABLA CIUDADES
-- ==========================================

CREATE TABLE ciudades (
    id_ciudades INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    fk_pais CHAR(2) NOT NULL,

    FOREIGN KEY (fk_pais)
        REFERENCES paises(codigo_pais)
);

-- ==========================================
-- 3. TABLA AEROPUERTOS
-- ==========================================

CREATE TABLE aeropuertos (
    codigo_aeropuerto CHAR(3) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    fk_ciudad INT NOT NULL,

    FOREIGN KEY (fk_ciudad)
        REFERENCES ciudades(id_ciudades)
);

-- ==========================================
-- 4. TABLA MODELOS_AVIONES
-- ==========================================

CREATE TABLE modelos_aviones (
    id_modelo INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL UNIQUE,
    capacidad INT NOT NULL,

    CHECK (capacidad > 0)
);

-- ==========================================
-- 5. TABLA LINEAS_AEREAS
-- ==========================================

CREATE TABLE lineas_aereas (
    id_linea_aerea CHAR(3) PRIMARY KEY,
    nombre_linea_aerea VARCHAR(50) NOT NULL
);

-- ==========================================
-- 6. TABLA AEROPUERTOS_MODELOS_AVIONES
-- ==========================================

CREATE TABLE aeropuertos_modelos_aviones (
    fk_aeropuerto CHAR(3) NOT NULL,
    fk_modelo INT NOT NULL,

    PRIMARY KEY (fk_aeropuerto, fk_modelo),

    FOREIGN KEY (fk_aeropuerto)
        REFERENCES aeropuertos(codigo_aeropuerto),

    FOREIGN KEY (fk_modelo)
        REFERENCES modelos_aviones(id_modelo)
);

-- ==========================================
-- 7. TABLA PROGRAMAS_VUELOS
-- ==========================================

CREATE TABLE programas_vuelos (
    id_programa_vuelo INT AUTO_INCREMENT PRIMARY KEY,
    numero_vuelo VARCHAR(20) NOT NULL UNIQUE,
    linea_aerea CHAR(3) NOT NULL,
    aeropuerto_partida CHAR(3) NOT NULL,
    aeropuerto_llegada CHAR(3) NOT NULL,

    CHECK (aeropuerto_partida <> aeropuerto_llegada),

    FOREIGN KEY (aeropuerto_partida)
        REFERENCES aeropuertos(codigo_aeropuerto),

    FOREIGN KEY (aeropuerto_llegada)
        REFERENCES aeropuertos(codigo_aeropuerto),

    FOREIGN KEY (linea_aerea)
        REFERENCES lineas_aereas(id_linea_aerea)
);

-- ==========================================
-- 8. TABLA SCHEDULE_PROGRAMAS_VUELOS
-- ==========================================

CREATE TABLE schedule_programas_vuelos (
    fk_programa_vuelo INT NOT NULL,
    dia_semana TINYINT NOT NULL,
    hora_salida TIME NOT NULL,

    PRIMARY KEY (
        fk_programa_vuelo,
        dia_semana,
        hora_salida
    ),

    CHECK (dia_semana BETWEEN 1 AND 7),

    FOREIGN KEY (fk_programa_vuelo)
        REFERENCES programas_vuelos(id_programa_vuelo)
);

-- ==========================================
-- 9. TABLA VUELOS
-- ==========================================

CREATE TABLE vuelos (
    pk_vuelo INT AUTO_INCREMENT PRIMARY KEY,
    fk_programa_vuelo INT NOT NULL,
    fecha DATE NOT NULL,
    hora TIME NOT NULL,
    plazas_vacias INT NOT NULL,
    fk_modelo INT NOT NULL,

    UNIQUE (fk_programa_vuelo, fecha),

    CHECK (plazas_vacias >= 0),

    FOREIGN KEY (fk_programa_vuelo)
        REFERENCES programas_vuelos(id_programa_vuelo),

    FOREIGN KEY (fk_modelo)
        REFERENCES modelos_aviones(id_modelo)
);

-- ==========================================
-- 10. TABLA ESCALAS_TECNICAS
-- ==========================================

CREATE TABLE escalas_tecnicas (
    fk_vuelo INT NOT NULL,
    numero_escala INT NOT NULL,
    aeropuerto_partida CHAR(3) NOT NULL,
    aeropuerto_llegada CHAR(3) NOT NULL,

    PRIMARY KEY (fk_vuelo, numero_escala),

    CHECK (numero_escala > 0),
    CHECK (aeropuerto_partida <> aeropuerto_llegada),

    FOREIGN KEY (fk_vuelo)
        REFERENCES vuelos(pk_vuelo),

    FOREIGN KEY (aeropuerto_partida)
        REFERENCES aeropuertos(codigo_aeropuerto),

    FOREIGN KEY (aeropuerto_llegada)
        REFERENCES aeropuertos(codigo_aeropuerto)
);


/*
====================================================
EJERCICIO 4 - SISTEMA DE VUELOS
DOCUMENTACIÓN Y JUSTIFICACIÓN DEL MODELO
====================================================

1. DISEÑO RELACIONAL

Se ha implementado una base de datos de 10 tablas,
siguiendo el modelo trabajado por la docente en Access
y adaptándolo a MySQL 8.4.

El diseño contempla:
- Aeropuertos, ciudades y países.
- Modelos de aviones y sus capacidades.
- Compatibilidad entre aeropuertos y modelos.
- Líneas aéreas y programas de vuelo.
- Días y horarios de operación.
- Vuelos realizados.
- Escalas técnicas ordenadas.

2. RELACIONES E INTEGRIDAD

Se utilizan claves primarias (PK) y foráneas (FK)
para establecer las relaciones entre tablas.

Las relaciones N:M se resuelven mediante tablas
intermedias con claves primarias compuestas.

Se aplican restricciones NOT NULL, UNIQUE y CHECK
para proteger la integridad de los datos.

3. ESCALAS TÉCNICAS

Las escalas técnicas representan paradas
intermedias en las que el avión aterriza
y despega sin intercambio de pasajeros.

Cada escala pertenece a un vuelo realizado.

La clave primaria compuesta
(fk_vuelo, numero_escala)
permite identificar y ordenar las escalas
correspondientes a cada vuelo.

4. AMPLIACIÓN: ESCALAS COMERCIALES

Si se permitiera subir o bajar pasajeros,
las escalas dejarían de ser exclusivamente
técnicas.

Se propone ampliar la tabla de escalas
incorporando los siguientes atributos:

- tipo_escala:
  'TECNICA' o 'COMERCIAL'.

- pasajeros_suben:
  Número de pasajeros que embarcan.

- pasajeros_bajan:
  Número de pasajeros que desembarcan.

Se aplicarían las siguientes restricciones:

- Los pasajeros que suben o bajan
  no pueden ser negativos.

- En una escala técnica, ambos valores
  deben ser cero.

- En una escala comercial, se permite
  el embarque y desembarque de pasajeros.

- La ocupación resultante no puede superar
  la capacidad del modelo de avión.

5. ALCANCE DE LA IMPLEMENTACIÓN

El modelo implementa la estructura principal
del sistema de vuelos.

Algunas reglas de negocio, como garantizar
que todos los aeropuertos tengan salidas
y llegadas o comprobar la capacidad disponible
entre tablas, requerirían validaciones
adicionales.

La ampliación de escalas comerciales se
documenta conceptualmente, sin modificar
las tablas implementadas.

====================================================
FIN DEL EJERCICIO 4
====================================================
*/


