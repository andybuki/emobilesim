<%--<div id="modal-background"></div>
<div id="modal-content" class="modalDialogRegistration">--%>
<div id="openModal" class="modalDialog">
<div>
    <g:form controller="configuration" action="setSimulationNameAndArea">
        <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
        <div class="contentModalWindowFleetNew">
            <div class="rowUp">
                <div class="leftbig"><b><g:message code="simulation.index.setNameForSimulation"/></b></div>

                <div class="clear"></div>
            </div>

            <div class="rowMiddle">
                <div class="leftText"><g:message code="templates.configuration.simulation._setSimulationName"/></div>

                <div class="rightOnlyButton">
                    <input type="text"
                           placeholder='<g:message code="templates.configuration.simulation._setSimulationName"/>'
                           name="nameForSimulation"/>
                </div>
            </div>

            <div class="rowMiddle">
                <div class="left140PX">
                    <g:select name="areaId" from="${availableAreas}"
                              noSelection="['': message(code: 'configuration.index.selectArea')]"/>
                </div>
            </div>

            <div class="clear"></div>
        </div>

        <div class="rowDown">
            <div class="left0PX">
                <%--<g:submitButton name="createCar" value="Cancel"/>--%>
                <input type="button" value="${message(code: 'templates.configuration.fleet._createFleet.cancel')}"
                       onclick="window.location.href = window.location.href"/>
            </div>

            <div class="right80PX">
                <%--TODO: Validate that name and area are set --%>
                <g:submitButton name="createSimulation"
                                value="${message(code: 'configuration.index.createNewSimulation')}"/>
            </div>

            <div class="clear"></div>
        </div>

        </div>
    </g:form>
    <%--<a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>--%>
</div>
</div>

