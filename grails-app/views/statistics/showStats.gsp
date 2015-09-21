<%--
  Created by IntelliJ IDEA.
  User: anbu
  Date: 02.10.14
  Time: 15:47
--%>

<%@ page import="de.dfki.gs.utils.TimeCalculator" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
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
            <g:each in="${stats.fleets}" var="fleetStat">
                <g:each in="${fleetStat.carTypes}" var="carType">
                    <g:if test="${carType.name=='All Cars'}">
                        <span class="cartypeBold">${carType.countSuccessful}</span>
                        Cars erfolgreich teilgenommen
                        <span> <span
                                class="cartypeBold">${carType.countFails}</span> ausgefallen
                        </span>

                        <td align="center" class="shieben" width="100px"
                            id="successful::${fleetStat.name}::${carType.name}::realTime">
                            ${TimeCalculator.readableTime(carType.stats.succeededCars.realTime.mean)}
                        </td>
                    </g:if>

                </g:each>

            </g:each>
        </div>

        <div class="rowMiddleStatistics">

        </div>

        <div class="rowMiddleStatistics">

        </div>

        <div class="rowMiddleStatistics">
            <span class="statisticsButtons">

                <button class="layoutButtonR3"
                        type="submit"
                        onclick="location.href='${createLink( controller: 'statistics', action: 'showStatisticsOnMap', params: [ experimentRunResultId: experimentRunResultId ] )}'">
                    <g:message code="stats.stats.showonmap"/> </button>

                <button class="layoutButtonR3"
                        type="submit"
                        onclick="location.href='${createLink( controller: 'statistics', action: 'showFleetDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
                    <g:message code="stats.stats.detailcar"/> </button>

                <button class="layoutButtonR3"
                        type="submit"
                        onclick="location.href='${createLink( controller: 'statistics', action: 'showGroupDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
                    <g:message code="stats.stats.detailstation"/> </button>

             </span>
        </div>


    </div>
</div>

<div id="updateMe"></div>


</body>
</html>


