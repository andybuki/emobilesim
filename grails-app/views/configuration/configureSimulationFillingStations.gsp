<%--
  Created by IntelliJ IDEA.
  User: simon
  Date: 19.12.15
  Time: 15:16
--%>
<%@ page import="de.dfki.gs.domain.utils.GroupStatus; de.dfki.gs.domain.utils.FleetStatus" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="configuration.index.newsimulation"/></title>
    <meta name="layout" content="mainConfigureSimulation"/>
    <calendar:resources lang="en" theme="tiger"/>
    <g:javascript src="jq/jquery-1.9.1.js" />
    <script src="http://openlayers.org/en/v3.11.2/build/ol-debug.js"></script><%--TODO put /ol.js here --%>
    <script src="${resource(dir: 'js', file: 'ol3-layerswitcher.js')}"></script>
    <script src="${resource(dir: 'js', file: 'jquery.easytabs.js')}"></script>
    <g:javascript src="jquery.loading.js"/>
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
        <li class='tab' id="tabo1"><a  href="#tabs1"><g:message code="configuration.index.configureroute" /></a></li>
        <li class='tab' id="tabo2"><a  href="#tabs2"><g:message code="configuration.index.configurefleet" /></a></li>
        <li class='tab' id="tabo3"><a  href="#tabs3"><g:message code="configuration.index.configurestation" /></a></li>
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
                        <g:message code= "configuration.index.simulationarea"/> ${simulationName}


                    <g:if test="${manualSelection}">
                        Ladestationtyp:
                        <g:select id="fillingStationType" name="stationTypeId"
                                  from="${availableFillingStationTypes}" optionKey="id" optionValue="name"
                        />

                        <span style="float:right; padding-left: 5px;">
                            <g:form name="saveFillingStationsForm" action="saveFillingStations">
                                <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                                <g:hiddenField name="stations" value=""/>
                                <g:hiddenField name="savedRouteSelected" value=""/>
                                <span  id="saveSubmitButton"></span>
                            </g:form>
                        </span>
                        <span style="float:right; padding-left: 5px;">
                            <g:form name="changeSelectionType" action="changeSelectionType">
                                <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                                <g:hiddenField name="manualSelection" value="${!manualSelection}"/>
                                <g:submitButton name="changeToSavedStations" value="${g.message(code:'configuration.index.savedFillingStations')}" />
                            </g:form>
                        </span>

                    </g:if>
                    <g:else>

                        <span style="float:right; padding-left: 5px;">
                            <g:form name="changeSelectionType" action="changeSelectionType">
                                <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                                <g:hiddenField name="manualSelection" value="${!manualSelection}"/>
                                <g:submitButton name="changeToSavedStations" value="Create Stations On Map" />
                            </g:form>
                        </span>

                        <span style="float:right; padding-left: 5px;">
                            <g:form controller="configuration" action="addExistentGroupToConfiguration">
                                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                <g:select name="groupId" from="${availableFillingStationGroups}" optionKey="id"
                                          optionValue="${{"${g.message(code:'execution.playsimulation.electricstations')}: " +
                                                  it.name+' ('+it.fillingStations?.size()+' Stations)'}}"
                                          onchange="addStations(this.value)"
                                          noSelection='["":"${g.message(code:'configuration.index.savedFillingStations')}"]'
                                />
                                <span style="float:right; padding-left: 5px;"><g:submitButton name="add"  value="${message(code: 'configuration.index.addgrouptosimulation')}" /></span>
                            </g:form>
                        </span>


                    </g:else>
                    </div>
                    <div class="right0PX">
                        <span class="rightBoldBig1">
                            <g:message code="configuration.index.simulationarea"/> ${simulationArea}
                        </span>
                    </div>

                    <div class="clear"></div>
                </div>

                <div class="layout">
                    <div class="layoutLeftStation">
                        <g:each in="${addedFillingStationGroups}" var="addedGroup">
                        <%--<g:message code="simulation.index.addedfleet"/>--%>
                            <div class="rowMiddleWithoutBorder">
                                <div class="leftCollectFleets">
                                    ${addedGroup.name} ( ${addedGroup.fillingStations.size()} <g:message code="configuration.executesim.fillingstations"/> )
                                </div>
                            <div>
                                 <g:form controller="configuration" action="removeGroupFromConfiguration">
                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                    <g:hiddenField name="groupId" value="${addedGroup.id}"/>
                                    <g:submitButton name="removeGroup" value="${message(code: 'configuration.index.unselect')}"/>
                                </g:form>
                            </div>
                            </div>
                        </g:each>
                    </div>
                    <div class="clear">
                    </div>

                    <div class="layoutRight">
                        <div id="mapNew" class="map"></div>
                    </div>
                </div>
                <div class="formConfiguration">
                    <div class="layoutLeft12">
                        <div class="contentLeftBigConfiguration1">
                            <div class="rowGroup3">
                                <div class="layoutButton">
                                <g:if test="${addedFillingStationGroups.size()>0}">
                                    <g:form controller="execution" action="executeExperiment">
                                        <span class="layoutButtonM"></span>
                                        <g:hiddenField name="relativeSearchLimit" value="20" />
                                        <g:hiddenField name="configurationId" value="${configurationStubId}"/>
                                        <span class="layoutButtonR">
                                            <g:submitButton name="send" value="${message(code: 'configuration.index.execute')}"/>
                                        </span>

                                    </g:form>
                                </g:if>
                                </div>
                            </div>

                            <div class="clear"></div>
                        </div>
                    </div>
                    <div id="modal-background"></div>
                </div>
            </div>
        </div>
    </div>
    <div id="updateMe"></div>
