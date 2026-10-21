###########################################################
###########################################################
##### ACTIVIDAD 2 – CONCEPTOS FUNDAMENTALES DE PYTHON #####
###########################################################
###########################################################


# Se genera un ambiente de Conda con el nombre "actividad2", se instalan las librerias necesarias, y se activa el entorno

    ## conda create --name actividad2 pandas requests pubchempy rdkit biopython spyder
    ## conda activate actividad2

#######################
##### EJERCICIO 1 #####
#######################
	
	    
### A)
        
# se importa la librería requests para hacer peticiones HTTP
import requests
     # se define la lista de ids
pdb_ids = ['1tup', '2xyz', '3def', '4ogq', '5jkl', '6mno', '7pqr', '8stu', '9vwx', '10yza']

# se define la función cuyo argumento es la lista de ids
def download_cif (pdb_ids):
    api_url= "https://files.rcsb.org/download"    # enlace descarga
    path2save = "C:/Users/laura/Documents/Unir/Actividad2"  # carpeta donde se van a guardar los archivos
    
# bucle para recorrer todos los ids
    for pdb_id in pdb_ids:
        url = f"{api_url}/{pdb_id}.cif"  # url completa para cada archivo
        response = requests.get(url)  # solicitud htttp
        if response.status_code == 200:   # comprobacion del exito de la descarga
# Guardar archivo .cif
              with open(f"{path2save}/{pdb_id}.cif", "wb") as cif_file:
                  cif_file.write(response.content)
                  print(f"Descargado {pdb_id}.cif")  # mensaje exito descarga
        else:
            print(f"Descarga fallida {pdb_id} - Status code: {response.status_code}")  # mensaje fallo descarga
 
print("Descarga completada.")  # mensaje final proceso descarga
            
download_cif(pdb_ids) # se ejecuta la funcion para la descarga y guardado de archivos .cif


### B)
        
import pandas as pd  # se importa pandas para generar el data frame

pdb_id = "1tup"   # definimos el ID del PDB
url = "https://rest.uniprot.org/uniprotkb/search"   # URL de busqueda en UniProt

# parametros de consulta
params = {
    "query": f"xref:pdb-{pdb_id}",
    "format": "json"
}
response = requests.get(url, params=params)   # Petición a la API
# Verificación de la respuesta
if response.status_code == 200:
    data = response.json()
    results = data.get("results", [])         # resultado encontrado
    if results:
        print("UniProt IDs encontrados:")     # verificacion de la respuesta
        for item in results:
            uniprot_id = item.get("primaryAccession")
            print(uniprot_id)
    else:
        print("No se encontraron resultados")
else:
    print(f"Error en la petición: {response.status_code}")
    
# definimos la funcion de llamada    
def info_uniprot(data):
    results = data.get("results", [])   # se extraen los resultados
    column = []   # generamos lista para incluir las columnas para el df
# # bucle para recorrer todas las claves del objeto
    for item in results:
        uniprot_id = item.get("primaryAccession") # ID de Uniprot
        fecha_publicacion = item.get("entryAudit", {}).get("firstPublicDate") # se obtiene fecha publicacion
        fecha_modificacion = item.get("entryAudit", {}).get("lastAnnotationUpdateDate")   # fecha modificacion
        reviewed = item.get("entryType")   # revisada
        gene_info = item.get("genes", [])   # para coger info de la clave genes
        nombre_gen = None   # nombre del gen
        sinonimos = []  # se genera lista vacia para los sinonimos
        secuencia = item.get("sequence", {}).get("value")

        if gene_info:
            gene = gene_info[0]
            nombre_gen = gene.get("geneName", {}).get("value")   # nombre del gen
            sinonimos = [g.get("value") for g in gene.get("synonyms", [])]   # sinonimos
            organismo = item.get("organism", {}).get("scientificName")   # organismo al que pertenece
            nombre_proteina = (item.get("recommendedName", {}).get("value"))
            pdb_ids = []   # lista vacia para introducir IDs de PDB
        for xref in item.get("uniProtKBCrossReferences", []):
            if xref.get("database") == "PDB":
                pdb_ids.append(xref.get("id"))   # se guardan IDs en la lista

        column.append({
            "Uniprot_id": uniprot_id,
            "Fecha_publicacion": fecha_publicacion,
            "Fecha_modificacion": fecha_modificacion,
            "Revisado": reviewed,
            "Nombre_del_gen": nombre_gen,
            "Sinónimos": ", ".join(sinonimos) if sinonimos else None,
            "Organismo": organismo,
            "Nombre_proteina": nombre_proteina,
            "Secuencia": secuencia,
            "PDB_ids": ", ".join(pdb_ids) if pdb_ids else None
        })

    return column  

