-- ----------------------
-- CREACIÓN BASE DE DATOS
-- ----------------------

-- Creamos la base de datos con CREATE DATABASE, y definimos que la manipularemos con USE
CREATE DATABASE db_genomica_grupo12;

USE db_genomica_grupo12;

-- Creamos la tabla "gen", que incluye información de los genes a nivel e secuencia y coordenada cromosómica
CREATE TABLE gen (
  id_gen VARCHAR(10) PRIMARY KEY,
  nombre_gen VARCHAR(10) NOT NULL,
  descripción_gen VARCHAR (100) NOT NULL,
  cromosoma_gen VARCHAR(10),
  inicio_gen INT NOT NULL,
  final_gen INT NOT NULL,
  hebra_gen CHAR(1),
  longitud INT,
  nucleotidos_sec TEXT NOT NULL,
  cds_sec TEXT NOT NULL,
  aa_sec TEXT NOT NULL,
-- Añadimos las restricciones especificadas: solo incluir secuencias de >= 10 y <=1000 nucleótidos/aminoácidos
  CHECK (CHAR_LENGTH(nucleotidos_sec) BETWEEN 10 AND 1000),
  CHECK (CHAR_LENGTH(cds_sec) BETWEEN 10 AND 1000),
  CHECK (CHAR_LENGTH(aa_sec) BETWEEN 10 AND 1000),
  CHECK (inicio_gen > 0),
  CHECK (final_gen >= inicio_gen),
  CHECK (hebra_gen IN ('+', '-'))
);

-- Creamos la tabla "features", donde se describen las coordenadas de las partes del gen (en este caso exones e intrones)
CREATE TABLE features (
  id_feature VARCHAR(20) PRIMARY KEY,
  id_gen VARCHAR(10) NOT NULL,
  nombre_gen VARCHAR(10),
  cromosoma_feature VARCHAR(10),
  inicio_feature INT NOT NULL,
  final_feature INT NOT NULL,
  hebra_feature CHAR(1),
  tipo_feature VARCHAR(10),
-- Añadimos "id_gen" de la tabla "gen" como una clave foránea
  CONSTRAINT fk_feature
  FOREIGN KEY (id_gen) REFERENCES gen(id_gen),
-- Añadimos restricciones
  CHECK (inicio_feature > 0),
  CHECK (final_feature >= inicio_feature),
  CHECK (hebra_feature IN ('+', '-'))-- ,
 );

-- Creamos la tabla "variantes", donde indicamos las mutaciones de variantes de cada gen
CREATE TABLE variantes (
  id_variante VARCHAR(15) PRIMARY KEY,
  id_gen VARCHAR(10) NOT NULL,
  posicion_var INT NOT NULL,
  tipo_mutacion VARCHAR(15),
  patogeneidad VARCHAR(15),
-- Nos aseguramos que el valor por defecto de los alelos es un '-' (un gap)
  alelo_ref CHAR(5) DEFAULT '-',
  alelo_mut CHAR(5) DEFAULT '-',
  CONSTRAINT fk_variantes
  FOREIGN KEY (id_gen) REFERENCES gen(id_gen),
  CHECK (posicion_var > 0)
);

-- Creamos la tabla "anotaciones", donde se describen las funciones de los genes
CREATE TABLE anotaciones (
  id_anotacion VARCHAR(10) PRIMARY KEY,
  id_gen VARCHAR(10) NOT NULL,
  nombre_gen VARCHAR(10) NOT NULL,
  tipo_anotacion VARCHAR(30),
  descripcion_anotacion VARCHAR(100),
  relación_genetica VARCHAR(100),
  CONSTRAINT fk_anotacion
  FOREIGN KEY (id_gen) REFERENCES gen(id_gen)
);

-- Creamos la tabla "estudios", donde se citan las publicaciones donde se describe cada variante
CREATE TABLE estudios (
  id_gen VARCHAR (10),
  id_variante VARCHAR(10),
  doi VARCHAR(8) PRIMARY KEY UNIQUE NOT NULL,
  titulo VARCHAR(100),
  autor VARCHAR(30),
  fecha_publicacion DATE,
  CONSTRAINT fk_estudio
  FOREIGN KEY (id_variante) REFERENCES variantes(id_variante),
  CONSTRAINT fk_estudio_gen
  FOREIGN KEY (id_gen) REFERENCES gen(id_gen),
-- Añadimos restricción para que el DOI tenga formato aaaa/111 (cuatro caracteres, caracter /, y tres números)
  CONSTRAINT doi_formato 
  CHECK (doi REGEXP '^[a-z]{4}/[0-9]{3}$')
);

-- ---------------------
-- INTRODUCCIÓN DE DATOS
-- ---------------------

