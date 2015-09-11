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


    <meta name="layout" content="main" />
</head>

<body>

    <div class="pContainerConfigureSimulationMap">


        <div class="rowUp">
            <div class="leftBoldBig"><g:message code="execution.playsimulation.playsimulation"/></div>
            <div class="right0PX"></div>
            <div class="clear"></div>
        </div>
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
                                            <span id="scale-value">time scale 1:50</span>
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
                    <button class="playButton" id="button_play_pause" onClick="toggle_button_clicked()"><g:message code="execution.playsimulation.playsimulation"/></button>
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
        <div id="mapView" style="background-color: #eee; width:99%; min-height: 600px; max-height: 1200px; height:800px; position: relative; left:10px;" class="olMap">

        </div>


        <script>
            var map, vectors, routesLayer, lonlat, zoom, markers, popup, simulationLayer;

            var startIconSize = new OpenLayers.Size( 30, 30 );
            var targetIconSize = new OpenLayers.Size( 20, 20 );
            // var offset = new OpenLayers.Pixel( -(size.x/2) , -(size.y/2));
            var startIcon =  new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'Ecar1.png' )}" , startIconSize );
            var targetIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'target.png' )}" , targetIconSize );
            var viaIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'via.png' )}" , targetIconSize );

            var gasolineIconSize = new OpenLayers.Size( 20, 20 );
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
            zoom = 12;


            map = new OpenLayers.Map( "mapView", {
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

            simulationLayer = new OpenLayers.Layer.Vector("Simple Geometry", {
                styleMap: new OpenLayers.StyleMap({'default':{
                    strokeColor: "#00FF00",
                    strokeOpacity: 1,
                    strokeWidth: 3,
                    fillColor: "#FF5500",
                    fillOpacity: 0.5,
                    pointRadius: 2,
                    pointerEvents: "visiblePainted",
// label with \n linebreaks
                    label : "\$\{speed\} km/h\n\$\{kmDriven\} km \n\$\{batteryLevel\} %\n\$\{currentEnergyUsed\} kW\n\$\{currentPrice\} EUR",
                    fontColor: "${favColor}",
                    fontSize: "8px",
                    fontFamily: "Courier New, monospace",
                    fontWeight: "bold",
                    labelAlign: "${align}",
                    labelXOffset: "${xOffset}",
                    labelYOffset: "${yOffset}",
                    labelOutlineColor: "white",
                    labelOutlineWidth: 1
                }}),
                renderers: OpenLayers.Layer.Vector.prototype.renderers
            });

            simulationLayer.events.on( {
                'featureclick' : function( feature ) {

                    currentFeatureId = feature.feature[ 'carFeatureId' ];

                }
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

            map.addLayers( [  mapgoogle_layer,mapnik_layer, markers, simulationLayer ] );

            map.addControl(new OpenLayers.Control.MousePosition());

            var selectFeature = new OpenLayers.Control.SelectFeature( simulationLayer );
            map.addControl(selectFeature);
            selectFeature.activate();

            mapgoogle_layer.mapObject.mapTypes.set('styled', styledMapType);
            mapgoogle_layer.mapObject.setMapTypeId('styled');


            routesLayer = new OpenLayers.Layer.Vector( "Route Vectors", {
                styleMap: new OpenLayers.StyleMap({'default':{
                    strokeColor: "red",  // TODO: chose a good color
                    strokeOpacity: 0.6,
                    strokeWidth: 2
                }}) } );




            layer = new OpenLayers.Layer.OSM( "Simple OSM Map");

            var color;
            var r = Math.floor(Math.random() * 255);
            var g = Math.floor(Math.random() * 255);
            var b = Math.floor(Math.random() * 255);
            color= "rgb("+r+" ,"+g+","+ b+")";
            var colorVariable = ["red","#00ff00","#ff00ff","#00ddff","yellow"];


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
                            strokeOpacity: 0.8,
                            strokeWidth: 2
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

            var startPoint = new OpenLayers.Geometry.Point(
                    ${car.route[ 0 ].fromLon},
                    ${car.route[ 0 ].fromLat}
            );

            startPoint.transform(
                    new OpenLayers.Projection("EPSG:4326"),
                    new OpenLayers.Projection("EPSG:900913")
            );

            var pointFeature = new OpenLayers.Feature.Vector( startPoint );
            pointFeature.attributes = {
                speed: "0",
                kmDriven: "0",
                favColor: 'red',
                align: "cm",
                batteryLevel: "%"<%--"${seg.batteryLevel}"--%>,
                currentEnergyUsed: "0Kw",<%--${seg.currentEnergyUsed}",--%>
                currentPrice:"0" <%--$"${seg.currentPrice}"--%>

            };

            pointFeature.carFeatureId = ${seg.id};
            pointFeature.fid = '${seg.id}';

            simulationLayer.addFeatures( [ pointFeature ] );



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

            var g_playing = false;
            var namesDrawn = false;
            var maxTotalKm = 0;


            function toggle_button_clicked() {
                if(g_playing)
                {
                    pause();
                }

                else
                {
                    play();
                }
            }

            function pause() {

                window.clearInterval( active );

                // call controller simulation PAUSE:
                jQuery.ajax({
                    url: '${g.createLink( controller: 'execution', action: 'pauseExperiment' )}',
                    type: "POST",
                    success: function( data ) {

                    }
                });

                g_playing = !g_playing;
                var button = document.getElementById('button_play_pause');
                button.innerHTML = "<b>Play simulation</b>";
            }

            function play() {
                var button = document.getElementById('button_play_pause');
                button.innerHTML = "";
                button.style.display="none";
                g_playing = true;

                // action to the controller:
                jQuery.ajax({
                    url: '${g.createLink( controller: 'execution', action: 'proceedExperiment', params: [ configurationId: configurationId, experimentRunResultId: experimentRunResultId ] )}',
                    type: "POST",
                    success: function( data ) {

                    }
                });

                active = window.setInterval( function() {
                            moveCar(); //TODO implement. Check what Variable is neccesarry
                            showInfoPane();
                        }, 10000//2000 // 2000 ms//TODO Maybe variable intervall here
                );

            }

            function moveCar() {

                // get infos for all simulationRoutes
                jQuery.ajax({
                    url: '${ g.createLink( controller: 'execution', action: 'getInfo' ) }',
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    type: "POST",
                    success: function( data ) {
                    /*
                        var info = data[ 'info' ];
                        var time = data[ 'time' ];

                        $( '#time' ).html( time );

                        // for each feature update position
                        // find by carFeatureId in list..
                        for ( var i = 0; i < info.length; i++ ) {

                            var simRoute = info[ i ];

                            var routeToBackTarget = simRoute[ 'routeBackToTarget' ];
                            var routeToEnergy = simRoute[ 'routeToEnergy' ];
                            if ( routeToEnergy != null && routeToBackTarget != null ) {
                                var routeDat = new Object();

                                routeDat.routesLayer = routesLayer;

                                var segmentsToEnergy = new Array();

                                for ( var i = 0; i < routeToEnergy.length; i++ ) {
                                    var segm = new Object();
                                    segm.fromX = routeToEnergy[ i ].fromX;
                                    segm.fromY = routeToEnergy[ i ].fromY;
                                    segm.toX = routeToEnergy[ i ].toX;
                                    segm.toY = routeToEnergy[ i ].toY;
                                    segmentsToEnergy.push( segm );
                                }

                                routeDat.routeToEnergy = segmentsToEnergy;

                                var segmentsBackToTarget = new Array();

                                for ( var i = 0; i < routeToBackTarget.length; i++ ) {
                                    var segm = new Object();
                                    segm.fromX = routeToBackTarget[ i ].fromX;
                                    segm.fromY = routeToBackTarget[ i ].fromY;
                                    segm.toX = routeToBackTarget[ i ].toX;
                                    segm.toY = routeToBackTarget[ i ].toY;
                                    segmentsBackToTarget.push( segm );
                                }

                                routeDat.routeBackToTarget = segmentsBackToTarget;

                                drawExtraRoute( routeDat );
                            }

                            var feat = simulationLayer.getFeatureByFid( simRoute[ 'featureId' ] );
                            var lon = simRoute[ 'lon' ];
                            var lat = simRoute[ 'lat' ];
                            var currentPrice = simRoute[ 'currentPrice' ];
                            var batteryLevel = simRoute[ 'batteryLevel' ];
                            var currentEnergyUsed = simRoute[ 'currentEnergyUsed' ];

                            var speed = simRoute[ 'speed' ];
                            var kmDriven = simRoute[ 'kmDriven' ];

                            if ( lat != null && lon != null ) {

                                var ll = new OpenLayers.LonLat( lon, lat );

                                ll.transform(
                                        new OpenLayers.Projection("EPSG:4326"),
                                        new OpenLayers.Projection("EPSG:900913")
                                );

                                feat.attributes = {
                                    speed: speed,
                                    kmDriven: kmDriven,
                                    currentPrice : currentPrice,
                                    batteryLevel: batteryLevel,
                                    currentEnergyUsed: currentEnergyUsed
                                };

                                feat.move( ll );
                                feat.layer.drawFeature( feat );
                            }

                        }
                        simulationLayer.redraw();
                    */
                    },
                    error: function( data ) {

                        console.log( data );

                    }
                });

            }


            function showInfoPane() {

                // get infos for one simulationRoutes
                jQuery.ajax({
                    url: '${ g.createLink( controller: 'execution', action: 'getInfo' ) }',
                    data: JSON.stringify( { data: { sessionId : "${sessionId}" } } ),
                    contentType: "application/json; charset=utf-8",
                    dataType: "json",
                    type: "POST",
                    success: function( data ) {

                        if ( data[ 'info' ] ) {
                            var info = data[ 'info' ];

                            var cars = info[ 'cars' ];
                            var stations = info[ 'stations' ];

                            var currentTime = info[ 'currentTime' ];

                            //new parameters
                            var currentPrice = info[ 'currentPrice' ];
                            var batteryLevel = info[ 'batteryLevel' ];
                            var currentEnergyUsed = info[ 'currentEnergyUsed' ];
                            var speed = info[ 'speed' ];
                            var kmDriven = info[ 'kmDriven' ];
                            var street = info[ 'street' ];
                            //new parameters --//

                            drawCarInfos( cars );
                            drawStationInfos( stations );
                            drawCurrentTime( currentTime );

                            $( '#speedInfo').html( speed );
                            $( '#kmInfo').html( kmDriven );
                            $( '#priceInfo' ).html( currentPrice );
                            $( '#streetInfo' ).html( street );
                            $( '#fillInfo' ).html( batteryLevel );

                            var batString = batteryLevel + "%";
                            $( '#progress-bar' ).css("width", batString );

                            if ( batteryLevel <= 30 ) {
                                var factor = 1 - ( batteryLevel / 30 );
                                $( '#progress-bar-red' ).css("opacity", factor );
                            } else {
                                $( '#progress-bar-red' ).css("opacity", 0 );
                            }
                            //drawCarsText ();
                            //drawStationsText ();

                        }

                        var simStatus = "false";
                        if ( data[ 'finished' ] ) {
                            simStatus = data[ 'finished' ];
                        }

                        console.log( simStatus );

                        var experimentRunResultId = data[ 'experimentRunResultId' ];


                        recheckStopButton( simStatus );


                        enableShowStatsButtonIfFinished( simStatus );


                        // $( '#speedInfo').html( speed );

                    },
                    error: function( data ) {

                        // console.log( data );

                    }
                });

            }

            function drawShowStatsButton( runResultId ) {

                <%--
                var buttonsDiv = document.getElementById( 'the_buttons' )


                           <button class="playButton"
                                   id="button_show_stats"
                                   type="submit"
                                   onclick="location.href='${createLink( controller: 'statistics', action: 'showStats', params: [ configurationId: configurationId ] )}'"
                                   value="disable"
                                   disabled
                               ><i class="icon icon-warning-sign"></i>Show Stats</button>


                var buttonnode= buttonsDiv.createElement('input');
                buttonnode.setAttribute( 'class', 'button_show_stats' );
                buttonnode.setAttribute( 'type', 'submit' );
                buttonnode.setAttribute( 'value', 'Show Stats' );

                buttonnode.setAttribute( 'onclick', "location.href='${createLink( controller: 'statistics', action: 'showStats', params: [ simulationExperimentResultId: runResultId ] )}'" );
                --%>
            }

            function enableShowStatsButtonIfFinished( simStatus ) {

                if ( simStatus == "finished" ) {
                    document.getElementById( 'button_show_stats' ).disabled = false;
                    document.getElementById( 'button_show_stats' ).value = "enabled";

                    document.getElementById( 'button_show_stats' ).style.color = "#00AA00";
                    document.getElementById('button_show_stats').style.display='inline';
                }



            }

            function recheckStopButton( simStatus ) {

                document.getElementById( 'button_stopp').disabled = (simStatus != "finished");

            }

            function drawCurrentTime( currentTime ) {

                var timeCanvas = document.getElementById( 'timeContainer' );

                if ( timeCanvas.getContext ) {

                    var ctx = timeCanvas.getContext( '2d' );
                    ctx.clearRect( 0,0,1100,40 );
                    ctx.font = "16px sans-serif ";
                    ctx.fillStyle = "black";
                    ctx.fillText( "Simulation duration:  "  +  currentTime , 480, 30 );

                    ctx.stroke();
                }


            }

            /*function drawCarsText () {

             var carCanvas = document.getElementById( 'carContainer' );

             if ( carCanvas.getContext ) {
             var ctx = carCanvas.getContext( '2d' );

             ctx.clearRect( 0,0,1100,40 );
             ctx.font = "11px sans-serif ";
             ctx.fillStyle = "black";
             //ctx.fillText( "All cars in the simulation", 0, 30 );
             ctx.onclick= "document.getElementById('light').style.display='block';document.getElementById('fade').style.display='block'";
             ctx.class="helpButton";
             ctx.src="${g.resource( dir: '/images', file: 'help.png' )}";
             ctx.stroke();
             }

             }

             function drawStationsText () {

             var stationCanvas = document.getElementById( 'stationContainer' );

             if ( stationCanvas.getContext ) {
             var ctx = stationCanvas.getContext( '2d' );

             ctx.clearRect( 0,0,1100,40 );
             ctx.font = "11px sans-serif ";
             ctx.fillStyle = "black";
             ctx.fillText( "All electric stations in the simulation", 0, 30 );

             ctx.stroke();
             }

             }*/

            function drawStationInfos( info ) {

                var canvas = document.getElementById('stationsContainer');
                var stationCount = info.length;

                var spaceForStation = 1100 / stationCount;
                if (stationCount>50) {
                    if (canvas.getContext) {
                        var ctx = canvas.getContext('2d');
                        ctx.clearRect(0, 0, 400, 500);

                        for (var dp = 0; dp < stationCount; dp++) {

                            var station = info[ dp ];


                            if (station[ 'status' ] == "IN_USE") {
                                // red
                                ctx.fillStyle = "rgba(255, 0, 0, 1.0)";

                            } else {
                                ctx.fillStyle = "rgba(0,255,0,1.0)";
                            }

                            // upperLeft.x, upperLeft.y, width, height
                            ctx.fillRect(dp * spaceForStation, 0, spaceForStation, 40);

                            ctx.stroke();

                        }

                        for (var dp = 0; dp < stationCount; dp++) {

                            ctx.beginPath();
                            //ctx.font = "10px arial ";
                            //ctx.fillStyle = "black";
                            for (var tx = 0; tx < stationCount; tx++) {

                                var station = info[ tx ];

                                var personalId = station[ 'personalId' ]
                                if (station[ 'status' ] == "IN_USE") {
                                    ctx.font = "12px sans-serif";
                                    ctx.fillStyle = "black";

                                } else {
                                    ctx.font = "0px arial";
                                    ctx.fillStyle = "green";
                                }

                                ctx.fillText(personalId, tx * spaceForStation, 20);

                            }
                            ctx.stroke();
                        }


                    }

                }

                else {
                    if (canvas.getContext) {
                        var ctx = canvas.getContext('2d');
                        ctx.clearRect(0, 0, 400, 500);

                        for (var dp = 0; dp < stationCount; dp++) {

                            var station = info[ dp ];


                            if (station[ 'status' ] == "IN_USE") {
                                // red
                                ctx.fillStyle = "rgba(255, 0, 0, 1.0)";
                            } else {
                                ctx.fillStyle = "rgba(0,255,0,1.0)";
                            }

                            // upperLeft.x, upperLeft.y, width, height
                            ctx.fillRect(dp * spaceForStation, 0, spaceForStation, 40);

                            ctx.stroke();

                        }

                        for (var dp = 0; dp < stationCount; dp++) {

                            ctx.beginPath();
                            ctx.font = "11px sans-serif ";
                            ctx.fillStyle = "black";
                            for (var tx = 0; tx < stationCount; tx++) {

                                var station = info[ tx ];

                                var personalId = station[ 'personalId' ]

                                ctx.fillText(personalId, tx * spaceForStation, 10);

                            }
                            ctx.stroke();
                        }


                    }

                }

            }

            function drawCarInfos( info ) {

                var canvas = document.getElementById('experimentContainer');
                var stationCanvas = document.getElementById('stationsContainer');
                var nameCanvas = document.getElementById('nameContainer');
                // canvas.width = canvas.width;

                if (canvas.getContext){

                    // use getContext to use the canvas for drawing
                    var ctx = canvas.getContext('2d');

                    ctx.clearRect ( 0 , 0 , 1100 , 500 );

                    var routeCount = info.length;
                    var sizeForRoute = 1100 / routeCount;

                    // find maxTotalKm
                    if ( maxTotalKm == 0 ) {

                        for ( var dp = 0; dp < routeCount; dp++ ) {
                            var car = info[ dp ];
                            var totalKmToDrive = car[ 'totalKmToDrive' ];
                            if ( totalKmToDrive > maxTotalKm ) {
                                maxTotalKm = totalKmToDrive;
                            }
                        }

                    }




                    /**
                     * drawing status of cars
                     * ROUTE DRIVEN
                     */
                    for ( var dp = 0; dp < routeCount; dp++ ) {

                        var car = info[ dp ];

                        ctx.fillStyle="#828282";
                        //ctx.fillStyle="rgba(10, 2, 45, 0.4)";

                        // max height of rect
                        var x = ( car[ 'totalKmToDrive' ] / maxTotalKm ) * 500;

                        var routeAccomblished = x * car[ 'drivenKm' ] / car[ 'totalKmToDrive' ];

                        // upperLeft.x, upperLeft.y, width, height
                        ctx.fillRect( dp * sizeForRoute, 530-routeAccomblished, sizeForRoute/2, routeAccomblished );

                        ctx.stroke();

                    }

                    // Yellow line, show the whole distance
                    for ( var dp = 0; dp < routeCount; dp++ ) {

                        var car = info[ dp ];
                        var nameCtx = nameCanvas.getContext('2d');
                        nameCtx.beginPath();

                        nameCtx.fillStyle = "#CC8400";
                        ctx.font = "11px sans-serif ";
                        ctx.fillStyle = "#CC8400";
                        // ctx.fillStyle="#112233";

                        //ctx.fillStyle="rgba(0,0,0, 0.99)";

                        // max height of rect
                        var x = ( car[ 'totalKmToDrive' ] / maxTotalKm ) * 500;
                        var y =  car[ 'totalKmToDrive' ] ;
                        var xRound = Math.round(y);
                        //alert(xRound+"km");

                        // upperLeft.x, upperLeft.y, width, height
                        //ctx.fillRect( (db) * (sizeForRoute) + sizeForRoute/2 , 520-batteryFill, sizeForRoute/2, batteryFill );
                        ctx.fillRect( dp * sizeForRoute  + sizeForRoute/2 , 520-xRound, sizeForRoute/2, xRound );
                        ctx.fillText( "  "+xRound+"km", dp * sizeForRoute, xRound+10, sizeForRoute/2 );
                        //alert(xRound+"km");
                        //ctx.fillText( x+"km", dp * sizeForRoute/2, ( (dp%5)*10 ) + 10 );
                        ctx.stroke();

                    }



                    /**
                     * drawing names of cars only once
                     */
                    if ( namesDrawn == false ) {


                        var nameCtx = nameCanvas.getContext('2d');

                        nameCtx.beginPath();
                        nameCtx.font = "12px sans-serif ";
                        nameCtx.fillStyle = "black";
                        for ( var tx = 0; tx < routeCount; tx++ ) {

                            var car = info[ tx ];

                            nameCtx.fillText( car[ 'carName' ], tx * sizeForRoute, ( (tx%5)*10 ) + 10 );

                        }
                        nameCtx.stroke();

                        namesDrawn = true;

                    }


                    /**
                     * drawing status of cars
                     * BATTERY STATUS
                     */

                    var ctxStation = canvas.getContext('2d');
                    ctxStation.beginPath();
                    ctx.beginPath();
                    for ( var db = 0; db < routeCount; db++ ) {

                        var car = info[ db ];

                        //ctx.fillStyle="rgba(32, 45, 21, 0.2)"
                        ctx.fillStyle=("#fff");
                        ctxStation.fillStyle=("#CC8400");

                        var batteryFill = ( 500 / 100 ) * car[ 'batteryFilledPercentage' ] ;
                        var batteryPersent = Math.round(car[ 'batteryFilledPercentage' ] );

                        ctx.font = "10px sans-serif";
                        //ctx.fillText( batteryFill, 190, 30 );
                        // upperLeft.x, upperLeft.y, width, height

                        ctx.fillRect( (db) * (sizeForRoute) + sizeForRoute/2 , 520-batteryFill, sizeForRoute/2, batteryFill );
                        ctxStation.fillText( "  "+batteryPersent +"% accu ", db * sizeForRoute+sizeForRoute/2 , 520-batteryFill, sizeForRoute+10 );
                        //ctx.fillText( "  "+xRound+"km", dp * sizeForRoute, 500-x, sizeForRoute/2 );
                        ctx.strokeStyle = "#AABBCC";
                        ctx.stroke();
                        ctxStation.stroke();
                    }


                }

            }

            function drawExperimentContainer( routeCount ){

                // get the canvas element using the DOM
                var canvas = document.getElementById('experimentContainer');
                var nameCanvas = document.getElementById( 'nameContainer' );
                var stationCanvas = document.getElementById('stationsContainer');


                // Make sure we don't execute when canvas isn't supported
                if (canvas.getContext){

                    // use getContext to use the canvas for drawing
                    var ctx = canvas.getContext('2d');
                    var nameCtx = nameCanvas.getContext( '2d' );
                    var stationCtx = stationCanvas.getContext( '2d' );

                    for (var x = 0.5; x < 1100.6; x += 10) {
                        ctx.moveTo(x, 0);
                        ctx.lineTo(x, 500);
                    }

                    for (var y = 0.5; y < 500.6; y += 10) {
                        ctx.moveTo(0, y);
                        ctx.lineTo(1100, y);
                    }

                    ctx.strokeStyle = "#eee";
                    ctx.stroke();

                    ctx.beginPath();

                    var sizeForRoute = 1100 / routeCount;

                    ctx.fillStyle="#AABBCC";
                    nameCtx.fillStyle="#AABBCC";
                    stationCtx.fillStyle="#AABBCC";
                    for ( var i = 0; i < routeCount; i++ ) {

                        ctx.fillRect( i * sizeForRoute, 0, sizeForRoute, 500 );
                        nameCtx.fillRect( i * sizeForRoute, 0, sizeForRoute, 50 );
                        stationCtx.fillRect( i * sizeForRoute, 0, sizeForRoute, 50 );

                    }

                    ctx.strokeStyle = "#AABBCC";
                    ctx.stroke();
                    nameCtx.stroke();
                    stationCtx.stroke();


                } else {
                    alert('You need Safari or Firefox 1.5+ to see this demo.');
                }

            }
        </script>
        <g:render template="/layouts/footer" />






    </div>
</body>
</html>