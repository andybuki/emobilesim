<%--
  Created by IntelliJ IDEA.
  User: simon
  Date: 25.09.15
  Time: 17:09
--%>

<%@ page import="de.dfki.gs.utils.TimeCalculator" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="stats.stats.mapView"/></title>
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui.css')}" type="text/css"/>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'style.css')}" type='text/css'/>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'iconic.css')}" type='text/css'/>
    <link rel="stylesheet" href="${resource(dir: 'css/ol3', file: 'ol.css')}" type="text/css"/>
    <%-- TODO Make this work <g:javascript src="ol3/loader.js"/></script>--%>
    <script src="https://code.jquery.com/jquery-1.11.2.min.js"></script>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/css/bootstrap.min.css">
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.5/js/bootstrap.min.js"></script>
    <%--TODO don't use debug mode if not necessary--%>
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type='text/css'/>
    <script src="http://openlayers.org/en/v3.10.0/build/ol.js"></script>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ol3-layerswitcher.css')}" type="text/css"/>

    <script src="http://maps.google.com/maps/api/js?v=3.5&sensor=false"></script>
    <script src="${resource(dir: 'js',file:'ol3-layerswitcher.js')}"></script>


    <style>
    .ol-popup {
        position: absolute;
        background-color: white;
        -webkit-filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
        filter: drop-shadow(0 1px 4px rgba(0,0,0,0.2));
        padding: 15px;
        border-radius: 10px;
        border: 1px solid #cccccc;
        bottom: 12px;
        left: -50px;
    }
    .ol-popup:after, .ol-popup:before {
        top: 100%;
        border: solid transparent;
        content: " ";
        height: 0;
        width: 0;
        position: absolute;
        pointer-events: none;
    }
    .ol-popup:after {
        border-top-color: white;
        border-width: 10px;
        left: 48px;
        margin-left: -10px;
    }
    .ol-popup:before {
        border-top-color: #cccccc;
        border-width: 11px;
        left: 48px;
        margin-left: -11px;
    }
    .ol-popup-closer {
        text-decoration: none;
        position: absolute;
        top: 2px;
        right: 8px;
    }
    .ol-popup-closer:after {
        content: "✖";
    }

    </style>
</head>

<body>
<g:render template="/layouts/topbarOnlyTitles"/>

<div class="statisticsButtonsDetailMap">
    <button class="layoutButtonR3"
            type="submit"
            onclick="location.href='${createLink( controller: 'statistics', action: 'showFleetDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
        <g:message code="stats.stats.detailcar"/> </button>

    <button class="layoutButtonR3"
            type="submit"
            onclick="location.href='${createLink( controller: 'statistics', action: 'showGroupDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
        <g:message code="stats.stats.detailstation"/> </button>
</div>


<div id="map" class="map"></div>
<div id="popup" class="ol-popup">
    <a href="#" id="popup-closer" class="ol-popup-closer"></a>
    <div id="popup-content"></div>
</div>


