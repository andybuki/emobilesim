
<div id="openModal" class="modalDialog">
    <div>
        <g:form controller="configuration" action="editFillingStationType">

            <div class="contentModalWindow">
                <div class="rowUp">
                    <div class="leftbig"><b><g:message code="templates.configuration.fillingstationtype._createfillingstationtype.editstation"/></b></div>
                    <div class="clear"></div>
                </div>
                <div>
                    <div class="rowMiddle">
                        <div class="leftModal"><g:message code="templates.configuration.fillingstationtype._createfillingstationtype.fillingstation"/></div>
                        <div class="rightOnlyButton"><g:textField name="fillingStationTypeName" id="fillingStationTypeName" value="${fillingStationTypeName}"/></div>
                        <div class="clear"></div>
                    </div>
                    <div class="rowMiddle">
                        <div class="leftModal"><g:message code="templates.configuration.fillingstationtype._createfillingstationtype.power"/></div>
                        <div class="rightOnlyButton"><g:textField name="power" id="power" value="${power}"/></div>
                        <div class="clear"></div>
                    </div>


                    <div class="rowDown">
                        <div class="left0PX">
                            <%--<g:submitButton name="createCar" value="Cancel"/>--%>
                            <input type="button" value="${message(code: 'templates.configuration.fillingstationtype._createfillingstationtype.cancel')}" onclick="window.location.href=window.location.href"/>
                        </div>
                        <div class="rightOnly0PX">
                            <g:hiddenField name="fillingStationTypeId" value="${fillingStationTypeId}"/>

                            <g:submitButton name="createFillingStation" value="${message(code: 'templates.configuration.fillingstationtype._createfillingstationtype.update')}"/>
                        </div>
                        <div class="clear"></div>
                    </div>
                </div>
            </div>
        </g:form>
    </div>
</div>


