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

<style>
circle {
    stroke:#ff0000;
    r:10;
    fill-opacity:0.8;
    fill:red;
    stroke-width: 0px;
    stroke-opacity: 1;
}
polyline {
    stroke-width: 2px;
    stroke-opacity: 0.6;
    fill-opacity:0.0;
    stroke: green;
}


</style>

<div id="openModal" class="modalDialogRoutes">
    <div class="settingsWindowBig">
        <fieldset class="fieldSet100Percent">
            <legend> <g:message code="templates.configuration.fleet._distribution.selectroutes"/> </legend>
            <div class="layout">
                <%--<div class="layoutLeftLittle">
                    <div class="contentLeft4">
                        <g:form controller="configuration" action="createDistributionForFleet">
                            <div class="contentLeftRoutes">
                                <div class="rowUp">
                                    <div class="leftbig"><b><g:message code="templates.configuration.fleet._distribution.properties"/></b></div>
                                </div>
                                <div>
                                    <div class="clear"></div>
                                </div>

                                <%--<div class="rowMiddleWithoutBorder">
                                    <div class="left0PX">
                                        <b><g:message code="templates.configuration.fleet._distribution.carnumber"/></b>
                                    </div>
                                    <div class="left0PX">
                                        <b><g:message code="templates.configuration.fleet._distribution.fleetname"/></b>
                                    </div>
                                    <div class="left0PX">
                                        <b>${fleetName}</b>
                                    </div>
                                </div>--%>

                                <%--<div class="rowMiddleWithoutBorder">
                                    <div class="left0PX1">
                                        <b>CarId</b>
                                    </div>
                                    <div class="left0PX1">
                                        <b>CarType</b>
                                    </div>
                                    <div class="left0PX1">
                                        <b>FleetName</b>
                                    </div>
                                    <div class="left0PX1">
                                        <b>Simulation StartTime</b>
                                    </div>
                                    <div class="left0PX1">
                                        <b>Akkuzustand</b>
                                    </div>
                                </div>

                                <g:each in="${carId}" var="car">
                                    <div class="rowMiddleWithoutBorder4">
                                        <span class="left0PX2">
                                            ${car.id}
                                        </span>
                                        <span class="left0PX2">
                                            ${car.name}
                                        </span>
                                        <span class="left0PX2">
                                            ${fleetName}
                                        </span>
                                        <span class="left0PX2">
                                            ${simulationTime}
                                            <g:link><g:img uri="${resource(dir: 'images', file: 'time.png')}"></g:img></g:link>
                                        </span>
                                        <span class="left0PX2">
                                            ${car.batteryPersent}
                                        </span>
                                    </div>
                                </g:each>--%>

                            <%--<g:each in="${carTypes}" var="carType">
                                <div class="rowMiddleWithoutBorder4">
                                    <div class="left0PX">
                                        ${carType.value.size()}
                                    </div>
                                    <div class="left0PX">
                                        of
                                    </div>
                                    <div class="left0PX">
                                        ${carType.key.name}
                                    </div>
                                </div>
                            </g:each>--%>



                            <%--</div>
                        </g:form>
                    </div>
                </div>
                --%>
                <div class="layoutRightLittle">
                    <div id="tabs-container">
                        <ul class="tabs-menu">
                            <li class="current"><a href="#tab-1"><g:message code="simulation.index.showonmap"/></a></li>
                            <li><a href="#tab-2"><g:message code="simulation.index.ownroutes"/></a></li>
                            <li><a href="#tab-3"><g:message code="simulation.index.distributed"/></a></li>
                        </ul>
                        <div class="tab">
                            <div id="tab-1" class="tab-content">

                                <%--<div class="simulationTime">
                                    <g:message code="templates.configuration.fleet._distribution.simulationtime"/>
                                    <span style="display: inline-block; width: 400px; padding: 0 5px;">
                                        <input id="Slider2" type="slider" name="price" value="80"/>
                                    </span>
                                    <script type="text/javascript">
                                        jQuery("#Slider2").slider({
                                            from: 480,
                                            to: 1020,
                                            step: 15,
                                            dimension: '',
                                            scale: ['8:00', '9:00', '10:00', '11:00', '12:00', '13:00', '14:00', '15:00', '16:00', '17:00'],
                                            limits: false,
                                            calculate: function( value ){
                                                var hours = Math.floor( value / 60 );
                                                var mins = ( value - hours*60 );
                                                return (hours < 10 ? "0"+hours : hours) + ":" + ( mins == 0 ? "00" : mins );
                                            },
                                            onstatechange: function( value ){
                                                console.dir( this );
                                            }
                                        });
                                    </script>
                                    <g:message code="templates.configuration.fleet._distribution.battery"/>
                                    <span style="display: inline-block; width: 400px; padding: 0 5px;">
                                        <input id="Slider1" type="slider" name="price" value="80"/>
                                    </span>
                                    <script type="text/javascript">
                                        jQuery("#Slider1").slider({ from: 0, to: 100, step: 5, smooth: true, round: 0, dimension: "&nbsp; %", skin: "plastic" });
                                    </script>
                                </div>--%>

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

                                        var mapnik_layer = new OpenLayers.Layer.OSM.Mapnik( "Mapnik" );
                                        var mapgoogle_layer = new OpenLayers.Layer.Google( "Google Streets");

                                        vectors = new OpenLayers.Layer.Vector("Vector Layer", {
                                            styleMap: new OpenLayers.StyleMap({'default':{
                                                strokeColor: "red",  // TODO: chose a good color
                                                strokeOpacity: 0.6,
                                                strokeWidth: 6,
                                                fillColor: "#FF5500",
                                                externalGraphic: "../images/start_circle.png",
                                                fillOpacity: 0.5,
                                                pointRadius: 10,
                                                pointerEvents: "visiblePainted",
                                                //label : "Start",
                                                fontSize: "10px",
                                                fontFamily: "Courier New, monospace",
                                                fontWeight: "bold",
                                                labelOutlineColor: "white",
                                                labelOutlineWidth: 5
                                                //cursor: 'pointer'
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
                                                        <%--configurationStubId: ${configurationStubId} ,
                                                        fleetId:${fleetId},--%>
                                                        calculateRouteLink: '${g.createLink( controller: 'configuration', action: 'calculateVrp' , params: [configurationStubId: configurationStubId , fleetName:fleetName,  fleetId:fleetId  ] )}'

                                                        <%--calculateRouteLink: '${g.createLink( controller: 'configuration', action: 'calculateRouting', params: [configurationStubId: configurationStubId , fleetName:fleetName,  fleetId:fleetId , carTypeId :carTypeId /*,fleetTypes:fleetTypes,  carId:carId */ ] )}'--%>

                                                    };
                                                    serialize( data );
                                                }
                                            }



                                        });



                                        
                                        var fleetDat = new Object();
                                        <g:each var="fleet" in="${fleets}">
                                        <g:each var="car" in="${fleet.cars}" >
                                        var segments = new Array();
                                        <g:each var="seg" in="${car.route}">
                                        var segm = new Object();
                                        segm.fromX = ${seg.fromLon};
                                        segm.fromY = ${seg.fromLat};
                                        segm.toX = ${seg.toLon};
                                        segm.toY = ${seg.toLat};
                                        segments.push( segm );
                                        </g:each>
                                        fleetDat.route = segments;
                                        fleetDat.routesLayer = routesLayer;
                                        fleetDat.markers = markers;
                                        drawRoute( fleetDat );
                                        </g:each>
                                        </g:each>
                                        //Draw  Routes------------------- ///
                                        <%--var routeDat = new Object();
                                        console.log(routeDat );
                                        <g:each var="route" in="${routes}">
                                        console.log( ${route.id} );
                                            routeDat.trackId = ${route.trackId};
                                            var segments = new Array();
                                            var vias = new Array();

                                            <g:each var="via" in="${route.vias}">

                                                var vv = new Object();
                                                vv.fromX = ${via.fromX};
                                                vv.fromY = ${via.fromY};
                                                vias.push( vv );
                                            </g:each>

                                            routeDat.vias = vias;

                                            <g:each var="seg" in="${route.route}">
                                                var segm = new Object();
                                                segm.fromX = ${seg.fromY};
                                                segm.fromY = ${seg.fromX};
                                                segm.toX = ${seg.toY};
                                                segm.toY = ${seg.toX};
                                                segments.push( segm );
                                            </g:each>

                                            routeDat.route = segments;--%>

                                        <%--var showTrackInfoLink = '${g.createLink( controller: 'mapView', action: 'showTrackInfo', params: [ trackId: route.trackId ] )}';
                                        routeDat.showTrackInfoLink = showTrackInfoLink;--%>
                                        <%--routeDat.routesLayer = routesLayer;
                                        routeDat.markers = markers;
                                        drawRoute( routeDat );
                                    </g:each>--%>



                                        var boxControl = new OpenLayers.Control.DrawFeature(
                                                vectors,
                                                OpenLayers.Handler.Path,
                                                {
                                                    title : 'Path',
                                                    displayClass : 'myNewDraw',
                                                    handlerOptions: {
                                                        sides : 4,
                                                        irregular : true
                                                    }
                                                    /*callbacks: {
                                                        point: function (point) {
                                                            console.log(point);
                                                            feature = new OpenLayers.Feature.Vector(point);
                                                            vectors.addFeatures(feature);
                                                            vectors.redraw();


                                                        }
                                                    }*/


                                                }

                                        );


                                        map.addControl(new OpenLayers.Control.EditingToolbar( vectors ) );
                                        var options = {
                                            hover: true,
                                            click: true
                                        };

                                        map.addLayers( [ mapnik_layer, mapgoogle_layer,  routesLayer, markers, vectors ] );

                                        var navControl = new OpenLayers.Control.Navigation({});

                                        var controlPanel = new OpenLayers.Control.Panel({
                                            displayClass: 'olControlEditingToolbar'
                                        });
                                        controlPanel.addControls([
                                            navControl,
                                            boxControl
                                        ]);
                                        map.addControl(controlPanel);
                                        navControl.activate();

                                        lonlat.transform( p1, pMerc );
                                        map.setCenter( lonlat, zoom );

                                        <%--function showTrackInfos( mode, trackId ) {

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
                                        }--%>

                                    </script>

                                </div>

                            </div>
                            <div id="tab-2" class="tab-content">
                                <div class="contentLeft1">
                                    <div class="rowUp">
                                        <div class="leftbig"><g:message code="templates.configuration.group._distribution.distributionsettings"/></div>
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
                                        <g:hiddenField name="fleetId" value="${fleetId}"/>
                                        <div class="right2-bottomed">
                                            <g:submitButton name="setDistribution" onclick="location.reload();" value="${message(code: 'templates.configuration.fleet._distribution.savedistributionforfleet')}"/>
                                        </div>

                                        <div class="clear"></div>
                                    </div>
                                </div>
                            </div>
                            <div id="tab-3" class="tab-content">
                                <div class="contentLeft1">
                                    <g:form controller="configuration" action="setDistributionForFleet">
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

                                            <div class="rowMiddle">
                                                <div class="leftDistribution60PX">
                                                    <g:message code="templates.configuration.fleet._distribution.from"/>
                                                </div>
                                                <div class="leftDistributionButton">
                                                    <g:select name="fromKm" from="${(10..95).step( 5 ) + ( 100..500 ).step( 20 )}" />
                                                </div>
                                                <div class="right50PX">
                                                    <g:message code="templates.configuration.fleet._distribution.to"/>
                                                </div>
                                                <div class="right60">
                                                    <g:select name="toKm" from="${(15..95).step( 5 ) + ( 100..500 ).step( 20 )}" />
                                                </div>

                                                <div class="clear"></div>
                                            </div>

                                            <div class="clear"></div>

                                            <div class="rowDown">
                                                <div class="leftLongBold"></div>
                                                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                <g:hiddenField name="fleetId" value="${fleetId}"/>
                                                <div class="right2-bottomed">
                                                    <g:submitButton name="setDistribution" onclick="location.reload();" value="${message(code: 'templates.configuration.fleet._distribution.savedistributionforfleet')}"/>
                                                </div>

                                                <div class="clear"></div>
                                            </div>
                                        </div>
                                    </g:form>
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