use BD1_PROYECTO2


------------------FUNCIONES-------------------------

----------------VALIDAR LETRAS-----------------------
GO
CREATE FUNCTION ValidarLetras(@cadena varchar(500))
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar solo letras 
	IF (@cadena LIKE '%[^a-zA-Z ]%') 
	BEGIN
	---------numeros
		SET @valido=0
	END
	ELSE
	BEGIN
	---------letras
		SET @valido=1
	END
	RETURN @valido
END
GO

SELECT dbo.ValidarLetras('Hola bebe')


----------------VALIDACION CURSO_EXISTENTE---------
GO
CREATE FUNCTION Carrera_Existente(@cadena varchar(500))
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar solo letras 

	IF EXISTS (SELECT id_carrera FROM CARRERA WHERE nombre = @cadena)
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO


SELECT dbo.Carrera_Existente('Are0aComun')



------------------VALIDAR CORREO--------------------
GO
CREATE FUNCTION Validar_correo(@cadena varchar(500))
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar correo
	IF (@cadena  LIKE '%[A-Z0-9][@][A-Z0-9]%[.][A-Z0-9]%') 
	BEGIN
		SET @valido=1
	END
	ELSE
	BEGIN
		SET @valido=0
	END
	RETURN @valido
END
GO


SELECT dbo.Validar_correo('kevingerrra!gmail.com')