info_uniprot(data)   # para ver los datos
rows = info_uniprot(data)  # se ejecuta la funcion y se guarda el resultado
df = pd.DataFrame(rows)   # se genera el data frame
print(df) # se imprime el data frame
print(df.to_string())  # para ver el data frame completo


### C)

# busqueda de cofactor en 1TUP
results = data.get("results", [])
for item in results:
    comments = item.get("comments", [])   # se busca en comments
    encontrado = False
    for comment in comments:
        # buscar comentarios de tipo COFACTOR
        if comment.get("commentType") == "COFACTOR":   # señalamos que sea el COFACTOR
            for cofactor in comment.get("cofactors", []):
                nombre = cofactor.get("name")   # que devuelva el nombre del COFACTOR
                if nombre:
                    print(f"Cofactor encontrado: {nombre}")
                    encontrado = True
    if not encontrado:
        print("No se encontraron cofactores")

#  importar libreria de APY PubChem
import pubchempy as pcp
import pandas as pd

#  cofactor encontrado para 1TUP
compuesto = "Zn2+"
# busqueda en PubChem
compuestos = pcp.get_compounds(compuesto, namespace='name')
# lista para guardar resultados
datos = []
if compuestos:
    c = compuestos[0]
    datos.append({
        "Compuesto": compuesto,   # nombre del compuesto
        "Pubchem_id": c.cid,   # ID compuesto en PubChem
        "Peso_molecular": c.exact_mass,   # peso molecular
        "Inchi": c.inchi,   # el inchi
        "Inchikey": c.inchikey,   # el inchikey
        "Iupac_name": c.iupac_name   #nombres según Iupac
    })
    # imprimir resultados
print("===== RESULTADOS PUBCHEM =====")
for clave, valor in datos[0].items():
    print(f"{clave}: {valor}")

# crear DataFrame
df_chempy = pd.DataFrame(datos)
# mostrar resultado
print(df_chempy)
print(df_chempy.to_string(index=False))



#######################
##### EJERCICIO 2 #####
#######################


### A)

# se importa MMCIFParser
from Bio.PDB.MMCIFParser import MMCIFParser

# se crea el objeto parser
parser = MMCIFParser(QUIET=True)
# leer el archivo 4ogp.cif estructura
estructure  = parser.get_structure("4ogq",
"C:/Users/laura/Documents/Unir/Actividad2/4ogq.cif")  # definimos archivo CIF necesario
# se genera lista para heteromoléculas
heteromoleculas = []
# recorrer estructura
for model in estructure:
    for chain in model:
        for residue in chain:
            # HETATM son los heteroatomos
            if residue.id[0] != " ":
                nombre = residue.get_resname().strip()
                # excluir agua
                if nombre != "HOH":
                    heteromoleculas.append(nombre)
# eliminar duplicados
heteromoleculas = list(set(heteromoleculas))
# mostrar resultado de la lista
print("Heteromoléculas (sin agua):")
print(heteromoleculas)


### B)

# se importa MMCIF2Dict
from Bio.PDB.MMCIF2Dict import MMCIF2Dict
# se importa Pandas para el DataFrame
import pandas as pd
# convertir archivo CIF a diccionario
dic = MMCIF2Dict("C:/Users/laura/Documents/Unir/Actividad2/4ogq.cif")
# extraer clave de heteromoleculas no polimericas
entity_ids = dic.get("_pdbx_entity_nonpoly.entity_id", [])
comp_ids = dic.get("_pdbx_entity_nonpoly.comp_id", [])  # ID heteromolecula
names = dic.get("_pdbx_entity_nonpoly.name", [])   # nombre heteromolecula

