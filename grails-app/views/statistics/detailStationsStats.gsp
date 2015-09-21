<%--
  Created by IntelliJ IDEA.
  User: glenn
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

<%--
    for each fleet in stats map print out a tabl
    #e
--%>
<br/><br/>
<g:form action="showStatisticsOnMap">
    <g:hiddenField name="experimentRunResultId" value="${experimentRunResultId}"/>
    <g:submitButton name="Show on map"
                    value="${message(code: 'stats.stats.showonmap')}"

                    id="${experimentRunResultId}" target="_blank"/>
</g:form>

<g:form action="showFleetDetails">
    <g:hiddenField name="experimentRunResultId" value="${experimentRunResultId}"/>
    <g:submitButton name="Detail car information"
                    value="${message(code: 'stats.stats.detailcar')}"
                    params="['experimentRunResultId':$experimentRunResultId]"
                    target="_blank"/>
</g:form>

<div class="pContainerConfigureStats">
    <div id="accordion1">
        <g:each in="${stats.groups}" var="groupStat">
            <div>
                <span class="titleStats">
                    <g:message code="statistics.showStats.stationOverview"/> ${groupStat.name}
                </span>
            </div>

            <div class="rowUp">
                <g:each in="${groupStat.stationTypes}" var="stationType">
                    <g:form id="allCarTypes2" controller="statistics" action="showStationPicture" target="_blank">
                        <g:hiddenField name="stationTypeName" value="${stationType.name}"/>
                        <g:hiddenField name="groupName" value="${groupStat.name}"/>
                        <g:hiddenField name="experimentRunResultId" value="${experimentRunResultId}"/>
                        <div class="contentImageStats">
                            <div class="rowUpStats">
                                <div class="cartypeStats">
                                    <span>StationType: <span
                                            class="cartypeBold">${stationType.name}</span>
                                    </span>
                                    <span>Successful: <span
                                            class="cartypeBold">${stationType.stats.succeededStations.timeInUse.valuez.size()}</span> of
                                        <span class="cartypeBold">${stationType.stats.allStations.timeInUse.valuez.size()}</span>
                                    </span>
                                    <span>Failed: <span
                                            class="cartypeBold">${stationType.stats.failedStations.timeInUse.valuez.size()}</span> of
                                        <span class="cartypeBold">${stationType.stats.allStations.timeInUse.valuez.size()}</span>
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
                                                <g:checkBox name="${groupStat.name}::${stationType.name}::timeInUse"
                                                            id="${groupStat.name}::${stationType.name}::timeInUse"
                                                            class="${groupStat.name}::${stationType.name}"
                                                            onclick="handleCheckBoxClickStation(this);"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.timeinusemean"/>
                                        </td>

                                        <td width="100px" class="shiebenTitle">
                                            <g:message code="stats.stats.avarageutilization"/>
                                        </td>

                                        <td width="100px" class="shiebenTitle">
                                            <%--
                                            <g:checkBox name="${groupStat.name}::${stationType.name}::timeInUseSum"
                                                        id="${groupStat.name}::${stationType.name}::timeInUseSum"
                                                        class="${groupStat.name}::${stationType.name}"
                                                        onclick="handleCheckBoxClick(this);" />
                                            --%>
                                            <g:message code="stats.stats.timeinusesum"/>
                                        </td>

                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${groupStat.name}::${stationType.name}::timeLiving"
                                                            class="${groupStat.name}::${stationType.name}"
                                                            onclick="handleCheckBoxClickStation(this);"
                                                            id="${groupStat.name}::${stationType.name}::timeLiving"/>

                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.timeliving"/>
                                        </td>
                                        <td width="100px" class="shiebenTitle">
                                            <label class="checkbox">
                                                <g:checkBox name="${groupStat.name}::${stationType.name}::failedToRoute"
                                                            class="${groupStat.name}::${stationType.name}"
                                                            onclick="handleCheckBoxClickStation(this);"
                                                            id="${groupStat.name}::${stationType.name}::failedToRoute"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.failedtoroute"/>
                                        </td>

                                    </tr>

                                    <tr class="table">

                                        <td width="100px" class="shiebenStations1">
                                            <label class="checkbox">
                                                <g:checkBox name="${groupStat.name}::${stationType.name}::all"
                                                            id="${groupStat.name}::${stationType.name}::all"
                                                            class="${groupStat.name}::${stationType.name}"
                                                            onclick="handleCheckBoxClick( this )"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.all"/>
                                        </td>

                                        <td class="shiebenStations" align="center" width="100px"
                                            id="all::${groupStat.name}::${stationType.name}::timeInUse">
                                            ${TimeCalculator.readableTime(stationType.stats.allStations.timeInUse.mean)}
                                        </td>

                                        <g:if test="${stationType.stats.allStations.timeLiving.mean == 0}">
                                            <td class="shiebenStations" align="center" width="100px"
                                                id="11122345::${groupStat.name}::${stationType.name}::3453467">
                                                0 %
                                            </td>
                                        </g:if>
                                        <g:else>
                                            <td class="shiebenStations" align="center" width="100px"
                                                id="11122345::${groupStat.name}::${stationType.name}::3453467">
                                                ${Math.round((stationType.stats.allStations.timeInUse.mean / stationType.stats.allStations.timeLiving.mean) * 100)} %
                                            </td>
                                        </g:else>


                                        <td class="shiebenStations" align="center" width="100px"
                                            id="all::${groupStat.name}::${stationType.name}::timeInUseSum">
                                            ${TimeCalculator.readableTime(stationType.stats.allStations.timeInUse.sum)}
                                        </td>



                                        <td class="shiebenStations" align="center" width="100px"
                                            id="all::${groupStat.name}::${stationType.name}::timeLiving">
                                            ${TimeCalculator.readableTime(stationType.stats.allStations.timeLiving.mean)}
                                        </td>
                                        <td class="shiebenStations" align="center" width="100px"
                                            id="all::${groupStat.name}::${stationType.name}::failedToRoute">
                                            ${(stationType.stats.allStations.failedToRoute.mean)}
                                        </td>

                                    </tr>

                                    <tr class="table">

                                        <td width="100px" class="shiebenStations1">
                                            <label class="checkbox">
                                                <g:checkBox name="${groupStat.name}::${stationType.name}::successful"
                                                            id="${groupStat.name}::${stationType.name}::successful"
                                                            class="${groupStat.name}::${stationType.name}"
                                                            onclick="handleCheckBoxClick( this )"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.succsesful"/>
                                        </td>

                                        <td class="shiebenStations" align="center" width="100px"
                                            id="successful::${groupStat.name}::${stationType.name}::timeInUse">
                                            ${TimeCalculator.readableTime(stationType.stats.succeededStations.timeInUse.mean)}
                                        </td>

                                        <g:if test="${stationType.stats.succeededStations.timeLiving.mean == 0}">
                                            <td class="shiebenStations" align="center" width="100px"
                                                id="1133122345::${groupStat.name}::${stationType.name}::345343467">
                                                0 %
                                            </td>
                                        </g:if>
                                        <g:else>
                                            <td class="shiebenStations" align="center" width="100px"
                                                id="1112232345::${groupStat.name}::${stationType.name}::344353467">
                                                ${Math.round((stationType.stats.succeededStations.timeInUse.mean / stationType.stats.succeededStations.timeLiving.mean) * 100)} %
                                            </td>
                                        </g:else>

                                        <td class="shiebenStations" align="center" width="100px"
                                            id="successful::${groupStat.name}::${stationType.name}::timeInUseSum">
                                            ${TimeCalculator.readableTime(stationType.stats.succeededStations.timeInUse.sum)}
                                        </td>
                                        <td class="shiebenStations" align="center" width="100px"
                                            id="successful::${groupStat.name}::${stationType.name}::timeLiving">
                                            ${TimeCalculator.readableTime(stationType.stats.succeededStations.timeLiving.mean)}
                                        </td>
                                        <td class="shiebenStations" align="center" width="100px"
                                            id="successful::${groupStat.name}::${stationType.name}::failedToRoute">
                                            ${(stationType.stats.succeededStations.failedToRoute.mean)}
                                        </td>

                                    </tr>

                                    <tr class="table">

                                        <td width="100px" class="shiebenStations1">
                                            <label class="checkbox">
                                                <g:checkBox name="${groupStat.name}::${stationType.name}::failed"
                                                            id="${groupStat.name}::${stationType.name}::failed"
                                                            class="${groupStat.name}::${stationType.name}"
                                                            onclick="handleCheckBoxClick( this )"/>
                                                <span></span>
                                            </label>
                                            <g:message code="stats.stats.failed"/>
                                        </td>

                                        <td class="shiebenStations" align="center" width="100px"
                                            id="failed::${groupStat.name}::${stationType.name}::timeInUse">
                                            ${TimeCalculator.readableTime(stationType.stats.failedStations.timeInUse.mean)}
                                        </td>

                                        <g:if test="${stationType.stats.failedStations.timeLiving.mean == 0}">
                                            <td class="shiebenStations" align="center" width="100px"
                                                id="1112246345::${groupStat.name}::${stationType.name}::34534767">
                                                0 %
                                            </td>
                                        </g:if>
                                        <g:else>
                                            <td class="shiebenStations" align="center" width="100px"
                                                id="1112562345::${groupStat.name}::${stationType.name}::563453467">
                                                ${Math.round((stationType.stats.failedStations.timeInUse.mean / stationType.stats.failedStations.timeLiving.mean) * 100)} %
                                            </td>
                                        </g:else>

                                        <td class="shiebenStations" align="center" width="100px"
                                            id="failed::${groupStat.name}::${stationType.name}::timeInUseSum">
                                            ${TimeCalculator.readableTime(stationType.stats.failedStations.timeInUse.sum)}
                                        </td>
                                        <td class="shiebenStations" align="center" width="100px"
                                            id="failed::${groupStat.name}::${stationType.name}::timeLiving">
                                            ${TimeCalculator.readableTime(stationType.stats.failedStations.timeLiving.mean)}
                                        </td>
                                        <td class="shiebenStations" align="center" width="100px"
                                            id="failed::${groupStat.name}::${stationType.name}::failedToRoute">
                                            ${(stationType.stats.failedStations.failedToRoute.mean)}
                                        </td>

                                    </tr>
                                    <tr>
                                        <td COLSPAN=4>
                                            <div class="rowMiddleWithoutBorder4">
                                                <g:submitButton name="Display graph"
                                                                value="${message(code: 'stats.stats.displaygraph')}"
                                                                id="${groupStat.name}::${stationType.name}" target="_blank"/>
                                                <g:submitToRemote class="addButton"
                                                                  url="[action: 'showStationsOnMap']"
                                                                  update="updateMe"
                                                                  name="showGroups"
                                                                  value="${message(code: 'stats.stats.displayonmap')}" target="_blank"/>
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


