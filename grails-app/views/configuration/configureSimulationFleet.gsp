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
    <g:javascript src="slider/draggable-0.1.js"/>
    <g:javascript src="slider/jquery.slider.js"/>
    <g:javascript src="application.js" />
    <g:javascript src="ol/OpenLayers.js" />
    <g:javascript src="jquery.loading.js"/>
    <g:javascript src="jquery-ui-timepicker-addon.js"/>
    <calendar:resources lang="en" theme="tiger"/>
    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui-timepicker-addon.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jslider.css')}" type='text/css' />
    <script src="http://maps.google.com/maps/api/js?v=3.5&sensor=false"></script>
</head>
<body>
    <div class="pContainerConfigure">
        <div class="rowUp">
            <g:form action="changeName">
                <div class="leftBoldBig1">
                    <g:message code="configuration.index.configuresimulation"/> <g:textField name="nameForSimulation" value="${simulationName}"/>
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                    <g:submitButton name="ok" value="Ok" />
                </div>
            </g:form>
                <g:form action="changeArea">
                    <div class="right0PX">
                        <span class="rightBoldBig1">
                            <%--<g:message code="configuration.index.simulationarea"/>--%> ${simulationArea}
                            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                <span class="rightBoldBig2">
                                    <g:if test="${(addedFleets == null || addedFleets.size() == 0)}">
                                        <g:submitToRemote class="addButton"
                                            url="[action: 'changeArea']"
                                            update="updateMe"
                                            name="submit"
                                            value="${message(code:'configuration.index.changearea')}" />
                                    </g:if>
                                </span>
                        </span>
                    </div>
                </g:form>
                <div class="clear"></div>
        </div>
        <div class="layout">
            <div class="layoutLeft1">
                <div class="contentLeftBigConfiguration">
                    <%--<div class="rowUp">
                        <div class="leftbig"><g:message code="simulation.index.fleetconfiguration"/></div>
                        <div class="right0PX"><img width="35px"src="${g.resource( dir: '/images', file: 'electrocar.png' )}"/></div>
                        <div class="clear"></div>
                    </div>
                    <b>Create Fleet:</b>
                    <div class="rowSpace">
                        <div class="clear"></div>
                    </div>--%>

                    <div class="rowGroup1">
                        <%--div class="rowBrightGrey">
                            <div class="leftConfigurationExtraLong">
                                <g:message code="configuration.index.selectfleets"/>
                            </div>
                            <div class="right0PX"></div>
                            <div class="clear"></div>
                        </div>--%>

                        <g:if test="${availableFleets != null && availableFleets.size() > 0}">
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
                        <br>
                        <div class="rowMiddleWithoutBorder22">
                            <g:form action="createFleetView">
                                <%--<div class="leftText"><g:message code="configuration.index.enoughfleets"/></div>--%>
                                <div class="left1800PX">
                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                    <g:submitToRemote class="addButton"
                                                      url="[action: 'createFleetView']"
                                                      update="updateMe"
                                                      name="submit"
                                                      value="${message(code: 'simulation.index.createnewfleet')}" />
                                </div>
                                <div class="clear"></div>
                            </g:form>
                        </div>
                    </div>

                    <div class="rowSpace">
                        <div class="clear"></div>
                    </div>


                </div>
            </div>
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
                                    <g:form controller="configuration" action="removeFleetFromConfiguration">
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                        <g:submitButton name="removeFleet" value="${message(code: 'configuration.index.unselect')}"/>
                                    </g:form>
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
                                        <td class="col1"><b>CarId</b></td>
                                        <td class="col2"><b>Car name</b></td>
                                        <td class="col3"><b>Simulation StartTime</b></td>
                                        <td class="col3"><b>Akkuzustand</b></td>
                                    </tr>

                                        <g:each in="${addedFleet.cars}" var="car">
                                            <tr>
                                                <td class="col1" name="carId">${car.id}</td>
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

                                                            ${car.battery}%<span class="kW">(${(car.battery*car.carType.maxEnergyLoad)/100} kW)</span>
                                                           <g:submitToRemote class="addButton"
                                                                              url="[action: 'configureBatteryView']"
                                                                              update="updateMe"
                                                                              name="submit"
                                                                              value="${message(code: 'configuration.index.configureakku')}"
                                                                               />

                                                    </g:form>

                                                </td>
                                            </tr>

                                        </g:each>

                                </table>
                                <%--<div class="clear"></div>--%>
                        </g:each>
                    </g:if>
                <%--<div class="rowMiddleWithoutBorder2">
                    <div class="left0PX"></div>
                    <div class="right0PX"></div>
                    <div class="clear"></div>
                </div>--%>
            </div>
            <%--<div class="rowSpace">
                <div class="clear"></div>
            </div>--%>
            </div>
        </div>
        <div class="formConfiguration">
            <g:form action="saveFinishedConfigurationFleet">
                <br><br>
                <div class="layoutButton">
                    <span class="layoutButtonL">
                        <%--<span class="addButtonCancel"><g:link controller="configuration" action="configureSimulation"><g:message code="configuration.index.cancel"/></g:link></span>--%>
                        <%--<g:submitToRemote class="addButton" url="[action: '/front/startSimulation']" update="sim" name="submit" value="CANCEL" />--%>
                    </span>
                                <%--<g:if test="${(savedGroups == 1 && savedFleets == 1 && configuredGroups == 0 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0)  ||
                                              (savedGroups == 1 && savedFleets == 1 && configuredGroups == 0 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 0 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 0 && configuredGroups == 1 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 0 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 0 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 0 && configuredGroups == 0 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0)
                                }">--%>
                                <g:if test="${notConfiguredFleets==1 || savedFleets == 1 || configuredFleets==1}">
                                        <span class="layoutButtonM"></span>
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <span class="layoutButtonR"><g:submitButton name="send" value="${message(code: 'configuration.index.next')}"/></span>
                                <%--</g:if>--%>
                                </g:if>
                </div>
            </g:form>

            <%--<g:form controller="execution" action="executeExperiment">
                <g:if test="${(configuredGroups==1 && configuredFleets==1 && savedGroups==0 && savedFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0)}">
                                <div class="layoutButton">
                                    <span class="layoutButtonM"></span>
                                    <g:hiddenField name="relativeSearchLimit" value="20" />
                                    <g:hiddenField name="configurationId" value="${configurationStubId}"/>
                                    <span class="layoutButtonR">
                                        <g:submitButton name="send" value="${message(code: 'configuration.index.execute')}"/>
                                    </span>
                                </div>
                </g:if>
            </g:form>--%>
            <div id="updateMe"></div>
        </div>
    </div>
</body>

</html>
