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
                <g:message code="configuration.index.configuresimulation"/>: ${simulationName} <%--<g:textField name="nameForSimulation" value="${simulationName}"/>--%>
                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                <%--<g:submitButton name="ok" onclick="window.location.reload()" value="Ok" />--%>
            </div>
        </g:form>
        <g:form action="changeArea">
            <div class="right0PX">
                <span class="rightBoldBig1">
                    <%--<g:message code="configuration.index.simulationarea"/>--%> ${simulationArea}
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                    <span class="rightBoldBig2">
                        <g:if test="${(addedGroups == null || addedGroups.size() == 0)}">
                            <%--<g:submitToRemote class="addButton"
                                              url="[action: 'changeArea']"
                                              update="updateMe"
                                              name="submit"
                                              value="${message(code:'configuration.index.changearea')}" />--%>
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
                </div>--%>

                <%--<div class="rowSpace">
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

                <g:if test="${availableFillingStationGroups != null && availableFillingStationGroups.size() > 0}">
                    <div class="rowMiddleWithoutBorder22">
                        <div class="leftText">Electric Stations:<%--<g:message code="simulation.index.selectgroup"/>--%></div>
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
                    <br>
                    <div class="rowMiddleWithoutBorder22">
                        <g:form action="createGroupView">
                            <div class="leftCarTypes"><%--<g:message code="simulation.index.createnewgroup"/>--%></div>
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


            </div>
        </div>
        <div class="layoutRight">
            <div class="rowGroup">
            <%--<div class="rowBrightGrey">
                <div class="leftConfigurationExtraLong">
                    <g:message code="configuration.index.collectfleets"/>
                </div>
            </div>--%>
                <g:if test="${addedGroups != null && addedGroups.size() > 0}">
                    <g:each in="${addedGroups}" var="addedGroup">
                        <g:form controller="configuration" action="removeGroupFromConfiguration">
                        <%--<g:message code="simulation.index.addedfleet"/>--%>
                            <div class="rowMiddleWithoutBorder">
                            <%--<div class="leftCollectFleets">
                                ${addedGroup.name} with ${addedGroup.fillingStations.size()*2} Filling Stations
                            </div>--%>

                                <g:if test="${addedGroup.groupStatus == GroupStatus.CONFIGURED}">
                                    <div class="leftCollectFleets0">
                                        ${addedGroup.name} (${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/> ) <img class="helpButton" title="<g:message code="configuration.index.allstations"/>" src="${g.resource( dir: '/images', file: 'checked.png' )}"/>
                                    </div>
                                </g:if>
                                <g:if test="${addedGroup.groupStatus == GroupStatus.SCHEDULED_FOR_CONFIGURING}">
                                    <div class="leftCollectFleets0">
                                        ${addedGroup.name} ( ${addedGroup.fillingStations.size()} <g:message code="execution.playsimulation.station"/>  ) <img class="helpButton" title="<g:message code="configuration.index.schedulestation"/>" src="${g.resource( dir: '/images', file: 'helpnew.png' )}"/>
                                    </div>
                                </g:if>

                                <g:if test="${addedGroup.groupStatus == GroupStatus.NOT_CONFIGURED}">
                                    <div class="leftCollectFleets0">
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
            </div>


        </div>
    </div>
    <div class="formConfiguration">
            <br><br>
        <div class="layoutButton">
                <span class="layoutButtonL">
            <g:form controller="configuration" action="configureSimulationRoute">
                <span class="addButtonCancel">
                    <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                    <g:submitButton name="send" value="${message(code: 'configuration.index.back')}"/>
                </span>
            </g:form>


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
            <%--<g:form action="saveFinishedConfigurationStation">
                <g:if test="${notConfiguredGroups==1 || savedGroups == 1 || configuredGroups==1}">

                    <span class="layoutButtonM"></span>
                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>

                    <span class="layoutButtonR"><g:submitButton name="send" value="${message(code: 'configuration.index.save')}"/></span>
                </g:if>
            </g:form> --%>
        </div>


            <g:if test="${(configuredGroups==1 && configuredFleets==1 && savedGroups==0 && savedFleets==0 && notConfiguredFleets==0 && notConfiguredGroups==0)}">
                <div class="layoutButton">
                    <g:form controller="execution" action="executeExperiment">
                        <span class="layoutButtonM"></span>
                        <g:hiddenField name="relativeSearchLimit" value="20" />
                        <g:hiddenField name="configurationId" value="${configurationStubId}"/>
                        <span class="layoutButtonR">
                            <g:submitButton name="send" value="${message(code: 'configuration.index.execute')}"/>
                        </span>

                    </g:form>

                    <g:form controller="execution" action="executeExperimentOnMap">
                        <span class="layoutButtonM"></span>
                        <g:hiddenField name="relativeSearchLimit" value="20" />
                        <g:hiddenField name="configurationId" value="${configurationStubId}"/>
                        <span class="layoutButtonR1">
                            <g:submitButton name="send" value="${message(code: 'configuration.index.executemap')}"/>
                        </span>

                    </g:form>
                </div>
            </g:if>



        <div id="updateMe"></div>
    </div>
</div>
</body>
</html>