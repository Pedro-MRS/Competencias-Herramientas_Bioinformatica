-- Consultas Básicas (utilizando SELECT, FROM, DISTINCT y AS):
-- 1. Obtener todos los datos de la tabla «Mantenimiento».
SELECT *
FROM Mantenimiento;

-- 2. Extraer el identificador_S y Direccion_S de todas las sedes.
SELECT identificador_S, Direccion_S
FROM Sede;

-- 3. Listar los diferentes dueños de aseguradoras disponibles, renombrando la columna como DueñoAseguradora, y eliminando duplicados.
SELECT DISTINCT nombreDueño_A AS DueñoAseguradora 
FROM Aseguradoras;

-- Consultas fáciles (utilizando WHERE, operadores y ORDER BY):
-- 1. Obtener todos los vehículos de la marca BMW u Honda que pertenecen a la sede número 2.
SELECT * 
FROM Vehículo
WHERE (Marca_V = 'BMW' OR Marca_V = 'Honda') AND Sede_identificador_S = 2;

-- 2. Listar los nombres de los clientes cuyo nombre comienza por la letra L.
SELECT Nombre_C
FROM Cliente
WHERE Nombre_C LIKE 'L%';

-- 3. Seleccionar todos los mantenimientos realizados entre las fechas 2021-01-01 y 2021-12-31 que tienen una descripción asociada (no nula).
SELECT * 
FROM Mantenimiento 
WHERE Fecha_M BETWEEN '2021-01-01' AND '2021-12-31' AND Descripcion_M IS NOT NULL
ORDER BY Fecha_M DESC;


-- Consultas intermedias (utilizando GROUP BY, HAVING, JOIN y operaciones textuales):
-- 1. Contar el número de vehículos que tiene cada sede y mostrar solo aquellas sedes que tienen más de cinco vehículos.
SELECT Sede_identificador_S, COUNT(*) AS Total_Vehiculos
FROM Vehículo
GROUP BY Sede_identificador_S
HAVING COUNT(*) > 5;


-- 2. Obtener los nombres de los clientes que han alquilado el vehículo de matrícula IJKL789.
SELECT DISTINCT Cliente.Nombre_C, Cliente.DNI_C, Alquila.Vehículo_Matricula_V
FROM Cliente 
JOIN Alquila ON Cliente.DNI_C = Alquila.Cliente_DNI_C
WHERE Alquila.Vehículo_Matricula_V = 'IJKL789';

-- 3. Para cada cliente, obtener su nombre, seguido de su correo electrónico en mayúsculas y la longitud de este string.
SELECT Nombre_C,
    UPPER(Email_C) AS Email_Mayusculas, 
    LENGTH(Email_C) AS Longitud_Email
FROM Cliente;

-- Consultas difíciles (utilizando subconsultas, operadores de sets y operaciones matemáticas):
-- 1. Obtener los vehículos que han sido alquilados por el cliente que ha gastado más en alquileres. Recomendación, buscar sobre la clave LIMIT.
SELECT Cliente.Nombre_C, Vehículo.Matricula_V, Vehículo.Marca_V,  Vehículo.Modelo_V
FROM Cliente
JOIN Alquila ON Cliente.DNI_C = Alquila.Cliente_DNI_C
JOIN Vehículo ON Alquila.Vehículo_Matricula_V = Vehículo.Matricula_V
WHERE Cliente.DNI_C = (
    SELECT Cliente_DNI_C
    FROM Alquila
    GROUP BY Cliente_DNI_C
    ORDER BY SUM(Precio_CV) DESC
    LIMIT 1
);


-- 2. Listar todas las matrículas de vehículos que han sido alquilados y que han tenido mantenimientos.
SELECT Vehículo_Matricula_V AS Vehículos_alquilados_con_mantenimiento
FROM Alquila
INTERSECT
SELECT Vehículo_Matricula_V 
FROM Mantenimiento;

-- 3. Para cada vehículo, obtener la diferencia entre el precio más alto y el precio más bajo de alquiler.
SELECT Vehículo_Matricula_V,
    MAX(Precio_CV) AS Precio_Maximo,
    MIN(Precio_CV) AS Precio_Minimo,
    (MAX(Precio_CV) - MIN(Precio_CV)) AS Diferencia_Precio
FROM Alquila
GROUP BY Vehículo_Matricula_V
ORDER BY Diferencia_Precio DESC;


-- Consulta compleja (combinando todo):
-- 1. Obtener el nombre y teléfono en una única columna de los clientes que han alquilado vehículos de la marca BMW u Honda 
-- en la sede con el mayor número de vehículos. Además, mostrar su gasto total en alquileres, ordenados de mayor a menor gasto.
SELECT CONCAT(Cliente.Nombre_C, ' - ', Cliente.Telefono_C) AS Cliente_Teléfono,
    SUM(Alquila.Precio_CV) AS Gasto_Total, Sede.identificador_S AS Sede
FROM Cliente
JOIN Alquila ON Cliente.DNI_C = Alquila.Cliente_DNI_C
JOIN Vehículo ON Alquila.Vehículo_Matricula_V = Vehículo.Matricula_V
JOIN Sede ON Vehículo.Sede_identificador_S = Sede.identificador_S
WHERE Vehículo.Marca_V IN ('BMW', 'Honda')
  AND Vehículo.Sede_identificador_S = (
      SELECT Sede_identificador_S
      FROM Vehículo
      GROUP BY Sede_identificador_S
      ORDER BY COUNT(*) DESC
      LIMIT 1
  )
GROUP BY Cliente.DNI_C, Cliente.Nombre_C, Cliente.Telefono_C, Sede.identificador_S
ORDER BY Gasto_Total DESC;





