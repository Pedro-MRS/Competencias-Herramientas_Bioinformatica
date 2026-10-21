###########################################################
##### 		CONCEPTOS FUNDAMENTALES DE PYTHON 		  #####
###########################################################

### PRACTICA 1 ###

    # A.) Se examina manualmente el archivo 1tup.pdb con un editor de texto
        ## El título descriptivo de esta estructura (TITLE) es:
                # (TITLE): TUMOR SUPPRESSOR P53 COMPLEXED WITH DNA.
        
        ## Los autores de este archivo (AUTHOR)son:
                # (AUTHOR): Y.CHO, S.GORINA, P.D.JEFFREY, N.P.PAVLETICH.
        
    # B.) Extraer la secuencia de aminoácidos de la proteina P53 y guardarla en una lista con with
    
import os     # se importa la librería para trabajar con el sistema operativo
os.getcwd()    # para saber el directorio actual de trabajo
os.chdir("C:/Users/laura/Documents/Unir")   # para cambiar al directorio donde se encuentra el archivo 1tup.pdb
secuencia_p53 = []    # Se genera la lista donde se van a guardar los aminoácidos 
with open("1tup.pdb", "r") as archivo:
    for linea in archivo:
        # Los registros SEQRES contienen la secuencia de aminoácidos
        if linea.startswith("SEQRES"):
            # Dividimos la línea en partes (columnas)
            partes = linea.split()
            
            # Los aminoácidos comienzan a partir de la columna 4 en adelante.
            aminoacidos_linea = partes[4:]
            
            for aa in aminoacidos_linea:
                # VALIDACIÓN: Solo añadimos si tiene exactamente 3 caracteres
                if len(aa) == 3:
                    secuencia_p53.append(aa)
print (secuencia_p53)

    # C.) Con la lista anterior se crea un programa para contar lso aminoácidos hay de cada tipo y se guarda en un diccionario
        # donde la clave sea el aminoácido y el valor el número de repeticiones
        
conteo_aminoacidos = {} # se genera el diccionario donde se van a guardar los aminoácidos y el conteo de cada uno de ellos

for aa in secuencia_p53:
    if aa in conteo_aminoacidos:
        # Si ya existe, sumamos 1 al valor actual
        conteo_aminoacidos[aa] += 1
    else:
        # Si no existe, creamos la clave con valor 1
        conteo_aminoacidos[aa] = 1
print(conteo_aminoacidos)

    # D.) Crear un gráfico de barras con Seaborn con la frecuencia de cada aminoácido
    
import seaborn as sns    # se importa libreria Seaborn con alias sns
import matplotlib.pyplot as plt    # se importa modulo pyplot de la libreria matplotlib con alias plt

# se preparan los datos
aminoacidos = list(conteo_aminoacidos.keys())
frecuencias = list(conteo_aminoacidos.values())

# se configura el estilo y el tamaño de la figura
sns.set_theme(style="whitegrid")
plt.figure(figsize=(12, 6))

# se genera el gráfico de barras
# se asigna 'hue' a los nombres de aminoácidos para generar colores distintos
grafico = sns.barplot(x=aminoacidos, y=frecuencias, hue=aminoacidos, palette="plasma", legend=False)

# Añadimos los títulos
plt.title("Frecuencia de Aminoácidos Proteína P53", fontsize=18, fontweight='bold')
plt.xlabel("Aminoácidos", fontsize=12)
plt.ylabel("Frecuencia aminoacidos", fontsize=12)

# Mostramos el gráfico
plt.show()


### PRACTICA 2 ###


    # A.) Leer el archivo actividad.csv y cambiar el nombre de las columnas por: id, dieta, pulsaciones, tiempo y actividad
    
import pandas as pd # se importa la librería Pandas con alias pd para manipulacion y analisis de datos

# se lee el archivo CSV y se especifica sep=';' porque los datos están separados por punto y coma
df = pd.read_csv('actividad.csv', sep=';')

# Se cambian los nombres de las columnas
df.columns = ['id', 'dieta', 'pulsaciones', 'tiempo', 'actividad']

# Se muestran las primeras filas para verificar el cambio
print(df.head())

    # B.) Determinar la presencia de celdas vacías y eliminar dichas filas
    
df.isnull()
df = df.dropna()

    # C.) Revisar cuantos niveles hay en la columna «dieta» e indicar cual es su frecuencia solo con un método

