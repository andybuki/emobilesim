<%--
  Created by IntelliJ IDEA.
  User: simon
  Date: 24.10.15
  Time: 17:40
--%>

<%@ page import="de.dfki.gs.domain.utils.GroupStatus; de.dfki.gs.domain.utils.FleetStatus"  contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="configuration.index.newsimulation"/></title>
    <meta name="layout" content="mainConfigureSimulation" />
    <calendar:resources lang="en" theme="tiger"/>
    <script src="http://openlayers.org/en/v3.10.0/build/ol.js"></script>

    <script src="${resource(dir: 'js',file:'ol3-layerswitcher.js')}"></script>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ol3-layerswitcher.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'css/ol3', file: 'ol.css')}" type="text/css"/>


</head>
<body>
<div class="pContainerConfigure">
    <div class="rowUp">
        <g:form action="changeName">
            <div class="leftBoldBig1">
                <g:message code="configuration.index.configuresimulation"/> <g:textField name="nameForSimulation" value="${simulationName}"/>
                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                <g:submitButton name="ok" value="Ok" />
            </div>
        </g:form>

            <div class="right0PX">
                <span class="rightBoldBig1">
                    <g:message code="configuration.index.simulationarea"/>: ${simulationArea}
                </span>
            </div>
        >
        <div class="clear"></div>
    </div>
    <div class="layout">
        <div class="layoutLeft1">
            <div class="contentLeftBigConfiguration">

                <div class="rowGroup1">
                    <g:if test="${availableFleets != null && availableFleets.size() > 0}">
                        <div class="rowMiddleWithoutBorder22">
                                <div class="leftText"><g:message code="simulation.index.existentfleet"/></div>
                            <div class="rightOnlyButton">

                                    <div id = "fleetSelection">
                                        <g:select name="fleetId" from="${availableFleets}" optionKey="id" optionValue="${{it.name+' ('+it.cars?.size()+' Cars)'}}"
                                                  noSelection="['':'Select Fleet']"
                                                  onchange="addFleet(this.value)"
                                                 />
                                    </div>
                            </div>
                            <div class="clear"></div>
                        </div>
                    </g:if>
                    <br>
                    <div class="rowMiddleWithoutBorder22">
                        <g:form action="createFleetView">
                            <div class="left1800PX">
                                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                <g:submitToRemote class="addButton"
                                                  url="[action: 'createFleetView']"
                                                  update="updateMe"
                                                  name="submit"
                                                  value="${message(code: 'simulation.index.createnewfleet')}" />
                            </div>
                            <div class="clear"></div>
                        </g:form>
                    </div>
                </div>

                <div class="rowSpace">
                    <div class="clear"></div>
                </div>


            </div>
        </div>
        <div class="layoutRight">
            <div id="map" class="map"></div>
        </div>
    </div>
    <div class="formConfiguration">
        <g:form action="saveFinishedConfigurationFleet">
            <br><br>
            <div class="layoutButton">
                <span class="layoutButtonL">
                </span>
                <g:if test="${notConfiguredFleets==1 || savedFleets == 1 || configuredFleets==1}">
                    <span class="layoutButtonM"></span>
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                    <span class="layoutButtonR"><g:submitButton name="send" value="${message(code: 'configuration.index.next')}"/></span>
                </g:if>
            </div>
        </g:form>

        <div id="updateMe"></div>
    </div>
</div>
<script type="text/javascript">




    var lon,lat; //This is the center of the picture
    <g:if test="${simulationArea == 'BERLIN'}">
    lon = 13.38;
    lat = 52.52;
    </g:if>
    <g:else>
    lon = 8.7;
    lat = 49.29;
    </g:else>
    function addFleet(fleetId){
        ${remoteFunction (controller: 'configuration',
                                                          action: 'addExistentFleetToConfiguration',
                                                          params: '\'fleetId=\'+fleetId+\'&configurationStubId=\'+\'' + configurationStubId + '\'' ,
                                                          update: 'fleetSelection'
                                                  )}
        ${remoteFunction(controller: 'configuration',
                                                          action: 'getJsonForAddedFleet',
                                                          params: '\'fleetId=\'+fleetId+\'&configurationStubId=\'+\'' + configurationStubId + '\'' ,
                                                          onSuccess: 'addFleetToMap(data);'
                                                  )}
    }
    function addFleetToMap(data){
        var addedFleet_features = new ol.format.GeoJSON().readFeatures(data,{featureProjection:'EPSG:3857'});
        var addedFleet_source = new ol.source.Vector();
        addedFleet_source.addFeatures(addedFleet_features);

        var addedFleet_layer = new ol.layer.Vector({
            source:addedFleet_source,
            opacity:0.6,
            style: styleFunctionForAddedFleet,
            title: "addedFleet"
        });
        map.addLayer(addedFleet_layer)
        map.addLayer(testLayer)

    }

    function styleFunctionForAddedFleet(feature, resolution){
        var styles = [circleFinalPosition];
        return styles;
    }
    var circleFinalPosition = new ol.style.Style({//TODO add good picture here
        image: new ol.style.Circle({
            radius: 10,
            fill: new ol.style.Fill({
                color: '#000000'
            }),
            stroke: new ol.style.Stroke({
                color: '#ff0000',
                width:5
            })
        })
    });

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

        /*interactions: ol.interaction.defaults().extend([new ol.interaction.Select({
         condition:  (ol.events.condition.pointerMove || ol.events.condition.click),
         layers:allRouteLayers,
         style: selectStyleFunctionForRoutes
         })]),*/
        view: new ol.View({
            center: ol.proj.fromLonLat([lon, lat]),
            zoom: 11
        })
    });

    var polygonFeature = new ol.Feature(
            new ol.geom.Polygon([[[-3e6, -1e6], [-3e6, 1e6],
                [-1e6, 1e6], [-1e6, -1e6], [-3e6, -1e6]]]));
    var testLayer = new ol.layer.Vector({
        source: new ol.source.Vector({
            features: [polygonFeature]
        }),
        style: new ol.style.Style({
            stroke: new ol.style.Stroke({
                width: 3,
                color: [255, 0, 0, 1]
            }),
            fill: new ol.style.Fill({
                color: [0, 0, 255, 0.6]
            })
        })
    });


    var layerSwitcher = new ol.control.LayerSwitcher({
        tipLabel: 'Légende' // Optional label for button
    });
    map.addControl(layerSwitcher);

</script>
</body>

</html>
