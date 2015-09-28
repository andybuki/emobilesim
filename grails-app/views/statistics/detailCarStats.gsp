<%--
  Created by IntelliJ IDEA.
  User: glenn
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

<%--
    for each fleet in stats map print out a tabl
    #e
--%>
<br/><br/>

<span class="statisticsButtons">
    <span class="statisticsButtons">

        <button class="layoutButtonR3"
                type="submit"
                onclick="location.href='${createLink( controller: 'statistics', action: 'showStatisticsOnMap', params: [ experimentRunResultId: experimentRunResultId ] )}'">
            <g:message code="stats.stats.showonmap"/> </button>

        <button class="layoutButtonR3"
                type="submit"
                onclick="location.href='${createLink( controller: 'statistics', action: 'showGroupDetails', params: [ experimentRunResultId: experimentRunResultId ] )}'">
            <g:message code="stats.stats.detailstation"/> </button>

    </span>

</span>
<br/><br/>
<div class="pContainerConfigureStats">
    <div id="accordion">
        <g:each in="${stats.fleets}" var="fleetStat">
            <div>
                <span class="titleStats">
                    <g:message code="statistics.showStats.fleetOverview"/>: ${fleetStat.name}
                    <g:message code="templates.configuration.fleet._distribution.with"/> ${fleetStat.carResults.size()}

                    <g:message code="templates.configuration.fleet._distribution.car"/>
                    <g:if test="${fleetStat.name != "All cars of Experiment"}">
                        |
                        <g:message code="templates.configuration.fleet._distribution.distribution"/>
                        ${fleetStat.distribution}
                        <g:if test="${fleetStat.plannedFromKm}">
                            from ${fleetStat.plannedFromKm} km to ${fleetStat.plannedToKm} km
                        </g:if>
                    </g:if>
                </span>
            </div>
            <div class="rowUp">
                <g:each in="${fleetStat.carTypes}" var="carType">
                    <g:form id="allCarTypes" controller="statistics" action="showPicture" target="_blank">
                        <g:hiddenField name="carTypeName" value="${carType.name}"/>
                        <g:hiddenField name="fleetName" value="${fleetStat.name}"/>
                        <g:hiddenField name="experimentRunResultId" value="${experimentRunResultId}"/>
                        <div class="contentImageStats">
                            <div class="rowUpStats">
                                <div class="cartypeStats">
                                    <span><g:message code="stats.stats.cartype"/> <span
                                            class="cartypeBold">${carType.name}</span></span>
                                    <span><g:message code="stats.stats.succsesful"/> <span
                                            class="cartypeBold">${carType.countSuccessful}</span> <g:message
                                            code="stats.stats.of"/> <span class="cartypeBold">${carType.countAll}</span>
                                    </span>
                                    <span><g:message code="stats.stats.failed"/> <span
                                            class="cartypeBold">${carType.countFails}</span> <g:message
                                            code="stats.stats.of"/> <span class="cartypeBold">${carType.countAll}</span>
                                    </span>
                                </div>
                            </div>

                            <div class="rowMiddle">
                                <table class="table">
                                    <tr class="table" align="center">
                                        <td width="100px" class="shiebenTitle">
                                            <g:message code="stats.stats.succsesscategory"/>
                                        </td>
                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::plannedTime"
                                                            id="${fleetStat.name}::${carType.name}::plannedTime"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.planedtime"/>
                                        </td>

                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::realDrivingTime"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"
                                                            id="${fleetStat.name}::${carType.name}::realDrivingTime"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.realdrivingtime"/>
                                        </td>
                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::realTime"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"
                                                            id="${fleetStat.name}::${carType.name}::realTime"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.realtime"/>
                                        </td>
                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::loadingTime"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"
                                                            id="${fleetStat.name}::${carType.name}::loadingTime"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.loadingtime"/>
                                        </td>

                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::plannedDistance"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"
                                                            id="${fleetStat.name}::${carType.name}::plannedDistance"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.planneddistance"/>
                                        </td>
                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::realDistance"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"
                                                            id="${fleetStat.name}::${carType.name}::realDistance"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.realdistance"/>
                                        </td>

                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::energyLoaded"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"
                                                            id="${fleetStat.name}::${carType.name}::energyLoaded"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.energyloaded"/>
                                        </td>
                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::energyDemanded"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick(this);"
                                                            id="${fleetStat.name}::${carType.name}::energyDemanded"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.energydemanded"/>
                                        </td>

                                    </tr>
                                    <tr class="table">

                                        <td width="100px" class="shieben1">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::all"
                                                            id="${fleetStat.name}::${carType.name}::all"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick( this )"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.all"/>
                                        </td>

                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::plannedTime">
                                            ${TimeCalculator.readableTime(carType.stats.allCars.plannedTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::realDrivingTime">
                                            ${TimeCalculator.readableTime(carType.stats.allCars.realDrivingTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::realTime">
                                            ${TimeCalculator.readableTime(carType.stats.allCars.realTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::loadingTime">
                                            ${TimeCalculator.readableTime(carType.stats.allCars.loadingTime.mean)}
                                        </td>

                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::plannedDistance">
                                            ${carType.stats.allCars.plannedDistance.mean}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::realDistance">
                                            ${carType.stats.allCars.realDistance.mean}
                                        </td>

                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::energyLoaded">
                                            ${carType.stats.allCars.energyLoaded.mean}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="all::${fleetStat.name}::${carType.name}::energyDemanded">
                                            ${carType.stats.allCars.energyDemanded.mean}
                                        </td>

                                    </tr>
                                    <tr class="table">

                                        <td width="100px" class="shieben1">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::successful"
                                                            id="${fleetStat.name}::${carType.name}::successful"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick( this )"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.succsesful"/>
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::plannedTime">
                                            ${TimeCalculator.readableTime(carType.stats.succeededCars.plannedTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::realDrivingTime">
                                            ${TimeCalculator.readableTime(carType.stats.succeededCars.realDrivingTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::realTime">
                                            ${TimeCalculator.readableTime(carType.stats.succeededCars.realTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::loadingTime">
                                            ${TimeCalculator.readableTime(carType.stats.succeededCars.loadingTime.mean)}
                                        </td>

                                        <td align="center" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::plannedDistance">
                                            ${carType.stats.succeededCars.plannedDistance.mean}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::realDistance">
                                            ${carType.stats.succeededCars.realDistance.mean}
                                        </td>

                                        <td align="center" class="shieben" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::energyLoaded">
                                            ${carType.stats.succeededCars.energyLoaded.mean}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="successful::${fleetStat.name}::${carType.name}::energyDemanded">
                                            ${carType.stats.succeededCars.energyDemanded.mean}
                                        </td>

                                    </tr>
                                    <tr class="table">

                                        <td width="100px" class="shieben1">
                                            <label class="checkbox">
                                                <g:checkBox name="${fleetStat.name}::${carType.name}::failed"
                                                            id="${fleetStat.name}::${carType.name}::failed"
                                                            class="${fleetStat.name}::${carType.name}"
                                                            onclick="handleCheckBoxClick( this )"/>

                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.failed"/>
                                        </td>

                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::plannedTime">
                                            ${TimeCalculator.readableTime(carType.stats.failedCars.plannedTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::realDrivingTime">
                                            ${TimeCalculator.readableTime(carType.stats.failedCars.realDrivingTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::realTime">
                                            ${TimeCalculator.readableTime(carType.stats.failedCars.realTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::loadingTime">
                                            ${TimeCalculator.readableTime(carType.stats.failedCars.loadingTime.mean)}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::plannedDistance">
                                            ${carType.stats.failedCars.plannedDistance.mean}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::realDistance">
                                            ${carType.stats.failedCars.realDistance.mean}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::energyLoaded">
                                            ${carType.stats.failedCars.energyLoaded.mean}
                                        </td>
                                        <td align="center" class="shieben" width="100px"
                                            id="failed::${fleetStat.name}::${carType.name}::energyDemanded">
                                            ${carType.stats.failedCars.energyDemanded.mean}
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <div class="rowMiddleWithoutBorder4">
                                                <g:submitButton name="Display graph"
                                                                value="${message(code: 'stats.stats.displaygraph')}"
                                                                id="${fleetStat.name}::${carType.name}"/>

                                            </div>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                        </div>
                    </g:form>
                </g:each>
            </div>
        </g:each>
    </div>
</div>


<div id="updateMe"></div>
<g:javascript>

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
<script>
    $("#accordion").accordion({
        active: false,
        heightStyle: "content",
        collapsible: true,
        alwaysOpen: false

    });
    $("#accordion1").accordion({
        active: false,
        heightStyle: "content",
        collapsible: true,
        alwaysOpen: false
    });
</script>
</body>
</html>


