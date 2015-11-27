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
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'styleSort.css')}" type="text/css">
    <link href='http://fonts.googleapis.com/css?family=Droid+Sans' rel='stylesheet' type='text/css'>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'style.css')}" type='text/css'/>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'iconic.css')}" type='text/css'/>
    <g:javascript library="jquery-1.9.0"/>
    <g:javascript src="application.js"/>
    <g:javascript src="ol/OpenLayers.js"/>
    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <script src="http://maps.google.com/maps/api/js?v=4&sensor=false"></script>
    <script type="text/javascript" src="http://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
    <g:javascript src="tablesorter.js"/>
</head>

<body>
<g:render template="/layouts/topbarOnlyTitles"/>
<br/>

<div class="pContainerConfigureStats">
    <div class="" id="accordion">
    <div class="statisticDataBig">
        <span class="statisticDataBig">
            <g:if test="${stats.fillingStations.size()==0}"></g:if>
            <g:if test="${stats.fillingStations.size()!=0}"> ${stats.fillingStations.size()}-</g:if>
        </span>
        <span class="statisticsDataSmall"><g:message code="stats.stats.stations"/>,</span>
        <span class="statisticDataBig"> ${stats.usedStations} - </span>
        <span class="statisticsDataSmall"> <g:message code="stats.stats.stationsvisited"/>,</span>
        <span class="statisticDataBig"> ${TimeCalculator.readableTime(stats.stationsInUse)} - </span>
        <span class="statisticsDataSmall"><g:message code="stats.stats.timeinusesum"/>,</span>
        <span class="statisticDataBig">
            <g:if test="${stats.wholePower.size()==0}"></g:if>
            <g:if test="${stats.wholePower.size()!=0}">${Math.round(stats.wholePower.sum())} kW. -
                <span class="statisticsDataSmall2"> <g:message code="stats.stats.energy"/>,</span>
            </g:if>
        </span>

        <span class="statisticsDataSmall"> <g:message code="stats.stats.simulationarea"/> - </span>
        <span class="statisticDataBig"> ${stats.configurationArea} </span>
    </div>


    <div class="pContainerConfigureStats1">
        <div class="rowUpStatistic">
            <table align="left" id="sortTable" class="tablesorter">
                <thead>
                <tr class="statsTitleAllStation">
                    <th class="statsTitle2"><g:checkBox class="statisticsAll" name="id" id="stats" checked="true"/></th>
                    <th class="statsTitle3">ID</th>
                    <th class="statsTitle">Type kW</th>
                    <th class="statsTitle">Owner</th>
                    <th class="statsTitle">Nutzungszeit</th>
                    <th class="statsTitle">Geladener Strom</th>
                    <th class="statsTitle">Ladestationen GPS</th>
                    <th class="statsTitle">Visited car</th>
                    <th class="statsTitle">Visited time</th>
                </tr>
                </thead>
                <tbody>
                    <g:each in="${stats.fillingStations}" var="fillingStation">
                        <tr class="statsTitle1">
                            <td class="statsTitle1"> <g:checkBox class="statisticsAlle" name="id"/></td>
                            <td class="statsTitle1">${fillingStation.id}</td>
                            <td class="statsTitle1" id="fillingStationType"> ${fillingStation.fillingStationType.name} </td>
                            <g:if test="${fillingStation.name =='Rve' || fillingStation.name =='Vattenfall'}">
                                <td class="statsTitle1">${fillingStation.name} </td>
                            </g:if>
                            <g:else>
                                <td class="statsTitle1">privat </td>
                            </g:else>
                            <td class="statsTitle1">
                            <g:if test="${fillingStation.timeInUse==0}">
                                -
                            </g:if>
                            <g:else>
                                ${TimeCalculator.readableTime(fillingStation.timeInUse)}
                            </g:else>
                        </td>
                            <td class="statsTitle1">
                            <g:if test="${fillingStation.timeInUse==0}">
                                -
                            </g:if>
                            <g:else>
                                ${Math.round((fillingStation.timeInUse*fillingStation.fillingStationType.fillingPortion))} kW
                            </g:else></td>
                            <td class="statsTitle1"> ( ${fillingStation.lat} ${fillingStation.lon}) </td>
                            <td class="statsTitle1"></td>
                            <td class="statsTitle1"></td>
                        </tr>
                    </g:each>
                </tbody>
            </table>
        </div>
    </div>
