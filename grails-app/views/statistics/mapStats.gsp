<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 21.09.15
  Time: 12:48
--%>

<%@ page import="de.dfki.gs.utils.TimeCalculator" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
    <script type='text/javascript' src="${resource(dir: 'js', file: 'prefix-free.js')}"></script>
    <script type='text/javascript' src="${resource(dir: 'js', file: 'jquery-1.9.0.js')}"></script>
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui.css')}" type="text/css">

    <link href='http://fonts.googleapis.com/css?family=Droid+Sans' rel='stylesheet' type='text/css'>

    <link rel='stylesheet' href="${resource(dir: 'css', file: 'style.css')}" type='text/css'/>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'iconic.css')}" type='text/css'/>


    <g:javascript library="jquery-1.9.0"/>

    <g:javascript src="application.js"/>

    <g:javascript src="ol/OpenLayers.js"/>
    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>

    <script src="http://maps.google.com/maps/api/js?v=3.5&sensor=false"></script>

    <script type="text/javascript" src="http://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

</head>

<body>
<g:render template="/layouts/topbarOnlyTitles"/>


<g:form action="showFleetDetails">
    <g:hiddenField name="experimentRunResultId" value="${experimentRunResultId}"/>
    <g:submitButton name="Detail car information"
                    value="${message(code: 'stats.stats.detailcar')}"
                    params="['experimentRunResultId':$experimentRunResultId]"
                    target="_blank"/>
</g:form>

<g:form action="showGroupDetails">
    <g:hiddenField name="experimentRunResultId" value="${experimentRunResultId}"/>
    <g:submitButton name="Display station information"
                    value="${message(code: 'stats.stats.detailstation')}"
                    target="_blank"/>

