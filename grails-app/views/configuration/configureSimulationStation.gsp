<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 22.06.15
  Time: 21:57
--%>
<%@ page import="de.dfki.gs.domain.utils.GroupStatus; de.dfki.gs.domain.utils.FleetStatus"  contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title><g:message code="configuration.index.newsimulation"/></title>
    <meta name="layout" content="mainConfigureSimulation" />
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
    <script src="${resource(dir: 'js', file: 'jquery.easytabs.js')}"></script>

    <script src="http://openlayers.org/en/v3.11.2/build/ol-debug.js"></script><%--TODO put /ol.js here --%>
    <script src="${resource(dir: 'js', file: 'ol3-layerswitcher.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.easytabs.js')}"></script>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ol3-layerswitcher.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'css/ol3', file: 'ol.css')}" type="text/css"/>

    <script type="text/javascript">


        $(function()
        {
            var tabs = $('#tab-container');
            tabs.easytabs({defaultTab:"#tabo3"} );
            disable_easytabs(tabs, [1,0]);

            tabs.bind("easytabs:before", function (e, clicked) {
                if(clicked.parent().hasClass('disabled')) {
                    return false;
                }
            });
        });

        function on_disable_b_and_c_clicked()
        {
            var tabs = $('#tab-container');
            disable_easytabs(tabs, [1,0]);
            return false;
        }


        function disable_easytabs(tabs, indexes)
        {
            var lis = tabs.children('ul').children();
            var index = 0;
            lis.each(function()
            {
                var li = $(this);
                var a = li.children('a');
                var disabled = $.inArray(index, indexes) != -1;
                if (disabled)
                {
                    li.addClass('disabled');
                }
                else
                {
                    li.removeClass('disabled');
                }
                index++;
            });
        }

    </script>



    <style>
    .rowUp3 {
        background-color: #ccffaa;
        border: 0px solid #ddd;
    }
    </style>
</head>

