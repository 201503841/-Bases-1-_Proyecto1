use BD1_PROYECTO2


DROP TABLE ACTA
DROP TABLE NOTAS_ESTUDIANTE
DROP TABLE ASIGNACION_CURSO
DROP TABLE DESASIGNACION_CURSO
DROP TABLE HORARIO
DROP TABLE CURSO_HABILITADO
DROP TABLE ESTUDIANTE
DROP TABLE CURSO
DROP TABLE CARRERA
drop table DOCENTE
drop table historial


-----------------SCRIPT BD------------------------------
CREATE TABLE CARRERA
(
id_carrera  int IDENTITY(0,1) PRIMARY KEY,
nombre varchar(75)
)

CREATE TABLE DOCENTE
(
siif int NOT NULL PRIMARY KEY,
nombre varchar(75),
apellido varchar(75),
nacimiento datetime,
correo varchar(200),
telefono int,
direccion varchar(200),
dpi float,
fecha_inicial datetime
);



CREATE TABLE ESTUDIANTE 
(
carnet int NOT NULL PRIMARY KEY,
nombre varchar(100),
apellido varchar(100),
fecha_nacimiento datetime,
correo varchar(200),
telefono int,
direccion varchar(200),
dpi float,
creditos int,
fecha_hora datetime,
id_carrera int FOREIGN KEY REFERENCES CARRERA(id_carrera)
);


CREATE TABLE CURSO 
(
id_curso int NOT NULL PRIMARY KEY,
nombre varchar(75),
creditos_necesarios int,
creditos_otorga int,
obligatorio int ,
id_carrera int FOREIGN KEY REFERENCES CARRERA(id_carrera),

CONSTRAINT CHK_CURSO_creditos_necesarios CHECK (creditos_necesarios >=0),
CONSTRAINT CHK_CURSO_creditos_otorga CHECK (creditos_otorga >=0),
CONSTRAINT CHK_CURSO_obligatorio CHECK (obligatorio IN (0,1))
);

---------------REVISAR DESASIGNADOS----------------

CREATE TABLE CURSO_HABILITADO
(
id_habilitado int IDENTITY(1,1) PRIMARY KEY,
id_curso int FOREIGN KEY REFERENCES CURSO(id_curso),
ciclo varchar(2),
siif int FOREIGN KEY REFERENCES DOCENTE(siif),
cupo int,
seccion varchar(1),
año int,
asignados int DEFAULT 0,

CONSTRAINT CHK_CURSO_HABILITADO_cupo CHECK (cupo >=0),
CONSTRAINT CHK_CURSO_HABILITADO_seccion CHECK (seccion LIKE '[A-Z]')

);


CREATE TABLE HORARIO
(
id_horario int IDENTITY(1,1) PRIMARY KEY,
id_habilitado int FOREIGN KEY REFERENCES CURSO_HABILITADO(id_habilitado),
dia int,
horario varchar(11),

CONSTRAINT CHK_HORARIO_dia CHECK(dia like '[1-7]')

);


CREATE TABLE ASIGNACION_CURSO
(
id_asinacion_curso int IDENTITY(1,1) PRIMARY KEY,
id_habilitado int FOREIGN KEY REFERENCES CURSO_HABILITADO(id_habilitado),
carnet int FOREIGN KEY REFERENCES ESTUDIANTE(carnet)
);


CREATE TABLE DESASIGNACION_CURSO
(
id_desasignacion_curso int IDENTITY(1,1) PRIMARY KEY,
id_habilitado int FOREIGN KEY REFERENCES CURSO_HABILITADO(id_habilitado),
carnet int FOREIGN KEY REFERENCES ESTUDIANTE(carnet)
);

CREATE TABLE NOTAS_ESTUDIANTE 
(
id_notas int IDENTITY(1,1) PRIMARY KEY,
id_habilitado int FOREIGN KEY REFERENCES CURSO_HABILITADO(id_habilitado),
carnet int FOREIGN KEY REFERENCES ESTUDIANTE(carnet),
nota float
);

CREATE TABLE ACTA
(
id_acta int IDENTITY(1,1) PRIMARY KEY,
id_habilitado int FOREIGN KEY REFERENCES CURSO_HABILITADO(id_habilitado),
fecha_hora datetime
);


CREATE TABLE HISTORIAL
(
id_historial int IDENTITY(1,1) PRIMARY KEY,
fecha datetime,
descripcion varchar(1000),
tipo varchar(50)
);



SELECT * FROM HISTORIAL