</g:form>
<div id="openModal1" class="modalDialogMap1">
    <div id="map" style="background-color: #eee; width:100%; height:100%; position: absolute; left:0%; top:0% padding-top:1px" class="olMap"></div>
    <script type="text/javascript">

        // global variables
        var map, vectors, routesLayer, lonlat, zoom, markers, popup ;

        var startIconSize = new OpenLayers.Size( 40, 40 );
        var targetIconSize = new OpenLayers.Size( 20, 20 );
        // var offset = new OpenLayers.Pixel( -(size.x/2) , -(size.y/2));
        var startIcon =  new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'start.png' )}" , startIconSize );
        var targetIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'target.png' )}" , targetIconSize );
        var viaIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'via.png' )}" , targetIconSize );

        var gasolineIconSize = new OpenLayers.Size( 25, 25 );
        var gasolineNormalIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'gasolinenormal.png' )}" , gasolineIconSize );
        var gasolineFastIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'gasolinefast.png' )}" , gasolineIconSize );
        var gasolineMiddleIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'gasolinemiddle.png' )}" , gasolineIconSize );
        var gasolineSlowIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'gasolineslow3.png' )}" , gasolineIconSize );

        var p1 = new OpenLayers.Projection( "EPSG:4326" );
        var pMerc = new OpenLayers.Projection( "EPSG:900913" );
        <g:if test="${simulationArea == 'BERLIN'}">
        lonlat = new OpenLayers.LonLat(13.38, 52.52);
        </g:if>
        <g:else>
        lonlat = new OpenLayers.LonLat(8.7,49.29);
        </g:else>
        zoom = 11;
        map = new OpenLayers.Map( "map", {
            controls: [
                new OpenLayers.Control.KeyboardDefaults(),
                new OpenLayers.Control.Navigation(),
                new OpenLayers.Control.LayerSwitcher(),
                new OpenLayers.Control.PanZoomBar(),
                new OpenLayers.Control.MousePosition()
            ],
            maxExtent:
                    new OpenLayers.Bounds( -20037508.34, -20037508.34,
                            20037508.34,  20037508.34 ),
            numZoomLevels: 18,
            maxResolution: 156543,
            units: 'm',
            projection: pMerc,
            displayProjection: p1
        } );


        markers = new OpenLayers.Layer.Markers( "Markers", {
            strategies: [
                new OpenLayers.Strategy.Fixed(),
                new OpenLayers.Strategy.Cluster()
            ]
        } );
        var stylez = [
            {
                "featureType": "all",
                "elementType": "all",
                "stylers": [
                    {
                        "saturation": -100
                    },
                    {
                        "gamma": 0.5
                    }
                ]
            },
            {
                "featureType": "all",
                "elementType": "geometry",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "all",
                "elementType": "labels",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "all",
                "elementType": "labels.text",
                "stylers": [
                    {
                        "visibility": "simplified"
                    }
                ]
            },
            {
                "featureType": "all",
                "elementType": "labels.icon",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "administrative",
                "elementType": "all",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "landscape",
                "elementType": "all",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "landscape.natural.terrain",
                "elementType": "all",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "landscape.natural.terrain",
                "elementType": "geometry",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "landscape.natural.terrain",
                "elementType": "labels.text",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "landscape.natural.terrain",
                "elementType": "labels.icon",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "all",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "geometry",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "labels",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "labels.text",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "labels.text.stroke",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "poi",
                "elementType": "labels.icon",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "all",
                "stylers": [
                    {
                        "visibility": "simplified"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "geometry",
                "stylers": [
                    {
                        "visibility": "on"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "geometry.fill",
                "stylers": [
                    {
                        "visibility": "on"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "geometry.stroke",
                "stylers": [
                    {
                        "visibility": "on"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "labels",
                "stylers": [
                    {
                        "visibility": "simplified"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "labels.text",
                "stylers": [
                    {
                        "visibility": "simplified"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "labels.text.fill",
                "stylers": [
                    {
                        "visibility": "simplified"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "labels.text.stroke",
                "stylers": [
                    {
                        "visibility": "simplified"
                    }
                ]
            },
            {
                "featureType": "road",
                "elementType": "labels.icon",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "transit",
                "elementType": "all",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "transit.station.airport",
                "elementType": "geometry",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            },
            {
                "featureType": "water",
                "elementType": "all",
                "stylers": [
                    {
                        "visibility": "off"
                    }
                ]
            }
        ];

        var mapgoogle_layer = new OpenLayers.Layer.Google(
                "Google Maps", {
                    type: "styled"

                }

        );
        var mapnik_layer = new OpenLayers.Layer.OSM.Mapnik( "Open Street Maps" );

        var styledMapOptions = {
            name: "Styled Map"
        };

        var styledMapType = new google.maps.StyledMapType(stylez, styledMapOptions);

        map.addLayers( [  mapgoogle_layer,mapnik_layer, markers ] );


        map.addControl(new OpenLayers.Control.MousePosition());

        mapgoogle_layer.mapObject.mapTypes.set('styled', styledMapType);
        mapgoogle_layer.mapObject.setMapTypeId('styled');



        epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
        projectTo = map.getProjectionObject(); //The map projection (Spherical Mercator)
        var vectorLayer = new OpenLayers.Layer.Vector("Overlay");

        //Draw Electric Stations
        var gasDat = new Object();
        <g:each var="fillingStationGroup" in="${fillingStationGroups}">
        <g:each var="fillingStation" in="${fillingStationGroup.stations}">
        <g:if test="${fillingStation.time == 0}">
        var stations = new Array();

        gasDat.fromX = ${fillingStation.lat};
        gasDat.fromY = ${fillingStation.lon};
        gasDat.fillingStationId = ${fillingStation.id};
        gasDat.fillingStationType = ${fillingStation.power};

        drawGasolineStationNull( gasDat );

        </g:if>

        <g:if test="${fillingStation.time > 0}">
        var stations = new Array();

        gasDat.fromX = ${fillingStation.lat};
        gasDat.fromY = ${fillingStation.lon};
        gasDat.fillingStationId = ${fillingStation.id};
        gasDat.fillingStationType = ${fillingStation.power};
        gasDat.time = ${fillingStation.time};

        // Convert seconds to hours minutes
        var sec_num = gasDat.time
        var hours   = Math.floor(sec_num / 3600);
        var minutes = Math.floor((sec_num - (hours * 3600)) / 60);
        var seconds = sec_num - (hours * 3600) - (minutes * 60);

        if (hours   < 10) {hours   = "0"+hours;}
        if (minutes < 10) {minutes = "0"+minutes;}
        if (seconds < 10) {seconds = "0"+seconds;}
        var time    = hours+':'+minutes+':'+seconds;

        var feature = new OpenLayers.Feature.Vector(
                new OpenLayers.Geometry.Point( gasDat.fromX , gasDat.fromY ).transform(epsg4326, projectTo),
                {description: gasDat.fillingStationType + ' '+'Kw' + '<br>' + 'Lat:' + gasDat.fromX + '<br>' + 'Lon:'+ gasDat.fromY + '<br>' +'Time:'+ time}
        );
        vectorLayer.addFeatures(feature);


        drawGasolineStation( gasDat );

        </g:if>
        <g:if test="${fillingStation.time < 0}">
        var stations = new Array();

        gasDat.fromX = ${fillingStation.lat};
        gasDat.fromY = ${fillingStation.lon};
        gasDat.fillingStationId = ${fillingStation.id};
        gasDat.fillingStationType = ${fillingStation.power};

        var feature = new OpenLayers.Feature.Vector(
                new OpenLayers.Geometry.Point( gasDat.fromX , gasDat.fromY ).transform(epsg4326, projectTo),
                {description: gasDat.fillingStationType + ' '+'Kw' + '<br>' + 'Lat:' + gasDat.fromX + '<br>' + 'Lon:'+ gasDat.fromY }
        );
        vectorLayer.addFeatures(feature);


        drawGasolineStation( gasDat );

        </g:if>


        </g:each>
        </g:each>
        var colorVariable = ["red","#00ff00","#ff00ff","#00ddff","yellow"];
        var a = 0;
        var fleetDat = new Object();
        <g:each var="fleet" in="${fleets}">
            <g:each var="car" in="${fleet.cars}" >
            var segments = new Array();
            var vias = new Array();
            var randomColor;
            var r = Math.floor(Math.random() * 255);
            var g = Math.floor(Math.random() * 255);
            var b = Math.floor(Math.random() * 255);
            randomColor= "rgb("+r+" ,"+g+","+ b+")";
            colorVariable.push(randomColor);
            var singleRoutesLayer = new OpenLayers.Layer.Vector("Route of ${car.name}", {
                styleMap: new OpenLayers.StyleMap({
                    'default': {
                        strokeColor: colorVariable[a],// TODO: chose a good color
                        strokeOpacity: 0.4,
                        strokeWidth: 4
                    }
                })
            });
            a++;
            <g:each var="seg" in="${car.route}">
            var segm = new Object();
            segm.fromX = ${seg.fromLon};
            segm.fromY = ${seg.fromLat};
            segm.toX = ${seg.toLon};
            segm.toY = ${seg.toLat};
            segments.push( segm );
            <g:if test="${seg.type=='via_target'}">
            vias.push(segm);
            </g:if>
            </g:each>
            fleetDat.route = segments;
            fleetDat.routesLayer = singleRoutesLayer;
            fleetDat.markers = markers;
            fleetDat.vias =vias;
            drawRoute( fleetDat );
            map.addLayer(singleRoutesLayer);
            </g:each>
        </g:each>

        <g:each var="realRoute" in="${realRoutes}">
        var segments = new Array();
        var vias = new Array();
        var singleRoutesLayer = new OpenLayers.Layer.Vector("Real Route Route of All Cars", {
            styleMap: new OpenLayers.StyleMap({
                    'default': OpenLayers.Util.extend({
                        orientation: true
                    })


                <%--'default': {
                    strokeColor: "yellow",// TODO: chose a good color
                    strokeOpacity: 0.2,
                    strokeWidth: 4
                }--%>
            })
        });

        <g:each var="seg" in="${realRoute.trackEdges}">
        var segm = new Object();
        segm.fromX = ${seg.fromLon};
        segm.fromY = ${seg.fromLat};
        segm.toX = ${seg.toLon};
        segm.toY = ${seg.toLat};
        segments.push( segm );
        <g:if test="${seg.type=='via_target'}">
        vias.push(segm);
        </g:if>
        </g:each>
        fleetDat.route = segments;
        fleetDat.routesLayer = singleRoutesLayer;
        fleetDat.markers = markers;
        fleetDat.vias =vias;
        drawRoute( fleetDat );
        map.addLayer(singleRoutesLayer);
        </g:each>


        map.addLayer(vectorLayer);


        //Add a selector control to the vectorLayer with popup functions
        var controls = {
            selector: new OpenLayers.Control.SelectFeature(vectorLayer, { onSelect: createPopup, onUnselect: destroyPopup })
        };



        function createPopup(feature) {
            feature.popup = new OpenLayers.Popup.FramedCloud("pop",
                    feature.geometry.getBounds().getCenterLonLat(),
                    null,
                    '<div class="markerContent">'+feature.attributes.description+'</div>',
                    null,
                    true,
                    function() { controls['selector'].unselectAll(); }
            );
            //feature.popup.closeOnMove = true;
            map.addPopup(feature.popup);
        }

        function destroyPopup(feature) {
            feature.popup.destroy();
            feature.popup = null;
        }

        map.addControl(controls['selector']);
        controls['selector'].activate();



        lonlat.transform( p1, pMerc );
        map.setCenter( lonlat, zoom );

    </script>
    <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
</div>
</body>
</html>