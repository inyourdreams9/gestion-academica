-- Base: usa la BD ya creada
USE gestion_academica;

-- Tabla rol
CREATE TABLE IF NOT EXISTS rol (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol VARCHAR(50) NOT NULL,
  descripcion TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO rol (id_rol, nombre_rolalumno, descripcion) VALUES
(1, 'Administrador','Acceso total al sistema'),
(2, 'Docente','Encargado de dictar cursos'),
(3, 'Alumno','Usuario estudiante')
ON DUPLICATE KEY UPDATE nombre_rol = VALUES(nombre_rol);

-- Tabla usuario
CREATE TABLE IF NOT EXISTS usuario (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  dni VARCHAR(8) UNIQUE NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  apellido VARCHAR(100) NOT NULL,
  email VARCHAR(150) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  estado TINYINT(1) DEFAULT 1,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  id_rol INT,
  FOREIGN KEY (id_rol) REFERENCES rol(id_rol)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO usuario (id_usuario, dni, nombre, apellido, email, password_hash, estado, fecha_creacion, id_rol) VALUES
(1, '11111111', 'Juan', 'Salinas', 'admin@example.com', SHA2('AdminPass123!',256), 1, NOW(), 1),
(2, '22222222', 'Carlos', 'Ramirez', 'carlos.ramirez@example.com', SHA2('DocentePass1!',256), 1, NOW(), 2),
(3, '22334455', 'Ana', 'Lopez', 'ana.lopez@example.com', SHA2('DocentePass2!',256), 1, NOW(), 2),
(4, '33333333', 'María', 'Gonzales', 'maria.gonzales@example.com', SHA2('AlumnoPass1!',256), 1, NOW(), 3),
(5, '33445566', 'Luis', 'Torres', 'luis.torres@example.com', SHA2('AlumnoPass2!',256), 1, NOW(), 3)
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre), apellido = VALUES(apellido), email = VALUES(email);

-- Tabla docente
CREATE TABLE IF NOT EXISTS docente (
  id_docente INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  especialidad VARCHAR(150),
  grado_academico VARCHAR(100),
  telefono VARCHAR(20),
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO docente (id_docente, id_usuario, especialidad, grado_academico, telefono) VALUES
(1, 2, 'Matemáticas', 'Magíster en Educación', '987654321'),
(2, 3, 'Programación', 'Licenciatura en Informática', '987000111')
ON DUPLICATE KEY UPDATE telefono = VALUES(telefono);

-- Tabla alumno
CREATE TABLE IF NOT EXISTS alumno (
  id_alumno INT AUTO_INCREMENT PRIMARY KEY,
  id_usuario INT NOT NULL,
  dni_apoderado VARCHAR(8),
  telefono VARCHAR(20),
  fecha_nacimiento DATE,
  FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO alumno (id_alumno, id_usuario, dni_apoderado, telefono, fecha_nacimiento) VALUES
(1, 4, '44444444', '912345678', '2005-04-12'),
(2, 5, '55555555', '912000111', '2006-09-20')
ON DUPLICATE KEY UPDATE telefono = VALUES(telefono);

-- Tabla seccion
CREATE TABLE IF NOT EXISTS seccion (
  id_seccion INT AUTO_INCREMENT PRIMARY KEY,
  nombre_seccion VARCHAR(50) NOT NULL,
  periodo_academico VARCHAR(20),
  capacidad_maxima INT,
  estado TINYINT(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO seccion (id_seccion, nombre_seccion, periodo_academico, capacidad_maxima, estado) VALUES
(1, 'Sección A', '2026-I', 30, 1),
(2, 'Sección B', '2026-I', 25, 1),
(3, 'Sección C', '2026-II', 20, 1)
ON DUPLICATE KEY UPDATE capacidad_maxima = VALUES(capacidad_maxima);

-- Tabla curso (ahora incluyendo id_seccion y con IDs explícitos para que coincidan con referencias)
CREATE TABLE IF NOT EXISTS curso (
  id_curso INT AUTO_INCREMENT PRIMARY KEY,
  id_seccion INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  descripcion TEXT,
  estado TINYINT(1) DEFAULT 1,
  fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO curso (id_curso, id_seccion, nombre, descripcion, estado, fecha_creacion) VALUES
(1, 1, 'Álgebra Básica', 'Curso introductorio de álgebra', 1, NOW()),
(2, 1, 'Programación I', 'Fundamentos de programación en Python', 1, NOW()),
(3, 2, 'Álgebra Intermedia', 'Álgebra con polinomios y ecuaciones', 1, NOW()),
(4, 2, 'Cálculo I', 'Límites, derivadas e introducción a integrales', 1, NOW()),
(5, 3, 'Bases de Datos', 'Modelado relacional y SQL básico', 1, NOW()),
(6, 3, 'Estructuras de Datos', 'Listas, pilas, colas, árboles y grafos', 1, NOW())
ON DUPLICATE KEY UPDATE nombre = VALUES(nombre);

-- Tabla asignacion_curso
CREATE TABLE IF NOT EXISTS asignacion_curso (
  id_asignacion INT AUTO_INCREMENT PRIMARY KEY,
  id_docente INT NOT NULL,
  id_curso INT NOT NULL,
  estado TINYINT(1) DEFAULT 1,
  fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_docente) REFERENCES docente(id_docente),
  FOREIGN KEY (id_curso) REFERENCES curso(id_curso)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO asignacion_curso (id_asignacion, id_docente, id_curso, estado, fecha_asignacion) VALUES
(1, 1, 1, 1, NOW()),
(2, 1, 3, 1, NOW()),
(3, 2, 2, 1, NOW()),
(4, 2, 6, 1, NOW()),
(5, 1, 5, 1, NOW())
ON DUPLICATE KEY UPDATE fecha_asignacion = VALUES(fecha_asignacion);

-- Tabla matricula
CREATE TABLE IF NOT EXISTS matricula (
  id_matricula INT AUTO_INCREMENT PRIMARY KEY,
  id_alumno INT NOT NULL,
  id_seccion INT NOT NULL,
  fecha_matricula DATE,
  estado TINYINT(1) DEFAULT 1,
  FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno),
  FOREIGN KEY (id_seccion) REFERENCES seccion(id_seccion)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO matricula (id_matricula, id_alumno, id_seccion, fecha_matricula, estado) VALUES
(1, 1, 1, '2026-03-01', 1),
(2, 2, 1, '2026-03-02', 1),
(3, 1, 2, '2026-08-01', 1),
(4, 2, 3, '2026-08-02', 1)
ON DUPLICATE KEY UPDATE fecha_matricula = VALUES(fecha_matricula);

-- Tabla nota_curso
CREATE TABLE IF NOT EXISTS nota_curso (
  id_nota INT AUTO_INCREMENT PRIMARY KEY,
  id_curso INT NOT NULL,
  id_alumno INT NOT NULL,
  nombre_evaluacion VARCHAR(100),
  calificacion DECIMAL(5,2),
  ponderacion DECIMAL(5,2),
  fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_curso) REFERENCES curso(id_curso),
  FOREIGN KEY (id_alumno) REFERENCES alumno(id_alumno)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO nota_curso (id_nota, id_curso, id_alumno, nombre_evaluacion, calificacion, ponderacion, fecha_registro) VALUES
(1, 1, 1, 'Examen Parcial', 15.50, 0.30, NOW()),
(2, 2, 2, 'Proyecto 1', 18.00, 0.40, NOW()),
(3, 3, 1, 'Quiz 1', 14.00, 0.10, NOW()),
(4, 4, 1, 'Tarea 1', 16.00, 0.15, NOW()),
(5, 5, 1, 'Proyecto BD', 17.50, 0.40, NOW()),
(6, 6, 2, 'Laboratorio 1', 18.00, 0.20, NOW())
ON DUPLICATE KEY UPDATE calificacion = VALUES(calificacion), ponderacion = VALUES(ponderacion);

