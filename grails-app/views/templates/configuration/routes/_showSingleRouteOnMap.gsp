<div id="openModal" class="modalDialogMap">
    <div id="map" style="background-color: #eee; width:100%; height:100%; position: absolute; left:0%; top:0% padding-top:1px" class="olMap"></div>
    <g:javascript src="jquery.loading.js"/>
    <script type="text/javascript">

        // global variables
        var map, vectors, routesLayer, lonlat, zoom, markers;

        var startIconSize = new OpenLayers.Size( 40, 40 );
        var targetIconSize = new OpenLayers.Size( 20, 20 );
        // var offset = new OpenLayers.Pixel( -(size.x/2) , -(size.y/2));
        var startIcon =  new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'start.png' )}" , startIconSize );
        var targetIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'target.png' )}" , targetIconSize );
        var viaIcon = new OpenLayers.Icon( "${g.resource( dir: '/images', file: 'viaPin.png' )}" , targetIconSize );

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

        var color;
        var r = Math.floor(Math.random() * 255);
        var g = Math.floor(Math.random() * 255);
        var b = Math.floor(Math.random() * 255);
        color= "rgb("+r+" ,"+g+","+ b+")";
        var colorVariable = ["red","#00ff00","#ff00ff","#00ddff","yellow","yellow"];
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

        // DRAW Routes to 'routes'
        // and all markers to markers!
        var fleetDat = new Object();
        var a = 0;
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
    <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
</div>