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
 
 ### 1.2 Getting started
 
 Idea Intellij Pro or Eclipse 
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
-  import sql data to database. The table names should be berlin_2po_4pgr, wiesloch_2po_4pgr
- create MySql database. Name - emobilesim
- In RouteServe.groovy line 317 put your Postgres Data
- Line 331 add your Postgress tables
- In DataSource.groovy are the typical MySql settings


## 2 <a name="ch2"> Installation - server</a> 

Instalation process contains multiple steps. Emobilesim can be install local or 
on server. In this documentation will introduce both instalation types.

## 3 <a name="ch3"> How to use Emobilesim</a> 
Work in progress...