----------------VALIDACION DOCENTE_EXISTENTE---------
GO
CREATE FUNCTION Docente_existente(@cadena int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar que no exista el id

	IF EXISTS (SELECT nombre FROM DOCENTE WHERE siif = @cadena)
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO


SELECT dbo.Docente_existente(123456789)


----------------VALIDACION CURSO_EXISTENTE ---------
GO
CREATE FUNCTION Curso_existente(@cadena int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar que no exista el id

	IF EXISTS (SELECT nombre FROM CURSO WHERE id_curso = @cadena)
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO

----------------VALIDACION SECCION_EXISTENTE ---------
GO
CREATE FUNCTION Seccion_existente(@cadena varchar(1),@id_curso int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar que no exista el id

	IF EXISTS (SELECT id_habilitado FROM CURSO_HABILITADO WHERE seccion = @cadena AND id_curso=@id_curso)
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO




----------------VALIDACION CURSO HABILITADO ---------
GO
CREATE FUNCTION Validar_CursoHabilitado(@cadena int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar que no exista el id

	IF EXISTS (SELECT seccion FROM CURSO_HABILITADO WHERE id_habilitado = @cadena)
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO

SELECT dbo.Validar_CursoHabilitado(56)


----------------VALIDACION EXISTENCIA DE LA ASIGNACION DEL ESTUDIANTE---------
GO
CREATE FUNCTION Validar_AsignacionEstudiante(@carnet int,@id_habilitado int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;


	IF EXISTS (SELECT 1 FROM ASIGNACION_CURSO WHERE id_habilitado = @id_habilitado AND carnet=@carnet)
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO

SELECT dbo.Validar_CursoHabilitado(56)



----------------VALIDACION EXISTENCIA DEL CARNET---------
GO
CREATE FUNCTION Validar_Carnet(@carnet int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	-------validar que no exista el id

	IF EXISTS (SELECT 1 FROM ESTUDIANTE WHERE carnet = @carnet )---SI EXISTE EL CARNET
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO

select dbo.Validar_Carnet(201403841)

---------------------------VALIDACION DE CREDITOS-------------------------------
GO
CREATE FUNCTION Validar_creditos(@carnet int, @id_habilitado int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	DECLARE @creditos_estudiante int;
	DECLARE @creditos_necesarios int;

    SELECT @creditos_estudiante = creditos FROM ESTUDIANTE WHERE carnet=@carnet

	SELECT @creditos_necesarios =  c.creditos_necesarios FROM CURSO_HABILITADO as h
	INNER JOIN CURSO as c on c.id_curso= h.id_curso 
	WHERE h.id_habilitado=@id_habilitado

	IF (@creditos_estudiante>= @creditos_necesarios)

	BEGIN
	---------CREDITOS NECESARIOS
		SET @valido=1
	END
	ELSE
	BEGIN
	-------- NO TIENE CREDITOS NECESARIOS
		SET @valido=0
	END
	RETURN @valido
END
GO

select dbo.Validar_creditos(201503841,1)

--------------------------VALIDAR SECCION------------------
GO
CREATE FUNCTION ValidarSeccion(@carnet int, @id_habilitado int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	DECLARE @creditos_estudiante int;
	DECLARE @creditos_necesarios int;

    SELECT @creditos_estudiante = creditos FROM ESTUDIANTE WHERE carnet=@carnet

	SELECT @creditos_necesarios =  c.creditos_necesarios FROM CURSO_HABILITADO as h
	INNER JOIN CURSO as c on c.id_curso= h.id_curso 
	WHERE h.id_habilitado=@id_habilitado

	IF (@creditos_estudiante>= @creditos_necesarios)

	BEGIN
	---------CREDITOS NECESARIOS
		SET @valido=1
	END
	ELSE
	BEGIN
	-------- NO TIENE CREDITOS NECESARIOS
		SET @valido=0
	END
	RETURN @valido
END
GO




---------------------VALIDAR CARRERA-----------------
GO
CREATE FUNCTION Validar_Carrera(@carnet int, @id_habilitado int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	DECLARE @carrera_curso int;
	DECLARE @carrera_estudiante int;

    SELECT @carrera_estudiante = id_carrera FROM ESTUDIANTE WHERE carnet=@carnet

	SELECT @carrera_curso =  c.id_carrera FROM CURSO_HABILITADO as h
	INNER JOIN CURSO as c on c.id_curso= h.id_curso 
	WHERE h.id_habilitado=@id_habilitado

	IF (@carrera_estudiante=@carrera_curso) or (@carrera_curso=0)

	BEGIN
	---------MISMA CARRERA
		SET @valido=1
	END
	ELSE
	BEGIN
	--------DIFERENTE CARRERA
		SET @valido=0
	END
	RETURN @valido
END
GO


select dbo.Validar_Carrera(201503841,2)

---------------------VALIDAR CUPO-----------------
GO
CREATE FUNCTION Validar_Cupo(@id_habilitado int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	DECLARE @cupo int;
	
    SELECT @cupo = cupo FROM CURSO_HABILITADO WHERE id_habilitado=@id_habilitado

	IF (@cupo > 0) 
	BEGIN
	---------EXISTE CUPO
		SET @valido=1
	END
	ELSE
	BEGIN
	--------SIN CUPO
		SET @valido=0
	END
	RETURN @valido
END
GO


---------------------VALIDAR ESTUDIANTE ASIGNADO-----------------
GO
CREATE FUNCTION Validar_EstarAsignado(@carnet int , @id_habilitado int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;


	IF EXISTS (SELECT 1 FROM ASIGNACION_CURSO WHERE id_habilitado=@id_habilitado AND carnet = @carnet )---SI EXISTE EL CARNET en el curso habilitado
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO

select dbo.Validar_EstarAsignado(201503841,2)


---------------------VALIDAR TOTAL DE NOTAS -----------------
GO
CREATE FUNCTION ValidarNotasIngresadas(@id_habilitado int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	DECLARE @cant_Estudiantes int;
	DECLARE @cant_Notas int;

	SELECT @cant_Estudiantes = COUNT(c.id_habilitado) FROM ASIGNACION_CURSO as a
	INNER JOIN CURSO_HABILITADO as  c on c.id_habilitado=a.id_habilitado
	INNER JOIN CURSO as cursito ON cursito.id_curso=c.id_curso
	WHERE c.id_habilitado=@id_habilitado

	SELECT @cant_Notas = COUNT(id_habilitado) FROM NOTAS_ESTUDIANTE WHERE id_habilitado=@id_habilitado



	IF (@cant_Estudiantes=@cant_Notas) -----si el numero de estudiantes es el mismo que el numero de notas ingresadas
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido
END
GO


SELECT.dbo.ValidarNotasIngresadas(2)





---------------------VALIDAR SI EXISTE ID CARREAR -----------------
GO
CREATE FUNCTION Validar_IdCarrera(@id_carrera int)
RETURNS BIT
AS 
BEGIN
	DECLARE @valido BIT;
	
	IF EXISTS (SELECT 1 FROM CARRERA WHERE id_carrera=@id_carrera)---SI EXISTE el codigo de carrera
	BEGIN
	---------existe
		SET @valido=1
	END
	ELSE
	BEGIN
	---------no existe
		SET @valido=0
	END
	RETURN @valido

END
GO


SELECT.dbo.Validar_IdCarrera(10)



---------------PROCEDIMIENTOS-------------------------

---------------------CREAR CARRERA-----------------
GO
CREATE PROCEDURE Crear_Carrera(@nombre as varchar(70))
AS
BEGIN
	
	if(dbo.ValidarLetras(@nombre)=1) ----solo letras
	BEGIN
		if(dbo.Carrera_Existente(@nombre)=0)----si no existe
		BEGIN
			INSERT INTO CARRERA (nombre) 
				VALUES (@nombre)
		END
		ELSE
		BEGIN
			SELECT 'YA EXISTE LA CARRERA INGRESADA' as ERROR;
		END
	END
	ELSE
	BEGIN
	SELECT 'EXISTE UN CARACTER QUE NO ES LETRA' as ERROR;
	END
END 
GO


select * from CARRERA
drop table CARRERA


---------------------REGISTRAR ESTUDIANTE -----------------
GO
CREATE PROCEDURE Registrar_Estudiante(
@carnet int,@nombre varchar(100),@apellido varchar(100),@fecha_nacimiento varchar(30),@correo varchar(200),@telefono int, @direccion varchar(200),@dpi float, @id_carrera int)
AS
BEGIN
	set dateformat dmy;
	if(dbo.Validar_correo(@correo)=1)
	BEGIN
	
		INSERT INTO ESTUDIANTE (carnet,nombre,apellido,fecha_nacimiento,correo,telefono,direccion,dpi,creditos,fecha_hora,id_carrera) 
				VALUES (@carnet,@nombre,@apellido,convert(datetime,@fecha_nacimiento),@correo,@telefono,@direccion,@dpi,0,GETDATE(),@id_carrera)
	END	
	ELSE
	BEGIN
	SELECT 'CORREO NO VALIDO' as ERROR;
	END
END 
GO

---------------------REGISTRAR DOCENTE---------------------------
GO
CREATE PROCEDURE Registrar_Docente(@siif int, @nombre varchar(75),@apellido varchar(75), @nacimiento varchar(30),@correo varchar(200), @telefono int, @direccion varchar(200),@dpi float)
AS
BEGIN
	set dateformat dmy;
	if(dbo.Docente_existente(@siif)=0)----si no existe
	BEGIN
		if(dbo.Validar_correo(@correo)=1)----si es valido
		BEGIN
			INSERT INTO DOCENTE(siif,nombre,apellido,nacimiento,correo,telefono,direccion,dpi,fecha_inicial) 
				VALUES (@siif,@nombre,@apellido,convert(datetime,@nacimiento),@correo,@telefono,@direccion,@dpi,GETDATE())
		END
		ELSE
		BEGIN
			SELECT 'CORREO NO VALIDO' as ERROR;
		END
	END
	ELSE
	BEGIN
	SELECT 'YA EXISTE EN LA BD EL DOCENTE INGRESADO' as ERROR;
	END
END 
GO


--------------------- CREAR CURSO---------------------------
GO
CREATE PROCEDURE Crear_Curso(@id_curso int,@nombre varchar(15), @creditos_necesarios int,@creditos_otroga int, @obligatorio int,@id_carrera int)
AS
BEGIN
	if(dbo.Curso_existente(@id_curso)=0)----si no existe
	BEGIN
		INSERT INTO CURSO(id_curso,nombre,creditos_necesarios,creditos_otorga,obligatorio,id_carrera) 
			VALUES (@id_curso,@nombre,@creditos_necesarios,@creditos_otroga,@obligatorio,@id_carrera)
	END
	ELSE
	BEGIN
	SELECT 'El CURSO INGRESADO YA SE ENCUENTRA EN LA BASE DE DATOS' as ERROR;
	END
END 
GO




--------------------- HABILITAR CURSO PARA ASIGNACION ---------------------------
GO
CREATE PROCEDURE Habilitar_Curso(@id_curso int, @ciclo varchar(2), @siif int, @cupo int, @seccion varchar(1))
AS
BEGIN
	
	if(dbo.Seccion_existente(@seccion, @id_curso)=0)----si no existe
	BEGIN
		if @ciclo IN ('1S','2S','VJ','VD')
		BEGIN
			
			INSERT INTO CURSO_HABILITADO(id_curso,ciclo,siif,cupo,seccion,año,asignados) 
				VALUES (@id_curso , @ciclo, @siif , @cupo , @seccion,2022,0)
		END
		ELSE
		BEGIN
			SELECT 'CICLO INVALIDO'
		END
	END
	ELSE
	BEGIN
		SELECT 'LA SECCION INGRESADA YA EXISTE' as ERROR;
	END
END 
GO


--------------------- AGREGAR UN HORARIO DE CURSO HABILITADO ---------------------------
GO
CREATE PROCEDURE Agregar_Horario(@id_habilitado int, @dia int,@horario varchar(9))
AS
BEGIN
	
	if(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		INSERT INTO HORARIO(id_habilitado,dia,horario) 
			VALUES (@id_habilitado, @dia, @horario)
	
	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' as ERROR;
	END
END 
GO


--------------------- ASIGNACION DE CURSOS ---------------------------
GO
CREATE PROCEDURE Asignando_curso(@id_habilitado int, @carnet int)
AS
BEGIN
	
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		IF (dbo.Validar_Carnet(@carnet)=1) --- si existe carnet 
			BEGIN 
				IF (dbo.Validar_creditos(@carnet,@id_habilitado)=1)--- si cumple con creditos necesarios
				BEGIN
					IF(dbo.Validar_Carrera(@carnet,@id_habilitado)=1) -- curso de la carrera
					BEGIN 
						IF(dbo.Validar_Cupo(@id_habilitado)=1) ----si hay cupo
						BEGIN
							INSERT INTO ASIGNACION_CURSO(id_habilitado,carnet) 
								VALUES (@id_habilitado,@carnet)
							
							UPDATE CURSO_HABILITADO SET cupo = cupo-1 WHERE id_habilitado=@id_habilitado
						END
						ELSE
						BEGIN 
							SELECT 'YA NO EXISTE CUPO EN LA SECCION SELECIONADA' as ERROR;
						END
					END 
					ELSE 
					BEGIN 
						SELECT 'NO SE PUEDE ASIGNAR A UN CURSO QUE NO PERTENECE A SU CARRERA' AS ERROR;
					END
				END 
				ELSE
				BEGIN 
					SELECT 'NO CUMPLE CON LOS CREDITOS NECESARIOS' AS ERROR;
				END
		END
		ELSE 
		BEGIN 
			SELECT 'EL CARNET NO EXISTE' AS ERROR ;
		END
	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END
END 
GO



--------------------- ASIGNACION DE CURSOS ---------------------------
GO
CREATE PROCEDURE Asignando_curso(@id_habilitado int, @carnet int)
AS
BEGIN
	
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		IF (dbo.Validar_Carnet(@carnet)=1) --- si existe carnet 
			BEGIN 
				IF (dbo.Validar_creditos(@carnet,@id_habilitado)=1)--- si cumple con creditos necesarios
				BEGIN
					IF(dbo.Validar_Carrera(@carnet,@id_habilitado)=1) -- curso de la carrera
					BEGIN 
						IF(dbo.Validar_Cupo(@id_habilitado)=1) ----si hay cupo
						BEGIN
							INSERT INTO ASIGNACION_CURSO(id_habilitado,carnet) 
								VALUES (@id_habilitado,@carnet)
							
							UPDATE CURSO_HABILITADO SET cupo = cupo-1 , asignados=asignados+1 WHERE id_habilitado=@id_habilitado

						END
						ELSE
						BEGIN 
							SELECT 'YA NO EXISTE CUPO EN LA SECCION SELECIONADA' as ERROR;
						END
					END 
					ELSE 
					BEGIN 
						SELECT 'NO SE PUEDE ASIGNAR A UN CURSO QUE NO PERTENECE A SU CARRERA' AS ERROR;
					END
				END 
				ELSE
				BEGIN 
					SELECT 'NO CUMPLE CON LOS CREDITOS NECESARIOS' AS ERROR;
				END
		END
		ELSE 
		BEGIN 
			SELECT 'EL CARNET NO EXISTE' AS ERROR ;
		END
	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END
END 
GO


--------------------- DESASIGNACION DE CURSOS ---------------------------
GO
CREATE PROCEDURE Quitando_curso(@id_habilitado int, @carnet int)
AS
BEGIN
	DECLARE @id_curso int;
	DECLARE @cupo int;
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		IF (dbo.Validar_Carnet(@carnet)=1) --- si existe carnet 
			BEGIN 
				IF(dbo.Validar_EstarAsignado(@carnet,@id_habilitado)=1)
				BEGIN

				    SELECT @id_curso =a.id_asinacion_curso FROM ASIGNACION_CURSO AS a
					INNER JOIN CURSO_HABILITADO c on c.id_habilitado=a.id_habilitado
					INNER JOIN CURSO as cursito on cursito.id_curso=c.id_curso
					WHERE a.carnet=@carnet and c.id_habilitado = @id_habilitado
					DELETE FROM ASIGNACION_CURSO WHERE id_asinacion_curso=@id_curso
					SELECT @cupo= cupo FROM CURSO_HABILITADO 
					WHERE id_habilitado=@id_habilitado


					UPDATE CURSO_HABILITADO SET cupo=(@cupo + 1), asignados=asignados-1  WHERE id_habilitado= @id_habilitado;

					INSERT INTO DESASIGNACION_CURSO(id_habilitado,carnet) values (@id_habilitado,@carnet)

				END
				ELSE 
				BEGIN 
					SELECT 'EL ESTUDIANTE NO SE ENCUENTRA ASIGNADO AL CURSO' AS ERROR;
				END
		END
		ELSE
		BEGIN
			SELECT 'EL CARNET INGRESADO NO EXISTE' AS ERROR;
		END
	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END
END 
GO






--------------------- INGRESAR NOTAS  ---------------------------
GO
CREATE PROCEDURE IngresarNota(@id_habilitado int, @carnet int, @nota float)
AS
BEGIN
	DECLARE @creditosNuevos int;
	DECLARE @creditosActuales int;
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		IF (dbo.Validar_Carnet(@carnet)=1) --- si existe carnet 
			BEGIN 
			IF(dbo.Validar_EstarAsignado(@carnet,@id_habilitado)=1)
				BEGIN

				INSERT INTO NOTAS_ESTUDIANTE (id_habilitado,carnet,nota) VALUES  (@id_habilitado,@carnet,round(@nota,0))

				IF (@nota>=61) -------SE AGREGAN LOS CREDITOS
				BEGIN 

					SELECT @creditosNuevos= cursito.creditos_otorga FROM ASIGNACION_CURSO as a
					INNER JOIN CURSO_HABILITADO as c ON c.id_habilitado=a.id_habilitado
					INNER JOIN CURSO as cursito ON cursito.id_curso=c.id_curso
					WHERE a.carnet=@carnet AND c.id_habilitado=@id_habilitado


					SELECT @creditosActuales = creditos FROM ESTUDIANTE WHERE carnet=@carnet

					UPDATE ESTUDIANTE SET creditos = (@creditosActuales+@creditosNuevos) WHERE carnet=@carnet
				END 
				ELSE
				BEGIN
					SELECT 'NOTA NO SATISFACTORIA, NO SE AGREGARON LOS CREDITOS' AS ATENCION;
				END
			END
			ELSE 
			BEGIN
				SELECT 'EL ESTUDIANTE NO SE ENCUENTRA ASIGNADO AL CURSO' AS ERROR;
			END
		END
		ELSE 
		BEGIN 
			SELECT 'EL CARNET NO EXISTE' AS ERROR ;
		END
	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END
END 
GO

--------------------- GENERAR ACTA ---------------------------
GO
CREATE PROCEDURE GenerarActa(@id_habilitado int)
AS
BEGIN
	
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		IF (dbo.ValidarNotasIngresadas(@id_habilitado)=1)
		BEGIN 

		INSERT INTO ACTA(id_habilitado,fecha_hora) values (@id_habilitado,SYSDATETIME())

		END 
		ELSE
		BEGIN 
			SELECT 'AUN EXISTEN ALUMNOS QUE NO TIENEN NOTA' AS ERROR;
		END
	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END
END 
GO



------------------------------CONSULTAS ----------------------
---------------------CONSULTA 1. CONSULTAR PENSUM--------------------
GO
CREATE PROCEDURE ConsultarPensum(@id_carrera int)
AS
BEGIN

	
	IF(dbo.Validar_IdCarrera(@id_carrera)=1)-----si existe
	BEGIN
		SELECT CURSO.id_curso as "Codigo del curso", CURSO.nombre as "Nombre del curso", "Obligatorio" = CASE WHEN CURSO.obligatorio =1 
																											  THEN 'Si'
																											  WHEN CURSO.obligatorio=0
																											  THEN 'No' END, CURSO.creditos_necesarios as "Creditos Necesarios" FROM CURSO
		INNER JOIN CARRERA ON CARRERA.id_carrera=CURSO.id_carrera
		WHERE CARRERA.id_carrera=0
		UNION
		SELECT CURSO.id_curso, CURSO.nombre,"Obligatorio" = CASE WHEN CURSO.obligatorio =1 
																											  THEN 'Si'
																											  WHEN CURSO.obligatorio=0
																											  THEN 'No' END, CURSO.creditos_necesarios FROM CURSO
		INNER JOIN CARRERA ON CARRERA.id_carrera=CURSO.id_carrera
		WHERE CARRERA.id_carrera=@id_carrera
	END
	ELSE
	BEGIN
		SELECT 'EL ID DE LA CARRERA INGRESADA NO EXISTE' AS ERROR;
	END

END 
GO

--------------CONSULTA 2. CONSULTAR ESTUDIANTE----------------------------

GO
CREATE PROCEDURE ConsultarEstudiante(@carnet int)
AS
BEGIN

	
	IF(dbo.Validar_Carnet(@carnet)=1)-----si existe
	BEGIN
		SELECT ESTUDIANTE.carnet as Carnet,  concat(ESTUDIANTE.nombre, ' ', ESTUDIANTE.apellido) as "Nombre Completo", ESTUDIANTE.fecha_nacimiento as "Fecha de nacimiento", ESTUDIANTE.correo as "Correo", ESTUDIANTE.telefono as Telefono, ESTUDIANTE.direccion as Direccion, ESTUDIANTE.dpi as Dpi, CARRERA.nombre as Carrera,ESTUDIANTE.creditos AS Creditos  FROM ESTUDIANTE
		INNER JOIN CARRERA ON CARRERA.id_carrera=ESTUDIANTE.id_carrera
		WHERE ESTUDIANTE.carnet=@carnet

	END
	ELSE
	BEGIN
		SELECT 'EL CARNET INGRESADO NO EXISTE' AS ERROR;
	END

END 
GO



--------------CONSULTA 3. CONSULTAR DOCENTE----------------------------

GO
CREATE PROCEDURE ConsultarDocente(@siif int)
AS
BEGIN

	
	IF(dbo.Docente_existente(@siif)=1)-----si existe
	BEGIN
		SELECT DOCENTE.siif as "Registro SIIF",  concat(DOCENTE.nombre, ' ', DOCENTE.apellido) as "Nombre Completo", DOCENTE.nacimiento as "Fecha de nacimiento", DOCENTE.correo as "Correo", DOCENTE.telefono as Telefono, DOCENTE.direccion as Direccion, DOCENTE.dpi as Dpi  FROM DOCENTE
		WHERE DOCENTE.siif=@siif

	END
	ELSE
	BEGIN
		SELECT 'EL CODIGO DOCENTE INGRESADO NO EXISTE' AS ERROR;
	END

END 
GO

----------------CONSULTA 4 . CONSULTAR ESTUDIANTES ASIGNADOS----------


GO
CREATE PROCEDURE ConsultarEstudiantesAsignados(@id_habilitado int)
AS
BEGIN

	
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		SELECT ASIGNACION_CURSO.carnet as "Carnet", concat(ESTUDIANTE.nombre, ' ', ESTUDIANTE.apellido) AS "Nombre Completo", ESTUDIANTE.creditos as "Creditos que posee" FROM ASIGNACION_CURSO 
		inner join CURSO_HABILITADO on CURSO_HABILITADO.id_habilitado=ASIGNACION_CURSO.id_habilitado
		inner join ESTUDIANTE ON ESTUDIANTE.carnet=ASIGNACION_CURSO.carnet
		INNER JOIN CURSO ON CURSO.id_curso = CURSO_HABILITADO.id_curso
		WHERE CURSO_HABILITADO.id_habilitado=@id_habilitado

	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END

END 
GO



----------------CONSULTA 5. CONSULTAR APROBACIONES ----------


GO
CREATE PROCEDURE ConsultarAprobaciones(@id_habilitado int)
AS
BEGIN

	
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN

		SELECT CURSO.id_curso as "Codigo de curso", ASIGNACION_CURSO.carnet AS Carnet, concat(ESTUDIANTE.nombre, ' ', ESTUDIANTE.apellido) as "Nombre Completo", "Aprobado/Desaprobado" = CASE WHEN NOTAS_ESTUDIANTE.nota>=61 
																																														  THEN 'APROBADO'
																																														  WHEN NOTAS_ESTUDIANTE.nota<61
																																														  THEN 'DESAPROBADO' END FROM ASIGNACION_CURSO 
		inner join CURSO_HABILITADO on CURSO_HABILITADO.id_habilitado=ASIGNACION_CURSO.id_habilitado
		INNER JOIN ESTUDIANTE ON ESTUDIANTE.carnet=ASIGNACION_CURSO.carnet
		INNER JOIN CURSO ON CURSO.id_curso=CURSO_HABILITADO.id_curso
		INNER JOIN NOTAS_ESTUDIANTE ON NOTAS_ESTUDIANTE.carnet=ESTUDIANTE.carnet
		WHERE NOTAS_ESTUDIANTE.id_habilitado=@id_habilitado and ASIGNACION_CURSO.id_habilitado=@id_habilitado

	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END

END 
GO


----------------CONSULTA 6. CONSULTAR ACTA ----------

GO
CREATE PROCEDURE ConsultarActa(@id_habilitado int)
AS
BEGIN

	
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN

		SELECT CURSO.id_curso as "Codigo de curso", CURSO_HABILITADO.seccion AS "Sección", "Ciclo" = CASE WHEN CURSO_HABILITADO.ciclo>='1S' 
																										 THEN 'PRIMER SEMESTRE'
																										 WHEN CURSO_HABILITADO.ciclo = '2S'
																										 THEN 'SEGUNDO SEMESTRE'
																										 WHEN CURSO_HABILITADO.ciclo = 'VJ'
																										 THEN 'VACACIONES DE JUNIO'
																										 WHEN CURSO_HABILITADO.ciclo = 'VD'
																										 THEN 'VACACIONES DE DICIEMBRE'END, CURSO_HABILITADO.año as "Año", CURSO_HABILITADO.asignados as "Cantidad de estudiantes que llevaron el curso", ACTA.fecha_hora as "Fecha y hora de generado" FROM CURSO_HABILITADO 
		INNER JOIN CURSO ON CURSO.id_curso=CURSO_HABILITADO.id_curso
		INNER JOIN ACTA ON ACTA.id_habilitado = CURSO_HABILITADO.id_habilitado 
		where ACTA.id_habilitado=@id_habilitado 

	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END

END 
GO

----------------CONSULTA 7. TASA DE DESASIGNACION ----------

GO
CREATE PROCEDURE ConsultarTasa(@id_habilitado int, @seccion varchar(1))
AS
BEGIN

	
	IF(dbo.Validar_CursoHabilitado(@id_habilitado)=1)-----si existe
	BEGIN
		


		SELECT CURSO.id_curso as "Codigo de curso", CURSO_HABILITADO.seccion AS "Sección", "Ciclo" = CASE WHEN CURSO_HABILITADO.ciclo>='1S' 
																										 THEN 'PRIMER SEMESTRE'
																										 WHEN CURSO_HABILITADO.ciclo = '2S'
																										 THEN 'SEGUNDO SEMESTRE'
																										 WHEN CURSO_HABILITADO.ciclo = 'VJ'
																										 THEN 'VACACIONES DE JUNIO'
																										 WHEN CURSO_HABILITADO.ciclo = 'VD'
																										 THEN 'VACACIONES DE DICIEMBRE'END, CURSO_HABILITADO.año as "Año", CURSO_HABILITADO.asignados as "Cantidad de estudiantes que llevaron el curso", count(DESASIGNACION_CURSO.carnet) as "Cantidad de estudiantes que se desasignaron",((100*count(DESASIGNACION_CURSO.carnet))/CURSO_HABILITADO.cupo) as "Porcentaje de desasignacion" FROM CURSO_HABILITADO 
		INNER JOIN CURSO ON CURSO.id_curso=CURSO_HABILITADO.id_curso
		INNER JOIN DESASIGNACION_CURSO ON DESASIGNACION_CURSO.id_habilitado = CURSO_HABILITADO.id_habilitado 
		where DESASIGNACION_CURSO.id_habilitado=@id_habilitado 
		group by CURSO.id_curso, CURSO_HABILITADO.seccion,CURSO_HABILITADO.ciclo,CURSO_HABILITADO.año, CURSO_HABILITADO.asignados, CURSO_HABILITADO.cupo
		ORDER BY count(DESASIGNACION_CURSO.carnet)
		

	END
	ELSE
	BEGIN
		SELECT 'EL CURSO INGRESADO NO ESTA HABILITADO' AS ERROR;
	END

END 
GO



EXECUTE ConsultarTasa 2,'C'


-------------LLAMADAS A PROCEDIMIENTOS
EXECUTE Crear_Carrera 'AreaComun'
EXECUTE Crear_Carrera 'Sistemas'
EXECUTE Crear_Carrera 'Civil'
EXECUTE Crear_Carrera 'Industrial'
EXECUTE Crear_Carrera 'Ambiental'


EXECUTE Registrar_Estudiante 201503841,'Suseth','Godinez','29/07/1996','susethgg@gmail.com',54205719,'26 calle 9-11 fuentes del valle I',3000822740101,1
EXECUTE Registrar_Estudiante 201705896,'Aneli','Ramirez','27/07/1982','aneliVicente@gmail.com',42780956,'San Marcos',1254852871212,1
EXECUTE Registrar_Estudiante 201248967,'Carlos','Mendez','19/01/1975','carlosjjgg@gmail.com',55114044,'Zona 21 Guatemala',5888967540101,2
EXECUTE Registrar_Estudiante 200275789,'Josue','Palencia','25/12/1974','palenciajosue25@gmail.com',45958604,'Zona 12 Guatemala',1111444480101,2
EXECUTE Registrar_Estudiante 201964874,'Estuardo Daniel','Ventura','29/10/1978','V_estyardabuek@gmail.com',51858574,'Villa nueva',1515462890101,3
EXECUTE Registrar_Estudiante 202164578,'Daniel','Rivera','05/05/1995','rebecamal2185@gmail.com',53638975,'Boca del Monte',6254789210101,3
EXECUTE Registrar_Estudiante 201504581,'Lester','Patzan','11/05/1998','lesterlesterv2@gmail.com',55114542,'Zona 21 Guatemala',6254789210101,3
EXECUTE Registrar_Estudiante 201721456,'Esteban','Mendez','20/05/1996','estebaan_21@gmail.com',54215879,'Boca del Monte',6254789210101,3
EXECUTE Registrar_Estudiante 201657894,'Roberto','Bethancurt','18/05/1998','robertbetarh_87@gmail.com',58485848,'Amatitlan',6254789210101,4
EXECUTE Registrar_Estudiante 201945875,'Gabriela','Ortiz','13/05/2001','gabrielitalinda@gmail.com',51451263,'Villa nueva',6254789210101,4

EXECUTE Registrar_Docente 123456789,'Fernando','Morataya','15/03/1974','docente123@gmail.com',55533364,'lote 6 manza b villa hermosa I',2984852870101
EXECUTE Registrar_Docente 10528576,'Kevin Ismael','Guerra','15/07/1974','kevincito7@gmail.com',45689782,'San Miguel petapa', 1565548910101
EXECUTE Registrar_Docente 12586453,'Raquel','Jibes','15/03/1974','jibes29@gmail.com',45859623,'Guatemala',1523568970101
EXECUTE Registrar_Docente 4520006,'Sofia','Godinez','21/07/1980','ssofiaS26@gmail.com',52563587,'Guatemala',5246897850101
EXECUTE Registrar_Docente 78965431,'Lorena','Garcia','13/01/1985','loren_gg@gmail.com',51202051,'San Miguel Petapa zona 13',3025689751010


-----AREA COMUN---
EXECUTE Crear_curso 120,'Matematica 1',0,5,1,0 
EXECUTE Crear_Curso 017,'Social Humanistica',0,5,1,0
EXECUTE Crear_Curso 039,'Deportes 1',0,1,0,0
EXECUTE Crear_Curso 069,'Tecnica Complementaria',0,3,1,0
EXECUTE Crear_Curso 06,'Idioma Tecnico',0,2,0,0


-------SISTEMAS----
EXECUTE Crear_curso 774,'Bases 1',10,5,1,1 
EXECUTE Crear_curso 770,'IPC1',3,4,1,1 
EXECUTE Crear_curso 796,'Lenguajes',5,3,1,1 
EXECUTE Crear_curso 964,'Organizacion Computacional',5,3,1,1 
EXECUTE Crear_curso 777,'Compiladores 1',20,4,1,1 


--------CIVIL-----
EXECUTE Crear_curso 080,'Topografia 1',0,6,1,2 
EXECUTE Crear_curso 170,'Mecanica Analitica 1',0,5,1,2 
EXECUTE Crear_curso 478,'Petrologia',3,4,0,2 
EXECUTE Crear_curso 335,'Gestion de Desastres',3,3,1,2 
EXECUTE Crear_curso 300,'Resistencia de materiales 1',10,5,1,2 


--------INDUSTRIAL-------
EXECUTE Crear_curso 474,'Ingenieria Petrolera',10,3,0,3 
EXECUTE Crear_curso 022,'Psicologia Industrial',5,3,1,3 
EXECUTE Crear_curso 250,'Mecanica de Fluidos',5,6,1,3 
EXECUTE Crear_curso 660,'Mercadotecnia 1',15,3,1,3 
EXECUTE Crear_curso 634,'Ingenieria de Metodos',20,6,1,3 

--------AMBIENTAL-------
EXECUTE Crear_curso 027,'Biologia General',0,3,1,4 
EXECUTE Crear_curso 635,'Climatologia',3,3,1,4 
EXECUTE Crear_curso 075,'Autocad 2D',3,6,1,4
EXECUTE Crear_curso 196,'Calidad del aire',10,3,1,4 
EXECUTE Crear_curso 663,'Legisacion Amibental',5,3,1,4





EXECUTE Habilitar_Curso 774,'1S',123456789,110,A  ------id 1 bases
EXECUTE Habilitar_Curso 120,'VD',78965431,90,A   ------ id 2 mate
EXECUTE Habilitar_Curso 017,'VD',12586453,90,C   ------ id 3 Social humanistica
EXECUTE Habilitar_Curso 039,'1S',4520006,60,D   ------ id 4 Deportes
EXECUTE Habilitar_Curso 080,'VD',10528576,100,F   ------ id 5 tOPOLOGRAFIA 1   //CIVIL
EXECUTE Habilitar_Curso 635,'1S',12586453,95,E   ------ id 6 Climatologia 1   //AMBINTAL
EXECUTE Habilitar_Curso 250,'1S',10528576,90,A   ------ id 7 Mecanica de fluidos 1 //INDUSTRIAL




EXECUTE Agregar_Horario 2,1,'9:00-10:40' 
EXECUTE Agregar_Horario 2,2,'9:00-10:40'
EXECUTE Agregar_Horario 2,3,'9:00-10:40'
EXECUTE Agregar_Horario 2,5,'9:00-10:40'----agregar horario a habilitado 2 matematica


EXECUTE Agregar_Horario 4,1,'7:00-9:00' 
EXECUTE Agregar_Horario 4,5,'7:00-9:00'----agregar horario a habilitado 4 DEPORTES


EXECUTE Asignando_curso 2,201503841   ----asignando a matematica
EXECUTE Asignando_curso 2,201705896   
EXECUTE Asignando_curso 2,200275789   
EXECUTE Asignando_curso 2,201721456
EXECUTE Asignando_curso 2,201945875

EXECUTE Quitando_curso 2,201945875



-------------ingresando notas de mate 1
EXECUTE IngresarNota 2,201503841,75.6
EXECUTE IngresarNota 2,201705896,45.5
EXECUTE IngresarNota 2,200275789,62.7
EXECUTE IngresarNota 2,201721456,90.5

EXECUTE GenerarActa 2



EXECUTE Asignando_curso 2,201503841   ----asignando a matematica
EXECUTE Asignando_curso 2,201705896   
EXECUTE Asignando_curso 2,200275789   
EXECUTE Asignando_curso 2,201721456
EXECUTE Asignando_curso 2,201945875




-----------------------------REVISAR DATOS DE LAS TABLAS 
SELECT * FROM CARRERA
SELECT * FROM ESTUDIANTE
select * from DOCENTE
select * from CURSO
SELECT * FROM CURSO_HABILITADO
SELECT * FROM HORARIO
select * from ASIGNACION_CURSO
select * from DESASIGNACION_CURSO
SELECT * FROM NOTAS_ESTUDIANTE
SELECT * FROM HISTORIAL
SELECT * FROM ACTA




-----------------------------CONSULTAS 
EXECUTE ConsultarPensum 1
EXECUTE ConsultarEstudiante 201503841
EXECUTE ConsultarDocente 10528576
EXECUTE ConsultarEstudiantesAsignados 2
EXECUTE ConsultarAprobaciones 2
EXECUTE ConsultarActa 2
EXECUTE ConsultarTasa 2,'C'