# se genera lista para los datos
datos = []
# se recorren los IDs
for i in range(len(comp_ids)):
    datos.append({
        "ID": comp_ids[i],
        "Nombre_heteromolecula": names[i]
    })

# crear DataFrame
df_heteromoleculas = pd.DataFrame(datos)
# mostrar resultado
print(df_heteromoleculas)
print(df_heteromoleculas.to_string(index=False))


### C)

# se importa pubchempy
import pubchempy as pcp

# se añade columna SMILES en el DataFrame ya generado de heteromoleculas
df_heteromoleculas["SMILES"] = None

# recorrer DataFrame
for i in range(len(df_heteromoleculas)):
    nombre = df_heteromoleculas.loc[i, "Nombre_heteromolecula"]
    # buscar en PubChem
    resultados = pcp.get_compounds(nombre, namespace="name")
    # si hay resultados, guardar SMILES
    if resultados:
        df_heteromoleculas.loc[i, "SMILES"] = resultados[0].canonical_smiles

# mostrar resultado final
print(df_heteromoleculas)
print(df_heteromoleculas.to_string(index=False))


## D) Generar archivo .sdf con RDKit

import pubchempy as pcp
from rdkit import Chem
from rdkit.Chem import Descriptors

# se genera el archivo SDF de salida en la ruta donde se va a guardar
sdf_file = "C:/Users/laura/Documents/Unir/Actividad2/heteromoleculas.sdf"
# crear writer SDF para incluir la informacion en el archivo
writer = Chem.SDWriter(sdf_file)
# recorrer DataFrame de heteromoleculas
for i in range(len(df_heteromoleculas)):
    # se obtienen los datos del DataFrame
    ID = df_heteromoleculas.loc[i, "ID"]
    nombre = df_heteromoleculas.loc[i, "Nombre_heteromolecula"]
    smiles = df_heteromoleculas.loc[i, "SMILES"]
    # se comprueba que existe SMILES
    if smiles:
        # crear objeto mol de RDKit desde SMILES
        mol = Chem.MolFromSmiles(smiles)
        # se comprueba que la molecula es válida
        if mol:
            # calculo del peso molecular
            peso = Descriptors.MolWt(mol)
            # se añaden propiedades al objeto mol
            mol.SetProp("ID", ID)
            mol.SetProp("Nombre", nombre)
            mol.SetProp("Molecular_weight", str(peso))
            # se guarda en archivo SDF
            writer.write(mol)

# cerrar writer
writer.close()

print(f"Archivo SDF generado correctamente: {sdf_file}")

## para comprobar que el archivo SDF puede utilizarse  por RDKit
# leer archivo SDF
supplier = Chem.SDMolSupplier("C:/Users/laura/Documents/Unir/Actividad2/heteromoleculas.sdf")
# mostra las moleculas que estan correctas
print("Moléculas cargadas correctamente:")
# se comprueba que RDKit pudo leer correctamente la molecula
for mol in supplier:
    if mol:
        print(mol.GetProp("ID"))


# ejemplo de creacion de un objeto Mol desde el archivo SDF
suppl = Chem.SDMolSupplier("C:/Users/laura/Documents/Unir/Actividad2/heteromoleculas.sdf") # devuelve un iterador
mol_sdf = suppl[1] # se toma la segunda heteromolecula
# se realiza comprobacion basica de la creacion del mol
if mol_sdf:
    print("Mol creada correctamente")
else:
    print("Error: la molécula no se pudo crear")
 #  se comprueban algunas propiedades del mol   
if mol_sdf.HasProp("Nombre"):
    print("Nombre:", mol_sdf.GetProp("Nombre"))
if mol_sdf.HasProp("ID"):
    print("ID:", mol_sdf.GetProp("ID"))
if mol_sdf.HasProp("Molecular_weight"):
    print("Peso molecular:", mol_sdf.GetProp("Molecular_weight"))