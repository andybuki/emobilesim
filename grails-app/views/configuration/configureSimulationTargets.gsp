<%--
  Created by IntelliJ IDEA.
  User: simon
  Date: 23.11.15
  Time: 10:05
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

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ol3-layerswitcher.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'css/ol3', file: 'ol.css')}" type="text/css"/>

</head>

<body>
<div class="pContainerConfigure">
    <div class="rowUp">
        <div class="leftBoldBig1">
            Simulation: ${simulationName}
        </div>

        <div class="right0PX">
            <span class="rightBoldBig1">
                <g:message code="configuration.index.simulationarea"/> ${simulationArea}
            </span>
        </div>

        <div class="clear"></div>
    </div>

    <div class="layout">


        <!--
        <div class="rowSpace">
            <div class="clear"></div>
        </div>

        <div class="rowGroup2">
        </div>

        <div class="rowSpace">
            <div class="clear"></div>
        </div>
        -->

<div class="layoutRight">
    <div id="map" class="map"></div>
</div>
</div>
<div class="formConfiguration">
    <g:form action="saveFinishedConfigurationFleet">
        <div class="layoutButton">
            <span class="layoutButtonL">
            </span>
            <g:if test="${notConfiguredFleets == 1 || savedFleets == 1 || configuredFleets == 1}">
                <span class="layoutButtonM"></span>
                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                <span class="layoutButtonR"><g:submitButton name="send"
                                                            value="${message(code: 'configuration.index.next')}"/></span>
            </g:if>
        </div>
    </g:form>
    <div class="layoutLeft2">
        <div class="contentLeftBigConfiguration1">
            <div class="rowGroup3">
                <div>
                    <g:form name="saveBaseAndTargetsForm" action="saveBaseAndTargets">
                        <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                        <g:hiddenField name="base" value=""/>
                        <g:hiddenField name="targets" value=""/>
                        <g:submitButton name="submit" value="Save"/>
                    </g:form>
                </div>
            </div>

            <div class="clear"></div>
        </div>
    </div>
    <div id="updateMe"></div>
