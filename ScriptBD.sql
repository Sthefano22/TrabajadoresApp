-- =============================================
-- SCRIPT DE BASE DE DATOS - SISTEMA DE TRABAJADORES
-- MYPER Software - Prueba Técnica .NET
-- Base de datos: TrabajadoresPrueba
-- =============================================

PRINT '=== INICIANDO CONFIGURACIÓN DE BASE DE DATOS ==='

-- 1. Crear base de datos si no existe
IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'TrabajadoresPrueba')
BEGIN
    CREATE DATABASE TrabajadoresPrueba;
    PRINT '✅ Base de datos "TrabajadoresPrueba" creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'ℹ️  Base de datos "TrabajadoresPrueba" ya existe.';
END
GO

USE TrabajadoresPrueba;
GO

-- 2. Crear tabla Trabajadores con estructura mejorada
IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='Trabajadores' AND xtype='U')
BEGIN
    CREATE TABLE Trabajadores (
        Id INT IDENTITY(1,1) PRIMARY KEY,
        Nombres NVARCHAR(100) NOT NULL,
        Apellidos NVARCHAR(100) NOT NULL,
        TipoDocumento NVARCHAR(20) NOT NULL,
        NumeroDocumento NVARCHAR(20) NOT NULL,
        Sexo NVARCHAR(10) NOT NULL CHECK (Sexo IN ('Masculino', 'Femenino')),
        FechaNacimiento DATE NOT NULL,
        Foto NVARCHAR(255) NULL,
        Direccion NVARCHAR(200) NULL,
        FechaCreacion DATETIME2 NOT NULL DEFAULT GETDATE(),
        FechaActualizacion DATETIME2 NULL,
        Estado BIT NOT NULL DEFAULT 1,
        
        -- Constraints para integridad de datos
        CONSTRAINT UQ_NumeroDocumento UNIQUE(NumeroDocumento),
        CONSTRAINT CHK_FechaNacimiento CHECK (FechaNacimiento <= GETDATE())
    );
    
    PRINT '✅ Tabla "Trabajadores" creada exitosamente.';
END
ELSE
BEGIN
    PRINT 'ℹ️  Tabla "Trabajadores" ya existe.';
END
GO

-- 3. Crear índices para mejorar performance
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Trabajadores_Sexo')
BEGIN
    CREATE INDEX IX_Trabajadores_Sexo ON Trabajadores(Sexo);
    PRINT '✅ Índice IX_Trabajadores_Sexo creado.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Trabajadores_FechaCreacion')
BEGIN
    CREATE INDEX IX_Trabajadores_FechaCreacion ON Trabajadores(FechaCreacion DESC);
    PRINT '✅ Índice IX_Trabajadores_FechaCreacion creado.';
END

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name = 'IX_Trabajadores_Documento')
BEGIN
    CREATE INDEX IX_Trabajadores_Documento ON Trabajadores(TipoDocumento, NumeroDocumento);
    PRINT '✅ Índice IX_Trabajadores_Documento creado.';
END

-- 4. Procedimiento almacenado para listar trabajadores (REQUERIMIENTO)
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_ListarTrabajadores')
    DROP PROCEDURE sp_ListarTrabajadores
GO

CREATE PROCEDURE sp_ListarTrabajadores
    @Sexo NVARCHAR(10) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @Sexo IS NULL OR @Sexo = ''
        SELECT * FROM Trabajadores WHERE Estado = 1 ORDER BY FechaCreacion DESC;
    ELSE
        SELECT * FROM Trabajadores WHERE Sexo = @Sexo AND Estado = 1 ORDER BY FechaCreacion DESC;
END
GO
PRINT '✅ Procedimiento almacenado "sp_ListarTrabajadores" creado.';

-- 5. Procedimiento para obtener estadísticas
IF EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'sp_ObtenerEstadisticas')
    DROP PROCEDURE sp_ObtenerEstadisticas
GO

CREATE PROCEDURE sp_ObtenerEstadisticas
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        COUNT(*) AS TotalTrabajadores,
        COUNT(CASE WHEN Sexo = 'Masculino' THEN 1 END) AS TotalMasculinos,
        COUNT(CASE WHEN Sexo = 'Femenino' THEN 1 END) AS TotalFemeninos,
        COUNT(CASE WHEN FechaCreacion >= CAST(GETDATE() AS DATE) THEN 1 END) AS RegistrosHoy,
        AVG(DATEDIFF(YEAR, FechaNacimiento, GETDATE())) AS EdadPromedio
    FROM Trabajadores 
    WHERE Estado = 1;
END
GO
PRINT '✅ Procedimiento almacenado "sp_ObtenerEstadisticas" creado.';

-- 6. Insertar datos de prueba profesionales
PRINT '📥 Insertando datos de prueba...';

