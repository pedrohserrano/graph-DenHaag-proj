LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/gene_gene_associations_50k.csv" AS line
MERGE (a:TrialGene {Name:line.OFFICIAL_SYMBOL_A})
MERGE (b:TrialGene {Name:line.OFFICIAL_SYMBOL_B})
MERGE (a) -[:TO {dist:line.EXPERIMENTAL_SYSTEM}]-> (b)


variables a considerar como nodos o relaciones
distancia
dfid (como el id del destino)
ounsafe_me09 percepcion de inseguridad






#cuenta los nodos totales
match (n)  
return count(n)

#en caso de nodos específicos
match (n:mynodo)  
return count(n)

#cuenta las aristas
match ()-[r]->()
return count(r)

#cuando se define el nodo se le puede poner caracteristicas como area o atracciones



LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/terrorist_data_subset.csv" AS row
MERGE (c:Country {Name:row.Country})
MERGE (a:Actor {Name: row.ActorName, Aliases: row.Aliases, Type: row.ActorType})
MERGE (o:Organization {Name: row.AffiliationTo})
MERGE (a)-[:AFFILIATED_TO {Start: row.AffiliationStartDate, End: row.AffiliationEndDate}]->(o)
MERGE(c)<-[:IS_FROM]-(a)

LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/gene_gene_associations_100.csv" AS line
MERGE (a:TrialGene {Name:line.OFFICIAL_SYMBOL_A})
MERGE (b:TrialGene {Name:line.OFFICIAL_SYMBOL_B})
MERGE (a) -[:TO {dist:line.EXPERIMENTAL_SYSTEM}]-> (b)

LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/graph.csv" AS row
MERGE (d:Destino {Name:row.d_naam})
MERGE (o:Origen {Name:row.o_naam})
MERGE (o)-[:MOVED_TO {Start:row.startdate, End:row.enddate}]->(d)





##EN ESTA HAY CAMINOS
LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/graph.csv" AS line
MERGE (o:Zone {Name:line.o_naam})
MERGE (d:Zone {Name:line.d_naam})
MERGE (o)-[:move_to {dist:line.distance}]->(d)

##SE LE AGREGA UN NODO Y UNA RELACIÓN MÁS
LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/graph.csv" AS line
MERGE (o:Zone {Name:line.o_naam})
MERGE (d:Zone {Name:line.d_naam})
MERGE (a:Atrac {Name:line.o_atrac})
MERGE (o)-[:move_to {dist:line.distance}]->(d)
MERGE (a)<-[:had]-(o)


#ESHTA
LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/den_haag_sample.csv" AS table
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
MERGE (o)-[:Move_to {dist: toInt(table.migra0)}]->(d)
MERGE (o)-[:Belong]->(r)
MERGE (r)-[:Crime {Orig: toInt(table.ocrimes0), Dest: toInt(table.dcrimes0)}]-(y)

##MERGE (r:Reg)-[:Move_reg {dist_reg: toInt(table.migra0)}]->(r:Reg)

##PRUEBA DE UN SEGUNDO GRAFO
LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/den_haag_sample.csv" AS table
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
MERGE (o)-[:Move_to {dist: toInt(table.migra0)}]->(d)
MERGE (o)-[:Belong]->(r)
MERGE (r)-[:Crime {Orig: toInt(table.ocrimes0), Dest: toInt(table.dcrimes0)}]-(y)

##MERGE (r:Reg)-[:Move_reg {dist_reg: toInt(table.migra0)}]->(r:Reg)




##ORDENADO POR CRIMENES
MATCH (n:Zone)-[:Move_to]->(m:Zone)
RETURN n, m
ORDER BY n.Crime DESC, n.Offenders DESC
LIMIT 100

#TODAS LAS RELACIONES
MATCH (o)-[:Belong]->(r)-[c:Crime]->(y) RETURN o,r,y

