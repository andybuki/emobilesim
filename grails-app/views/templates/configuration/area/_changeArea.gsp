
<div id="openModal" class="modalDialog">
    <div>
        <g:form controller="configuration" action="updateArea">
            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            <div class="contentModalWindowFleet">
                <div class="rowMiddle">

                    <div class="right235PX">

                        <g:select name="areaId" from="${availableAreas}"/>

                        <g:submitButton name="updateArea" value="${message(code: 'templates.configuration.area._changeArea.Change')}"/>

                    </div>
                    <div class="clear"></div>
                </div>
                <div class="rowUnknown" id="updateCar"></div>
                <div class="rowDown">
                    <div class="left0PX">
                        <input type="button" value="${message(code: 'templates.configuration.fleet._createFleet.cancel')}" onclick="window.location.href=window.location.href"/>
                    </div>
                </div>

            </div>
        </g:form>
        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
    </div>
</div>