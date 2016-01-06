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
    <script src="${resource(dir: 'js', file: 'jquery.easytabs.js')}"></script>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'ol3-layerswitcher.css')}" type="text/css"/>
    <link rel="stylesheet" href="${resource(dir: 'css/ol3', file: 'ol.css')}" type="text/css"/>


    <script type="text/javascript">


        $(function()
        {
            var tabs = $('#tab-container');
            tabs.easytabs({ animate: false });
            disable_easytabs(tabs, [1,2]);
            tabs.bind("easytabs:before", function (e, clicked) {
                if(clicked.parent().hasClass('disabled')) {
                    return false;
                }
            });

            $("#modal-launcher, #modal-background, #modal-close").click(function () {
                $("#modal-content,#modal-background").toggleClass("active");
            });
        });

        function on_disable_b_and_c_clicked()
        {
            var tabs = $('#tab-container');
            disable_easytabs(tabs, [1,2]);
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
            <div class="pContainerConfigure">
                <div class="rowUp">
                    <div class="leftBoldBig1">
                        <g:message code= "stats.stats.statistics"/> ${simulationName}
                    </div>

                    <g:if test="${availableRoutes.size()>0}">
                        <div id = "RouteSelection">
                            <g:select name="customerPositionSetId" from="${availableRoutes}" optionKey="id" optionValue="${{it.name}}"
                                  noSelection='["":"${g.message(code:'configuration.index.savedroute')}"]'
                                  onchange="addRoute(this.value)"
                            />
                        </div>
                    </g:if>


                    <div class="right0PX">
                        <span class="rightBoldBig1">
                            <g:message code="configuration.index.simulationarea"/> ${simulationArea}
                        </span>
                    </div>

                    <div class="clear"></div>
                </div>

                <div class="layout">
                    <div class="layoutRight">
                        <div id="mapNew" class="map"></div>
                    </div>
                </div>
                <div class="formConfiguration">
                    <div class="layoutLeft12">
                        <div class="contentLeftBigConfiguration1">
                            <div class="rowGroup3">
                                <div>
                                    <g:form name="saveBaseAndTargetsForm" action="saveBaseAndTargets">
                                        <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                                        <g:hiddenField name="base" value=""/>
                                        <g:hiddenField name="targets" value=""/>
                                        <g:hiddenField name="savedRouteSelected" value=""/>
                                        <div id="saveSubmitButton"></div>
                                    </g:form>
                                </div>
                            </div>

                            <div class="clear"></div>
                        </div>
                    </div>
                    <div id="modal-background"></div>
                </div>
            </div>
        </div>
        <div id="tabs2">
        </div>
        <div id="tabs3">
        </div>
    </div>
    <div id="updateMe"></div>
</div>
</div>
<script type="text/javascript">
    var savedRouteSelected = -1;
    function addRoute(customerPositionSetId){

        ${remoteFunction(controller: 'configuration',
                                                          action: 'getJsonForAddedRoute',
                                                          params: '\'customerPositionSetId=\'+customerPositionSetId+\'&configurationStubId=\'+\'' + configurationStubId + '\'' ,
                                                          onSuccess: 'addRouteToMap(data);'
                                                  )}
    }
    function addRouteToMap(data){
        baseFeatures.clear();
        collection.clear();
        var addedRoute_features = new ol.format.GeoJSON().readFeatures(data,{featureProjection:'EPSG:3857'});
        var addedTargets_source = new ol.source.Vector({
            features:collection
        });
        var addedBase_source = new ol.source.Vector({
            features:baseFeatures
        });
        addedRoute_features.forEach(function(feature){
            if (feature.get("geoType")=="fleetBase"){
                addedBase_source.addFeature(feature);
                savedRouteSelected = feature.get("customerPositionSetId")
            }
            else{
                addedTargets_source.addFeature(feature);
                savedRouteSelected = feature.get("customerPositionSetId")
            }
        });


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
                color: '#3366ff',
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
                color: '#3366ff',
                width: 2
            }),
            image: new ol.style.Circle({
                radius: 7,
                fill: new ol.style.Fill({
                    color: '#3366ff'
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
        savedRouteSelected = -1;
    });
    modifyTarget.on('modifyend',function(){
        saveDataTarget();
        savedRouteSelected = -1;
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
        savedRouteSelected = -1;
    });
    collection.on('change:length',function(){
        saveDataTarget();
        savedRouteSelected = -1;
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
        if(collection.getLength()==1){
            <g:remoteFunction action="createSaveButton" update="saveSubmitButton"/>
        }
    }
    jQuery(function () {
        jQuery("[name='saveBaseAndTargetsForm']").submit(function () {
            jQuery("[name='base']").val(savedFeaturesBase);
            jQuery("[name='targets']").val(savedFeaturesTarget);
            jQuery("[name='savedRouteSelected']").val(savedRouteSelected)
        });

    });

</script>
<br/><br/>
</body>

</html>