#LAS COLOMIAS QUE MAS SE VAN
#LAS COLONIAS QUE MAS LLEGAN
#LOS DISTRITOS QUE MAS SE VAN Y MAS LLEGAN
#CAMINO MAS LARGO, QUE QUIERE DECIR
#CAMINO MAS CORTO ENTRE COLONIAS Y QUE QUIERE DECIR


#ORDER (TOP 10 DE LOS QUE SALEN DE COLONIAS CON MAS CRIMEN)
MATCH (n:Zone)-[:Move_to]->(m:Zone)
RETURN n, m
ORDER BY n.Crime DESC, n.Offenders DESC
LIMIT 20

#de estas colonias cual es el camino más largo y cual es el barrio que más crimenes tiene

Kortenbos es el que tiene el camino más largo con 1285 y 115 offenders

#el que tiene mayor crimen es:
Offenders	463
Crime	3590
Name	Schildersbuurt-West
#y se movio 1 persona
Offenders	30
Crime	84
Name	Rivierenbuurt-Zuid


MATCH (n:Zone)-[r:Move_to]->(m:Zone)
WHERE n<>m
RETURN n, m, r
ORDER BY r.dist DESC, n.Crime DESC, n.Offenders DESC
LIMIT 20

#entonces sacamos el top 20 de movimiento de personas, donde el origen y destino no es el mismo
#COLONIA ORIGEN
Offenders	287
Crime	524
Name	Valkenboskwartier
#COLONIA DESTINO
Offenders	488
Crime	971
Name	Schildersbuurt-West
dist	73

#NUMERO 2
#COLONIA ORIGEN
Offenders	253
Crime	345
Name	Venen/Oorden/Raden
#COLONIA DESTINO
Offenders	150
Crime	366
Name	Zijden/Steden/Zichten
dist	42


#AHORA RELACIONAMOS CON SUS REGIONES(DISTRITOS)
MATCH (n:Zone)-[r:Belong]->(m:Reg)
WHERE n<>m
RETURN n, m, r
ORDER BY n.Crime DESC
LIMIT 100
#graph reg and zone
aqui se ve que donde hay centralidad son los distritos que tienen mayor número de colonias con crimen

##DIAMETRO DEL GRAFO
MATCH (z1:Zone),(z2:Zone)
WHERE z1 <> z2
WITH z1, z2
MATCH p=shortestPath((z1)-[*]->(z2))
RETURN z1.Name, z2.Name, length(p)
ORDER BY length(p) DESC LIMIT 1

Archipelbuurt	Transvaalkwartier-Midden	10
#	TODOS LOS CAMINOS MAS CORTOS ENTRE ELLOS
MATCH p = allShortestPaths((n:Zone)-[r:Move_to*]-(m:Zone))
WHERE n.Name='Archipelbuurt' AND m.Name = 'Transvaalkwartier-Midden'
RETURN EXTRACT(n IN NODES(p)| n.Name) AS Paths

[Archipelbuurt, Bezuidenhout-Oost, Noordpolderbuurt, Kampen, Zijden/Steden/Zichten, Transvaalkwartier-Midden]
[Archipelbuurt, Oud Scheveningen, Kortenbos, Burgen en Horsten, Zijden/Steden/Zichten, Transvaalkwartier-Midden]
[Archipelbuurt, Landen, Morgenstond-Zuid, Zeeheldenkwartier, Willemspark, Bezuidenhout-Oost, Parkbuurt Oosteinde, Kraayenstein, Transvaalkwartier-Midden]


#DE LA COLONIA DONDE SE MUEVE MAS GENTE, HACEMOS DIKSTRA Y
MATCH (n:Zone {Name:'Valkenboskwartier'}), (m:Zone),
path = shortestPath((n)-[*]->(m))
WITH REDUCE(dist = 0, rel in rels(path) | dist + toInt(rel.dist)) AS distance, path, n, m
RETURN n, m, path, distance
ORDER BY distance desc


##################################CHECAR EL GRAFO DE TODAS LAS REGIONES CON TODA LA BASE, RELACIONADAS ENTRE ELLAS