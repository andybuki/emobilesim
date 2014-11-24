<%--
  Created by IntelliJ IDEA.
  User: glenn
  Date: 08.04.14
  Time: 11:00
--%>


<%@ page contentType="text/html;charset=UTF-8" %>
<html class="js">
<head>
    <title><g:message code="configuration.executesim.simulation"/></title>

    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">


    <r:layoutResources/>
    <meta name="layout" content="main" />
</head>

<body onload="drawExperimentContainer( ${routeCount} );">

<script type="text/javascript">

    var g_playing = false;
    var namesDrawn = false;
    var maxTotalKm = 0;


    function toggle_button_clicked() {
        if(g_playing)
        {
            pause();
        }

        else
        {
            play();
        }
    }

    function pause() {

        window.clearInterval( active );

        // call controller simulation PAUSE:
        jQuery.ajax({
            url: '${g.createLink( controller: 'execution', action: 'pauseExperiment' )}',
            type: "POST",
            success: function( data ) {

            }
        });

        g_playing = !g_playing;
        var button = document.getElementById('button_play_pause');
        button.innerHTML = "<b>Play simulation</b>";
    }

    function play() {
        var button = document.getElementById('button_play_pause');
        button.innerHTML = "";
        button.style.display="none";
        g_playing = true;

        // action to the controller:
        jQuery.ajax({
            url: '${g.createLink( controller: 'execution', action: 'proceedExperiment', params: [ configurationId: configurationId, experimentRunResultId: experimentRunResultId ] )}',
            type: "POST",
            success: function( data ) {

            }
        });

        active = window.setInterval( function() {
                    showInfoPane();
                }, 2000 // 2000 ms
        );

    }



    function showInfoPane() {

        // get infos for one simulationRoutes
        jQuery.ajax({
            url: '${ g.createLink( controller: 'execution', action: 'getInfo' ) }',
            data: JSON.stringify( { data: { sessionId : "${sessionId}" } } ),
            contentType: "application/json; charset=utf-8",
            dataType: "json",
            type: "POST",
            success: function( data ) {

                if ( data[ 'info' ] ) {
                    var info = data[ 'info' ];

                    var cars = info[ 'cars' ];
                    var stations = info[ 'stations' ];

                    var currentTime = info[ 'currentTime' ];

                    drawCarInfos( cars );

                    drawStationInfos( stations );

                    drawCurrentTime( currentTime );

                    //drawCarsText ();
                    //drawStationsText ();

                }

                var simStatus = "false";
                if ( data[ 'finished' ] ) {
                    simStatus = data[ 'finished' ];
                }

                console.log( simStatus );

                var experimentRunResultId = data[ 'experimentRunResultId' ];


                recheckStopButton( simStatus );


                enableShowStatsButtonIfFinished( simStatus );


                // $( '#speedInfo').html( speed );

            },
            error: function( data ) {

                // console.log( data );

            }
        });

    }

    function drawShowStatsButton( runResultId ) {

        <%--
        var buttonsDiv = document.getElementById( 'the_buttons' )


                   <button class="playButton"
                           id="button_show_stats"
                           type="submit"
                           onclick="location.href='${createLink( controller: 'statistics', action: 'showStats', params: [ configurationId: configurationId ] )}'"
                           value="disable"
                           disabled
                       ><i class="icon icon-warning-sign"></i>Show Stats</button>


        var buttonnode= buttonsDiv.createElement('input');
        buttonnode.setAttribute( 'class', 'button_show_stats' );
        buttonnode.setAttribute( 'type', 'submit' );
        buttonnode.setAttribute( 'value', 'Show Stats' );

        buttonnode.setAttribute( 'onclick', "location.href='${createLink( controller: 'statistics', action: 'showStats', params: [ simulationExperimentResultId: runResultId ] )}'" );
        --%>
    }

    function enableShowStatsButtonIfFinished( simStatus ) {

        if ( simStatus == "finished" ) {
            document.getElementById( 'button_show_stats' ).disabled = false;
            document.getElementById( 'button_show_stats' ).value = "enabled";

            document.getElementById( 'button_show_stats' ).style.color = "#00AA00";
            document.getElementById('button_show_stats').style.display='inline';
        }



    }

    function recheckStopButton( simStatus ) {

        document.getElementById( 'button_stopp').disabled = (simStatus != "finished");

    }

    function drawCurrentTime( currentTime ) {

        var timeCanvas = document.getElementById( 'timeContainer' );

        if ( timeCanvas.getContext ) {

            var ctx = timeCanvas.getContext( '2d' );
            ctx.clearRect( 0,0,1100,40 );
            ctx.font = "16px sans-serif ";
            ctx.fillStyle = "black";
            ctx.fillText( "Simulation duration:  "  +  currentTime , 480, 30 );

            ctx.stroke();
        }


    }

    /*function drawCarsText () {

        var carCanvas = document.getElementById( 'carContainer' );

        if ( carCanvas.getContext ) {
            var ctx = carCanvas.getContext( '2d' );

            ctx.clearRect( 0,0,1100,40 );
            ctx.font = "11px sans-serif ";
            ctx.fillStyle = "black";
            //ctx.fillText( "All cars in the simulation", 0, 30 );
            ctx.onclick= "document.getElementById('light').style.display='block';document.getElementById('fade').style.display='block'";
            ctx.class="helpButton";
            ctx.src="${g.resource( dir: '/images', file: 'help.png' )}";
            ctx.stroke();
        }

    }

    function drawStationsText () {

        var stationCanvas = document.getElementById( 'stationContainer' );

        if ( stationCanvas.getContext ) {
            var ctx = stationCanvas.getContext( '2d' );

            ctx.clearRect( 0,0,1100,40 );
            ctx.font = "11px sans-serif ";
            ctx.fillStyle = "black";
            ctx.fillText( "All electric stations in the simulation", 0, 30 );

            ctx.stroke();
        }

    }*/

    function drawStationInfos( info ) {

        var canvas = document.getElementById('stationsContainer');
        var stationCount = info.length;

        var spaceForStation = 1100 / stationCount;
        if (stationCount>50) {
            if (canvas.getContext) {
                var ctx = canvas.getContext('2d');
                ctx.clearRect(0, 0, 400, 500);

                for (var dp = 0; dp < stationCount; dp++) {

                    var station = info[ dp ];


                    if (station[ 'status' ] == "IN_USE") {
                        // red
                        ctx.fillStyle = "rgba(255, 0, 0, 1.0)";

                    } else {
                        ctx.fillStyle = "rgba(0,255,0,1.0)";
                    }

                    // upperLeft.x, upperLeft.y, width, height
                    ctx.fillRect(dp * spaceForStation, 0, spaceForStation, 40);

                    ctx.stroke();

                }

                for (var dp = 0; dp < stationCount; dp++) {

                    ctx.beginPath();
                    //ctx.font = "10px arial ";
                    //ctx.fillStyle = "black";
                    for (var tx = 0; tx < stationCount; tx++) {

                        var station = info[ tx ];

                        var personalId = station[ 'personalId' ]
                        if (station[ 'status' ] == "IN_USE") {
                            ctx.font = "12px sans-serif";
                            ctx.fillStyle = "black";

                        } else {
                            ctx.font = "0px arial";
                            ctx.fillStyle = "green";
                        }

                        ctx.fillText(personalId, tx * spaceForStation, 20);

                    }
                    ctx.stroke();
                }


            }

        }

        else {
            if (canvas.getContext) {
                var ctx = canvas.getContext('2d');
                ctx.clearRect(0, 0, 400, 500);

                for (var dp = 0; dp < stationCount; dp++) {

                    var station = info[ dp ];


                    if (station[ 'status' ] == "IN_USE") {
                        // red
                        ctx.fillStyle = "rgba(255, 0, 0, 1.0)";
                    } else {
                        ctx.fillStyle = "rgba(0,255,0,1.0)";
                    }

                    // upperLeft.x, upperLeft.y, width, height
                    ctx.fillRect(dp * spaceForStation, 0, spaceForStation, 40);

                    ctx.stroke();

                }

                for (var dp = 0; dp < stationCount; dp++) {

                    ctx.beginPath();
                    ctx.font = "11px sans-serif ";
                    ctx.fillStyle = "black";
                    for (var tx = 0; tx < stationCount; tx++) {

                        var station = info[ tx ];

                        var personalId = station[ 'personalId' ]

                        ctx.fillText(personalId, tx * spaceForStation, 10);

                    }
                    ctx.stroke();
                }


            }

        }

    }

    function drawCarInfos( info ) {

        var canvas = document.getElementById('experimentContainer');
        var stationCanvas = document.getElementById('stationsContainer');
        var nameCanvas = document.getElementById('nameContainer');
        // canvas.width = canvas.width;

        if (canvas.getContext){

            // use getContext to use the canvas for drawing
            var ctx = canvas.getContext('2d');

            ctx.clearRect ( 0 , 0 , 1100 , 500 );

            var routeCount = info.length;
            var sizeForRoute = 1100 / routeCount;

            // find maxTotalKm
            if ( maxTotalKm == 0 ) {

                for ( var dp = 0; dp < routeCount; dp++ ) {
                    var car = info[ dp ];
                    var totalKmToDrive = car[ 'totalKmToDrive' ];
                    if ( totalKmToDrive > maxTotalKm ) {
                        maxTotalKm = totalKmToDrive;
                    }
                }

            }




            /**
            * drawing status of cars
             * ROUTE DRIVEN
             */
            for ( var dp = 0; dp < routeCount; dp++ ) {

                var car = info[ dp ];

                ctx.fillStyle="#828282";
                //ctx.fillStyle="rgba(10, 2, 45, 0.4)";

                // max height of rect
                var x = ( car[ 'totalKmToDrive' ] / maxTotalKm ) * 500;

                var routeAccomblished = x * car[ 'drivenKm' ] / car[ 'totalKmToDrive' ];

                // upperLeft.x, upperLeft.y, width, height
                ctx.fillRect( dp * sizeForRoute, 530-routeAccomblished, sizeForRoute/2, routeAccomblished );

                ctx.stroke();

            }

             // Yellow line, show the whole distance
            for ( var dp = 0; dp < routeCount; dp++ ) {

                var car = info[ dp ];
                var nameCtx = nameCanvas.getContext('2d');
                nameCtx.beginPath();

                nameCtx.fillStyle = "#CC8400";
                ctx.font = "11px sans-serif ";
                ctx.fillStyle = "#CC8400";
                // ctx.fillStyle="#112233";

                //ctx.fillStyle="rgba(0,0,0, 0.99)";

                // max height of rect
                var x = ( car[ 'totalKmToDrive' ] / maxTotalKm ) * 500;
                var xRound = Math.round(x);
                //alert(x+"km");

                // upperLeft.x, upperLeft.y, width, height
                ctx.fillRect( dp * sizeForRoute, 540-x, sizeForRoute/2, 3 );
                ctx.fillText( "  "+xRound+"km", dp * sizeForRoute, 540-x, sizeForRoute/2 );
                //alert(xRound+"km");
                //ctx.fillText( x+"km", dp * sizeForRoute/2, ( (dp%5)*10 ) + 10 );
                ctx.stroke();

            }



            /**
             * drawing names of cars only once
             */
            if ( namesDrawn == false ) {


                var nameCtx = nameCanvas.getContext('2d');

                nameCtx.beginPath();
                nameCtx.font = "12px sans-serif ";
                nameCtx.fillStyle = "black";
                for ( var tx = 0; tx < routeCount; tx++ ) {

                    var car = info[ tx ];

                    nameCtx.fillText( car[ 'carName' ], tx * sizeForRoute, ( (tx%5)*10 ) + 10 );

                }
                nameCtx.stroke();

                namesDrawn = true;

            }


            /**
             * drawing status of cars
             * BATTERY STATUS
             */

            var ctxStation = canvas.getContext('2d');
            ctxStation.beginPath();
            ctx.beginPath();
            for ( var db = 0; db < routeCount; db++ ) {

                var car = info[ db ];

                //ctx.fillStyle="rgba(32, 45, 21, 0.2)"
                ctx.fillStyle=("#fff");
                ctxStation.fillStyle=("#CC8400");

                var batteryFill = ( 500 / 100 ) * car[ 'batteryFilledPercentage' ] ;
                var batteryPersent = Math.round(car[ 'batteryFilledPercentage' ] );

                ctx.font = "10px sans-serif";
                //ctx.fillText( batteryFill, 190, 30 );
                // upperLeft.x, upperLeft.y, width, height

                ctx.fillRect( (db) * (sizeForRoute) + sizeForRoute/2 , 520-batteryFill, sizeForRoute/2, batteryFill );
                ctxStation.fillText( "  "+batteryPersent +"% accu ", db * sizeForRoute+sizeForRoute/2 , 520-batteryFill, sizeForRoute+10 );
                //ctx.fillText( "  "+xRound+"km", dp * sizeForRoute, 500-x, sizeForRoute/2 );
                ctx.strokeStyle = "#AABBCC";
                ctx.stroke();
                ctxStation.stroke();
            }


        }

    }

    function drawExperimentContainer( routeCount ){

        // get the canvas element using the DOM
        var canvas = document.getElementById('experimentContainer');
        var nameCanvas = document.getElementById( 'nameContainer' );
        var stationCanvas = document.getElementById('stationsContainer');


        // Make sure we don't execute when canvas isn't supported
        if (canvas.getContext){

            // use getContext to use the canvas for drawing
            var ctx = canvas.getContext('2d');
            var nameCtx = nameCanvas.getContext( '2d' );
            var stationCtx = stationCanvas.getContext( '2d' );

            for (var x = 0.5; x < 1100.6; x += 10) {
                ctx.moveTo(x, 0);
                ctx.lineTo(x, 500);
            }

            for (var y = 0.5; y < 500.6; y += 10) {
                ctx.moveTo(0, y);
                ctx.lineTo(1100, y);
            }

            ctx.strokeStyle = "#eee";
            ctx.stroke();

            ctx.beginPath();

            var sizeForRoute = 1100 / routeCount;

            ctx.fillStyle="#AABBCC";
            nameCtx.fillStyle="#AABBCC";
            stationCtx.fillStyle="#AABBCC";
            for ( var i = 0; i < routeCount; i++ ) {

                ctx.fillRect( i * sizeForRoute, 0, sizeForRoute, 500 );
                nameCtx.fillRect( i * sizeForRoute, 0, sizeForRoute, 50 );
                stationCtx.fillRect( i * sizeForRoute, 0, sizeForRoute, 50 );

            }

            ctx.strokeStyle = "#AABBCC";
            ctx.stroke();
            nameCtx.stroke();
            stationCtx.stroke();


        } else {
            alert('You need Safari or Firefox 1.5+ to see this demo.');
        }

    }

