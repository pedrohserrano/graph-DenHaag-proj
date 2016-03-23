
//cypher query language
//Graph analytics Den Haag crime project
//03212026
//Pedro V


///////////////Defining the Graph///////////////


//Loading table 
LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/den_haag_full.csv" AS table
//Defining vertex
MERGE (o:Zone {
Name: table.obu_naam,
Offenders: toInt(table.ooffenders0),
Crime: toInt(table.Crim_o)})
MERGE (d:Zone {
Name: table.dbu_naam, 
Offenders: toInt(table.doffenders0), 
Crime: toInt(table.Crim_d)})
MERGE (r:Reg {Name: table.owk_name})
MERGE (y:Year {Name: toInt(table.year)})
//Defining edges
MERGE (o)-[:Move_to {dist: toInt(table.migra0)}]->(d)
MERGE (o)-[:Belong]->(r)
MERGE (r)-[:Crime {Orig: toInt(table.Crim_o), Dest: toInt(table.Crim_d)}]-(y)

//https://github.com/pedrohserrano/graph-thehague/blob/master/den_haag_sample.csv


///////////////Graph decriptive analysis///////////////


//Count vertex total
MATCH (n)  
RETURN count(n)

//Count edges total
MATCH ()-[r]->()
RETURN count(r)

//Calcula el ex-grado de los nodos zona
MATCH (n:Zone)-[r:Move_to]->()
RETURN n.Name as Node, count(r) as Outdegree
ORDER BY Outdegree DESC
UNION
MATCH (a:Zone)-[r:Move_to]->(leaf)
WHERE not((leaf)-->())
RETURN leaf.Name as Node, 0 as Outdegree
//En el documento se muestra el top 5 mayor y menor

//Calcula el in-grado de los nodos zona
MATCH (n:Zone)<-[r:Move_to]-()
RETURN n.Name as Node, count(r) as Indegree
ORDER BY Indegree DESC
UNION
MATCH (a:Zone)<-[r:Move_to]-(root)
WHERE not((root)<--())
RETURN root.Name as Node, 0 as Indegree
//En el documento se muestra el top 5 mayor y menor

//Calcula el grado total del los vertices
MATCH (n:Zone)-[r:Move_to]-()
RETURN n.Name, count(distinct r) as Degree
ORDER BY Degree DESC

//Histograma de los grados del grafo
MATCH (n:Zone)-[r:Move_to]-()
WITH n as Nodes, count(distinct r) as Degree
RETURN Degree, Count(Nodes)
ORDER BY Degree ASC

//Calcula el diametro del subgrafo en el que solo considera colonias
MATCH (z1:Zone),(z2:Zone)
WHERE z1 <> z2
WITH z1, z2
MATCH p=shortestPath((z1)-[r:Move_to*]->(z2))
RETURN z1.Name, z2.Name, length(p)
ORDER BY length(p) DESC LIMIT 1

//A partir del diametro calcula los caminos más cortos entre esos nodos
MATCH p = allShortestPaths((n:Zone)-[r:Move_to*]-(m:Zone))
WHERE n.Name='Archipelbuurt' AND m.Name = 'Transvaalkwartier-Midden'
RETURN EXTRACT(n IN NODES(p)| n.Name) AS Paths


///////////////Análisis exploratorio del grafo///////////////


//Muestra todas las relaciones
MATCH (o)-[:Belong]->(r)-[c:Crime]->(y) RETURN o,r,y

//Muestra todos los nodos cuya relación sea move_to ordenados por número de crímenes y delincuentas
MATCH (n:Zone)-[:Move_to*]->(m:Zone)
RETURN n, m
ORDER BY n.Crime DESC, n.Offenders DESC
LIMIT 10
//En el documento se muestran los 5 distintos

//Muestra el top 10 de las relaciones donde hay mayor flujo de personas
MATCH (n:Zone)-[r:Move_to]->(m:Zone)
WHERE n<>m
RETURN n, m, r
ORDER BY r.dist DESC, n.Crime DESC, n.Offenders DESC
LIMIT 10
//En el documento va la gráfica y el grafo

//Muestra relación de distritos con colonias para mostrar comunidad de nodos
MATCH (n:Zone)-[r:Belong]->(m:Reg)
WHERE n<>m
RETURN n, m, r
ORDER BY n.Crime DESC
LIMIT 100

//A la colonia donde se mueve más gente calculamos el algoritmo Dijsktra
MATCH (n:Zone {Name:'Valkenboskwartier'}), (m:Zone),
path = shortestPath((n)-[*]->(m))
WITH REDUCE(dist = 0, rel in rels(path) | dist + toInt(rel.dist)) AS distance, path, n, m
RETURN n, m, path, distance
ORDER BY distance desc

