<div id="openModal" class="modalDialogArea">
    <div>
        <g:form controller="configuration">
            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            <div class="contentModalWindowFleetArea">
                <div class="rowUp">
                    <div class="leftbig"><b>Change Akku Zustand</b></div>
                    <div class="clear"></div>
                </div>
                <div class="rowMiddle">
                    <div class="left0PX"><g:select name="batteryCount" from="${1..100}" /></div>
                </div>

                <div class="rowMiddle">
                    <div class="left00PX"><input type="button" value="${message(code: 'templates.configuration.fleet._createFleet.cancel')}" onclick="window.location.href=window.location.href"/></div>
                    <div class="right80PX">
                        <g:hiddenField name="fleetId" value="${fleetId}"/>
                        <g:hiddenField name="carId" value="${carId}"/>
                        <g:actionSubmit action="configureBatteryAll" name="createFleet" value="${message(code: 'templates.configuration.fleet._configureBatteryAll')}"/>
                        <g:actionSubmit action="configureBatteryOne" name="createFleet" value="${message(code: 'templates.configuration.fleet._configureBattery')}"/>
                    </div>
                </div>
            </div>
        </g:form>
        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
    </div>
</div>