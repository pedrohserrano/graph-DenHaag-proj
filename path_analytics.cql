#CYPHER

#DELETE ALL
match (a)-[r]->() delete a,r
match (a) delete a

##DEFINING NODES, JUST ONE TYPE
LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/graph.csv" AS line
MERGE (o:Zone {Name:line.o_naam})
MERGE (d:Zone {Name:line.d_naam})
MERGE (o)-[:move_to {dist:line.distance}]->(d)

##ONE MORE NODE AND ONE MORE RELATION
LOAD CSV WITH HEADERS FROM "file:///home/pedrohserrano/graph.csv" AS line
MERGE (o:Zone {Name:line.o_naam})
MERGE (d:Zone {Name:line.d_naam})
MERGE (a:Atrac {Name:line.o_atrac})
MERGE (o)-[:move_to {dist:line.distance}]->(d)
MERGE (a)<-[:had]-(o)

#TOTAL NODES COUNT
match (n)  
return count(n)

#MOST FRECUENT NEIGH
match (n:Zone)  
return count(n)

#EDGES COUNT
match ()-[r]->()
return count(r)

#FINDING ROOT NODES
match (m)-[r:mve_to]->(n:Zone)
where not (()-->(m))
return m

#FINDING TRIANGLES
match (a)-[:TO]->(b)-[:TO]->(c)-[:TO]->(a)
return distinct a, b, c

#SHOW RELATIONS UP
MATCH ()-[r:move_to]->() RETURN r LIMIT 60
MATCH ()-[r:had]->() RETURN r LIMIT 60

#ALL SHORTEST PATHS
MATCH p = allShortestPaths(source-[r:TO*]-destination)
WHERE source.Name='A' AND destination.Name = 'P'
RETURN EXTRACT(n IN NODES(p)| n.Name) AS Paths

#DIAMETER OF THE GRAPH
match (n:MyNode), (m:MyNode)
where n <> m
with n, m
match p=shortestPath((n)-[*]->(m))
return n.Name, m.Name, length(p)
order by length(p) desc limit 1

#Dijkstra's algorithm for a specific target node:
MATCH (from: MyNode {Name:'A'}), (to: MyNode {Name:'P'}),
path = shortestPath((from)-[:TO*]->(to))
WITH REDUCE(dist = 0, rel in rels(path) | dist + toInt(rel.dist)) AS distance, path
RETURN path, distance

#SOLO ORIGEN DIJKSTRA
MATCH (from: MyNode {Name:'A'}), (to: MyNode),
path = shortestPath((from)-[:TO*]->(to))
WITH REDUCE(dist = 0, rel in rels(path) | dist + toInt(rel.dist)) AS distance, path, from, to
RETURN from, to, path, distance order by distance desc


#Find the degree of all nodes
match (n:MyNode)-[r]-()
return n.Name, count(distinct r) as degree
order by degree

#Find degree histogram of the graph
match (n:MyNode)-[r]-()
with n as nodes, count(distinct r) as degree
return degree, count(nodes) order by degree asc

#Save the degree of the node as a new node property
match (n:MyNode)-[r]-()
with n, count(distinct r) as degree
set n.deg = degree
return n.Name, n.deg

#Construct the Adjacency Matrix of the graph
match (n:MyNode), (m:MyNode)
return n.Name, m.Name,
case
when (n)-->(m) then 1
else 0
end as value