-- Introducimos la información de dos genes en la tabla "gen"
START TRANSACTION;
USE `db_genomica_grupo12`;
INSERT INTO `db_genomica_grupo12`.`gen` (`id_gen`, `nombre_gen`, `descripción_gen`, `cromosoma_gen`, `inicio_gen`, `final_gen`, `hebra_gen`, `longitud`, `nucleotidos_sec`, `cds_sec`, `aa_sec`) 
  VALUES ('QWERTY', 
		  'tp53',
          'supresor tumoral',
          'Chr6',
          '123',
          '590',
          '+',
          '467',
          'ATGGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTtgaacccgtgttagccttggacctaaggtcctgacctagctgttacgttgacctaaggtcctgacctaCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTgcttaggacgtgacctaagtgctgacctaaggtcctgacgtagcttacgttgacctaaggtcctgaCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCTAA',
          'ATGGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCCAGACCTAA',
          'MAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQ*'
);
INSERT INTO `db_genomica_grupo12`.`gen` (`id_gen`, `nombre_Gen`, `descripción_gen`, `cromosoma_gen`, `inicio_gen`, `final_gen`, `hebra_gen`, `longitud`, `nucleotidos_sec`, `cds_sec`, `aa_sec`) 
  VALUES ('ASDFGH', 
		  'brca1',
          'regulador ciclo celular',
          'Chr9',
          '987',
          '1331',
          '-',
          '344',
          'ATGGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTtgaacccgtgttagccttggacctaaggtcctgacctagctgttacgttgacctaaggtcctgacctaagcttaggacgtgacctaagtgctgacctaaggtcctgacgtagcCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCAGACCCAGACCCAGACCTAA',
          'ATGGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTGAAGCTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCCTTTTCAGACCCAGACCCAGACCTAA',
          'MAEAEAEAEAEAEAEAEAEAEAEAEAEAEAEAPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFPFQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQTQ*'
);

COMMIT;

-- Introducimos las características genómicas de los dos genes en la tabla "features"
START TRANSACTION;
USE `db_genomica_grupo12`;
INSERT INTO `db_genomica_grupo12`.`features` (`id_feature`, `id_gen`, `nombre_gen`, `cromosoma_feature`, `inicio_feature`, `final_feature`, `hebra_feature`, `tipo_feature`) 
  VALUES ('QWERTYe1', 'QWERTY', 'tp53', 'Chr6', '123', '236', '+', 'exon'
  );
INSERT INTO `db_genomica_grupo12`.`features` (`id_feature`, `id_gen`, `nombre_gen`, `cromosoma_feature`, `inicio_feature`, `final_feature`, `hebra_feature`, `tipo_feature`) 
  VALUES ('QWERTYi1', 'QWERTY', 'tp53', 'Chr6', '237', '304', '+', 'intron'
  );
INSERT INTO `db_genomica_grupo12`.`features` (`id_feature`, `id_gen`, `nombre_gen`, `cromosoma_feature`, `inicio_feature`, `final_feature`, `hebra_feature`, `tipo_feature`) 
  VALUES ('QWERTYi2', 'QWERTY', 'tp53', 'Chr6', '407', '472', '+', 'intron'
  );
INSERT INTO `db_genomica_grupo12`.`features` (`id_feature`, `id_gen`, `nombre_gen`, `cromosoma_feature`, `inicio_feature`, `final_feature`, `hebra_feature`, `tipo_feature`) 
  VALUES ('QWERTYe3', 'QWERTY', 'tp53', 'Chr6', '473', '590', '+', 'exon'
  );
INSERT INTO `db_genomica_grupo12`.`features` (`id_feature`, `id_gen`, `nombre_gen`, `cromosoma_feature`, `inicio_feature`, `final_feature`, `hebra_feature`, `tipo_feature`) 
  VALUES ('ASDFGHe1', 'ASDFGH', 'brca1', 'Chr9', '987', '1101', '-', 'exon'
  );
INSERT INTO `db_genomica_grupo12`.`features` (`id_feature`, `id_gen`, `nombre_gen`, `cromosoma_feature`, `inicio_feature`, `final_feature`, `hebra_feature`, `tipo_feature`) 
  VALUES ('ASDFGHi1', 'ASDFGH', 'brca1', 'Chr9', '1102', '1215', '-', 'intron'
  );
INSERT INTO `db_genomica_grupo12`.`features` (`id_feature`, `id_gen`, `nombre_gen`, `cromosoma_feature`, `inicio_feature`, `final_feature`, `hebra_feature`, `tipo_feature`) 
  VALUES ('ASDFGHe2', 'ASDFGH', 'brca1', 'Chr9', '1216', '1331', '-', 'exon'
  );
  
COMMIT;

-- Introducimos las variantes de los dos genes en la tabla "variantes"
START TRANSACTION;
USE `db_genomica_grupo12`;
INSERT INTO `db_genomica_grupo12`.`variantes` (`id_variante`, `id_gen`, `posicion_var`, `tipo_mutacion`, `patogeneidad`, `alelo_ref`, `alelo_mut`) 
  VALUES ('qwerty_wt', 'QWERTY', '200', '-', 'Benigna', 'T', 'T'
 );