# Un solo metodo para obtener niveles y sus frecuencias
resultado_dieta = df['dieta'].value_counts()
print(resultado_dieta)


    # D.) Agrupar datos del nivel de actividad mediante el metodo "groupby" y generar una lista que se pueda observar como se ha llevado a cabo la agrupación
    
# Se agrupan datos por la columna 'actividad'
agrupado = df.groupby('actividad')

# Se convierte el objeto groupby en una lista
lista_agrupados = list(agrupado)

# Para mostrar como se ha llevado a cabo la agrupacion 
print(lista_agrupados)
   
    
    # La lista debe contener tres elementos:
    # ¿Por que tres? La lista contiene tres elementos porque el método groupby crea un grupo por cada valor único (nivel) presente en la columna seleccionada.Los tres niveles distintos son: rest (reposo), walking (caminar), y running (correr)
    # ¿Que contienen cada uno de estos elementos de la lista? Cada uno de los tres niveles de la lista es, a su vez, una tupla que contiene dos partes: l Nombre del nivel (Key) y el contenido en un DataFrame de Pandas que contiene exclusivamente las filas que pertenecen a ese nivel especifico

# Para inspeccionar cada grupo se puede gestionar con el siguiente codigo:
    # para el primer nivel (rest)
nombre_grupo, datos_grupo = lista_agrupados[0]
print(f"Grupo: {nombre_grupo}")
print(datos_grupo)

# para el segundo nivel (walking)
nombre_grupo2, datos_grupo2 = lista_agrupados[1]
print(f"Grupo: {nombre_grupo2}")
print(datos_grupo2)

# para el tercer nivel (running)
nombre_grupo3, datos_grupo3 = lista_agrupados[2]
print(f"Grupo: {nombre_grupo3}")
print(datos_grupo3)

    # E.) Tomar el objeto groupby (en este caso es la variable "agrupado") y con el metodo agg calcular la frecuencia cardiaca media y la desviacion estandar para cada nivel de actividad

# Se selecciona 'pulsaciones' y se genera una lista con los estadisticos deseadas
estadisticas_actividad = agrupado['pulsaciones'].agg(['mean', 'std'])
# Se renombran las columnas para que sean mas descriptivas
estadisticas_actividad.columns = ['Media Pulsaciones', 'Desviacion Estandar']
print(estadisticas_actividad)

    # F.) El nombre de los pacientes del estudio se han sustituido por "id" y provienen de distintas ciudades. Añadir esta informacion mediante el "merge" para añadir esta información y completar el conjunto de datos

# Se lee el nuevo archivo de "ciudades.tsv" usando sep='\t' porque los valores estan separados por tabuladores
df_ciudades = pd.read_csv('ciudades.tsv', sep='\t')

# Se combinan los DataFrames usando la columna 'id' como clave comun
df_completo = pd.merge(df, df_ciudades, on='id')   # El parámetro 'on' indica la columna compartida

# Se muestra el resultado combinado
print(df_completo)

    # G.) Generar un grafico con Matplotlib/Seaborn para ver la relacion entre las variables pulsaciones y tiempo segun el tipo de actividad y la dieta. Dar un título apropiado al grafico y reflejar en cada eje el nombre de la variable correspondiente. 
    
# Se van a utilizar la libreria seaborn y el modulo pyplot de la libreria matplotlib que ya están importadas anteriormente con sus respectivos alias
# Se configura el estilo visual
sns.set_theme(style="whitegrid")

# Se genera un grafico de líneas multifacetado
g = sns.relplot(
    data=df_completo,
    x="tiempo", 
    y="pulsaciones",
    col="dieta",  # se crea una columna para cada tipo de dieta
    hue="actividad",  # asigna un color distinto a cada actividad
    kind="line",  # para observar la evolucion de las pulsaciones en el tiempo
    style="actividad",
    facet_kws={'sharey': True} # se comparte eje Y para comparar mejor
)
# Ajustamos títulos y etiquetas de los ejes
g.set_axis_labels("Tiempo", "Frecuencia Cardiaca")
g.set_titles("Estratificación por Dieta: {col_name}")
g.fig.suptitle("Relación Pulsaciones vs Tiempo segun Actividad y Dieta", y=1.05, fontsize=14)
plt.show()


    
    
    
