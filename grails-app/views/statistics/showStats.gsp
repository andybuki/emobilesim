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
    <script src="${resource(dir: 'js', file: 'jquery.easytabs.js')}"></script>


    <script type="text/javascript" src="http://code.jquery.com/ui/1.11.2/jquery-ui.js"></script>
    <script type='text/javascript' src="${resource(dir: 'js', file: 'jquery.knob.js')}"></script>
    <script type="text/javascript">
        $(function()
        {

            var tabs = $('#tab-container');
            tabs.easytabs({defaultTab:"#tabo1"} );


        });
    </script>
    <style>
    #tabs2 ,#tabs3, #tabs4{
        display: none;

    }
    </style>
</head>

<body>
<g:render template="/layouts/topbarOnlyTitles"/>


<div id="tab-container" class='tab-containerFirst'>
    <ul class='etabs1'>
        <li class='tab' id="tabo1"><a  href="${createLink( controller: 'statistics', action: 'showStats', params: [ experimentRunResultId: experimentRunResultId ] )}">Datenvisualisierung</a></li>
        <li class='tab' id="tabo2"><a  href="${createLink( controller: 'statistics', action: 'showFleetDetails', params: [ experimentRunResultId: experimentRunResultId ] )}">Autodaten</a></li>
        <li class='tab' id="tabo3"><a href="${createLink( controller: 'statistics', action: 'showGroupDetails', params: [ experimentRunResultId: experimentRunResultId ])}">Ladestationen Daten</a></li>
        <li class='tab' id="tabo4"><a  href="${createLink( controller: 'statistics', action: 'showStatisticsOnMap', params: [ experimentRunResultId: experimentRunResultId ] )}"><g:message code="stats.stats.showonmap"/></a></li>
    </ul>
    <div class='panel-container'>
        <div id="tabs1">
            <div class="pContainerConfigure">
                    <div class="rowUp">
                        <div class="leftBoldBig1">
                            <div class="rowMiddleWithoutBorder22">
                                <%--<g:message code= "stats.stats.statistics"/>  ${stats.simulationName}:--%>

                                Ziele erreicht:  ${stats.successFullCars.size()} Autos
                                 <%--<g:message code="stats.stats.succsesfulcars"/>--%>,

                                <span>
                                    <g:if test="${stats.wholeRoute.size()==0}"></g:if>
                                    <g:if test="${stats.wholeRoute.size()!=0}">Distanz: ${Math.round(stats.wholeRoute.sum())?:0} km.
                                        <span><%--<g:message code="stats.stats.wholeroute"/>--%>,</span>
                                    </g:if>
                                </span>

                                <span>Ladestationen: ${stats.fillingStations.size()} Stück </span>
                                <span> <%--<g:message code="stats.stats.stations"/>--%>,</span>

                                <span>
                                    <g:if test="${stats.wholePower.size()!=0}">
                                        Energieverbrauch:
                                        ${Math.round(stats.wholePower.sum())} kW.
                                        <span><%--<g:message code="stats.stats.energy"/>--%></span>
                                    </g:if>
                                </span>

                        </div>
                   </div>
                        <div class="right0PX">
                            <span class="rightBoldBig3">
                                <span> <g:message code="stats.stats.simulationarea"/> - </span> ${stats.configurationArea}
                            </span>
                        </div>
                    </div>

                <div id="opener" title="Legende">
                    <table>
                        <tr>
                            <td style="vertical-align:bottom;"><g:message code="stats.stats.planeddis"/></td>
                            <td><div style="border-bottom:3px dashed #000; width:60px; padding-top: 6px;"></div></td>
                        </tr>
                        <tr>
                            <td><g:message code="stats.stats.realerfolg"/> </td>
                            <td><div style="border-bottom: 5px solid green; width:60px; padding-top: 6px;"></div></td>
                        </tr>
                        <tr>
                            <td><g:message code="stats.stats.realfailed"/> </td>
                            <td><div style="border-bottom: 4px solid red; width:60px; padding-top: 6px;"></div></td>
                        </tr>
                        <tr>
                            <td> <g:message code="stats.stats.battery"/> </td>
                            <td>
                                <div>
                                    <g:img name="removeFleet" class="kiko" uri="${resource(dir: '/images', file: 'kiko.png')}"/></div>

                            </td>
                        </tr>
                    </table>

                </div>

                    <div class="pContainerConfigureStats10" style="width:95%">
                        <br>
                        <g:each in="${stats.carsNumbers}" var="carsNumber">
                            <div class="visualisierung">${carsNumber.id}.${carsNumber.carType.name} - ${Math.round(carsNumber.realDistance)}km</div>
                            <g:if test="${carsNumber.carStatus =='MISSION_ACCOMBLISHED' }">
                                <div style="border-bottom: 5px solid green; width:${Math.round(carsNumber.realDistance*10)}px"></div>
                            </g:if>
                            <g:else>
                                <div style="border-bottom: 4px solid red; width:${Math.round(carsNumber.realDistance*10)}px"></div>
                            </g:else>

                            <span class="knobi" style="left:${Math.round(carsNumber.realDistance*10)}px"><input class="knob-dyn2" data-fgColor="chartreuse" data-thickness=".3" readonly value="${Math.round(carsNumber.endBattery*100)}"></span>

                            <div style="padding-top: 7px; border-left: 1px solid #ccc; border-bottom: 2px dashed #000; width:${Math.round(carsNumber.plannedDistance*10)}px"></div>
                        </g:each>
                        <div class="stabuki">

                        </div>
                    </div>
                    <br/><br/>
            </div>
        </div>
        <div id="tabs2">
        </div>
        <div id="tabs3">
        </div>
        <div id="tabs4">
        </div>
    </div>
    <div id="updateMe"></div>
</div>
</div>


<script>
    $(".knob-dyn2").knob({
                'min':0,
                'max':100,
                'readOnly': true,
                'width': 40,
                'height': 40,
                'fgColor': '#3399ff',
                'thickness': 0.3

    });

    $( "#dialog" ).dialog({
        autoOpen: false,
        show: {

        },
        hide: {

        }
    });

    $( "#opener" ).click(function() {
        $( "#dialog" ).dialog( "open" );
    });
</script>
<g:render template="/layouts/footer" />
</body>
</html>