INSERT INTO `db_genomica_grupo12`.`variantes` (`id_variante`, `id_gen`, `posicion_var`, `tipo_mutacion`, `patogeneidad`, `alelo_ref`, `alelo_mut`) 
  VALUES ('qwerty25', 'QWERTY', '200', 'SNP', 'Benigna', 'T', 'C'
  );
INSERT INTO `db_genomica_grupo12`.`variantes` (`id_variante`, `id_gen`, `posicion_var`, `tipo_mutacion`, `patogeneidad`, `alelo_ref`, `alelo_mut`) 
  VALUES ('qwerty18', 'QWERTY', '200', 'SNP', 'Patógena', 'T', 'A'
  );
INSERT INTO `db_genomica_grupo12`.`variantes` (`id_variante`, `id_gen`, `posicion_var`, `tipo_mutacion`, `patogeneidad`, `alelo_ref`, `alelo_mut`) 
  VALUES ('asdfgh_wt', 'ASDFGH', '102', '-', 'Benigna', 'G', 'G'
  );
INSERT INTO `db_genomica_grupo12`.`variantes` (`id_variante`, `id_gen`, `posicion_var`, `tipo_mutacion`, `patogeneidad`, `alelo_ref`, `alelo_mut`) 
  VALUES ('asdfgh09', 'ASDFGH', '102', 'delecion', 'Benigna', 'G', '-'
  );
INSERT INTO `db_genomica_grupo12`.`variantes` (`id_variante`, `id_gen`, `posicion_var`, `tipo_mutacion`, `patogeneidad`, `alelo_ref`, `alelo_mut`) 
  VALUES ('asdfgh10', 'ASDFGH', '102', 'SNP', 'Patógena', 'G', 'A'
  );

COMMIT;

-- Introducimos las anotaciones de los dos genes en la tabla "anotaciones"
START TRANSACTION;
USE `db_genomica_grupo12`;
INSERT INTO `db_genomica_grupo12`.`anotaciones` (`id_anotacion`, `id_gen`, `nombre_gen`, `tipo_anotacion`, `descripcion_anotacion`) 
  VALUES ('BP01', 'QWERTY', 'tp53', 'Crecimiento celular', 'funcional'
  );
INSERT INTO `db_genomica_grupo12`.`anotaciones` (`id_anotacion`, `id_gen`, `nombre_gen`, `tipo_anotacion`, `descripcion_anotacion`) 
  VALUES ('BP02', 'QWERTY', 'tp53', 'Cancer', 'clinica'
  );
INSERT INTO `db_genomica_grupo12`.`anotaciones` (`id_anotacion`, `id_gen`, `nombre_gen`, `tipo_anotacion`, `descripcion_anotacion`) 
  VALUES ('BP03', 'ASDFGH', 'brca1', 'Ciclo celular', 'funcional'
  );
INSERT INTO `db_genomica_grupo12`.`anotaciones` (`id_anotacion`, `id_gen`, `nombre_gen`, `tipo_anotacion`, `descripcion_anotacion`) 
  VALUES ('BP04', 'ASDFGH', 'brca1', 'Cancer', 'clinica'
  );

COMMIT;

-- Introducimos las publicaciones de las variantes descritas en la tabla "estudios"
START TRANSACTION;
USE `db_genomica_grupo12`;
INSERT INTO `db_genomica_grupo12`.`estudios` (`id_gen`, `id_variante`, `doi`, `titulo`, `autor`, `fecha_publicacion`) 
  VALUES ('QWERTY', 'qwerty25', 'aaaa/111', 'Lorem ipsum dolor sit amet', 'Darwin, Charles', '1999-01-01'
  );
INSERT INTO `db_genomica_grupo12`.`estudios` (`id_gen`, `id_variante`, `doi`, `titulo`, `autor`, `fecha_publicacion`) 
  VALUES ('QWERTY', 'qwerty18', 'bbbb/222', 'consectetur adipiscing elit', 'Mendel, Gregory', '2000-02-02'
  );
INSERT INTO `db_genomica_grupo12`.`estudios` (`id_gen`, `id_variante`, `doi`, `titulo`, `autor`, `fecha_publicacion`) 
  VALUES ('ASDFGH', 'asdfgh09', 'cccc/333', 'sed do eiusmod tempor incididunt', 'Franklin, Rosalin', '2001-03-03'
  );
-- En el siguiente ejemplo, dejamos fuera la introducción del dato id_variante, ya que el estudio esta solo relacionado con el gen y no esta asociado a ninguna variante
INSERT INTO `db_genomica_grupo12`.`estudios` (`id_gen`, `doi`, `titulo`, `autor`, `fecha_publicacion`) 
  VALUES ('ASDFGH', 'dddd/444', 'ut labore et dolore magna aliqua', 'McClintock, Barbara', '2002-04-04'
  );

COMMIT;
