# "Repositorio de Recursos y Herramientas para Bioinformática"

Este repositorio reúne el conjunto de tecnologías, librerías, herramientas bioinformáticas, bases de datos y algoritmos de análisis de datos biológicos y químicos aplicados en el marco del Máster en Bioinformática.

### 📑 Tabla de Contenidos

Entornos de desarrollo integrado (IDEs).

Python.

Entorno de Programación R y Bioconductor.

Bases de datos genómicas, bioquímicas y herramientas No-Code.

Gestión de Bases de Datos Relacionales (MySQL).

Machine Learning / Deep Learning.

Entornos Bash / Linux, Perl y QIIME2.

Herramientas de análisis bioinformático.

Visualización y manipulación estructural de moléculas.

## 💻 Entornos de Desarrollo Integrados (IDEs)

***Jupyter Notebook / Google Colab***: Entornos interactivos basados en la nube y locales para prototipado rápido, ejecución por celdas y documentación reproducible de análisis de datos.

***VS Code / Spyder***: IDEs avanzados para Python con herramientas integradas de depuración, análisis estático de código y control de versiones.

***RStudio***: Entorno de desarrollo integrado especializado para el análisis estadístico y la generación de informes gráficos en R.

## 🐍 Python

### <u>Librerías Base del Sistema y cálculo</u>

***os / sys***: Gestión e interacción con el sistema operativo, manipulación de rutas de archivos y argumentos del sistema.

***math / random***: Funciones matemáticas de precisión y generación de números aleatorios/muestreo.

***re***: Manejo de expresiones regulares para búsqueda y formateo de patrones en secuencias o archivos de texto biológico.

### <u>Análisis y estructuración de datos</u>

***numpy***: Computación numérica de alto rendimiento basada en arreglos multidimensionales (arrays).

***pandas***: Estructuras de datos flexibles (DataFrames) para manipulación, filtrado, limpieza y transformación de datos tabulares.

### <u>Visualización gráfica</u>

***matplotlib / seaborn***: Creación de gráficos estáticos, vectoriales e interactivos (histogramas, dispersión, mapas de calor).

### <u>Obtención de datos químicos y biológicos via APIs</u>

***requests***: Módulo para la extracción web de datos a través de peticiones HTTP RESTful.

**APIs integradas:**

***UniProt REST API***: Acceso a datos funcionales y de secuencia de proteínas.

***Protein Data Bank (PDB)***: Descarga e inspección de estructuras 3D de macromoléculas.

***ChEMBL / PubChem / ChEBI***: Consultas de moléculas pequeñas, propiedades bioactivas y relaciones estructura-actividad.

### <u>Bioinformática y quimioinformática</u>

**Biopython:**

***Bio.Seq & Bio.SeqUtils***: Manipulación de secuencias, traducción, transcripción y cálculo de propiedades físico-químicas.

***Bio.PDB***: Análisis de coordenadas atómicas, distancias y estructuras secundarias en archivos PDB.

***Bio.Entrez***: Conexión automatizada a los servicios Web de NCBI (PubMed, GenBank, etc.).

***RDKit***: Toolkit de quimioinformática para el procesamiento, análisis y generación de representaciones 2D/3D de moléculas en múltiples formatos (MOL, SMILES, SMARTS, SDF, InChI, InChIKey).

## 📊 Entorno de programación R y Bioconductor

### <u>Manipulación, lectura y tablas</u>

***dplyr / tidyr / readr***: Modificación, filtrado, pivoteo, limpieza y lectura rápida de conjuntos de datos.

***gtsummary***: Generación automática de tablas de resumen descriptivas y estadísticas con formato publicable.

***caret***: Pipeline unificado para el preprocesamiento de datos y modelado predictivo.

### <u>Visualización avanzada</u>

***ggplot2***: Implementación de la gramática de gráficos para generar:

### <u>Histogramas, boxplots, heatmaps y volcanoplots (para análisis de expresión diferencial)</u>

***patchwork / pheatmap / gridExtra***: Combinación de paneles de gráficos y personalización de mapas de calor complejos.

### <u>Bioestadística y diagnóstico</u>

***nortest / psych / stats / moments / car / broom / performance***: Pruebas de normalidad, análisis multivariante, modelos lineales, asimetría, curtosis y diagnóstico de modelos.

***pROC***: Análisis y visualización de curvas ROC y cálculo del Área Bajo la Curva (AUC).

### <u>Bioconductor</u>

Marco de trabajo especializado en el análisis estadístico e integración de datos genómicos de alto rendimiento (arrays, RNA-Seq, ChIP-Seq, etc.).

## 🌐 Bases de Datos genómicas, bioquímicas y herramientas No-Code

### <u>Bases genómicas y funcionales</u>

***EBI (ENA, Ensembl, VEP)***: Archivos de secuencias de nucleótidos, anotación de genomas y predicción del impacto de variantes (Variant Effect Predictor).

