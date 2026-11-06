-- BASE DE DATOS: VENTAS
-- EJERCICIO 2: SISTEMA DE VENTAS

/*
OBJETIVO:
Diseñar una base de datos para gestionar proveedores,
clientes, productos, categorías y ventas.

PROVEEDORES:
- CIF/NIF, nombre, dirección, teléfono y página web.

CLIENTES:
- CIF/NIF, nombre y dirección.
- Varios teléfonos de contacto.

DIRECCIONES:
- Calle, número, ciudad y código postal.

PRODUCTOS:
- ID único, nombre, precio actual, stock y proveedor.
- Cada producto pertenece a una sola categoría.

CATEGORÍAS:
- ID, nombre y descripción.

FACTURAS:
- Número, fecha, cliente, descuento e importe final
  con IVA incluido.

DETALLE DE VENTA:
- Producto vendido.
- Precio del producto en el momento de la venta.
- Cantidad vendida.
- Importe total del producto.
*/
CREATE DATABASE IF NOT EXISTS ventas;
USE ventas;


-- Tabla PROVEEDORES
CREATE TABLE proveedores (
    cif_nif VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    calle VARCHAR(100),
    numero VARCHAR(10),
    ciudad VARCHAR(50),
    codigo_postal CHAR(5),
    telefono VARCHAR(20),
    pagina_web VARCHAR(255)
);

-- Tabla CATEGORIAS
CREATE TABLE categorias (
    id_categoria VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion VARCHAR(100) NOT NULL
);

-- Tabla CLIENTES
CREATE TABLE clientes (
    cif_nif VARCHAR(15) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    calle VARCHAR(100),
    numero VARCHAR(10),
    ciudad VARCHAR(50),
    codigo_postal CHAR(5)
  );

USE ventas;

  -- Tabla TELEFONOS
CREATE TABLE telefonos (
    id_telefono INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(15) NOT NULL,
    cif_nif VARCHAR(15) NOT NULL,
    FOREIGN KEY (cif_nif) REFERENCES clientes(cif_nif)
);

-- Tabla PRODUCTOS
CREATE TABLE productos (
    id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_actual DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    cif_nif VARCHAR(15) NOT NULL,
    id_categoria VARCHAR(15) NOT NULL,
    FOREIGN KEY (cif_nif) REFERENCES proveedores(cif_nif),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabla FACTURAS
CREATE TABLE facturas (
    id_factura INT AUTO_INCREMENT PRIMARY KEY,
    fecha DATE NOT NULL,
    descuento DECIMAL(5,2) NULL,
    importe_total DECIMAL(15,2),
    cif_nif VARCHAR(15) NOT NULL,
    FOREIGN KEY (cif_nif) REFERENCES clientes(cif_nif)
);

-- Tablas LINEA FACTURA
CREATE TABLE facturas_lineas (
    id_factura INT NOT NULL,
    num_linea INT NOT NULL,
    precio_venta DECIMAL(15,2) NOT NULL,
    cantidad INT NOT NULL,
    id_producto INT NOT NULL,

    PRIMARY KEY (id_factura, num_linea),

    FOREIGN KEY (id_factura)
        REFERENCES facturas(id_factura),

    FOREIGN KEY (id_producto)
        REFERENCES productos(id_producto)
);


