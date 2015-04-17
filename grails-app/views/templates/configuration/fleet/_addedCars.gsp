
<g:if test="${addedCars}">
    <g:each in="${addedCars}">
        <div class="rowMiddle">
            <div class="leftText">${it.count} <g:message code="simulation.index.carstype"/> ${it.name}</div>
        </div>
        <div class="clear"></div>
    </g:each>
</g:if>