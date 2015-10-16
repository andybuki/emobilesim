<%--
  Created by IntelliJ IDEA.
  User: anbu
  Date: 02.10.14
  Time: 15:47
--%>

<%@ page import="de.dfki.gs.utils.TimeCalculator" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="stats.stats.statistic"/></title>
    <script type='text/javascript' src="${resource(dir: 'js', file: 'prefix-free.js')}"></script>
    <script type='text/javascript' src="${resource(dir: 'js', file: 'jquery-1.9.0.js')}"></script>
    <link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
    <link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
    <link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'jquery-ui.css')}" type="text/css">

    <link href='http://fonts.googleapis.com/css?family=Droid+Sans' rel='stylesheet' type='text/css'>

    <link rel='stylesheet' href="${resource(dir: 'css', file: 'style.css')}" type='text/css'/>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'iconic.css')}" type='text/css'/>


    <g:javascript library="jquery-1.9.0"/>

    <g:javascript src="application.js"/>

    <g:javascript src="ol/OpenLayers.js"/>
    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <script src="http://maps.google.com/maps/api/js?v=3.5&sensor=false"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>

</head>

<body>
<g:render template="/layouts/topbarOnlyTitles"/>


<br/>

<div class="pContainerStatistics">
    <div class="statistics">
        <div class="rowUp">
            <div class="leftBoldStatistics"><b>Statistic: ${stats.simulationName}</b></div>

        </div>

        <div class="rowMiddleStatistics">
            <div class="statisticsData">
                <span class="">${stats.successFullCars.size()} -  </span>
                <span class="statisticsDataSmall"> <g:message code="stats.stats.succsesfulcars"/>,</span>
                <span class="">${stats.failedCars.size()} -  </span>
                <span class="statisticsDataSmall"><g:message code="stats.stats.failedcars"/>,</span>
                <span class="">${Math.round(stats.wholeRoute.sum())?:0} km. -  </span>
                <span class="statisticsDataSmall"><g:message code="stats.stats.wholeroute"/>,</span>
                <span class="statisticsDataSmall"> <g:message code="stats.stats.simulationarea"/> - </span> ${stats.configurationArea}
            </div>
        </div>

        <div class="rowMiddleStatistics">
            <div class="statisticsData">
                <span class="">${stats.fillingStations.size()} -  </span>
                <span class="statisticsDataSmall"> <g:message code="stats.stats.stations"/>,</span>
                ${stats.usedStations} -
                <span class="statisticsDataSmall"> <g:message code="stats.stats.stationsvisited"/>,</span>
                ${TimeCalculator.readableTime(stats.stationsInUse)} -
                <span class="statisticsDataSmall"><g:message code="stats.stats.timeinusesum"/>,</span>
                <span class="">${Math.round(stats.wholePower.sum())} kW. -  </span>
                <span class="statisticsDataSmall"><g:message code="stats.stats.energy"/></span>
            </div>
        </div>


        <div class="rowMiddleStatistics">
            <span class="statisticsButtons">
                <button class="layoutButtonR3"
                        type="submit"
                        onclick="location.href='${createLink( controller: 'statistics', action: 'showStatisticsOnMap', params: [ experimentRunResultId: experimentRunResultId ] )}'">
                        <g:message code="stats.stats.showonmap"/>
                </button>
                <button class="layoutButtonR3"
                        type="submit"
                        onclick="location.href='${createLink( controller: 'statistics', action: 'showFleetDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
                    <g:message code="stats.stats.detailcar"/>
                </button>
                <button class="layoutButtonR3"
                        type="submit"
                        onclick="location.href='${createLink( controller: 'statistics', action: 'showGroupDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
                    <g:message code="stats.stats.detailstation"/>
                </button>
             </span>
        </div>
    </div>
</div>

<div id="updateMe"></div>


</body>
</html>


