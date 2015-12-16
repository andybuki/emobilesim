<div id="openModal" class="modalDialogArea">
    <div>
        <g:form controller="configuration">
            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            <div class="contentModalWindowFleetArea">
                <div class="rowUpBattery">
                    <div class="leftbig"><b>Change Start Time</b></div>
                    <div class="clear"></div>
                </div>
                <div class="rowMiddle">
                    <div class="left200PX">
                        <calendar:datePicker class="calendarSet" name="startDate" dateFormat="%H:%M - %d/%m/%y" defaultValue="${new Date()}" showTime="true"/>
                    </div>
                </div>

                <div class="rowMiddle">
                    <div class="left00PX"><input type="button" value="${message(code: 'templates.configuration.fleet._createFleet.cancel')}" onclick="window.location.href=window.location.href"/></div>
                    <div class="right80PX">
                        <g:hiddenField name="fleetId" value="${fleetId}"/>
                        <g:hiddenField name="carId" value="${carId}"/>
                        <g:actionSubmit action="configureStartTimeAll" name="createFleet" value="${message(code: 'templates.configuration.fleet._configureTimeAll')}"/>
                        <g:actionSubmit action="configureStartTimeOne" name="createFleet" value="${message(code: 'templates.configuration.fleet._configureTime')}"/>
                    </div>
                </div>
            </div>
        </g:form>

        <a class="close" title="${message(code: 'templates.configuration.stations.close')}" href=""></a>
    </div>
</div>