</div>
</div>
<script type="text/javascript">
   function addStations(groupId){
       if(groupId){
           ${remoteFunction(controller: 'configuration',
                                                          action: 'getJsonForGroup',
                                                          params: '\'groupId=\'+groupId+\'&configurationStubId=\'+\'' + configurationStubId + '\'' ,
                                                          onSuccess: 'addGroupToMap(data);'
                                                  )}
       }
    }
    function addGroupToMap(data){
        addedGroup_source.clear()
        var addedGroup_features = new ol.format.GeoJSON().readFeatures(data,{featureProjection:'EPSG:3857'});
        addedGroup_source.addFeatures(addedGroup_features)
    }


    var lon, lat; //This is the center of the picture
    <g:if test="${simulationArea == 'BERLIN'}">
    lon = 13.38;
    lat = 52.52;
    </g:if>
    <g:else>
    lon = 8.7;
    lat = 49.29;
    </g:else>


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


        view: new ol.View({
            center: ol.proj.fromLonLat([lon, lat]),
            zoom: 11
        })
    });
    var layerSwitcher = new ol.control.LayerSwitcher({
        tipLabel: 'Légende' // Optional label for button
    });
    //map.addLayer(group_layer);
    map.addControl(layerSwitcher);

    //Layers

    var berlinLayer = new ol.layer.Vector({
        title: 'Berlin Polygon',
        source: new ol.source.Vector({
            projection : map.getView().getProjection(),
            url:<g:if test="${simulationArea == 'BERLIN'}">
                    "${g.resource( dir: '/geojson', file: 'berlinPolygon.json' )}",
            </g:if>
            <g:else>
            "${g.resource( dir: '/geojson', file: 'berlinPolygon.json' )}", //Should be wieslochPolygon,json
            </g:else>
            format: new ol.format.GeoJSON()
        }),
        style:  new ol.style.Style({
            stroke: new ol.style.Stroke({
                color: '#ff0000',
                width: 2
            })
        })
    })
    map.addLayer(berlinLayer);


    <g:each var = "route" in = "${routes}">
    var realRoutes_features = new ol.format.GeoJSON().readFeatures(${route},{featureProjection:'EPSG:3857'});

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
    map.addLayer(realRoutes_layer);
    </g:each>

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
    function fillingStationStyleFunction(feature, resolution){

        var stationImageSrc;
        if(feature){
            var stationType = feature.get("fillingStationTypeId");
        }
        else{
            var stationType = fillingStationTypeId;
        }


        switch(stationType){
            case "1":
                stationImageSrc= "${g.resource( dir: '/images', file: '2.3aku.png' )}";
                break;

            case "2":
                stationImageSrc= "${g.resource( dir: '/images', file: '3.7aku.png' )}";
                break;

            case "3":
                stationImageSrc= "${g.resource( dir: '/images', file: '7.4aku.png' )}";
                break;

            case "4":
                stationImageSrc= "${g.resource( dir: '/images', file: '11.1aku.png' )}";
                break;

            case "7":
                stationImageSrc= "${g.resource( dir: '/images', file: '49.8aku.png' )}";
                break;

            case "6":
                stationImageSrc= "${g.resource( dir: '/images', file: '43aku.png' )}";
                break;



            default:
                stationImageSrc= "${g.resource( dir: '/images', file: '22.2aku.png' )}";
                //return stationImageSrc;
                //break;
        }

        var styles = [  new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#ffcc33',
                width: 2
            }),



            image: new ol.style.Icon(/** @type {olx.style.IconOptions} */ ({
                anchor: [0.5, 26],
                anchorXUnits: 'fraction',
                anchorYUnits: 'pixels',
                opacity: 0.75,
                src:stationImageSrc,
                size: [52,46]

            }))

        })];
        return styles
    }
    ////////////////////////////////////
    <g:if test="${manualSelection}">
   var fillingStationFeatures = new ol.Collection();
   var featureOverlayForBase = new ol.layer.Vector({
       map: map,
       source: new ol.source.Vector({
           features: fillingStationFeatures,
           useSpatialIndex: false // optional, might improve performance
       }),
       style: fillingStationStyleFunction(),
       updateWhileAnimating: true, // optional, for instant visual feedback
       updateWhileInteracting: true // optional, for instant visual feedback
   });

    var modifyFillingStations = new ol.interaction.Modify({
        features: fillingStationFeatures,
        // the SHIFT key must be pressed to delete vertices, so
        // that new vertices can be drawn at the same position
        // of existing vertices
        deleteCondition: function(event) {
            return ol.events.condition.shiftKeyOnly(event) &&
                    ol.events.condition.singleClick(event);
        }
    });
    map.addInteraction(modifyFillingStations);

    modifyFillingStations.on('modifyend',function(){
        saveFillingStation();
    });

    var typeSelect = document.getElementById('fillingStationType');
    var fillingStationTypeId = typeSelect.value;

    typeSelect.onchange = function(e) {
        fillingStationTypeId = typeSelect.value;
        map.removeInteraction(draw);
        addDrawInteraction();
        map.removeLayer(featureOverlayForBase);
        map.addLayer(featureOverlayForBase);

    };


    var draw;
    function addDrawInteraction(){
        draw = new ol.interaction.Draw({
            features: fillingStationFeatures,
            type: 'Point',
            style: fillingStationStyleFunction(),
            condition: function(evt){
                var cityFeatures = berlinLayer.getSource().getFeaturesAtCoordinate(evt.coordinate);
                var cityFeature = cityFeatures["0"];
                return (cityFeatures.length>0&&cityFeature.get('city') == "${simulationArea}");
            }
        });
        map.addInteraction(draw);
        draw.on('drawend', function(e) {
            e.feature.setProperties({
                'fillingStationTypeId' : fillingStationTypeId
            });
            console.log(e.feature, e.feature.getProperties());
            featureOverlayForBase.setStyle(fillingStationStyleFunction)
        });
    }
    addDrawInteraction();





    fillingStationFeatures.on('change:length',function(){
        saveFillingStation();
    });

    var savedFeaturesFillingStations;
    function saveFillingStation(){

        var format = new ol.format.GeoJSON;
        savedFeaturesFillingStations = format.writeFeatures(fillingStationFeatures.getArray(), {
            featureProjection: map.getView().getProjection()
        });
        if(fillingStationFeatures.getLength()==1){
            <g:remoteFunction action="createSaveButton" update="saveSubmitButton"/>
        }
    }

    jQuery(function () {
        jQuery("[name='saveFillingStationsForm']").submit(function () {
            jQuery("[name='stations']").val(savedFeaturesFillingStations);
            jQuery("[name='savedRouteSelected']").val(savedRouteSelected)
        });

    });
    </g:if>
    <g:else>
    var addedGroup_source = new ol.source.Vector();
    var group_layer= new ol.layer.Vector({
        source:addedGroup_source,
        opacity:0.8,
        style: fillingStationStyleFunction,
        title: 'Route for: Group'
    });
    map.addLayer(group_layer);
    </g:else>


</script>
<br/><br/>
</body>

</html>
