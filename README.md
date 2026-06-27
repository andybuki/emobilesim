# Emobilesim

First transport simulation orientied on electric fleets and charging 
infrastructure of some geografic region. Emobilesim can work on local machine or on server.
This repository contains all necessary Groovy/Grails files. The description has all settings.  

---

1 [Installation - local maschine ](#ch1)

2 [Installation - server](#ch2)

3 [How to use Emobilesim](#ch3)

---

## 1 <a name="ch1"> Installation - local maschine</a> 

To work with Emobilesim will need to install following applications:
 
### 1.1 Development environments 
Idea Intellij Pro or Eclipse. It will be better to work with Idea Intellij Pro.
The whole project was made with it. 
 (https://www.jetbrains.com/idea/download/download-thanks.html)
 
### 1.2 Grails (Version 2.4.3)
To work with Emobilesim you will need Grails 2.4.3 (https://grails.org/download.html)
 
### 1.3 MySQL database
Install MySQL environment - MySQL Workbench (http://www.mysql.de/products/workbench/)
Create for localhost emobilesim database. All tables will create automaticly after 
start the emobilesim aplication.

### 1.4 PostgreSQL database
PostgreSQL database contains data about routes. It is possible to use local 
database. In default mode the aplication uses PostgreSQL database on server.
To work with PostgreSQL install pgAdmin3 - (http://www.pgadmin.org/)
Emobilesim can use different tables, for different regions. It is possible to add other regions
using OpenStreetMaps.

- Add extensions
The user need to add to your database following extensions: fuzzymatch, hstore, pgrouting,
plpgsql, postgis, postgis_tiger_geocoder, postgis_topology.

- Load needed regions (http://download.geofabrik.de/) for example Berlin or Brandenburg. For small regions it is possible to use (http://openstreetmap.org)  

- convert data to postgres database with osm2po from (http://osm2po.de/)  
  ``` java -Xmx1408m -jar osm2po-core-5.0.0-signed.jar prefix=berlin tileSize=x,c /Users/anbu02/Downloads/OSM/berlin.osm ```
   (instructions in web site)

-  import sql data to database. The table names should be berlin_2po_4pgr, wiesloch_2po_4pgr. Table names in PostgreSQL database and in programm need to be the same 
-". After it save the repository local.
In this case it is posible to work with repository to push/pull.
- In RouteServe.groovy line 317 put your Postgres Data
- Line 331 add your Postgress tables
- In DataSource.groovy are the typical MySql settings

### 1.5 Add JDK
Add JDK 7 or 8. Just add JDK from oracle website

### 1.6 Start project (http://localhost:8080/emobilesim/)
After short registration it is possible to work local with Emobilesim 

## 2 <a name="ch2"> Installation - server</a> 
Installation on server contains some different steps compared to local installation.

The application is in tomcat.
It is possible to stop and start tomcat with typical commands.
I use probe to see the data in the frontend. . It is easy using frontend to add emobilesim to
web server.

Using Idea Intellij Pro it is possible to create war. file with following command ```grails -Dgrails.env=lnv war```
Rename the file into ROOT.war. After it it is possible to upload it on server using probe front end interface or in any other 
way placing in tomcat/webapps order with ROOT.war name.


## 3 <a name="ch3"> How to use Emobilesim</a> 
This part concentrates on documentation ising the Emobilesim 

Work in progress...