<div id="openModal1" class="modalDialogMap1">
    <script type="text/javascript">

        var container = document.getElementById('popup');
        var content = document.getElementById('popup-content');
        var closer = document.getElementById('popup-closer');
        /**
         * Add a click handler to hide the popup.
         * @return {boolean} Don't follow the href.
         */
        closer.onclick = function() {
            popup.setPosition(undefined);
            closer.blur();
            return false;
        };

        /**
         * Create an overlay to anchor the popup to the map.
         */
        var popup = new ol.Overlay(/** @type {olx.OverlayOptions} */ ({
            element: container,
            autoPan: true,
            autoPanAnimation: {
                duration: 250
            }
        }));


        var lon,lat; //This is the center of the picture
        <g:if test="${simulationArea == 'BERLIN'}">
        lon = 13.38;
        lat = 52.52;
        </g:if>
        <g:else>
        lon = 8.7;
        lat = 49.29;
        </g:else>


        //Defining circle style for
        var routeColor = '#0000BB';
        var circle = new ol.style.Style({
            image: new ol.style.Circle({
                radius: 10,
                fill: new ol.style.Fill({
                    color: routeColor
                }),
                stroke: new ol.style.Stroke({
                    color: '#000000'
                })
            })
        });

        var stroke = new ol.style.Stroke({
            color: routeColor,
            width: 6
        });

            //making a style function
        function styleFunctionForUnusedStations(feature, resolution){

                var styles = [ new ol.style.Style({
                    image: new ol.style.Circle({
                        radius: 5,
                        fill: new ol.style.Fill({
                            color: "light_grey"
                        }),
                        stroke: new ol.style.Stroke({
                            color: '#000000'
                        })
                    })})];
                return styles
        }
        function styleFunctionForUsedStations(feature, resolution){

                var styles = [ new ol.style.Style({
                    image: new ol.style.Icon({
                        src: "${g.resource( dir: '/images', file: 'gasolinefast.png' )}",
                        //size: [20,20],
                        fill: new ol.style.Fill({
                            color: "red"
                        }),
                        stroke: new ol.style.Stroke({
                            color: '#000000'
                        })
                    })})];
                return styles
        }


        function styleFunctionForRoutes(feature, resolution){
            //Get color for the car
            var routeColor = feature.get('color');
            var circleViaTarget = new ol.style.Style({
                image: new ol.style.Circle({
                    radius: 10,
                    fill: new ol.style.Fill({
                        color: routeColor
                    }),
                    stroke: new ol.style.Stroke({
                        color: '#000000'
                    })
                })
            });
            var circleFinalPosition = new ol.style.Style({//TODO add good picture here
                image: new ol.style.Icon({
                    //radius: 10,
                    src: "${g.resource( dir: '/images', file: 'finish.png' )}",
                    fill: new ol.style.Fill({
                        color: '#000000'
                    }),
                    stroke: new ol.style.Stroke({
                        color: routeColor,
                        width:5
                    })
                })
            });

            var startPosition = new ol.style.Style({//TODO add good picture here
                image: new ol.style.Icon({
                    //radius: 10,
                    src: "${g.resource( dir: '/images', file: 'homeStart.png' )}",
                    scale: 0.5,
                    fill: new ol.style.Fill({
                        color: '#000000'
                    }),
                    stroke: new ol.style.Stroke({
                        color: routeColor,
                        width:5
                    })
                })
            });

            var routeStroke = new ol.style.Stroke({
                color: routeColor,
                width: 7
            });
            var failedRouteStroke = new ol.style.Stroke({
                color: routeColor,
                width: 7,
                lineDash:[.1,10]
            });
            var toEnergyStroke = new ol.style.Stroke({
                color: '#000000',// routeColor,
                lineDash: [.1,10],
                lineCap:'round',
                width: 4
            });
            var geoType = feature.get("geoType");
            switch(geoType) {
                case 'route':
                    return [new ol.style.Style({
                        stroke: routeStroke
                    })];
                break;

                case 'route_failed':
                    return [new ol.style.Style({
                        stroke: failedRouteStroke
                    })];
                    break;

                case 'to_filling_station':
                    return [new ol.style.Style({
                        stroke: routeStroke

                    }),
                        new ol.style.Style({
                            stroke: toEnergyStroke

                        })];
                    break;
                case 'to_filling_station_failed':
                    return [new ol.style.Style({
                        stroke: failedRouteStroke

                    }),
                        new ol.style.Style({
                            stroke: toEnergyStroke

                        })];
                    break;
                case 'via_target':
                    var textStroke = new ol.style.Stroke({
                        color: '#fff',
                        width: 3
                    });
                    var textFill = new ol.style.Fill({
                        color: '#000'
                    });
                    var text = new ol.style.Style({
                        text: new ol.style.Text({
                            font: '12px Calibri,sans-serif',
                            text:feature.get('viaCounter'),
                            fill: textFill,
                            stroke: textStroke
                        })
                    });
                    var styles = [circleViaTarget,text];
                    return styles;
                break;

                case 'finalPosition':
                    var styles = [circleFinalPosition];
                    return styles;
                break;

                case 'start':
                    var styles = [startPosition];
                    return styles;

                default:
                    return[circleViaTarget]
            }
        }
        function selectStyleFunctionForRoutes(feature, resolution){
           //Get color for the car

            var routeColor = feature.get('color');
            var circleViaTarget = new ol.style.Style({
                image: new ol.style.Circle({
                    radius: 13,
                    fill: new ol.style.Fill({
                        color: routeColor
                    }),
                    stroke: new ol.style.Stroke({
                        color: '#000000'
                    })
                })
            });
            var circleFinalPosition = new ol.style.Style({//TODO add good picture here
                image: new ol.style.Icon({
                    src: "${g.resource( dir: '/images', file: 'finish.png' )}",
                    //radius: 10,
                    fill: new ol.style.Fill({
                        color: '#ff0000'
                    })/*
                    stroke: new ol.style.Stroke({
                        color: routeColor,
                        width:5
                    })*/
                })
            });

            var startPosition = new ol.style.Style({//TODO add good picture here
                image: new ol.style.Icon({
                    src: "${g.resource( dir: '/images', file: 'homeStart.png' )}",
                    scale: 0.5,
                    fill: new ol.style.Fill({
                        color: '#ff0000'
                    })/*
                     stroke: new ol.style.Stroke({
                     color: routeColor,
                     width:5
                     })*/
                })
            });

            var routeStroke = new ol.style.Stroke({
                color: routeColor,
                width: 7
            });
            var failedRouteStroke = new ol.style.Stroke({
                color: routeColor,
                width: 7,
                lineDash:[.1,10]
            });
            var toEnergyStroke = new ol.style.Stroke({
                color: '#000000',// routeColor,
                lineDash: [.1,10],
                lineCap:'round',
                width: 4
            });
            var geoType = feature.get("geoType");
            switch(geoType) {
                case 'route':
                    return [new ol.style.Style({
                        stroke: routeStroke
                    })];
                    break;

                case 'route_failed':
                    return [new ol.style.Style({
                        stroke: failedRouteStroke
                    })];
                    break;

                case 'to_filling_station':
                    return [new ol.style.Style({
                        stroke: routeStroke

                    }),
                        new ol.style.Style({
                            stroke: toEnergyStroke

                        })];
                    break;

                case 'to_filling_station_failed':
                    return [new ol.style.Style({
                        stroke:failedRouteStroke

                    }),
                        new ol.style.Style({
                            stroke: toEnergyStroke

                        })];
                    break;

                case 'via_target':
                        var textStroke = new ol.style.Stroke({
                            color: '#fff',
                            width: 5
                        });
                        var textFill = new ol.style.Fill({
                            color: '#000'
                        });
                        var text = new ol.style.Style({
                            text: new ol.style.Text({
                                font: '12px Calibri,sans-serif',
                                text: feature.get('viaCounter'),
                                fill: textFill,
                                stroke: textStroke
                            })
                        });
                        var styles = [circleViaTarget, text];
                        return styles
                        break;
                case 'finalPosition':
                    var styles = [circleFinalPosition];
                    return styles;
                    break;

                case 'start':
                    var styles = [startPosition];
                    return styles;
                    break;
                default:
                    return[circleViaTarget]
            }
        }


        //Create the map

        //Creating an Layer containing points of interest on the driven routes(for each Car)
        var allRouteLayers = [];

        //var layersForMap =

        var map = new ol.Map({

            target: 'map',
            layers: [
                new ol.layer.Group({
                    'title': 'Base maps',
                    layers: [
                        new ol.layer.Tile({
                            title: 'Toner view',
                            type: 'base',
                            visible: false,
                            source: new ol.source.Stamen({
                                layer: 'toner'
                            })
                        }),
                        new ol.layer.Tile({
                            title: 'OSM',
                            type: 'base',
                            visible: true,
                            source: new ol.source.OSM()
                        }),
                        new ol.layer.Tile({
                            title: 'Satellite',
                            type: 'base',
                            visible: false,
                            source: new ol.source.MapQuest({layer: 'sat'})
                        }),

                    ]
                }),
                new ol.layer.Group({
                    title: 'Overlays',
                    layers: [
                        new ol.layer.Tile({
                            title: 'Countries',
                            source: new ol.source.TileWMS({
                                url: 'http://demo.opengeo.org/geoserver/wms',
                                params: {'LAYERS': 'ne:ne_10m_admin_1_states_provinces_lines_shp'},
                                serverType: 'geoserver'
                            })
                        })
                    ]
                })
            ],

            interactions: ol.interaction.defaults().extend([new ol.interaction.Select({
                condition:  (ol.events.condition.pointerMove || ol.events.condition.click),
                layers:allRouteLayers,
                style: selectStyleFunctionForRoutes
            })]),
            view: new ol.View({
                center: ol.proj.fromLonLat([lon, lat]),
                zoom: 11
            })
        });

        var layerSwitcher = new ol.control.LayerSwitcher({
            tipLabel: 'Légende' // Optional label for button
        });
        map.addControl(layerSwitcher);

        <g:each var = "realRoute" in = "${realRoutes}">
        var realRoutes_features = new ol.format.GeoJSON().readFeatures(${realRoute},{featureProjection:'EPSG:3857'});
        var realRoutes_source = new ol.source.Vector();
        realRoutes_source.addFeatures(realRoutes_features);

        var realRoutes_layer = new ol.layer.Vector({
            source:realRoutes_source,
            opacity:0.6,
            style: styleFunctionForRoutes,
            title: 'Route'
                    <g:each var="car" in="${fleets.cars}" status="counter">
                        +"${car.name}"
                    </g:each>
        });
        allRouteLayers.push(realRoutes_layer);
        map.addLayer(realRoutes_layer);
        </g:each>
        <%-- add the unused stations --%>
        var unusedStations_features = new ol.format.GeoJSON().readFeatures(${fillingStations.unusedStations},{featureProjection:'EPSG:3857'});
        var unusedStations_source = new ol.source.Vector();
        unusedStations_source.addFeatures(unusedStations_features);
        var unusedStations_layer = new ol.layer.Vector({
            title: 'Not visited filling stations',
            source:unusedStations_source,
            opacity:0.2,
            style: styleFunctionForUnusedStations
        });
        map.addLayer(unusedStations_layer);

        <%-- add the used stations --%>
        var usedStations_features = new ol.format.GeoJSON().readFeatures(${fillingStations.usedStations},{featureProjection:'EPSG:3857'});
        var usedStations_source = new ol.source.Vector();
        usedStations_source.addFeatures(usedStations_features);
        var usedStations_layer = new ol.layer.Vector({
            title: 'Visited filling stations',
            source:usedStations_source,
            opacity:0.7,
            style: styleFunctionForUsedStations


        });



        map.addLayer(usedStations_layer);

        map.addOverlay(popup);
        map.on('click', function (evt) {
            var feature = map.forEachFeatureAtPixel(evt.pixel, function (feature) {
                return feature;
            });
            if(feature){

                var evtCoordinate = evt.coordinate;

                //$(element).popover('destroy');
                // the keys are quoted to prevent renaming in ADVANCED mode.
                var featureGeoType = feature.get('geoType');

                switch(featureGeoType){
                    case 'route':
                            content.innerHTML = '<table align="left"><tr><td>Car Status = '+ '<b>' + feature.get('carStatus') +'</b>' +'</td></tr>' +
                            '<tr><td>Car Type =  '+ '<b>' + feature.get('carType')+ '</b>' + '</td></tr>' +
                            '<tr><td>Consumed Energy = '+ '<b>'  +(Math.round(feature.get('consumedEnergy')))+'  kWh  </b></td></tr>' +
                            '<tr><td>Loaded Energy = '+ '<b>' + (Math.round(feature.get('loadedEnergy')))+' kWh </b></td></tr>' +
                            '<tr><td>Planned Distance = '+ '<b>' + (Math.round(feature.get('plannedDistance')))+' km </b></td></tr>' +
                            '<tr><td>Real Distance = '+'<b>' + (Math.round(feature.get('realDistance')))+' km</b></td></tr>'+
                            '<tr><td>Planned Time = '+'<b>' + ((feature.get('plannedTime')))+' </b></td></tr>'+
                            '<tr><td>Real Time = '+'<b>' +((feature.get('realTime')))+' </b></td></tr>'+
                            '<tr><td>Start Time = '+'<b>' +((feature.get('carStartTime')))   +' </b></td></tr>'+
                            '<tr><td>End Time = '+'<b>' +((feature.get('endCarTime')))   +' </b></td></tr>'+
                            '<tr><td>Start&End Akkuzustand = '+'<b>' +((feature.get('battery')))+'% - '  + ((feature.get('endBattery'))) + '%'  +' </b></td></tr>'+
                            '<tr><td>Nr. of Visited Filling-Stations = '+'<b>' +feature.get('fillingStationsVisited')+' </b></td></tr></table>'
                         popup.setPosition(evtCoordinate);
                        break;

                    case 'via_target':
                        var address = feature.get('streetName') ? feature.get('streetName') : "No address available";
                        content.innerHTML = '<table align="left"><tr><td>This is the:  '+ '<b>' + feature.get('viaCounter') +'</b>'+ '. customer'  +'</td></tr>' +
                         '<tr><td>Akku= '+ '<b>'  + '%' +'</b>'+"</td></tr>" +
                         '<tr><td>Time= '+ '<b>'   +'</b>'+" </td></tr>" +
                         '<tr><td>Address= '+ '<b>' + address + '</b>'+'</td></tr></table>'
                        var featureCoordinates = feature.getGeometry().getCoordinates();
                        popup.setPosition(featureCoordinates);
                        break;


                    case 'finalPosition':
                        var address = feature.get('streetName') ? feature.get('streetName') : "No address available";
                            content.innerHTML = "<p>Address: "+ '<b>' + address + '</b>'+" </p>"
                        var featureCoordinates = feature.getGeometry().getCoordinates();
                        popup.setPosition(featureCoordinates);
                        break;

                    case 'start':
                        var address = feature.get('streetName') ? feature.get('streetName') : "No address available";
                        content.innerHTML = "<p>Address: "+ '<b>' + address + '</b>'+" </p>"
                        var featureCoordinates = feature.getGeometry().getCoordinates();
                        popup.setPosition(featureCoordinates);
                        break;

                    case 'to_filling_station':
                        content.innerHTML = "<p>Umweg zu Ladestation</p>";
                        popup.setPosition(evtCoordinate);
                        break;

                    case 'route_failed':
                        content.innerHTML = "<p>Route nicht geschaft</p>";
                        popup.setPosition(evtCoordinate);
                        break;

                    case 'unusedStations_features':
                        content.innerHTML = "<p>Not used charging Stations</p>";
                        popup.setPosition(evtCoordinate);
                        break;

                    default:
                        content.innerHTML = "<p>No information for this feature available</p>" ;
                        popup.setPosition(evtCoordinate);

                }

                map.addOverlay(popup);
            }
            else if(popup.getPosition()){
                popup.setPosition(undefined);
            }
        });

    </script>
</div>
</body>
</html>