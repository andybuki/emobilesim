<%--
  Created by IntelliJ IDEA.
  User: simon
  Date: 23.10.15
  Time: 18:54
--%>

<%@ page import="de.dfki.gs.domain.utils.GroupStatus; de.dfki.gs.domain.utils.FleetStatus"  contentType="text/html;charset=UTF-8" %>

<html>
<head>
    <title><g:message code="configuration.index.newsimulation"/></title>
    <meta name="layout" content="mainConfigureSimulation" />

    <script src="http://openlayers.org/en/v3.10.0/build/ol.js"></script>

    <script src="${resource(dir: 'js',file:'ol3-layerswitcher.js')}"></script>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ol3-layerswitcher.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'css/ol3', file: 'ol.css')}" type="text/css"/>
</head>

<body>
<div class="pContainerConfigure">

    <div class="rowUp">
        <g:form action="changeName">
            <div class="leftBoldBig2">
                <g:message code="configuration.index.configuresimulation"/>: ${simulationName}
                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            </div>
        </g:form>
        <g:form action="changeArea">
            <div class="right0PX">
                <span class="rightBoldBig1">
                    ${simulationArea}
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                    <span class="rightBoldBig2">

                    </span>
                </span>
            </div>
        </g:form>

        <div class="clear"></div>
    </div>

    <div class="layout">
        <div id="map" class="map"></div>
    </div>
    <div class="formConfiguration">

        <br><br>
        <div class="layoutButton">
        <span class="layoutButtonL">
            <g:form controller="configuration" action="configureSimulation">
                <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                <span class="addButtonCancel">
                    <g:submitButton name="send" value="${message(code: 'configuration.index.back')}"/>
                </span>
                </span>
            </g:form>
        </span>
            <g:form action="saveFinishedConfigurationRoute">
                <g:if test="${notConfiguredFleets==1 || savedFleets == 1 || configuredFleets==1}">

                    <span class="layoutButtonM"></span>
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>

                    <span class="layoutButtonR"><g:submitButton name="send" value="${message(code: 'configuration.index.next')}"/></span>
                </g:if>
            </g:form>
        </div>



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

    var layerSwitcher = new ol.control.LayerSwitcher({
        tipLabel: 'Légende' // Optional label for button
    });
    map.addControl(layerSwitcher);

</script>
</body>
</html>