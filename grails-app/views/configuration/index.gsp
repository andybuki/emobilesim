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
    <meta name="layout" content="mainConfiguration" />
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


    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui-timepicker-addon.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jslider.css')}" type='text/css' />

    <script src="http://maps.google.com/maps/api/js?v=3&amp;sensor=false"></script>

</head>
<body>

    <div class="pContainerConfigure">

        <div class="rowUp">
            <div class="leftBoldBig1"><g:message code="configuration.index.configuresimulation"/> <g:textField name="nameForSimulation" value="${simulationName}"/></div>
                <g:form action="changeArea">
                    <div class="right0PX">
                        <span class="rightBoldBig1">
                            <g:message code="configuration.index.simulationarea"/> ${simulationArea}
                            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                <span class="rightBoldBig2">
                                    <g:if test="${(addedFleets == null || addedFleets.size() == 0)&&(addedGroups == null || addedGroups.size() == 0)}">
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

            <div class="layoutLeft">
                <div class="contentLeftBigConfiguration">
                    <div class="rowUp">
                        <div class="leftbig"><g:message code="simulation.index.fleetconfiguration"/></div>
                        <div class="right0PX"><img width="35px"src="${g.resource( dir: '/images', file: 'electrocar.png' )}"/></div>
                        <div class="clear"></div>
                    </div>

                    <div class="rowSpace">
                        <div class="clear"></div>
                    </div>

                    <div class="rowGroup">
                        <div class="rowBrightGrey">
                            <div class="leftConfigurationExtraLong">
                                <g:message code="configuration.index.selectfleets"/>
                            </div>
                            <div class="right0PX"></div>
                            <div class="clear"></div>
                        </div>

                        <g:if test="${availableFleets != null && availableFleets.size() > 0}">
                            <div class="rowMiddleWithoutBorder">
                                <div class="leftText"><g:message code="simulation.index.existentfleet"/></div>
                                <div class="rightOnlyButton">
                                    <g:form controller="configuration" action="addExistentFleetToConfiguration">
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <g:select name="fleetId" from="${availableFleets}" optionKey="id" optionValue="${{it.name+' ('+it.cars?.size()+' Cars)'}}" />
                                        <g:submitButton name="add" onclick="window.location.reload()" value="${message(code: 'configuration.index.addfleet')}" />
                                    </g:form>
                                </div>
                                <div class="clear"></div>
                            </div>
                        </g:if>

                        <div class="rowMiddleWithoutBorder">
                            <g:form action="createFleetView">
                                <div class="leftText"><g:message code="configuration.index.enoughfleets"/></div>
                                <div class="rightOnlyButton">
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
                    <div class="rowGroup">
                        <div class="rowBrightGrey">
                            <div class="leftConfigurationExtraLong">
                                <g:message code="configuration.index.collectfleets"/>
                            </div>
                        </div>
                        <g:if test="${addedFleets != null && addedFleets.size() > 0}">
                            <g:each in="${addedFleets}" var="addedFleet">
                            <%--<g:message code="simulation.index.addedfleet"/>--%>
                                <div class="rowMiddleWithoutBorder">
                                    <g:if test="${addedFleet.fleetStatus == FleetStatus.CONFIGURED}">
                                        <div class="leftCollectFleets">
                                            ${addedFleet.name} ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/> ) <img class="helpButton" title="<g:message code="configuration.index.allroutes"/>" src="${g.resource( dir: '/images', file: 'checked.png' )}"/>
                                        </div>
                                    </g:if>
                                    <g:if test="${addedFleet.fleetStatus == FleetStatus.SCHEDULED_FOR_CONFIGURING}">
                                        <div class="leftCollectFleets">
                                            ${addedFleet.name}  ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/>  ) <img class="helpButton" title="<g:message code="configuration.index.scheduleroute"/>" src="${g.resource( dir: '/images', file: 'helpnew.png' )}"/>
                                        </div>
                                    </g:if>

                                    <g:if test="${addedFleet.fleetStatus == FleetStatus.NOT_CONFIGURED}">
                                        <div class="leftCollectFleets">
                                            ${addedFleet.name}  ( ${addedFleet.cars.size()} <g:message code="execution.playsimulation.car"/>  ) <img class="helpButton" title="<g:message code="configuration.index.routesconfigured"/>" src="${g.resource( dir: '/images', file: 'attention.png' )}"/>
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
                                            <g:form action="showFleetRoutesOnMap">
                                                <g:hiddenField name="configurationStubId" value="${configurationStubId}" />
                                                <g:submitToRemote class="addButton"
                                                                  url="[action: 'showFleetRoutesOnMap']"
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
                                        <g:if test="${addedFleet.fleetStatus == FleetStatus.NOT_CONFIGURED}">
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
                                    <div class="clear"></div>
                                </div>
                            </g:each>
                        </g:if>

                        <div class="rowMiddleWithoutBorder2">
                            <div class="left0PX"></div>
                            <div class="right0PX"></div>
                            <div class="clear"></div>
                        </div>
                    </div>
                    <div class="rowSpace">
                        <div class="clear"></div>
                    </div>
                </div>
            </div>

            <div class="layoutRight">
                <div class="contentRightBigConfiguration">
                    <div class="rowUp">
                        <div class="leftbig">
                            <g:message code="simulation.index.fillingconfiguration"/>
                        </div>
                        <div class="right0PX"><img width="30px"src="${g.resource( dir: '/images', file: 'ladestation.png' )}"/></div>
                        <div class="clear"></div>
                    </div>

                    <div class="rowSpace">
                        <div class="clear"></div>
                    </div>

                    <div class="rowGroup">
                        <div class="rowBrightGrey">
                            <div class="leftConfigurationLong">
                                <g:message code="configuration.index.selectfillingstation"/>
                            </div>
                            <div class="right0PX">
                            </div>
                            <div class="clear"></div>
                        </div>

                        <g:if test="${availableFillingStationGroups != null && availableFillingStationGroups.size() > 0}">
                            <div class="rowMiddleWithoutBorder">
                                <div class="leftConfiguration"><g:message code="simulation.index.selectgroup"/></div>
                                <div class="rightOnlyButton">
                                    <g:form controller="configuration" action="addExistentGroupToConfiguration">
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <g:select name="groupId" from="${availableFillingStationGroups}" optionKey="id" optionValue="${{it.name+' ('+it.fillingStations?.size()+' Stations)'}}" />
                                        <g:submitButton name="add" onclick="window.location.reload()" value="${message(code: 'configuration.index.addgrouptosimulation')}" />
                                    </g:form>
                                </div>
                                <div class="clear"></div>
                            </div>
                        </g:if>
                        <div class="rowMiddleWithoutBorder">
                            <g:form action="createGroupView">
                                <div class="leftCarTypes"><g:message code="simulation.index.createnewgroup"/></div>
                                <div class="rightOnlyButton">
                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                    <g:submitToRemote class="addButton" url="[action: 'createGroupView']" update="updateMe" name="submit" value="${message(code: 'configuration.index.createnewgroup')}" />
                                    <%--<img width="22px"src="${g.resource( dir: '/images', file: 'add.png' )}">--%>
                                </div>
                                <div class="clear"></div>
                            </g:form>
                        </div>
                    </div>



                    <div class="rowSpace">
                        <div class="clear"></div>
                    </div>
                    <div class="rowGroup">
                        <div class="rowBrightGrey">
                            <div class="leftConfigurationExtraLong">
                                <g:message code="configuration.index.collectedfillingstation"/>
                            </div>
                            <div class="right0PX">
                            </div>
                            <div class="clear"></div>

                        </div>

                        <g:if test="${addedGroups != null && addedGroups.size() > 0}">
                            <g:each in="${addedGroups}" var="addedGroup">

                                <g:form controller="configuration" action="removeGroupFromConfiguration">
                                <%--<g:message code="simulation.index.addedfleet"/>--%>
                                    <div class="rowMiddleWithoutBorder">
                                    <%--<div class="leftCollectFleets">
                                        ${addedGroup.name} with ${addedGroup.fillingStations.size()*2} Filling Stations
                                    </div>--%>

                                        <g:if test="${addedGroup.groupStatus == GroupStatus.CONFIGURED}">
                                            <div class="leftCollectFleets">
                                                ${addedGroup.name} (${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/> ) <img class="helpButton" title="<g:message code="configuration.index.allstations"/>" src="${g.resource( dir: '/images', file: 'checked.png' )}"/>
                                            </div>
                                        </g:if>
                                        <g:if test="${addedGroup.groupStatus == GroupStatus.SCHEDULED_FOR_CONFIGURING}">
                                            <div class="leftCollectFleets">
                                                ${addedGroup.name} ( ${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/>  ) <img class="helpButton" title="<g:message code="configuration.index.schedulestation"/>" src="${g.resource( dir: '/images', file: 'helpnew.png' )}"/>
                                            </div>
                                        </g:if>

                                        <g:if test="${addedGroup.groupStatus == GroupStatus.NOT_CONFIGURED}">
                                            <div class="leftCollectFleets">
                                                ${addedGroup.name} ( ${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/>  ) <img class="helpButton" title="<g:message code="configuration.index.stationsconfigured"/>" src="${g.resource( dir: '/images', file: 'attention.png' )}"/>
                                            </div>
                                        </g:if>

                                        <div class="right65PX">
                                            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                            <g:hiddenField name="groupId" value="${addedGroup.id}"/>
                                            <g:submitButton name="removeGroup" value="${message(code: 'configuration.index.unselect')}"/>
                                        </div>

                                        <div class="right100PX">
                                            <g:if test="${addedGroup.groupStatus == GroupStatus.CONFIGURED}">
                                                <g:form action="showGroupStationsOnMap">
                                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}" />
                                                    <g:submitToRemote class="addButton"
                                                                      url="[action: 'showGroupStationsOnMap']"
                                                                      update="updateMe"
                                                                      name="showGroups"
                                                                      value="${message(code: 'configuration.index.showstations')}" />

                                                </g:form>
                                            </g:if>
                                            <span class="konfiguration">
                                                <g:if test="${addedGroup.groupStatus == GroupStatus.SCHEDULED_FOR_CONFIGURING}">
                                                    <g:message code="configuration.index.pleasewait"/>
                                                </g:if>
                                            </span>
                                            <g:if test="${addedGroup.groupStatus == GroupStatus.NOT_CONFIGURED}">
                                                <g:form action="createGroupSelectorView">
                                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                    <g:hiddenField name="groupId" value="${addedGroup.id}"/>
                                                    <g:submitToRemote class="addButton"
                                                                      url="[action: 'createGroupSelectorView']"
                                                                      update="updateMe"
                                                                      name="submit"
                                                                      value="${message(code: 'configuration.index.configurestations')}" />
                                                </g:form>
                                            </g:if>
                                        </div>
                                        <div class="clear"></div>
                                    </div>
                                </g:form>

                            </g:each>
                        </g:if>
                        <div class="rowMiddleWithoutBorder2">
                            <div class="left0PX"></div>
                            <div class="right0PX"></div>
                            <div class="clear"></div>
                        </div>
                    </div>

                    <div class="rowSpace">
                        <div class="clear"></div>
                    </div>


                </div>
            </div>
        </div>

        <g:form action="saveFinishedConfiguration">
            <br><br>
                <div class="layoutButton">
                    <span class="layoutButtonL">
                        <span class="addButtonCancel"><g:link controller="sim" action=""><g:message code="configuration.index.cancel"/></g:link></span>
                        <%--<g:submitToRemote class="addButton" url="[action: '/front/startSimulation']" update="sim" name="submit" value="CANCEL" />--%>
                    </span>
                                <g:if test="${(savedGroups == 1 && savedFleets == 1 && configuredGroups == 0 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0)  ||
                                              (savedGroups == 1 && savedFleets == 1 && configuredGroups == 0 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 0 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 0 && configuredGroups == 1 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 0 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 0 && savedFleets == 1 && configuredGroups == 1 && configuredFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0) ||
                                              (savedGroups == 1 && savedFleets == 0 && configuredGroups == 0 && configuredFleets==1 && notConfiguredFleets==0 && notConfiguredGroups==0)
                                }">
                                        <span class="layoutButtonM"></span>
                                        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                        <span class="layoutButtonR"><g:submitButton name="send" value="${message(code: 'configuration.index.save')}"/></span>
                                </g:if>
                </div>
        </g:form>
        <g:form controller="execution" action="executeExperiment">
                <g:if test="${(configuredGroups==1 && configuredFleets==1 && savedGroups==0 && savedFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0)}">
                                <div class="layoutButton">
                                    <span class="layoutButtonM"></span>
                                    <g:hiddenField name="relativeSearchLimit" value="50" />
                                    <g:hiddenField name="configurationId" value="${configurationStubId}"/>
                                    <span class="layoutButtonR">
                                        <g:submitButton name="send" value="${message(code: 'configuration.index.execute')}"/>
                                    </span>
                                </div>
                </g:if>
        </g:form>
        <div id="updateMe"></div>
    </div>
</body>

</html>
