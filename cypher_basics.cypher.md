## Basic statements
---
#Creating nodes

CREATE (:Person {name: "Pedro"})

CREATE (:Person {name: "Kody", 
                hobby: "Cricket", 
                from: "Southafrica"})

---
# Creating nodes, relation and return

CREATE (remzi:Person {name:"Remzi", position:"Postdoc"}), 
        (amrapali:Person {name:"Amrapali"}),
        (remzi)-[:KNOWS]->(amrapali)
RETURN remzi, amrapali

---
# Retrieving nodes
Click on Person node lables

MATCH (nodes)
RETURN nodes

MATCH p=()-[r:KNOWS]->() 
RETURN p

---
# Creating relations of existing nodes

MATCH (pedro:Person {name:"Pedro"}), (kody:Person {name:"Kody"})
CREATE (pedro)-[:KNOWS]->(kody)
RETURN pedro, kody

---
# Updating properties of existing nodes

MATCH (n {name: "Pedro" })
SET n.hobby = "toCook"
SET n.country = "Mexico"
RETURN n

---
# Creating relations with different nodes

CREATE (graphs:Course {title: "KG"})

MATCH (c:Course), (p:Person)
WHERE p.name IN ["Remzi", "Kody", "Amrapali"]
CREATE (p)-[:TEACH]->(c)

---
# Create a full path

CREATE p =(pedro { name:"Pedro" })-[:TEACH]->(graphs)<-[:TEACH]-(kody { name: "Kody" })
RETURN p

---
# where statements

MATCH (p:Person)-[:KNOWS]-()
WHERE p.department = "IDS" RETURN p

---
#gives you the metagraph
CALL db.schema()

---
#delete all
MATCH (n)
DETACH DELETE n

---
#delete relations

MATCH ()-[k:KNOWS]-()
DELETE k

---
# Where statement

MATCH (pedro:Person), (kody:Person)
WHERE pedro.name = "Pedro" AND kody.name = "Kody"
CREATE (pedro)-[:KNOWS]->(kody)
RETURN pedro, kody
