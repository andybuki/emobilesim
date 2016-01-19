<%--
  Created by IntelliJ IDEA.
  User: glenn
  Date: 18.09.13
  Time: 18:11
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="de.dfki.gs.domain.utils.GroupStatus; de.dfki.gs.domain.utils.FleetStatus"  contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="configuration.index.newsimulation"/></title>
    <meta name="layout" content="mainConfigureSimulation" />
    <g:javascript library="jquery-1.11.2" />
    <g:javascript src="jquery-ui.min.js"/>
    <g:javascript src="slider/jshashtable-2.1_src.js"/>
    <g:javascript src="slider/jquery.numberformatter-1.2.3.js"/>
    <g:javascript src="slider/tmpl.js"/>
    <g:javascript src="slider/jquery.dependClass-0.1.js"/>
    <%--<g:javascript src="slider/draggable-0.1.js"/>
    <g:javascript src="slider/jquery.slider.js"/>--%>
    <g:javascript src="application.js" />
    <g:javascript src="ol/OpenLayers.js" />
    <g:javascript src="jquery-ui-timepicker-addon.js"/>
    <calendar:resources lang="en" theme="tiger"/>
    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui-timepicker-addon.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jslider.css')}" type='text/css' />
    <script src="${resource(dir: 'js', file: 'jquery.easytabs.js')}"></script>
    <script type="text/javascript">

        $(function()
        {

            var tabs = $('#tab-container');
            tabs.easytabs({defaultTab:"#tabo2"} );
            disable_easytabs(tabs, [2,0]);

            tabs.bind("easytabs:before", function (e, clicked) {
                if(clicked.parent().hasClass('disabled')) {
                    return false;
                }
            });



        });


        function on_disable_b_and_c_clicked()
        {
            var tabs = $('#tab-container');
            disable_easytabs(tabs, [2,0]);
            return false;
        }


        function disable_easytabs(tabs, indexes)
        {
            var lis = tabs.children('ul').children();
            var index = 0;
            lis.each(function()
            {
                var li = $(this);
                var a = li.children('a');
                var disabled = $.inArray(index, indexes) != -1;
                if (disabled)
                {
                    li.addClass('disabled');
                }
                else
                {
                    li.removeClass('disabled');
                }
                index++;
            });
        }

        function showSpinner() {
                       document.getElementById('spinner').style.display = 'inline';

                   }


        function form_submit() {
            var load = document.getElementById('loadbox');
            document.form1.submit();
            load.style.display = 'block';
            load.src = '/emobilesim/images/car.gif';
        }

    </script>
    <style>
    .rowUp2 {
        background-color: #AACCFF;
        border: 0px solid #ddd;
    }
    </style>
</head>
<body>
<%--<div id="loadbox" class="modalDialogNew">
<div><img id="loadbox2" src="/emobilesim/images/loader.gif"/>
</div></div>--%>