</div>
</div>
<script type="text/javascript">
    var lon, lat; //This is the center of the picture
    <g:if test="${simulationArea == 'BERLIN'}">
    lon = 13.38;
    lat = 52.52;
    </g:if>
    <g:else>
    lon = 8.7;
    lat = 49.29;
    </g:else>
    <%--function newBase() {
        var coordinates = ol.proj.fromLonLat([lon, lat]);
        var baseFeature = new ol.Feature({
                geometry: new ol.geom.Point(coordinates),
                name: 'Base'
                });
        var baseStyle = new ol.style.Style({
            image: new ol.style.Icon(/** @type {olx.style.IconOptions} */({
               // anchor: [0,0],
               // anchorXUnits: 'fraction',
               // anchorYUnits: 'pixels',
                opacity: 1,
                src: "${g.resource( dir: '/images', file: 'garage_open.png' )}"
            }))
        });
        baseFeature.setStyle(baseStyle);
        baseLayer = new ol.layer.Vector({
            source: new ol.source.Vector({
                features: [baseFeature]
            }),
            style: new ol.style.Style({
                stroke: new ol.style.Stroke({
                    width: 10,
                    color: [255, 0, 0, 1]
                }),
                fill: new ol.style.Fill({
                    color: [0, 0, 255, 0.6]
                })
            })
        });
        map.addLayer(baseLayer)
        featureOverlay.addFeatures([baseFeature]);
    }--%>


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
    var baseFeatures = new ol.Collection();
    var featureOverlayForBase = new ol.layer.Vector({
        map: map,
        source: new ol.source.Vector({
            features: baseFeatures,
            useSpatialIndex: false // optional, might improve performance
        }),
        style: overlayStyleFunctionForBase,
        updateWhileAnimating: true, // optional, for instant visual feedback
        updateWhileInteracting: true // optional, for instant visual feedback
    });
    function overlayStyleFunctionForBase(feature, resolution){

        var styles = [  new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#ffcc33',
                width: 2
            }),
            image: new ol.style.Circle({
                radius: 14,
                fill: new ol.style.Fill({
                    color: '#ff0000'
                })
            })
        })];
        return styles
    }

    var collection = new ol.Collection();
    var featureOverlay = new ol.layer.Vector({
        map: map,
        source: new ol.source.Vector({
            features: collection,
            useSpatialIndex: false // optional, might improve performance
        }),
        style: overlayStyleFunction,
        updateWhileAnimating: true, // optional, for instant visual feedback
        updateWhileInteracting: true // optional, for instant visual feedback
    });
    function overlayStyleFunction(feature, resolution){

        var styles = [  new ol.style.Style({
            fill: new ol.style.Fill({
                color: 'rgba(255, 255, 255, 0.2)'
            }),
            stroke: new ol.style.Stroke({
                color: '#ffcc33',
                width: 2
            }),
            image: new ol.style.Circle({
                radius: 7,
                fill: new ol.style.Fill({
                    color: '#ffcc33'
                })
            })
        })];
        return styles
    }
    var modifyBase = new ol.interaction.Modify({
        features: baseFeatures,
        // the SHIFT key must be pressed to delete vertices, so
        // that new vertices can be drawn at the same position
        // of existing vertices
        deleteCondition: function(event) {
            return ol.events.condition.shiftKeyOnly(event) &&
                    ol.events.condition.singleClick(event);
        }
    });
    var modifyTarget = new ol.interaction.Modify({
        features: collection,
        // the SHIFT key must be pressed to delete vertices, so
        // that new vertices can be drawn at the same position
        // of existing vertices
        deleteCondition: function(event) {
            return ol.events.condition.shiftKeyOnly(event) &&
                    ol.events.condition.singleClick(event);
        }
    });
    map.addInteraction(modifyBase);
    map.addInteraction(modifyTarget);
    modifyBase.on('modifyend',function(){
        saveDataBase();
    });
    modifyTarget.on('modifyend',function(){
        saveDataTarget();
    })
    var draw; // global so we can remove it later
    function addInteractionDrawBase() {
        draw = new ol.interaction.Draw({
            features: baseFeatures,
            type: 'Point',
            style: overlayStyleFunctionForBase,
            condition: function(evt){
                var cityFeatures = berlinLayer.getSource().getFeaturesAtCoordinate(evt.coordinate);
                var cityFeature = cityFeatures["0"];
                return (cityFeatures.length>0&&cityFeature.get('city') == "${simulationArea}");
            }
        });
        map.addInteraction(draw);
    }
    var returnvalue = false;
    function addInteractionDrawTarget() {
        draw = new ol.interaction.Draw({
            features: collection,
            type: 'Point',
            style: overlayStyleFunction,
            condition: function(evt){
                var cityFeatures = berlinLayer.getSource().getFeaturesAtCoordinate(evt.coordinate);
                var cityFeature = cityFeatures["0"];
                return (cityFeatures.length>0&&cityFeature.get('city') == "${simulationArea}");
            }

        });
        map.addInteraction(draw);
    }
        addInteractionDrawBase()


    var layerSwitcher = new ol.control.LayerSwitcher({
        tipLabel: 'Légende' // Optional label for button
    });

    map.addControl(layerSwitcher);


    baseFeatures.on('change:length',function(){
        map.removeInteraction(draw);
        addInteractionDrawTarget();
        saveDataBase();
    });
    collection.on('change:length',function(){
        saveDataTarget();
    });
    var savedFeaturesBase;
    function saveDataBase(){

        var format = new ol.format.GeoJSON;
        savedFeaturesBase = format.writeFeatures(baseFeatures.getArray(), {
            featureProjection: map.getView().getProjection()
        });
    }
    var savedFeaturesTarget;
    function saveDataTarget(){
        var format = new ol.format.GeoJSON;
        savedFeaturesTarget =  format.writeFeatures(collection.getArray(),{
            featureProjection: map.getView().getProjection()
        });
    }
    jQuery(function () {
        jQuery("[name='saveBaseAndTargetsForm']").submit(function () {
            jQuery("[name='base']").val(savedFeaturesBase);
            jQuery("[name='targets']").val(savedFeaturesTarget);
        });
    });

</script>
</body>

</html>
