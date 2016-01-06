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
    <script src="${resource(dir: 'js', file: 'jquery.easytabs.js')}"></script>
    <script src="http://maps.google.com/maps/api/js?v=4&sensor=false"></script>

    <script type="text/javascript">


        $(function()
        {
            var tabs = $('#tab-container');
            tabs.easytabs({defaultTab:"#tabo3"} );
            disable_easytabs(tabs, [1,0]);

            tabs.bind("easytabs:before", function (e, clicked) {
                if(clicked.parent().hasClass('disabled')) {
                    return false;
                }
            });
        });

        function on_disable_b_and_c_clicked()
        {
            var tabs = $('#tab-container');
            disable_easytabs(tabs, [1,0]);
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

    </script>

    <style>
    .rowUp3 {
        background-color: #ccffaa;
        border: 0px solid #ddd;
    }
    </style>
</head>

<body>
<div id="tab-container" class='tab-container'>
    <ul class='etabs1'>
        <li class='tab' id="tabo1"><a  href="#tabs1"><g:message code="configuration.index.configureroute"/></a></li>
        <li class='tab' id="tabo2"><a  href="#tabs2"><g:message code="configuration.index.configurefleet"/></a></li>
        <li class='tab' id="tabo3"><a  href="#tabs3"><g:message code="configuration.index.configurestation"/></a></li>
    </ul>
    <div class='panel-container'>
        <div id="tabs1">

        </div>
        <div id="tabs2">

        </div>
        <div id="tabs3">
            <div class="pContainerConfigure">
                <div class="rowUp3">
                        <div class="leftBoldBig1">
                            <g:message code= "stats.stats.statistics"/> ${simulationName}
                            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                            <g:if test="${availableFillingStationGroups != null && availableFillingStationGroups.size() > 0}">
                                <div class="rowMiddleWithoutBorder22">
                                <span style="float:left;">


                                <g:form controller="configuration" action="addExistentGroupToConfiguration">
                                    <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                    <g:select name="groupId" from="${availableFillingStationGroups}" optionKey="id" optionValue="${{"${g.message(code:'execution.playsimulation.electricstations')}: " + it.name+' ('+it.fillingStations?.size()+' Stations)'}}" />
                                    <g:submitButton name="add" onclick="window.location.reload()" value="${message(code: 'configuration.index.addgrouptosimulation')}" />
                                </g:form>

                                </span>
                                <span style="float:right; padding-left: 5px;">
                                    <g:form action="createGroupView">

                                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                <g:submitToRemote url="[action: 'createGroupView']" update="updateMe" name="submit" value="${message(code: 'configuration.index.createnewgroup')}" />
                                <%--<img width="22px"src="${g.resource( dir: '/images', file: 'add.png' )}">--%>
                        </g:form>
                                </span>
                            </div>
                            </g:if>
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
                            </div>--%>

                            <%--<div class="rowSpace">
                                <div class="clear"></div>
                            </div>--%>

                            <%--<div class="rowGroup1">
                            div class="rowBrightGrey">
                                <div class="leftConfigurationExtraLong">
                                    <g:message code="configuration.index.selectfleets"/>
                                </div>
                                <div class="right0PX"></div>
                                <div class="clear"></div>
                            </div>



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

                                            <div class="right1165PX">
                                                <%--<g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                <g:hiddenField name="groupId" value="${addedGroup.id}"/>
                                                <g:submitButton name="removeGroup" value="${message(code: 'configuration.index.unselect')}"/>
                                            </div>--%>

                                            <g:form controller="configuration" action="removeFleetFromConfiguration">
                                                <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
                                                <g:hiddenField name="groupId" value="${addedGroup.id}"/>
                                            <%--<g:submitButton name="removeFleet" value="${message(code: 'configuration.index.unselect')}" />--%>
                                                <button id="modal-close">
                                                    <g:img name="removeFleet" class="logoutexit" uri="${resource(dir: '/images', file: 'closesim.png')}"/>
                                                </button>
                                            </g:form>

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
                        <%--<span class="layoutButtonL">
                            <g:form controller="configuration" action="configureSimulationRoute">
                                <span class="addButtonCancel">
                                    <g:hiddenField name="configurationStubId" value="$configurationStubId"/>
                                    <g:submitButton name="send" value="${message(code: 'configuration.index.back')}"/>
                                </span>
                            </g:form>

                        </span>--%>
                        <%--<g:submitToRemote class="addButton" url="[action: '/front/startSimulation']" update="sim" name="submit" value="CANCEL" />--%>

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

                        <%--To view the execution on a map with the cars moving
                            <g:form controller="execution" action="executeExperimentOnMap">
                            <span class="layoutButtonM"></span>
                            <g:hiddenField name="relativeSearchLimit" value="20" />
                            <g:hiddenField name="configurationId" value="${configurationStubId}"/>
                            <span class="layoutButtonR1">
                                <g:submitButton name="send" value="${message(code: 'configuration.index.executemap')}"/>
                            </span>

                        </g:form>--%>
                        </div>
                    </g:if>



                    <div id="updateMe"></div>
                </div>
            </div>
        </div>
    </div>

</div>
</body>
</html>