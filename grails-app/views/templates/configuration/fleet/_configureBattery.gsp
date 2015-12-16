<script type="text/javascript">

    $(function() {

        $( "#slider-5" ).slider({

            value:60,
            slide: function( event, ui ) {
                $( "#minval" ).val( ui.value );
            }
        });
        $( "#minval" ).val( $( "#slider-5" ).slider( "value" ) );
    });
            </script>

<div id="openModal" class="modalDialogArea">

    <div>
        <g:form controller="configuration">
            <g:hiddenField name="configurationStubId" value="${configurationStubId}"/>
            <div class="contentModalWindowFleetArea">
                <div class="rowUpBattery">
                    <div class="leftbig"><b><g:message code="configuration.index.changeakku"/></b></div>
                    <div class="clear"></div>
                </div>
                <div class="rowMiddle2">
                    <div class="left00PXNew">
                        <input name="batteryCount" type="text" id="minval">

                    </div>
                    <div class="minval2">%</div>
                    <div class="sliderNew" id="slider-5"></div>

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

