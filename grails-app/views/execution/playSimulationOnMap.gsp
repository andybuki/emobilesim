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

    <style>

html, body, #map1 {
    width:100%; height:100%; margin:0;
}
    </style>

    <r:layoutResources/>
    <meta name="layout" content="main" />
</head>

<body>
    <div class="pContainerConfigureSimulationMap">
        <div class="rowUp">
            <div class="leftBoldBig"><g:message code="execution.playsimulation.playsimulation"/></div>
            <div class="right0PX"></div>
            <div class="clear"></div>
        </div>
       <br>
        <div class="simulationTypesExecute">
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
                                            <p id="scale-value">time scale 1:50</p>
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
                    <button class="playButton" id="button_play_pause" onClick="toggle_button_clicked()"><b><g:message code="execution.playsimulation.playsimulation"/></b></button>
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

        <br>
        <div id="map" style="background-color: #eee; width:99%; height:700px; position:relative; margin:0; left:10px;" class="olMap">

        </div>
        <br><br>

        <script>
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

            lonlat = new OpenLayers.LonLat(13.38, 52.52);
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


            layer = new OpenLayers.Layer.OSM( "Simple OSM Map");

            map.addLayer(layer);
            lonlat.transform( p1, pMerc );
            map.setCenter( lonlat, zoom );


        </script>
        <g:render template="/layouts/footer" />


        <r:layoutResources></r:layoutResources>

    </div>
</body>
</html>