</div>
</div>

<br/>
<div class="pContainerConfigureStats">
    <div class="exportTitle"> <g:message code="stats.stats.export"/></div>
    <div class="exportPanel">
        <r:require module="export"/>
        <export:resource />
        <export:formats formats="['csv', 'excel', 'pdf']" params="${params}">
        </export:formats>
    </div>
    <div class="exportTitle"> Show Plot: </div>
    <div class="exportTitle">
        <g:submitButton name="Display graph"
                        value="${message(code: 'stats.stats.displaygraph')}"/>

    </div>
    <div class="statisticsButtonsDetail">

        <button class="layoutButtonR3"
                type="submit"
                onclick="location.href='${createLink( controller: 'statistics', action: 'showStatisticsOnMap', params: [ experimentRunResultId: experimentRunResultId ] )}'">
            <g:message code="stats.stats.showonmap"/> </button>

        <button class="layoutButtonR3"
                type="submit"
                onclick="location.href='${createLink( controller: 'statistics', action: 'showFleetDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
            <g:message code="stats.stats.detailcar"/> </button>

    </div>
</div>
<div id="updateMe"></div>
<%--<g:javascript>

    function handleCheckBoxClick(cb) {

        var cbNameField = cb.name.split("::");

        var fleetName = cbNameField[0];
        var carTypeName = cbNameField[1];
        var columnName = cbNameField[2];

        var allField = document.getElementById(fleetName + "::" + carTypeName + "::all");
        var successfulField = document.getElementById(fleetName + "::" + carTypeName + "::successful");
        var failedField = document.getElementById(fleetName + "::" + carTypeName + "::failed");


        if (columnName == "all" || columnName == "successful" || columnName == "failed") {
            // click was on a row

            var columnElements = document.getElementsByClassName(fleetName + "::" + carTypeName);
            //var columnElements1 = document.getElementsByClassName(groupName + "::" + stationType);
            for (var i = 0; i < columnElements.length; i++) {

                var hua = columnElements[i];

                var currentColumnSplit = hua.name.split("::");
                var currentColumnName = currentColumnSplit[currentColumnSplit.length - 1];

                if (cb.checked && hua.checked) {
                    // highlight green
                    var fieldElement = document.getElementById(columnName + "::" + fleetName + "::" + carTypeName + "::" + currentColumnName);

                    fieldElement.style.color = "#00AA00";
                    fieldElement.style.fontWeight = "bold";


                } else {
                    // highlight normal!
                    var fieldElement = document.getElementById(columnName + "::" + fleetName + "::" + carTypeName + "::" + currentColumnName);

                    fieldElement.style.color = "black";

                }


            }


        } else {
            // click was on a column

            var allRowField = document.getElementById(fleetName + "::" + carTypeName + "::all");
            var successRowField = document.getElementById(fleetName + "::" + carTypeName + "::successful");
            var failedRowField = document.getElementById(fleetName + "::" + carTypeName + "::failed");


            var plannedTime = document.getElementById(fleetName + "::" + carTypeName + "::" + "plannedTime");
            var realDrivingTime = document.getElementById(fleetName + "::" + carTypeName + "::" + "realDrivingTime");
            var realTime = document.getElementById(fleetName + "::" + carTypeName + "::" + "realTime");
            var loadingTime = document.getElementById(fleetName + "::" + carTypeName + "::" + "loadingTime");
            var plannedDistance = document.getElementById(fleetName + "::" + carTypeName + "::" + "plannedDistance");
            var realDistance = document.getElementById(fleetName + "::" + carTypeName + "::" + "realDistance");
            var energyLoaded = document.getElementById(fleetName + "::" + carTypeName + "::" + "energyLoaded");
            var energyDemanded = document.getElementById(fleetName + "::" + carTypeName + "::" + "energyDemanded");


            var currentName = cb.name;

            var littleCurrentName = currentName.match(/(::[a-z])\w+/g);

            if (allRowField.checked && cb.checked) {

                var fieldElement = document.getElementById("all::" + fleetName + "::" + carTypeName + "::" + columnName);
                fieldElement.style.color = "#00AA00";


            } else {

                var fieldElement = document.getElementById("all::" + fleetName + "::" + carTypeName + "::" + columnName);
                fieldElement.style.color = "black";

            }

            if (successRowField.checked && cb.checked) {

                var fieldElement = document.getElementById("successful::" + fleetName + "::" + carTypeName + "::" + columnName);
                fieldElement.style.color = "#00AA00";


            } else {
                var fieldElement = document.getElementById("successful::" + fleetName + "::" + carTypeName + "::" + columnName);
                fieldElement.style.color = "black";
            }

            if (failedRowField.checked && cb.checked) {

                var fieldElement = document.getElementById("failed::" + fleetName + "::" + carTypeName + "::" + columnName);
                fieldElement.style.color = "#00AA00";


            } else {
                var fieldElement = document.getElementById("failed::" + fleetName + "::" + carTypeName + "::" + columnName);
                fieldElement.style.color = "black";
            }

            if (plannedTime.checked == true || realDrivingTime.checked == true || loadingTime.checked == true || realTime.checked == true && (energyDemanded.checked == false && energyLoaded.checked == false && plannedDistance.checked == false && realDistance.checked == false)) {
                plannedDistance.disabled = true;
                realDistance.disabled = true;
                energyLoaded.disabled = true;
                energyDemanded.disabled = true;
            } else if (plannedDistance.checked == true || realDistance.checked == true && (plannedTime.checked == false && realDrivingTime.checked == false && loadingTime.checked == false && realTime.checked == false && energyDemanded.checked == false && energyLoaded.checked == false)) {
                plannedTime.disabled = true;
                realDrivingTime.disabled = true;
                realTime.disabled = true;
                loadingTime.disabled = true;
                energyLoaded.disabled = true;
                energyDemanded.disabled = true;
            } else if (energyDemanded.checked == true || energyLoaded.checked == true && (plannedTime.checked == false && realDrivingTime.checked == false && loadingTime.checked == false && realTime.checked == false && plannedDistance.checked == false && realDistance.checked == false)) {
                plannedDistance.disabled = true;
                realDistance.disabled = true;
                plannedTime.disabled = true;
                realDrivingTime.disabled = true;
                realTime.disabled = true;
                loadingTime.disabled = true;

            } else {
                plannedDistance.disabled = false;
                realDistance.disabled = false;
                plannedTime.disabled = false;
                realDrivingTime.disabled = false;
                realTime.disabled = false;
                loadingTime.disabled = false;
                energyLoaded.disabled = false;
                energyDemanded.disabled = false;

            }

        }

    }

    function handleCheckBoxClickStation(cb) {

        var cbNameField = cb.name.split("::");
        var groupStat = cbNameField[0];
        var stationType = cbNameField[1];

        var timeInUse = document.getElementById(groupStat + "::" + stationType + "::" + "timeInUse");
        var timeLiving = document.getElementById(groupStat + "::" + stationType + "::" + "timeLiving");
        var failedToRoute = document.getElementById(groupStat + "::" + stationType + "::" + "failedToRoute");


        if (timeInUse.checked == true || timeLiving.checked == true) {
            failedToRoute.disabled = true;
        } else if (failedToRoute.checked == true) {
            timeInUse.disabled = true;
            timeLiving.disabled = true;
        } else {
            timeInUse.disabled = false;
            timeLiving.disabled = false;
            failedToRoute.disabled = false;

        }

    }

</g:javascript>
--%>
<script>
    $("#accordion").accordion({
        active: false,
        heightStyle: "content",
        collapsible: true,
        alwaysOpen: false

    });

    $("#sortTable").tablesorter({
        // pass the headers argument and assing a object
        headers: {
            // assign the secound column (we start counting zero)
            0: {
                // disable it by setting the property sorter to false
                sorter: false
            }

        }
    });

    $('#stats').click(function() {
        var checked = this.checked;
        $('.statisticsAlle').prop('checked', checked);
    });

</script>
</body>
</html>


