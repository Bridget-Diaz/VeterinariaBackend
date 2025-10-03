-- ==================================
-- CREAR BASE DE DATOS
-- ==================================
CREATE DATABASE SuperPetPrueba1;
USE SuperPetPrueba1;

-- ==================================
-- TABLA CLIENTES
-- ==================================
CREATE TABLE Clientes (
    id_cliente BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    telefono VARCHAR(15),
    email VARCHAR(100),
    direccion VARCHAR(200),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- ==================================
-- TABLA ROLES
-- ==================================
CREATE TABLE Roles (
    id_rol BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol VARCHAR(50) NOT NULL UNIQUE
);

-- ==================================
-- TABLA USUARIOS (para login)
-- ==================================
CREATE TABLE Usuarios (
    id_usuario BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NULL,
    id_rol BIGINT NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
        ON DELETE SET NULL
        ON UPDATE CASCADE,
    FOREIGN KEY (id_rol) REFERENCES Roles(id_rol)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ==================================
-- TABLA MASCOTAS
-- ==================================
CREATE TABLE Mascotas (
    id_mascota BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    especie VARCHAR(50),
    raza VARCHAR(50),
    edad INT,
    peso DECIMAL(5,2),
    observaciones TEXT,
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ==================================
-- TABLA VETERINARIOS
-- ==================================
CREATE TABLE Veterinarios (
    id_veterinario BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    telefono VARCHAR(15),
    email VARCHAR(100)
);

-- ==================================
-- TABLA SERVICIOS VETERINARIOS
-- ==================================
CREATE TABLE Servicios (
    id_servicio BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre_servicio VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10,2) NOT NULL
);

-- ==================================
-- TABLA CITAS VETERINARIAS
-- ==================================
CREATE TABLE Citas (
    id_cita BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    id_mascota BIGINT NOT NULL,
    id_veterinario BIGINT NOT NULL,
    id_servicio BIGINT NOT NULL,
    fecha_cita DATETIME NOT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_mascota) REFERENCES Mascotas(id_mascota)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_veterinario) REFERENCES Veterinarios(id_veterinario)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_servicio) REFERENCES Servicios(id_servicio)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ==================================
-- TABLA PRODUCTOS
-- ==================================
CREATE TABLE Productos (
    id_producto BIGINT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    categoria VARCHAR(50),
    precio DECIMAL(10,2) NOT NULL,
    stock INT DEFAULT 0
);


    select * from Usuarios;

