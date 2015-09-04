<script language="javascript">
    $(document).ready(function() {
        $(".tabs-menu a").click(function(event) {
            event.preventDefault();
            $(this).parent().addClass("current");
            $(this).parent().siblings().removeClass("current");
            var tab = $(this).attr("href");
            $(".tab-content").not(tab).css("display", "none");
            $(tab).fadeIn();
        });
    });
</script>

<div id="openModal" class="modalDialogRoutes">
    <div class="settingsWindowBig">
        <fieldset class="fieldSet100Percent">
            <legend> <g:message code="templates.configuration.group._distribution.selectstations"/> </legend>
            <div class="layout">
                <div class="layoutLeftLittle">
                    <div class="contentLeft4">
                        <g:form controller="configuration" action="createDistributionForGroup">
                            <div class="contentLeftRoutes">
                                <div class="rowUp">
                                    <div class="leftbig"><b><g:message code="templates.configuration.group._distribution.properties"/></b></div>
                                </div>
                                <div>
                                    <div class="clear"></div>
                                </div>
                                <div class="rowMiddleWithoutBorder">
                                    <div class="left0PX">
                                        <b><g:message code="templates.configuration.group._distribution.stationsnumber"/></b>
                                    </div>
                                    <div class="left0PX">
                                        <b><g:message code="templates.configuration.group._distribution.groupname"/></b>
                                    </div>
                                    <div class="left0PX">
                                        <b>${groupName}</b>
                                    </div>
                                </div>

                                <g:each in="${groupTypes}" var="groupType">
                                    <div class="rowMiddleWithoutBorder4">
                                        <table>
                                            <tr>
                                                <td width="60px" align="center" valign="middle">${groupType.value.size()}</td>
                                                <td width="60px" valign="middle">of</td>
                                                <td width="60px" valign="middle">${groupType.key}</td>
                                            </tr>
                                         </table>
                                    </div>
                                </g:each>

                            </div>
                        </g:form>
                    </div>
                </div>
                <div class="layoutRightLittle">
                    <div id="tabs-container">
                        <ul class="tabs-menu">
                            <li class="current"><a href="#tab-1"><g:message code="templates.configuration.group._distribution.onMap"/></a></li>

                            <li><a href="#tab-2"><g:message code="templates.configuration.group._distribution.random"/></a></li>

                            <li><a href="#tab-3"><g:message code="templates.configuration.group._distribution.file"/></a></li>
                        </ul>
                        <div class="tab">
                            <div id="tab-1" class="tab-content">
                                <div id="openModalMap" class="modalDialogStation">

                                    <div id="map" style="background-color: #eee; width:100%; height:100%; position: absolute; left:0%; top:0% padding-top:1px" class="olMap"></div>

                                    <script type="text/javascript">

                                        // global variables
                                        var map, vectors, routesLayer, lonlat, zoom, markers;

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

                                        routesLayer = new OpenLayers.Layer.Vector( "Route Vectors", {
                                            styleMap: new OpenLayers.StyleMap({'default':{
                                                strokeColor: "red",  // TODO: chose a good color
                                                strokeOpacity: 0.6,
                                                strokeWidth: 6
                                            }}) } );

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

                                        vectors = new OpenLayers.Layer.Vector("Vector Layer", {
                                            styleMap: new OpenLayers.StyleMap({'default':{
                                                strokeColor: "#FF11FF",  // TODO: chose a good color
                                                strokeOpacity: 0.6,
                                                strokeWidth: 6,
                                                fillColor: "#FF5500",
                                                fillOpacity: 0.5,
                                                pointRadius: 6,
                                                pointerEvents: "visiblePainted",
                                                label : "Start",
                                                fontSize: "10px",
                                                fontFamily: "Courier New, monospace",
                                                fontWeight: "bold",
                                                labelOutlineColor: "white",
                                                labelOutlineWidth: 5
                                            }}),
                                            eventListeners: {
                                                'featureadded' : function( evt ) {
                                                    var feature = evt.feature;
                                                    var data = {
                                                        feature: feature,
                                                        map: map,
                                                        vectors: vectors,
                                                        markers: markers,
                                                        routesLayer: routesLayer,
                                                        calculateRouteLink: '${g.createLink( controller: 'configuration', action: 'calculateChargingStation', params: [configurationStubId: configurationStubId , groupName:groupName, gasolineId: gasolineId, groupId:groupId, groupTypes:groupTypes, fillingStationId:fillingStationId  ] )}',
                                                        <%--calculateRouteLink: '${g.createLink( controller: 'mapView', action: 'calculateRoute' )}',--%>
                                                        <%--showGasolineInfoLink: '${g.createLink( controller: 'mapView', action: 'showGasolineInfo', params: [ gasolineId: gasolineId ] )}',
                                                        showTrackInfoLink: '${g.createLink( controller: 'mapView', action: 'showTrackInfo', params: [ simulationRouteId: simulationRouteId ] )}'--%>
                                                    };
                                                    serialize( data );
                                                }
                                            }
                                        });



                                        //Draw Electric Stations------------------- ///
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
                                                new OpenLayers.Geometry.Point( gasDat.fromX , gasDat.fromY ).transform(p1, projectTo),
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
                                                new OpenLayers.Geometry.Point( gasDat.fromX , gasDat.fromY ).transform(p1, projectTo),
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

                                        var boxControl = new OpenLayers.Control.DrawFeature(
                                                vectors,
                                                OpenLayers.Handler.Point,
                                                {
                                                    title : 'Point',
                                                    displayClass : 'myNewPoiter',
                                                    handlerOptions: {
                                                        sides : 4,
                                                        irregular : true
                                                    }

                                                }
                                        );

                                        map.addLayers( [ mapgoogle_layer, mapnik_layer,  routesLayer, markers ] );

                                        //var navControl = new OpenLayers.Control.Navigation({});

                                        var controlPanel = new OpenLayers.Control.Panel({
                                            displayClass: 'olControlEditingToolbar'
                                        });
                                        controlPanel.addControls([
                                            //navControl
                                            boxControl
                                        ]);
                                        map.addControl(controlPanel);
                                        //navControl.activate();

                                        lonlat.transform( p1, pMerc );
                                        map.setCenter( lonlat, zoom );


                                        function showTrackInfos( mode, trackId ) {

                                            if( mode == 'display' ) {
                                                if( document.getElementById("trackInfo") === null ) {
                                                    div = document.createElement("div");
                                                    div.setAttribute('id', 'trackInfo');
                                                    div.setAttribute('className', 'overlayBG');
                                                    div.setAttribute('class', 'overlayBG');
                                                    document.getElementsByTagName("body")[0].appendChild(div);
                                                }
                                                if( document.getElementById("lightBox") === null ) {
                                                    div = document.createElement("div");
                                                    div.setAttribute('id', 'lightBox');

                                                    var link = "${g.createLink( controller: 'mapView', action: 'showTrackInfo', params: [ trackId: trackId ] )}";

                                                    jQuery.ajax({
                                                        url: link + trackId,
                                                        type: "POST",
                                                        success: function( data ) {
                                                            div.innerHTML = data;
                                                            document.getElementsByTagName("body")[0].appendChild(div);
                                                        }
                                                    });

                                                }


                                            } else {
                                                document.getElementsByTagName("body")[0].removeChild(document.
                                                        getElementById("trackInfo"));
                                                document.getElementsByTagName("body")[0].removeChild(document.
                                                        getElementById("lightBox"));

                                            }
                                        }

                                    </script>

                                </div>

                            </div>
                            <div id="tab-2" class="tab-content">
                                <g:form controller="configuration" action="setDistributionForGroup">
                                    <div class="rowSpace">
                                        <div class="clear"></div>
                                    </div>
                                    <div class="contentLeft1">
                                        <div class="rowUp">
                                            <div class="leftbig"><g:message code="templates.configuration.group._distribution.distributionsettings"/> </div>
                                        </div>
                                        <div class="rowMiddle">
                                            <div class="leftDistribution">
                                                <g:message code="templates.configuration.fleet._distribution.selectdistribution"/>
                                            </div>
                                            <div class="rightDistribution">
                                                <g:select name="selectedDist" from="${distributions}" optionKey="key" optionValue="${it}" />
                                            </div>
                                            <div class="clear"></div>
                                        </div>

                                        <div class="clear"></div>
                                        <div class="rowDown">
                                            <div class="leftLongBold"></div>
                                            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                            <g:hiddenField name="groupId" value="${groupId}"/>
                                            <div class="right2-bottomed">
                                                <g:submitButton name="setDistribution" value="${message(code: 'templates.configuration.group._distribution.savedistributionforgroup')}" onclick="location.reload();"/>
                                            </div>

                                            <div class="clear"></div>
                                        </div>
                                    </div>
                                </g:form>
                            </div>

                            <div id="tab-3" class="tab-content">
                                <br>
                                <div class="contentLeft1">
                                    <div class="rowUp">
                                        <div class="leftbig"><g:message code="templates.configuration.group._distribution.electricstationssettings"/> </div>
                                    </div>
                                    <div class="rowMiddle">
                                        <div class="leftDistributionFile">
                                            <input type="file">
                                        </div>
                                        <div class="rightDistribution">

                                        </div>
                                        <div class="clear"></div>
                                    </div>

                                    <div class="rowDown">
                                        <div class="leftLongBold"></div>
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <g:hiddenField name="groupId" value="${groupId}"/>
                                        <div class="right2-bottomed">
                                            <g:submitButton name="setDistribution" value="${message(code: 'templates.configuration.group._distribution.savestationsfromfile')}" onclick="location.reload();"/>
                                        </div>

                                        <div class="clear"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>

            </div>

        </fieldset>
        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
    </div>
</div>


<g:each in="${distributions}" var="dist">

    ${dist.key} ${dist}

</g:each>

<g:each in="${cars}" var="car">

    ${car.name} (${car.id})

</g:each>

for Group ${fleetId}
