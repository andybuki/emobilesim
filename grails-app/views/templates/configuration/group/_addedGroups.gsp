<g:if test="${addedStations}">
    <g:each in="${addedStations}">
        <div class="rowMiddle">
            <div class="leftText">${it.count} <g:message code="simulation.index.stationoftype"/> ${it.name}</div>
        </div>
        <div class="clear"></div>
    </g:each>
</g:if>