<body>
<div id="tab-container" class='tab-container'>
    <ul class='etabs1'>
        <li class='tab' id="tabo1"><a  href="#tabs1"><g:message code="configuration.index.configureroute"/></a></li>
        <li class='tab' id="tabo2"><a  href="#tabs2"><g:message code="configuration.index.configurefleet"/></a></li>
        <li class='tab' id="tabo3"><a  href="#tabs3"><g:message code="configuration.index.configurestation"/></a></li>
    </ul>
    <div class='panel-container'>
        <div id="tabs1">

        </div>
        <div id="tabs2">

        </div>
        <div id="tabs3">
            <div class="pContainerConfigure">
                <div class="rowUp3">
                    <div class="leftBoldBig1">
                        <g:message code= "stats.stats.statistics"/> ${simulationName}
                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                        <g:if test="${availableFillingStationGroups != null && availableFillingStationGroups.size() > 0}">
                            <div class="rowMiddleWithoutBorder22">
                                <span style="float:left;">


                                    <g:form controller="configuration" action="addExistentGroupToConfiguration">
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <g:select name="groupId" from="${availableFillingStationGroups}" optionKey="id" optionValue="${{"${g.message(code:'execution.playsimulation.electricstations')}: " + it.name+' ('+it.fillingStations?.size()+' Stations)'}}" />
                                        <g:submitButton name="add" onclick="window.location.reload()" value="${message(code: 'configuration.index.addgrouptosimulation')}" />
                                    </g:form>

                                </span>
                                <span style="float:right; padding-left: 5px;">
                                    <g:form action="createGroupView">

                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <g:submitToRemote url="[action: 'createGroupView']" update="updateMe" name="submit" value="${message(code: 'configuration.index.createnewgroup')}" />
                                    </g:form>
                                </span>
                            </div>
                        </g:if>
                    </div>

                    <div class="right0PX">
                        <span class="rightBoldBig3">
                            <g:message code="configuration.index.simulationarea"/> ${simulationArea}
                        </span>
                    </div>

                    <div class="clear"></div>
                </div>
                <div class="layout">
                    <div class="layoutRight">
                        <div id="mapNew" class="map"></div>
                        <div class="rowGroup">
                            <g:if test="${addedGroups != null && addedGroups.size() > 0}">
                                <g:each in="${addedGroups}" var="addedGroup">
                                    <g:form controller="configuration" action="removeGroupFromConfiguration">
                                        <div class="rowMiddleWithoutBorder">
                                            <g:if test="${addedGroup.groupStatus == GroupStatus.CONFIGURED}">
                                                <div class="leftCollectFleets0">
                                                    ${addedGroup.name} (${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/> ) <img class="helpButton" title="<g:message code="configuration.index.allstations"/>" src="${g.resource( dir: '/images', file: 'checked.png' )}"/>
                                                </div>
                                            </g:if>
                                            <g:if test="${addedGroup.groupStatus == GroupStatus.SCHEDULED_FOR_CONFIGURING}">
                                                <div class="leftCollectFleets0">
                                                    ${addedGroup.name} ( ${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/>  ) <img class="helpButton" title="<g:message code="configuration.index.schedulestation"/>" src="${g.resource( dir: '/images', file: 'helpnew.png' )}"/>
                                                </div>
                                            </g:if>

                                            <g:if test="${addedGroup.groupStatus == GroupStatus.NOT_CONFIGURED}">
                                                <div class="leftCollectFleets0">
                                                    ${addedGroup.name} ( ${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/>  ) <img class="helpButton" title="<g:message code="configuration.index.stationsconfigured"/>" src="${g.resource( dir: '/images', file: 'attention.png' )}"/>
                                                </div>
                                            </g:if>

                                            <div class="right1165PX">


                                                <g:form controller="configuration" action="removeFleetFromConfiguration">
                                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                    <g:hiddenField name="groupId" value="${addedGroup.id}"/>
                                                    <button id="modal-close">
                                                        <g:img name="removeFleet" class="logoutexit" uri="${resource(dir: '/images', file: 'closesim.png')}"/>
                                                    </button>
                                                </g:form>

                                            </div>

                                            <div class="right100PX">
                                                <%--<g:if test="${addedGroup.groupStatus == GroupStatus.CONFIGURED}">
                                                    <g:form action="showGroupStationsOnMap">
                                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}" />
                                                        <g:submitToRemote class="addButton"
                                                                          url="[action: 'showGroupStationsOnMap']"
                                                                          update="updateMe"
                                                                          name="showGroups"
                                                                          value="${message(code: 'configuration.index.showstations')}" />

                                                    </g:form>
                                                </g:if>--%>
                                                <span class="konfiguration">
                                                    <g:if test="${addedGroup.groupStatus == GroupStatus.SCHEDULED_FOR_CONFIGURING}">
                                                        <g:message code="configuration.index.pleasewait"/>
                                                    </g:if>
                                                </span>
                                                <g:if test="${addedGroup.groupStatus == GroupStatus.NOT_CONFIGURED}">
                                                    <g:form action="createGroupSelectorView">
                                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                        <g:hiddenField name="groupId" value="${addedGroup.id}"/>
                                                        <g:submitToRemote class="addButton"
                                                                          url="[action: 'createGroupSelectorView']"
                                                                          update="updateMe"
                                                                          name="submit"
                                                                          value="${message(code: 'configuration.index.configurestations')}" />
                                                    </g:form>
                                                </g:if>
                                            </div>
                                            <div class="clear"></div>
                                        </div>
                                    </g:form>

                                </g:each>
                            </g:if>
                        </div>


                    </div>
                </div>
                <div class="formConfiguration">
                    <g:if test="${(configuredGroups==1 && configuredFleets==1 && savedGroups==0 && savedFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0)}">
                        <div class="layoutButton">
                            <g:form controller="execution" action="executeExperiment">
                                <span class="layoutButtonM"></span>
                                <g:hiddenField name="relativeSearchLimit" value="20" />
                                <g:hiddenField name="configurationId" value="${configurationStubId}"/>
                                <span class="layoutButtonR">
                                    <g:submitButton name="send" value="${message(code: 'configuration.index.execute')}"/>
                                </span>

                            </g:form>
                        </div>
                    </g:if>
                    <div id="updateMe"></div>
                </div>
            </div>
        </div>
    </div>

</div>


<script type="text/javascript">

    var container = document.getElementById('popup');
    var content = document.getElementById('popup-content');
    var closer = document.getElementById('popup-closer');
    /**
     * Add a click handler to hide the popup.
     * @return {boolean} Don't follow the href.
     */
    //closer.onclick = function() {
    //popup.setPosition(undefined);
    //closer.blur();
    //return false;
    //};

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

        target: 'mapNew',
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

    <g:each in="${fleets.cars}" var="cars">
    <g:each in="${cars}" var="car">

    var realRoutes_layer = new ol.layer.Vector({
        source:realRoutes_source,
        opacity:0.6,
        style: styleFunctionForRoutes,
        title: 'Route for:'
        <%--<g:each var="car" in="${fleets.cars}" status="counter">--%>

        +  "${car.name}"

        <%-- +"${car.name}"
     </g:each>--%>
    });
    </g:each>
    </g:each>

    allRouteLayers.push(realRoutes_layer);
    map.addLayer(realRoutes_layer);
    </g:each>
    <%-- add the unused stations --%>


    var startPosition_layer = new ol.layer.Vector({
        title: 'Start Position',
        opacity: 0.5,
        style:styleFunctionForRoutes

    });


    map.addLayer(startPosition_layer);
    map.addOverlay(popup);


</script>

</body>
</html>