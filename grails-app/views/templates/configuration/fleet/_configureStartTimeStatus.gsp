<div id="openModal" class="modalDialogArea">
    <div>
        <g:form controller="configuration" action="createBattery">
            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            <div class="contentModalWindowFleetArea">
                <div class="rowUp">
                    <div class="leftbig"><b>Change Start Time</b></div>
                    <div class="clear"></div>
                </div>
                <div class="rowMiddle">
                    <div class="left200PX">
                        <calendar:datePicker name="date" dateFormat="%H:%M - %d/%m/%y" defaultValue="${new Date()}" showTime="true"/>
                    </div>
                </div>

                <div class="rowMiddle">
                    <div class="left00PX"><input type="button" value="${message(code: 'templates.configuration.fleet._createFleet.cancel')}" onclick="window.location.href=window.location.href"/></div>
                    <div class="right80PX"><g:submitButton name="createFleet" value="${message(code: 'templates.configuration.fleet._configureBatteryAll')}"/>
                    <g:submitButton name="createFleet" value="${message(code: 'templates.configuration.fleet._configureBattery')}"/></div>

                </div>
            </div>
        </g:form>
        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
    </div>
</div>