INSERT INTO Trabajadores (Nombres, Apellidos, TipoDocumento, NumeroDocumento, Sexo, FechaNacimiento, Direccion) VALUES
('Juan Carlos', 'Pérez García', 'DNI', '70123456', 'Masculino', '1985-05-15', 'Av. Lima 123, Miraflores'),
('María Elena', 'López Martínez', 'DNI', '70234567', 'Femenino', '1990-08-22', 'Jr. Unión 456, Lima Centro'),
('Carlos Alberto', 'Rodríguez Silva', 'Carnet Extranjería', 'CE123456', 'Masculino', '1988-12-10', 'Av. Arequipa 789, San Isidro'),
('Ana Cecilia', 'Gómez Fernández', 'DNI', '70345678', 'Femenino', '1992-03-30', 'Calle Las Flores 321, La Molina'),
('Luis Miguel', 'Torres Díaz', 'DNI', '70456789', 'Masculino', '1987-07-18', 'Av. Javier Prado 654, San Borja'),
('Sofía Alejandra', 'Hernández Castro', 'DNI', '70567890', 'Femenino', '1995-11-25', 'Jr. Amazonas 987, Jesús María'),
('Roberto Antonio', 'Vargas Mendoza', 'Pasaporte', 'P1234567', 'Masculino', '1983-02-14', 'Av. La Marina 2345, San Miguel'),
('Laura Patricia', 'Ramírez Ortega', 'DNI', '70678901', 'Femenino', '1991-09-08', 'Calle Los Pinos 543, Barranco'),
('Pedro José', 'Castillo Rojas', 'DNI', '70789012', 'Masculino', '1989-06-12', 'Av. Brasil 876, Pueblo Libre'),
('Carmen Rosa', 'Díaz Mendoza', 'DNI', '70890123', 'Femenino', '1993-04-05', 'Jr. Carabaya 234, Cercado de Lima'),
('Jorge Luis', 'Medina Torres', 'DNI', '70901234', 'Masculino', '1986-09-15', 'Av. Tacna 567, Lince'),
('Elena Margarita', 'Castro Ruiz', 'DNI', '71012345', 'Femenino', '1994-12-20', 'Calle Moquegua 890, Magdalena'),
('Ricardo Andrés', 'Silva Mendoza', 'DNI', '71123456', 'Masculino', '1984-03-08', 'Av. Angamos 1234, Surco'),
('Patricia Alejandra', 'Ortega López', 'DNI', '71234567', 'Femenino', '1996-07-30', 'Jr. Ica 432, Breña'),
('Fernando José', 'Rojas Paredes', 'DNI', '71345678', 'Masculino', '1982-11-12', 'Av. Petit Thouars 765, Lince');

PRINT '✅ 15 registros de prueba insertados correctamente.';

-- 7. Crear vista para reportes
IF EXISTS (SELECT * FROM sys.views WHERE name = 'VW_Trabajadores_Completo')
    DROP VIEW VW_Trabajadores_Completo
GO

CREATE VIEW VW_Trabajadores_Completo AS
SELECT 
    Id,
    Nombres,
    Apellidos,
    TipoDocumento,
    NumeroDocumento,
    Sexo,
    FechaNacimiento,
    DATEDIFF(YEAR, FechaNacimiento, GETDATE()) AS Edad,
    Foto,
    Direccion,
    FechaCreacion,
    FechaActualizacion,
    Estado
FROM Trabajadores;
GO
PRINT '✅ Vista "VW_Trabajadores_Completo" creada.';

-- 8. Verificación final
PRINT '';
PRINT '=== VERIFICACIÓN FINAL ===';
SELECT 'Base de Datos' AS Item, 'TrabajadoresPrueba' AS Valor
UNION ALL
SELECT 'Tablas Creadas', CONVERT(VARCHAR, COUNT(*)) + ' tablas' FROM sys.tables WHERE name = 'Trabajadores'
UNION ALL
SELECT 'Procedimientos Almacenados', CONVERT(VARCHAR, COUNT(*)) + ' procedimientos' FROM sys.procedures WHERE name IN ('sp_ListarTrabajadores', 'sp_ObtenerEstadisticas')
UNION ALL
SELECT 'Vistas Creadas', CONVERT(VARCHAR, COUNT(*)) + ' vistas' FROM sys.views WHERE name = 'VW_Trabajadores_Completo'
UNION ALL
SELECT 'Registros de Prueba', CONVERT(VARCHAR, COUNT(*)) + ' trabajadores' FROM Trabajadores
UNION ALL
SELECT 'Índices Creados', CONVERT(VARCHAR, COUNT(*)) + ' índices' FROM sys.indexes WHERE object_id = OBJECT_ID('Trabajadores') AND name LIKE 'IX_%';

PRINT '';
PRINT '=== MUESTRA DE DATOS INSERTADOS ===';
SELECT TOP 5 
    Nombres + ' ' + Apellidos AS NombreCompleto,
    TipoDocumento + ' ' + NumeroDocumento AS Documento,
    Sexo,
    DATEDIFF(YEAR, FechaNacimiento, GETDATE()) AS Edad,
    Direccion
FROM Trabajadores 
ORDER BY Id;

PRINT '';
PRINT '🎉 CONFIGURACIÓN COMPLETADA EXITOSAMENTE!';
PRINT '📊 Base de datos lista para usar con el sistema de gestión de trabajadores.';
PRINT '';
PRINT '📋 RESUMEN:';
PRINT '   • 1 Base de datos creada';
PRINT '   • 1 Tabla principal';
PRINT '   • 2 Procedimientos almacenados';
PRINT '   • 1 Vista de reportes';
PRINT '   • 3 Índices optimizados';
PRINT '   • 15 Registros de prueba';
PRINT '';
PRINT '🚀 Ya puede ejecutar la aplicación web.';
GO