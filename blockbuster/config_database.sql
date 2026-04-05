-- Script SQL para configurar Blockbuster
-- Ejecutar como root/administrador de MySQL

-- Crear base de datos
CREATE DATABASE IF NOT EXISTS blockbuster CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE blockbuster;

-- Crear usuario con permisos
CREATE USER IF NOT EXISTS 'blockbuser'@'localhost' IDENTIFIED BY 'blockpass487';
GRANT ALL PRIVILEGES ON blockbuster.* TO 'blockbuser'@'localhost';
FLUSH PRIVILEGES;

-- Crear tabla roles
CREATE TABLE IF NOT EXISTS roles (
    id_rol INT PRIMARY KEY AUTO_INCREMENT,
    nombre_rol VARCHAR(50) NOT NULL,
    descripcion_rol TEXT,
    estatus_rol VARCHAR(20) DEFAULT 'activo'
);

-- Insertar roles
INSERT INTO roles (nombre_rol, descripcion_rol) VALUES
('Administrador', 'Control total del sistema'),
('Operador', 'Gestión de clientes y pagos'),
('Cliente', 'Usuario final del sistema');

-- Crear tabla usuarios
CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT PRIMARY KEY AUTO_INCREMENT,
    nombre_usuario VARCHAR(100) NOT NULL,
    ap_usuario VARCHAR(100) NOT NULL,
    am_usuario VARCHAR(100),
    email_usuario VARCHAR(150) UNIQUE NOT NULL,
    password_usuario VARCHAR(255) NOT NULL,
    id_rol INT NOT NULL,
    estatus_usuario VARCHAR(20) DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_rol) REFERENCES roles(id_rol)
);

-- Insertar usuarios de prueba con nuevas credenciales predeterminadas
INSERT INTO usuarios (nombre_usuario, ap_usuario, am_usuario, email_usuario, password_usuario, id_rol, estatus_usuario) VALUES
('Admin', 'Sistema', 'Principal', 'admin@blockbuster.com', '$2y$10$hHAdoPnlb/Gj1Yrowlq1FuPMf5HrlRDlVgrklknKyU.aIQUsBRDVW', 1, 'activo'),
('Operador', 'Sistema', 'Principal', 'operador@blockbuster.com', '$2y$10$T3JRYKtcb2jDLpLEsbsbIeDa5I6wdzIbkRv1XIwSLwMTVxVb0PiSG', 2, 'activo'),
('Cliente', 'Sistema', 'Principal', 'cliente@blockbuster.com', '$2y$10$T1VHSIUP7KuZvlvbX2nqwuaAKru.LI1mSCUtwTi3g6LRjVC2Gjxym', 3, 'activo');

-- Crear tabla planes
CREATE TABLE IF NOT EXISTS planes (
    id_plan INT PRIMARY KEY AUTO_INCREMENT,
    nombre_plan VARCHAR(100) NOT NULL,
    precio_plan DECIMAL(10,2) NOT NULL,
    cantidad_limite_plan INT NOT NULL,
    descripcion_plan TEXT,
    estatus_plan VARCHAR(20) DEFAULT 'activo',
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar planes
INSERT INTO planes (nombre_plan, precio_plan, cantidad_limite_plan, descripcion_plan, estatus_plan) VALUES
('Plan Básico', 9.99, 1, 'Acceso básico a películas y series', 'activo'),
('Plan Premium', 15.99, 4, 'Acceso premium con múltiples pantallas', 'activo'),
('Plan Familiar', 19.99, 6, 'Plan familiar para toda la familia', 'activo');

-- Crear tabla generos
CREATE TABLE IF NOT EXISTS generos (
    id_genero INT PRIMARY KEY AUTO_INCREMENT,
    nombre_genero VARCHAR(100) NOT NULL,
    descripcion_genero TEXT,
    estatus_genero VARCHAR(20) DEFAULT 'activo'
);

-- Insertar géneros
INSERT INTO generos (nombre_genero, descripcion_genero, estatus_genero) VALUES
('Acción', 'Películas de acción y aventura', 'activo'),
('Comedia', 'Películas y series cómicas', 'activo'),
('Drama', 'Películas dramáticas', 'activo'),
('Terror', 'Películas de terror y suspenso', 'activo'),
('Romance', 'Películas románticas', 'activo'),
('Ciencia Ficción', 'Películas de ciencia ficción', 'activo');

-- Crear tabla streaming
CREATE TABLE IF NOT EXISTS blockbuster_streaming (
    id_streaming INT PRIMARY KEY AUTO_INCREMENT,
    nombre_streaming VARCHAR(200) NOT NULL,
    descripcion_streaming TEXT,
    tipo_streaming ENUM('pelicula', 'serie') NOT NULL,
    id_genero INT,
    duracion_streaming INT,
    temporadas_streaming INT,
    clasificacion_streaming VARCHAR(10),
    caratula_streaming VARCHAR(255),
    trailer_streaming VARCHAR(255),
    estatus_streaming TINYINT(1) DEFAULT 1,
    sipnosis_streaming TEXT,
    fecha_estreno_streaming DATE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_genero) REFERENCES generos(id_genero)
);

