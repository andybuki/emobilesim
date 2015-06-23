<div id="openModal" class="modalDialogBig">
    <div>
        <g:form controller="configuration" action="createGroup">
            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            <div class="contentLeft2">
                <div class="rowUp">
                    <div class="leftbig"><b><%--<<g:message code="simulation.index.selectcarstype"/>--%> <g:message code="templates.configuration.group._createGroup.selectStationForGroup"/></b></div>
                    <div class="clear"></div>
                </div>
                <div class="rowMiddle">

                    <div class="leftModal">
                        <g:message code="templates.configuration.group._createGroup.setname"/>
                    </div>

                    <div class="rightOnlyButton">
                        <g:textField name="nameForGroup" value="${nameForGroup}"/>
                    </div>

                </div>

                <div class="rowMiddle">
                    <div class="left180PX">
                        <g:select name="stationCount" from="${1..100}" /> &nbsp;&nbsp;
                        <g:message code="simulation.index.stationoftype"/>
                    </div>
                    <div class="right200PX">
                        <g:select name="stationTypeId" from="${availableFillingStationTypes}" optionKey="id" optionValue="name" />
                        &nbsp;&nbsp;

                        <g:hiddenField name="groupStubId" value="${groupStubId}"/>
                        <g:submitToRemote class="addButton"
                                          url="[action: 'addStationsToUnsavedGroup']"
                                          update="updateFillingStation"
                                          name="submit"
                                          value="${message(code: 'templates.configuration.fleet._anotherfillingstation.addgroup')}" />
                    </div>
                    <div class="clear"></div>
                </div>

                <div class="rowMiddle">
                    <div class="leftbig"><b><g:message code="templates.configuration.group._createGroup.addedFillingStations"/></b></div>
                </div>

                <div class="rowUnknown" id="updateFillingStation"></div>

                <div class="rowDown">
                    <div class="left0PX">
                        <%--<g:submitButton name="createCar" value="Cancel"/>--%>
                        <input type="button" value="${message(code: 'templates.configuration.group._createGroup.cancel')}" onclick="window.location.href=window.location.href"/>
                    </div>
                    <div class="right90PX">
                        <g:submitButton name="createGroup" value="${message(code: 'templates.configuration.group._createGroup.creategroup')}"/>
                    </div>
                    <div class="clear"></div>
                </div>
            </div>
        </g:form>
        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
    </div>
</div>