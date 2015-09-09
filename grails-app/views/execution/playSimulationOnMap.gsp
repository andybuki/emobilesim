<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 07.09.15
  Time: 14:52
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="configuration.executesim.simulation"/></title>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">

    <g:javascript library="jquery-1.11.2" />
    <g:javascript src="jquery-ui.min.js"/>
    <g:javascript src="slider/jshashtable-2.1_src.js"/>
    <g:javascript src="slider/jquery.numberformatter-1.2.3.js"/>
    <g:javascript src="slider/tmpl.js"/>
    <g:javascript src="slider/jquery.dependClass-0.1.js"/>
    <g:javascript src="slider/draggable-0.1.js"/>
    <g:javascript src="slider/jquery.slider.js"/>

    <g:javascript src="application.js" />
    <g:javascript src="ol/OpenLayers.js" />
    <g:javascript src="jquery.loading.js"/>

    <g:javascript src="jquery-ui-timepicker-addon.js"/>

    <calendar:resources lang="en" theme="tiger"/>
    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui-timepicker-addon.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jslider.css')}" type='text/css' />

    <script src="http://maps.google.com/maps/api/js?v=3.5&sensor=false"></script>

    <script>


        function scale() {

            var scaleValue = $('#scale-slider').val();
            var scaleString = "time scale 1:" + scaleValue;

            $('#scale-value').text( scaleString );

            jQuery.ajax({
                url: '${g.createLink( controller: 'simulation', action: 'scaleSimulation' )}',
                type: "POST",
                data: JSON.stringify( { data: { scaleValue : scaleValue } } ),
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                success: function( data ) {

                    console.log( "scaling: " + data )

                }
            });

        }
    </script>

    <style>

html, body, #map1 {
    width:100%; height:100%; margin:0;
}
    </style>

    <r:layoutResources/>
    <meta name="layout" content="main" />
</head>

<body>
    <div class="pContainerConfigureSimulationMap">
        <div class="rowUp">
            <div class="leftBoldBig"><g:message code="execution.playsimulation.playsimulation"/></div>
            <div class="right0PX"></div>
            <div class="clear"></div>
        </div>
       <br>
        <div class="simulationTypesExecuteMap">
                <div class="rowUp">
                    <span class="infoBold">
                    <g:message code="execution.playsimulation.info"/>
                        <span class="infoBold1">${routeCount}</span><span class="info"> car</span>
                        <span class="infoBold1">${stationCount}</span><span class="info"> charging station</span>
                    </span>
                </div>
                <div draggable="true" id="info_box" >
                        <div id="carInformation">
                            <table >
                                <tr>
                                    <td>
                                        <div class="slide-control-group" >
                                            <p id="scale-value">time scale 1:50</p>
                                            <input id="scale-slider" name="r" type="range" min="1" max="500" value="50" onchange="scale()" style="width: 260px"/>
                                        </div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        speed
                                    </td>
                                    <td id="speedInfo">

                                    </td>
                                    <td>
                                        km/h
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        distance traveled
                                    </td>
                                    <td id="kmInfo">

                                    </td>
                                    <td>
                                        km
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        costs
                                    </td>
                                    <td id="priceInfo">

                                    </td>
                                    <td>
                                        Euro
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        time
                                    </td>
                                    <td id="time">

                                    </td>
                                    <td>
                                        hh:mm:ss
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        fill level
                                    </td>
                                    <td id="fillInfo">

                                    </td>
                                    <td>
                                        %
                                    </td>
                                </tr>

                            </table>
                            <table class="lightboxselectiontable" style="font-size: 13px;" >
                                <tr>
                                    <td id="battery">
                                        <div id="batteryContainer" style="width:230px; height:10px; border:1px solid black;">
                                            <div id="progress-bar"
                                                 style="width:0%; /*change this width */
                                                 background-color: greenyellow;
                                                 height:10px;">
                                                <div id="progress-bar-red"
                                                     style="width:100%;
                                                     background-color: red;
                                                     opacity: 0;  /* 1 is red , 0 is green */
                                                     height:10px;">
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </table>
                            <table class="lightboxselectiontable">
                                <tr>
                                    <td>street</td>
                                    <td id="streetInfo"></td>
                                </tr>
                            </table>
                        </div>
                </div>
                <div class="playButtons" id="the_buttons">
                    <button class="playButton" id="button_play_pause" onClick="toggle_button_clicked()"><b><g:message code="execution.playsimulation.playsimulation"/></b></button>
                    <button class="playButton"
                            id="button_stopp"
                            type="submit"
                            onclick="location.href='${createLink( controller: 'execution', action: 'stopExperiment', params: [ configurationId: configurationId, experimentRunResultId: experimentRunResultId ] ) }'">
                        <i class="icon icon-warning-sign"></i><g:message code="execution.playsimulation.stop"/> </button>
                    <button class="playButtonStats"
                            id="button_show_stats"
                            type="submit"
                            onclick="location.href='${createLink( controller: 'statistics', action: 'showStats', params: [ experimentRunResultId: experimentRunResultId ] )}'"
                            value="disabled"
                            disabled="true"
                    ><i class="icon icon-warning-sign"></i><g:message code="execution.playsimulation.showstats"/> </button>
                </div>

        </div>

        <br>
        <div id="map" style="background-color: #eee; width:99%; height:700px; position:relative; margin:0; left:10px;" class="olMap">

        </div>
        <br><br>

        <script>
            var map, vectors, routesLayer, lonlat, zoom, markers, popup ;

            var startIconSize = new OpenLayers.Size( 40, 40 );
            var targetIconSize = new OpenLayers.Size( 20, 20 );
            // var offset = new OpenLayers.Pixel( -(size.x/2) , -(size.y/2));
            var startIcon =  new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'start.png' )}" , startIconSize );
            var targetIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'target.png' )}" , targetIconSize );
            var viaIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'via.png' )}" , targetIconSize );

            var gasolineIconSize = new OpenLayers.Size( 30, 30 );
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


            routesLayer = new OpenLayers.Layer.Vector( "Route Vectors", {
                styleMap: new OpenLayers.StyleMap({'default':{
                    strokeColor: "red",  // TODO: chose a good color
                    strokeOpacity: 0.6,
                    strokeWidth: 6
                }}) } );


            layer = new OpenLayers.Layer.OSM( "Simple OSM Map");

            var color;
            var r = Math.floor(Math.random() * 255);
            var g = Math.floor(Math.random() * 255);
            var b = Math.floor(Math.random() * 255);
            color= "rgb("+r+" ,"+g+","+ b+")";
            var colorVariable = ["red","#00ff00","#ff00ff","#00ddff","yellow"];
            markers = new OpenLayers.Layer.Markers( "Markers", {
                strategies: [
                    new OpenLayers.Strategy.Fixed(),
                    new OpenLayers.Strategy.Cluster()
                ]
            } );

            var fleetDat = new Object();
            var a = 0;
            <g:each var="fleet" in="${fleets}" >
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


            epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
            projectTo = map.getProjectionObject(); //The map projection (Spherical Mercator)
            var vectorLayer = new OpenLayers.Layer.Vector("Overlay");
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



            map.addLayer(layer);

            map.addLayer(vectorLayer);

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
        <g:render template="/layouts/footer" />


        <r:layoutResources></r:layoutResources>

    </div>
</body>
</html>