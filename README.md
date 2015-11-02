Emobilesim
=======
First transport simulation orientied on electric fleets and charging 
infrastructure of some geografic region. 

1.0 Installation
Instalation process contains multiple steps. Emobilesim can be install local or 
on server. In this documentation will introduce both instalation types.

To work with Emobilesim will need following applications:
- Idea Intellij Pro or Eclipse 
- Grails (Version 2.4.3)
- MySQL database (create database with name emobilesim, application will create 
tables himself)
- PostgreSQL database with following extensions: fuzzymatch, hstore, pgrouting,
plpgsql, postgis, postgis_tiger_geocoder, postgis_topology.
Emobilesim uses openstreetmap graph. You need to import data and create a tables with 
requied regions. For example Berlin and so on.
- load region from http://download.geofabrik.de/
- convert data to postgres database with osm2po from http://osm2po.de/  
   java -Xmx1408m -jar osm2po-core-5.0.0-signed.jar prefix=berlin tileSize=x,c /Users/anbu02/Downloads/OSM/berlin.osm
   (instructions in web site)
-  import sql data to database


Work in progress...