-- Insertar contenido de ejemplo
INSERT INTO blockbuster_streaming (nombre_streaming, descripcion_streaming, tipo_streaming, id_genero, duracion_streaming, temporadas_streaming, clasificacion_streaming, caratula_streaming, trailer_streaming, estatus_streaming, sipnosis_streaming, fecha_estreno_streaming) VALUES
('Avengers: Endgame', 'Los Vengadores restantes deben encontrar una manera de recuperar a sus aliados para un enfrentamiento épico con Thanos.', 'pelicula', 1, 181, NULL, 'PG-13', 'https://via.placeholder.com/600x360/ff0000/ffffff?text=Endgame', 'https://youtu.be/TcMBFSGVi1c', 1, 'Un final épico para la saga de los superhéroes.', '2019-04-26'),
('John Wick: Chapter 4', 'John Wick regresa para enfrentar su destino y derrotar a enemigos extraordinarios.', 'pelicula', 1, 169, NULL, 'R', 'https://via.placeholder.com/600x360/000000/ffffff?text=John+Wick+4', 'https://youtu.be/0hH4P8s7Xm4', 1, 'Acción imparable en cada esquina.', '2023-03-24'),
('The Mandalorian', 'La serie sigue las aventuras del cazarrecompensas conocido como "el Mandaloriano" en los confines de la galaxia.', 'serie', 6, NULL, 3, 'TV-14', 'https://via.placeholder.com/600x360/1f1f1f/ffffff?text=Mandalorian', 'https://youtu.be/BbNvKCuEF4E', 1, 'Aventura espacial con el Niño y los mandalorianos.', '2019-11-12'),
('Inception', 'Un ladrón que roba secretos corporativos a través del uso de la tecnología de compartición de sueños.', 'pelicula', 6, 148, NULL, 'PG-13', 'https://via.placeholder.com/600x360/002244/ffffff?text=Inception', 'https://youtu.be/YoHD9XEInc0', 1, 'La frontera entre sueño y realidad se desdibuja.', '2010-07-16'),
('La La Land', 'Sueños, música y romance en Los Ángeles.', 'pelicula', 5, 128, NULL, 'PG-13', 'https://via.placeholder.com/600x360/ff69b4/ffffff?text=La+La+Land', 'https://youtu.be/0pdqf4P9MB8', 1, 'Amor, arte y la pasión por perseguir tus sueños.', '2016-12-09'),
('The Hangover', 'Una despedida de soltero se convierte en una comedia caótica en Las Vegas.', 'pelicula', 2, 100, NULL, 'R', 'https://via.placeholder.com/600x360/ffd700/000000?text=The+Hangover', 'https://youtu.be/hn2xA7pdwFs', 1, 'Comedia absurda y extraña que no olvidarás.', '2009-06-05'),
('Get Out', 'Un fin de semana familiar revela un oscuro misterio entre risas y terror.', 'pelicula', 4, 104, NULL, 'R', 'https://via.placeholder.com/600x360/222222/ffffff?text=Get+Out', 'https://youtu.be/DzfpyUB60YY', 1, 'Terror psicológico con una crítica social fuerte.', '2017-02-24'),
('Parasite', 'Una familia pobre debe infiltrarse en una casa rica y descubre peligros inesperados.', 'pelicula', 3, 132, NULL, 'R', 'https://via.placeholder.com/600x360/444444/ffffff?text=Parasite', 'https://youtu.be/5xH0HfJHsaY', 1, 'Drama intenso sobre clases sociales y engaños.', '2019-05-30');

-- Crear otras tablas necesarias
CREATE TABLE IF NOT EXISTS usuarios_planes (
    id_usuario_plan INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_plan INT NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estatus_usuario_plan VARCHAR(20) DEFAULT 'activo',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_plan) REFERENCES planes(id_plan)
);

CREATE TABLE IF NOT EXISTS alquileres (
    id_alquiler INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_streaming INT NOT NULL,
    fecha_alquiler TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_vencimiento DATE NOT NULL,
    estatus_alquiler ENUM('en_proceso', 'culminado', 'cancelado') DEFAULT 'en_proceso',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_streaming) REFERENCES blockbuster_streaming(id_streaming)
);

CREATE TABLE IF NOT EXISTS pagos (
    id_pago INT PRIMARY KEY AUTO_INCREMENT,
    id_usuario INT NOT NULL,
    id_alquiler INT,
    monto_pago DECIMAL(10,2) NOT NULL,
    numero_tarjeta VARCHAR(20),
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estatus_pago ENUM('pendiente', 'aprobado', 'rechazado') DEFAULT 'pendiente',
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_alquiler) REFERENCES alquileres(id_alquiler)
);

-- Confirmar configuración
SELECT 'Base de datos Blockbuster configurada exitosamente!' as mensaje;