-- ==================================
-- TABLA INVENTARIO (movimientos de stock)
-- ==================================
CREATE TABLE Inventario (
    id_movimiento BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_producto BIGINT NOT NULL,
    tipo_movimiento ENUM('ENTRADA','SALIDA') NOT NULL,
    cantidad INT NOT NULL,
    fecha_movimiento DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ==================================
-- TABLA PEDIDOS (VENTAS)
-- ==================================
CREATE TABLE Pedidos (
    id_pedido BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_cliente BIGINT NOT NULL,
    fecha_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    total DECIMAL(10,2) NOT NULL,
    estado VARCHAR(20) DEFAULT 'Pendiente',
    FOREIGN KEY (id_cliente) REFERENCES Clientes(id_cliente)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ==================================
-- TABLA DETALLE DE PEDIDO
-- ==================================
CREATE TABLE DetallePedido (
    id_detalle BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_pedido BIGINT NOT NULL,
    id_producto BIGINT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES Pedidos(id_pedido)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_producto) REFERENCES Productos(id_producto)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- ==================================
-- TABLA HISTORIAL MÉDICO
-- ==================================
CREATE TABLE HistorialMedico (
    id_historial BIGINT AUTO_INCREMENT PRIMARY KEY,
    id_mascota BIGINT NOT NULL,
    id_veterinario BIGINT NOT NULL,
    fecha DATE NOT NULL,
    diagnostico TEXT,
    tratamiento TEXT,
    FOREIGN KEY (id_mascota) REFERENCES Mascotas(id_mascota)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    FOREIGN KEY (id_veterinario) REFERENCES Veterinarios(id_veterinario)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

-- ==================================
-- INSERTAR ROLES BÁSICOS
-- ==================================
INSERT INTO Roles (nombre_rol) VALUES ('ADMIN'), ('CLIENTE'), ('VETERINARIO');

-- ========================
-- CLIENTES
-- ========================
INSERT INTO Clientes (nombre, telefono, email, direccion) VALUES
('Juan Pérez', '987654321', 'juanperez@mail.com', 'Av. Siempre Viva 123'),
('María López', '912345678', 'maria.lopez@mail.com', 'Jr. Las Flores 456'),
('Carlos Ramos', '976543210', 'carlos.r@mail.com', 'Calle Central 789');

-- ========================
-- USUARIOS (con rol CLIENTE y ADMIN)
-- Passwords en texto plano (luego tu app los codificará con BCrypt al registrar)
-- ========================
INSERT INTO Usuarios (id_cliente, id_rol, email, password) VALUES
(1, 2, 'juanperez@mail.com', '$2a$10$PruebaHashDeEjemplo1'),
(2, 2, 'maria.lopez@mail.com', '$2a$10$PruebaHashDeEjemplo2'),
(NULL, 1, 'admin@superpet.com', '$2a$10$PruebaHashAdmin');

-- ========================
-- VETERINARIOS
-- ========================
INSERT INTO Veterinarios (nombre, especialidad, telefono, email) VALUES
('Dr. José Martínez', 'Medicina General', '934567890', 'jose.vet@mail.com'),
('Dra. Ana Castillo', 'Dermatología', '945678901', 'ana.castillo@mail.com');

-- ========================
-- MASCOTAS
-- ========================
INSERT INTO Mascotas (id_cliente, nombre, especie, raza, edad, peso, observaciones) VALUES
(1, 'Firulais', 'Perro', 'Labrador', 5, 25.3, 'Vacunado, muy activo'),
(2, 'Michi', 'Gato', 'Siames', 3, 4.5, 'Le teme a desconocidos');

-- ========================
-- SERVICIOS
-- ========================
INSERT INTO Servicios (nombre_servicio, descripcion, precio) VALUES
('Consulta General', 'Revisión médica general de la mascota', 50.00),
('Vacunación', 'Aplicación de vacunas básicas y refuerzo', 80.00),
('Desparasitación', 'Tratamiento antiparasitario interno y externo', 40.00);

-- ========================
-- CITAS
-- ========================
INSERT INTO Citas (id_cliente, id_mascota, id_veterinario, id_servicio, fecha_cita, estado) VALUES
(1, 1, 1, 1, '2025-09-01 10:00:00', 'Pendiente'),
(2, 2, 2, 2, '2025-09-02 15:30:00', 'Confirmada');

-- ========================
-- PRODUCTOS
-- ========================
INSERT INTO Productos (nombre, descripcion, categoria, precio, stock) VALUES
('Alimento Premium Perros', 'Bolsa de 10kg de alimento balanceado para perros adultos', 'Alimento', 120.00, 50),
('Alimento Gatos Kitten', 'Alimento seco para gatos menores de 1 año', 'Alimento', 90.00, 40),
('Antipulgas Frontline', 'Pipeta antipulgas para perros medianos', 'Medicamento', 60.00, 20);

INSERT INTO Productos (nombre, descripcion, categoria, precio, stock) VALUES
-- Alimentos
('Alimento Premium Perros', 'Bolsa de 10kg de alimento balanceado para perros adultos', 'Alimento', 120.00, 50),
('Alimento Gatos Kitten', 'Alimento seco para gatos menores de 1 año', 'Alimento', 90.00, 40),
('Alimento Senior Perros', 'Alimento balanceado para perros mayores de 7 años', 'Alimento', 110.00, 30),
('Alimento Húmedo Gatos', 'Lata de 170g sabor salmón', 'Alimento', 12.00, 100),
('Snack Dental Perros', 'Galletas dentales que reducen el sarro', 'Alimento', 25.00, 80),

-- Medicamentos
('Antipulgas Frontline', 'Pipeta antipulgas para perros medianos', 'Medicamento', 60.00, 20),
('Desparasitante Drontal', 'Tableta antiparasitaria de amplio espectro para perros', 'Medicamento', 45.00, 25),
('Vitaminas PetVital', 'Suplemento vitamínico para gatos y perros', 'Medicamento', 35.00, 30),
('Collar Antipulgas', 'Collar protector contra pulgas y garrapatas (8 meses duración)', 'Medicamento', 70.00, 15),

-- Accesorios
('Correa Retráctil', 'Correa retráctil de 5 metros para perros medianos', 'Accesorio', 55.00, 25),
('Arnés Pequeño', 'Arnés de nylon para perros pequeños', 'Accesorio', 40.00, 20),
('Collar Luminoso LED', 'Collar ajustable con luz LED para paseos nocturnos', 'Accesorio', 65.00, 10),

-- Juguetes
('Pelota de Goma', 'Pelota resistente para perros mordelones', 'Juguete', 30.00, 50),
('Rascador para Gatos', 'Rascador con base de sisal de 50cm', 'Juguete', 85.00, 10),
('Juguete Sonajero', 'Juguete con sonido para cachorros', 'Juguete', 20.00, 35),

-- Higiene
('Shampoo Antipulgas', 'Shampoo medicado para perros y gatos', 'Higiene', 45.00, 25),
('Toallitas Húmedas Pet', 'Toallitas limpiadoras para mascotas', 'Higiene', 28.00, 40),
('Arena Sanitaria Gatos', 'Bolsa de 10kg de arena aglutinante', 'Higiene', 60.00, 30);

-- ========================
-- PEDIDOS Y DETALLE
-- ========================
INSERT INTO Pedidos (id_cliente, total, estado) VALUES
(1, 180.00, 'Pagado');

INSERT INTO DetallePedido (id_pedido, id_producto, cantidad, precio_unitario) VALUES
(1, 1, 1, 120.00),
(1, 3, 1, 60.00);

-- ========================
-- HISTORIAL MÉDICO
-- ========================
INSERT INTO HistorialMedico (id_mascota, id_veterinario, fecha, diagnostico, tratamiento) VALUES
(1, 1, '2025-08-15', 'Gastritis leve', 'Dieta blanda y medicación por 5 días'),
(2, 2, '2025-08-20', 'Dermatitis alérgica', 'Baño medicado y crema tópica por 10 días');

select * from detallepedido;
select * from Mascotas;

select * from Usuarios;

select * from Clientes;

DELETE FROM Clientes
WHERE id_cliente = 4;
select * from Productos;

select * from Citas; 