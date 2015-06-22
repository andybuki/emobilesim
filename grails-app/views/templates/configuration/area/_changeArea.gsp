
<div id="openModal" class="modalDialogArea">
    <div>
        <g:form controller="configuration" action="updateArea">
            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            <div class="contentModalWindowFleetArea">
                <div class="rowUp">
                    <div class="leftBoldSimArea"><b><g:message code="configuration.index.changearea"/></b></div>
                    <div class="right0PX"></div>
                    <div class="clear"></div>
                </div>
                <div class="rowMiddle">
                    <div class="left140PX">
                        <g:select name="areaId" from="${availableAreas}"/>
                    </div>


                    <div class="clear"></div>
                </div>
                <div class="rowUnknown" id="updateCar"></div>

                <div class="rowDown">
                    <div class="left140PX">
                        <input type="button" value="${message(code: 'templates.configuration.fleet._createFleet.cancel')}" onclick="window.location.href=window.location.href"/>

                    </div>
                    <div class="right0PX">
                        <g:submitButton name="updateArea" value="${message(code: 'templates.configuration.area._changeArea.Change')}"/>
                    </div>
                </div>

            </div>
        </g:form>
        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
    </div>
</div>