***NCBI (RefSeq, GenBank, PubMed, ClinVar, SRA, Gene, BLAST, dbSNP)***: Bases de datos de referencia, literatura médica, variaciones patogénicas, lecturas de secuenciación masiva (SRA) y alineamiento de secuencias.

***UCSC Genome Browser / GeneCards / OMIM / Franklin***: Exploradores genómicos, bases de datos integradas de genes humanos, fenotipos mendelianos e interpretación de variantes.

***KEGG / GeneOntology (GO)***: Rutas metabólicas, redes funcionales y ontologías de procesos biológicos/componentes celulares.

### <u>Recursos para anotación de variantes y biología humana</u>

***UK Biobank / Orphanet / COSMIC / The Human Protein Atlas / 1000 Genomes / gnomAD***: Estudios de asociación a escala genómica (GWAS), enfermedades raras, genómica del cáncer, localización celular de proteínas y frecuencias alélicas poblacionales.

### <u>Herramientas de In Silico Pathogenicity</u>

***SIFT / PolyPhen-2 / MutationTaster***: Algoritmos predictivos sobre el impacto funcional y la nocividad de variaciones aminoacídicas o nucleotídicas.

***mtDNA***: Análisis específico del genoma mitocondrial.

### <u>Alineamiento, predicción de genes</u>

***Clustal Omega / COBALT / MUSCLE***: Herramientas de alineamiento múltiple de secuencias (MSA).

***GENSCAN / ORFfinder***: Algoritmos para la predicción de genes de novo y búsqueda de marcos abiertos de lectura.

***Galaxy***: Plataforma interactiva y accesible (No-Code) basada en web para el procesamiento reproducible de datos biomédicos.

## 🛢️ Gestión de Bases de Datos Relacionales (MySQL)

***Modelo Entidad–Relación (E-R)***: Diseño conceptual y lógico de esquemas de datos relacionales para bioinformática.

**Consultas SQL:**

***DDL (Data Definition Language)***: Creación y modificación de estructuras de tablas.

***DML (Data Manipulation Language)***: Insert, Update, Delete y selección avanzada de registros.

***DCL (Data Control Language)***: Gestión de permisos de usuarios, control de accesos.

***Transacciones***: Mantenimiento de la integridad de los datos (Commit/Rollback).

## 🤖 Machine Learning y Deep Learning

### <u>Aprendizaje Automático (Scikit-learn)</u>

**Métodos No Supervisados (Reducción de Dimensionalidad y Agrupamiento):**

***PCA, MDS, Isomap, t-SNE, UMAP***: Métodos lineal y no lineales para compresión y visualización de datos omicos de alta dimensión.

***Clustering: K-Means (no jerárquico), Clustering jerárquico aglomerativo y divisivo.***

**Métodos Supervisados:**

***k-NN, SVM, Árboles de Decisión y Random Forest***: Algoritmos para la clasificación celular, diagnóstico patológico y regresión bioactiva.

**Evaluación y selección:**

Validación cruzada, ajuste de hiperparámetros, métricas de rendimiento y preprocesamiento de conjuntos de datos.

**Aprendizaje Profundo** (***TensorFlow & PyTorch***)

Redes Neuronales: Diseño, construcción y entrenamiento de arquitecturas profundas (CNNs, RNNs) aplicadas a la predicción de estructuras de proteínas, visión computacional en imágenes médicas y modelos del lenguaje biológico.

## 🐧 Entornos Bash / Linux, Perl y QIIME2

***Linux / Bash Scripting***: Automatización de tareas en línea de comandos, procesamiento masivo de texto mediante flujos (pipelines) y gestión de procesos en servidor.

***Perl***: Lenguaje tradicional utilizado en bioinformática para el parseo y manipulación rápida de archivos de texto estructurado.

***QIIME2***: Framework bioinformático extensible para el análisis de datos de secuencias microbiómicas (Metagenómica 16S/ITS).

## ✂️ Herramientas de Análisis Bioinformático

### <u>Control de calidad y trimming</u>

***FastQC / Fastp***: Control de calidad visual y estadístico de lecturas FASTQ.

***Trimmomatic***: Eliminación de adaptadores y filtrado por calidad de secuencias.

### <u>Mapeo, ensamble y caracterización</u>

***Bowtie2***: Alineamiento rápido de lecturas de secuenciación contra genomas de referencia.

***Kraken***: Clasificación taxonómica de lecturas metagenómicas.

***Salmon***: Cuantificación rápida y no alineada de expresión génica a partir de RNA-Seq.

***Prokka***: Anotación rápida de genomas procariotas.

***QUAST***: Evaluación de la calidad del ensamblaje de genomas.

***MAFFT***: Alineamiento de secuencias múltiples de alta velocidad.

***DESeq2***: Análisis estadístico de expresión génica diferencial a partir de datos de contajes (RNA-Seq).

## 🔬 Visualización y Manipulación Estructural

***PyMOL***: Software especializado en la renderización 3D, inspección de interacciones ligando-proteína, mutogénesis in silico y generación de figuras de calidad para publicación.