</script>
    <div class="pContainerConfigure">

            <div class="rowUp">
                <div class="leftBoldBig"><g:message code="execution.playsimulation.playsimulation"/></div>
                <div class="right0PX"></div>
                <div class="clear"></div>
            </div>

        <div class="simulationTypesExecute">
            <div>
                <br/>
                <span class="infoBold"><g:message code="execution.playsimulation.info"/></span><br/>
                <span class="infoBold">${routeCount}</span><span class="info"> <g:message code="execution.playsimulation.cars"/></span><br/>
                <span class="infoBold">${stationCount}</span><span class="info"> <g:message code="execution.playsimulation.stations"/></span>
                <div class="playButtons" id="the_buttons">
                    <button class="playButton" id="button_play_pause" onClick="toggle_button_clicked()"><b><g:message code="execution.playsimulation.playsimulation"/></b></button>

                    <%--<g:form name="hua" controller="execution" >
                        <g:actionSubmit value="Stop Experiment" action="stopExperiment" />
                    </g:form>--%>

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

                    <%--<a href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='block';document.getElementById('fade').style.display='block'"><img class="helpButton" src="${g.resource( dir: '/images', file: 'help.png' )}"/></a>

                    <div id="light" class="white_content">
                        <img  src="${g.resource( dir: '/images', file: 'sim.jpg' )}"/>
                        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href = "javascript:void(0)" onclick = "document.getElementById('light').style.display='none';document.getElementById('fade').style.display='none'"></a>

                    </div>--%>





                    <%--
                    <button class="playButton"
                            id="button_show_stats"
                            type="submit"
                            onclick="location.href='${createLink( controller: 'statistics', action: 'showStats', params: [ configurationId: configurationId ] )}'"
                            value="disable"
                            disabled
                        ><i class="icon icon-warning-sign"></i>Show Stats</button>
                    --%>
                </div>
            </div>

            <table>
                <tr height="50">
                    <td width="1150px"><canvas id="timeContainer" width="1100" height="40"></canvas></td>

                </tr>

                <tr>
                    <td width="1150px" height="500"><canvas id="experimentContainer" width="1100" height="500"></canvas>
                        <a href = "javascript:void(0)" onclick = "document.getElementById('process').style.display='block'">
                            <img class="helpButton" src="${g.resource( dir: '/images', file: 'help.png' )}"/>

                        </a>
                    </td>

                    <div id="process" class="white_content_process">
                        <div>2 bulks per car, orange and gray</div>
                        <div>Orange: Accumulator in % per car</div>
                        <div>Gray: Distance in km per car</div>
                        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href = "javascript:void(0)" onclick = "document.getElementById('process').style.display='none'"></a>

                    </div>

                </tr>
                <tr>
                    <td width="1150px"><canvas id="nameContainer" width="1100" height="50"></canvas>
                        <a href = "javascript:void(0)" onclick = "document.getElementById('cars').style.display='block'">
                            <img class="helpButton" src="${g.resource( dir: '/images', file: 'help.png' )}"/>

                        </a>
                    </td>
                    <div id="cars" class="white_content_cars">

                        <span>All cars in the simulation</span>
                        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href = "javascript:void(0)" onclick = "document.getElementById('cars').style.display='none'"></a>

                    </div>
                </tr>

                <tr>
                     <td width="1150px"><canvas id="stationsContainer" width="1100" height="40"></canvas>
                         <a href = "javascript:void(0)" onclick = "document.getElementById('stations').style.display='block'">
                             <img class="helpButton" src="${g.resource( dir: '/images', file: 'help.png' )}"/>
                         </a>
                     </td>
                    <div id="stations" class="white_content_stations">
                        <div>Electric stations in the simulation</div>
                        <div>green - free</div>
                        <div>red - occupied</div>
                        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href = "javascript:void(0)" onclick = "document.getElementById('stations').style.display='none'"></a>

                    </div>
                </tr>


                <div id="fade" class="black_overlay"></div>
            </table>
            <g:render template="/layouts/footer" />

            <r:layoutResources></r:layoutResources>
        </div>
    </div>
</body>
</html>

