<div id="openModal" class="modalDialogMap">
    <div id="map" style="background-color: #eee; width:100%; height:100%; position: absolute; left:0%; top:0% padding-top:1px" class="olMap"></div>
    <script type="text/javascript">

        // global variables
        var map, vectors, routesLayer, lonlat, zoom, markers, popup ;

        var startIconSize = new OpenLayers.Size( 40, 40 );
        var targetIconSize = new OpenLayers.Size( 20, 20 );
        // var offset = new OpenLayers.Pixel( -(size.x/2) , -(size.y/2));
        var startIcon =  new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'start.png' )}" , startIconSize );
        var targetIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'target.png' )}" , targetIconSize );
        var viaIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'via.png' )}" , targetIconSize );

        var gasolineIconSize = new OpenLayers.Size( 25, 25 );
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


        markers = new OpenLayers.Layer.Markers( "Markers", {
            strategies: [
                new OpenLayers.Strategy.Fixed(),
                new OpenLayers.Strategy.Cluster()
            ]
        } );

        var mapnik_layer = new OpenLayers.Layer.OSM.Mapnik( "Mapnik" );
        var mapgoogle_layer = new OpenLayers.Layer.Google( "Google Streets");

        map.addLayers( [ mapnik_layer, mapgoogle_layer, markers ] );
        map.addControl(new OpenLayers.Control.MousePosition());

        map.addLayer(new OpenLayers.Layer.OSM());

        epsg4326 =  new OpenLayers.Projection("EPSG:4326"); //WGS 1984 projection
        projectTo = map.getProjectionObject(); //The map projection (Spherical Mercator)
        var vectorLayer = new OpenLayers.Layer.Vector("Overlay");

        //Draw Electric Stations
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
                new OpenLayers.Geometry.Point( gasDat.fromX , gasDat.fromY ).transform(epsg4326, projectTo),
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
                new OpenLayers.Geometry.Point( gasDat.fromX , gasDat.fromY ).transform(epsg4326, projectTo),
                {description: gasDat.fillingStationType + ' '+'Kw' + '<br>' + 'Lat:' + gasDat.fromX + '<br>' + 'Lon:'+ gasDat.fromY }
        );
        vectorLayer.addFeatures(feature);


        drawGasolineStation( gasDat );

        </g:if>


        </g:each>
        </g:each>


        map.addLayer(vectorLayer);


        //Add a selector control to the vectorLayer with popup functions
        var controls = {
            selector: new OpenLayers.Control.SelectFeature(vectorLayer, { onSelect: createPopup, onUnselect: destroyPopup })
        };



        function createPopup(feature) {
            feature.popup = new OpenLayers.Popup.FramedCloud("pop",
                    feature.geometry.getBounds().getCenterLonLat(),
                    null,
                    '<div class="markerContent">'+feature.attributes.description+'</div>',
                    null,
                    true,
                    function() { controls['selector'].unselectAll(); }
            );
            //feature.popup.closeOnMove = true;
            map.addPopup(feature.popup);
        }

        function destroyPopup(feature) {
            feature.popup.destroy();
            feature.popup = null;
        }

        map.addControl(controls['selector']);
        controls['selector'].activate();



        lonlat.transform( p1, pMerc );
        map.setCenter( lonlat, zoom );

    </script>
   <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
</div>