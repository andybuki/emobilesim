<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 22.06.15
  Time: 21:57
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
            <div class="leftBoldBig2">
                <g:message code="configuration.index.configuresimulation"/>: ${simulationName}
                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            </div>
        </g:form>
        <g:form action="changeArea">
            <div class="right0PX">
                <span class="rightBoldBig1">
                    ${simulationArea}
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                    <span class="rightBoldBig2">

                    </span>
                </span>
            </div>
        </g:form>

        <div class="clear"></div>
    </div>

    <div class="layout">
        <div class="layoutLeft1">
            <div class="contentLeftBigConfiguration">

                <div class="rowGroup">

                    <g:if test="${addedFleets != null && addedFleets.size() > 0}">

                        <g:each in="${addedFleets}" var="addedFleet">
                            <div class="rowMiddleWithoutBorder">
                                <g:if test="${addedFleet.fleetStatus == FleetStatus.CONFIGURED}">
                                    <div class="leftCollectFleets0">
                                        ${addedFleet.name} ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/> ) <img class="helpButton" title="<g:message code="configuration.index.allroutes"/>" src="${g.resource( dir: '/images', file: 'checked.png' )}"/>
                                    </div>

                                </g:if>
                                <g:if test="${addedFleet.fleetStatus == FleetStatus.SCHEDULED_FOR_CONFIGURING}">
                                    <div class="leftCollectFleets0">
                                        ${addedFleet.name}  ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/>  ) <img class="helpButton" title="<g:message code="configuration.index.scheduleroute"/>" src="${g.resource( dir: '/images', file: 'helpnew.png' )}"/>
                                    </div>
                                </g:if>

                                <g:if test="${addedFleet.fleetStatus == FleetStatus.NOT_CONFIGURED}">
                                    <div class="leftCollectFleets0">
                                        ${addedFleet.name}  ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/>  ) <img class="helpButton" title="<g:message code="configuration.index.routesconfigured"/>" src="${g.resource( dir: '/images', file: 'attention.png' )}"/>
                                    </div>


                                </g:if>
                                <div class="right65PX">
                                    <g:form controller="configuration" action="removeFleetFromConfigurationRoute">
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                        <g:submitButton name="removeFleet" value="${message(code: 'configuration.index.unselect')}"/>
                                    </g:form>
                                </div>
                                <div class="right100PX">
                                    <g:if test="${addedFleet.distribution != de.dfki.gs.domain.utils.Distribution.OBU_ROUTES}">
                                        <g:form action="createRouteSelectorView">
                                            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                            <g:hiddenField name="fleetId" value="${addedFleet.id}"/>
                                            <g:submitToRemote class="addButton"
                                                              url="[action: 'createRouteSelectorView']"
                                                              update="updateMe"
                                                              name="submit"
                                                              value="${message(code: 'configuration.index.configureroutes')}" />
                                        </g:form>
                                    </g:if>
                                </div>

                            </div>

                        </g:each>
                    </g:if>
                    <br>
                </div>

                <div class="rowSpace">
                    <div class="clear"></div>
                </div>


            </div>
        </div>
        <div class="layoutRight">
            <div class="rowGroup2">
                <g:each in="${addedFleets}" var="addedFleet">
                    <g:if test="${addedFleet.fleetStatus == FleetStatus.CONFIGURED}">
                        <g:form action="showFleetRoutesOnMap">
                            <g:hiddenField name="fleetId" value="${addedFleet.id}" />
                            <g:submitToRemote class="addButton"
                                              url="[action: 'showSingleFleetRouteOnMap']"
                                              update="updateMe"
                                              name="showRoutes"
                                              value="${message(code: 'configuration.index.showroutes')}"/>

                        </g:form>
                    </g:if>
                    <span class="konfiguration">
                        <g:if test="${addedFleet.fleetStatus == FleetStatus.SCHEDULED_FOR_CONFIGURING}">
                            <g:message code="configuration.index.pleasewait"/>
                        </g:if>
                    </span>
                </g:each>


            </div>


        </div>
    </div>
    <div class="formConfiguration">

            <br><br>
            <div class="layoutButton">
                <span class="layoutButtonL">
                    <g:form controller="configuration" action="configureSimulation">
                        <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                        <span class="addButtonCancel">
                            <g:submitButton name="send" value="${message(code: 'configuration.index.back')}"/>
                            </span>
                        </span>
                    </g:form>
                </span>
        <g:form action="saveFinishedConfigurationRoute">
                <g:if test="${notConfiguredFleets==1 || savedFleets == 1 || configuredFleets==1}">

                    <span class="layoutButtonM"></span>
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>

                    <span class="layoutButtonR"><g:submitButton name="send" value="${message(code: 'configuration.index.next')}"/></span>
                </g:if>
                </g:form>
            </div>



        <div id="updateMe"></div>
    </div>
</div>
</body>
</html>