<div id="tab-container" class='tab-container'>
    <ul class='etabs1'>
        <li class='tab' id="tabo1"><a  href="#tabs1"><g:message code="configuration.index.configureroute" /></a></li>
        <li class='tab' id="tabo2"><a  href="#tabs2"><g:message code="configuration.index.configurefleet"/></a></li>
        <li class='tab' id="tabo3"><a  href="#tabs3"><g:message code="configuration.index.configurestation"/></a></li>
    </ul>
    <div class='panel-container'>
        <div id="tabs1">

        </div>
        <div id="tabs2">
            <div class="pContainerConfigure">
                <div class="rowUp2">
                    <div class="leftBoldBig1">
                        <g:message code= "configuration.index.simulationarea"/> ${simulationName}

                        <%--<g:if test="${availableFleets != null && availableFleets.size() > 0}">--%>
                        <div class="rowMiddleWithoutBorder22">
                            <span style="float:left;">
                                <g:form controller="configuration" action="addExistentFleetToConfiguration">
                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                    <g:select name="fleetId" from="${availableFleets}" optionKey="id" optionValue="${{"${g.message(code:'simulation.index.existentfleet')}: "  +it.name+' ('+it.cars?.size()+' Cars)'}}" />
                                    <g:submitButton name="add" value="${message(code: 'configuration.index.addfleet')}" />
                                </g:form>
                            </span>
                            <span style="float:right; padding-left: 5px;">
                                <g:form action="createFleetView">
                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                    <g:submitToRemote
                                            url="[action: 'createFleetView']"
                                            update="updateMe"
                                            name="submit"
                                            value="${message(code: 'simulation.index.createnewfleet')}" />
                                </g:form>
                            </span>
                        </div>
                        <%--</g:if>--%>


                    </div>

                    <div class="right0PX">
                        <span class="rightBoldBig3">
                            <g:message code="configuration.index.simulationarea"/> ${simulationArea}
                        </span>
                    </div>

                    <div class="clear"></div>
                </div>

                <div class="layout">
                    <%--<div class="layoutLeft1">
                        <div class="contentLeftBigConfiguration">



                            <div class="rowUp">
                                <div class="leftbig"><g:message code="simulation.index.fleetconfiguration"/></div>
                                <div class="right0PX"><img width="35px"src="${g.resource( dir: '/images', file: 'electrocar.png' )}"/></div>
                                <div class="clear"></div>
                            </div>
                            <b>Create Fleet:</b>
                            <div class="rowSpace">
                                <div class="clear"></div>
                            </div>--%>

                    <%--<div class="rowGroup1">
                        div class="rowBrightGrey">
                            <div class="leftConfigurationExtraLong">
                                <g:message code="configuration.index.selectfleets"/>
                            </div>
                            <div class="right0PX"></div>
                            <div class="clear"></div>
                        </div>--%>

                    <%--<g:if test="${availableFleets != null && availableFleets.size() > 0}">
                        <div class="rowMiddleWithoutBorder22">
                            <div class="leftText"><g:message code="simulation.index.existentfleet"/></div>
                            <div class="rightOnlyButton">
                                <g:form controller="configuration" action="addExistentFleetToConfiguration">
                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                    <g:select name="fleetId" from="${availableFleets}" optionKey="id" optionValue="${{it.name+' ('+it.cars?.size()+' Cars)'}}" />
                                    <g:submitButton name="add" value="${message(code: 'configuration.index.addfleet')}" />
                                </g:form>
                            </div>
                            <div class="clear"></div>
                        </div>
                    </g:if>


                </div>

                <div class="rowSpace">
                    <div class="clear"></div>
                </div>


            </div>
        </div>--%>
                    <div class="layoutRight">
                        <div class="rowGroup">
                        <%--<div class="rowBrightGrey">
                            <div class="leftConfigurationExtraLong">
                                <g:message code="configuration.index.collectfleets"/>
                            </div>
                        </div>--%>
                            <g:if test="${addedFleets != null && addedFleets.size() > 0}">
                                <g:each in="${addedFleets}" var="addedFleet">
                                <%--<g:message code="simulation.index.addedfleet"/>--%>
                                    <div class="rowMiddleWithoutBorder">
                                        <g:if test="${addedFleet.fleetStatus == FleetStatus.CONFIGURED}">
                                            <div class="leftCollectFleets">

                                                ${addedFleet.name} ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/> ) <%--<img class="helpButton" title="<g:message code="configuration.index.allroutes"/>" src="${g.resource( dir: '/images', file: 'checked.png' )}"/>--%>
                                            </div>

                                        </g:if>
                                        <g:if test="${addedFleet.fleetStatus == FleetStatus.SCHEDULED_FOR_CONFIGURING}">
                                            <div class="leftCollectFleets">
                                                ${addedFleet.name}  ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/>  ) <%--<img class="helpButton" title="<g:message code="configuration.index.scheduleroute"/>" src="${g.resource( dir: '/images', file: 'helpnew.png' )}"/>--%>
                                            </div>
                                        </g:if>

                                        <g:if test="${addedFleet.fleetStatus == FleetStatus.NOT_CONFIGURED}">
                                            <div class="leftCollectFleets">
                                                ${addedFleet.name}  ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/>  ) <%--<img class="helpButton" title="<g:message code="configuration.index.routesconfigured"/>" src="${g.resource( dir: '/images', file: 'attention.png' )}"/>--%>
                                            </div>


                                        </g:if>
                                        <div class="right65PX">

                                        </div>
                                        <div class="right100PX">
                                            <g:if test="${addedFleet.fleetStatus == FleetStatus.CONFIGURED}">
                                            <%--<g:form action="showFleetRoutesOnMap">
                                                <%--<g:hiddenField name="configurationStubId" value="${configurationStubId}" />--%>
                                            <%--<g:hiddenField name="fleetId" value="${addedFleet.id}" />
                                                <g:submitToRemote class="addButton"
                                                      url="[action: 'showSingleFleetRouteOnMap']"
                                                      update="updateMe"
                                                      name="showRoutes"
                                                      value="${message(code: 'configuration.index.showroutes')}"/>

                                            </g:form>--%>
                                            </g:if>
                                            <span class="konfiguration">
                                                <g:if test="${addedFleet.fleetStatus == FleetStatus.SCHEDULED_FOR_CONFIGURING}">
                                                    <g:message code="configuration.index.pleasewait"/>
                                                </g:if>
                                            </span>
                                            <g:if test="${addedFleet.fleetStatus == FleetStatus.NOT_CONFIGURED}">
                                            <%--<g:form action="createRouteSelectorView">
                                                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                                <g:submitToRemote class="addButton"
                                                                  url="[action: 'createRouteSelectorView']"
                                                                  update="updateMe"
                                                                  name="submit"
                                                                  value="${message(code: 'configuration.index.configureroutes')}" />
                                            </g:form>--%>
                                            </g:if>
                                        </div>

                                    </div>

                                    <table class="tableConfiguration">
                                        <tr>
                                            <td class="col1"><b>AutoID</b></td>
                                            <td class="col2"><b>Autoname</b></td>
                                            <td class="col3"><b>Simulationsstartzeit</b></td>
                                            <td class="col3"><b>Akkuzustand</b></td>
                                            <td class="col3" align="right">
                                                <g:form controller="configuration" action="removeFleetFromConfiguration">
                                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                    <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                                    <g:submitButton name="removeFleet" value="${message(code: 'configuration.index.unselect')}"/>
                                                </g:form>
                                            </td>
                                        <td class="col3>
                                                <g:form controller="configuration" action="removeFleetFromConfiguration">
                                            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                            <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                        <%--<g:submitButton name="removeFleet" value="${message(code: 'configuration.index.unselect')}" />--%>
                                            <%--<button id="modal-close">
                                            <g:img name="removeFleet" class="logoutexit" uri="${resource(dir: '/images', file: 'closesim.png')}"/>
                                            </button>--%>
                                        </g:form>
                                        </td>
                                        </tr>

                                        <g:each in="${addedFleet.cars}" var="car">
                                            <tr>
                                                <td class="col1" name="carId"> ${car.id} </td>
                                                <td class="col2">${car.name}</td>
                                                <td class="col3">
                                                    <g:form action="configureStartTimeView">
                                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                        <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                                        <g:hiddenField name="carId" value="${car.id}"/>

                                                        <g:if test="${(car.carStartTime)=='NULL'}">
                                                            ${(car.carStartTime)}
                                                        </g:if>
                                                        <g:if test="${(car.carStartTime)!=''}">
                                                            ${(car.carStartTime)}
                                                        </g:if>
                                                        <g:submitToRemote class="addButton"
                                                                          url="[action: 'configureStartTimeView']"
                                                                          update="updateMe"
                                                                          name="submit"
                                                                          value="${message(code: 'configuration.index.time')}"
                                                        />

                                                    </g:form>
                                                </td>
                                                <td class="col4">
                                                    <g:form action="configureBatteryView">
                                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                        <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                                        <g:hiddenField name="carId" value="${car.id}"/>

                                                        ${car.battery}%<span class="kW">${Math.round((car.battery*car.carType.maxEnergyLoad)/100)} kW</span>
                                                        <g:submitToRemote class="addButton"
                                                                          url="[action: 'configureBatteryView']"
                                                                          update="updateMe"
                                                                          name="submit"
                                                                          value="${message(code: 'configuration.index.configureakku')}"
                                                        />

                                                    </g:form>

                                                </td>
                                                <td></td>
                                                <td></td>
                                            </tr>

                                        </g:each>

                                    </table>

                                </g:each>
                            </g:if>

                        </div>

                    </div>
                </div>

                <div class="formConfiguration" id="load">
                    <div class="layoutLeft12">
                        <div class="contentLeftBigConfiguration1">
                            <div class="rowGroup3">
                                <div>
                                    <g:form name="form1" action="saveFinishedConfigurationFleet" onsubmit="form_submit();">
                                        <br><br>
                                        <div class="layoutButton">
                                            <g:if test="${addedFleets}">
                                                <span class="layoutButtonM"></span>
                                                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>

                                                <span class="layoutButtonR2"><g:submitButton id="submitButton2" onClick="form_submit();" name="send" value="${message(code: 'configuration.index.next')}" /></span>
                                            </g:if>
                                        </div>
                                    </g:form>
                                </div>
                            </div>

                            <div class="clear"></div>
                        </div>
                    </div>
                    <div id="updateMe"></div>
                </div>
            </div>
        </div>
        <div id="tabs3"/>
    </div>
</div>
<script type="text/javascript">



</script>

</body>
</html>
