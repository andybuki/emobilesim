<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 15.10.14
  Time: 10:08
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="layouts._topbar.open"/></title>
    <meta name="layout" content="main" />
</head>

<body>
<div class="pContainer">
    <div class="simulationTypes">
        <div class="rowUp">
            <div class="leftBoldSim"><b><g:message code="layouts._topbar.open"/></b></div>
            <div class="right0PX"></div>
            <div class="clear"></div>
        </div>
        <g:if test="${ configurations.size() > 0}">
            <div class="rowMiddle">

                    <table border="0">
                        <tr class="tr30px" valign="middle">
                            <th width="120px"><g:message code="configuration.executesim.name"/> </th>
                            <th><g:message code="configuration.executesim.description"/></th>

                        </tr>
                    </table>

            </div>
        </g:if>
        <div class="rowDown">
            <g:if test="${ configurations.size() > 0}">
                <table border="0">
                    <g:each in="${configurations}" var="conf">
                        <tr class="tr30px">
                            <td width="130px">${conf.configurationId} <g:message code="configuration.executesim.simulation"/></td>
                            <td>${conf.routeCount} <g:message code="configuration.executesim.cars"/>  ${conf.stationCount} <g:message code="configuration.executesim.fillingstations"/></td>
                            <td width="70px">
                                <g:link uri="/configuration/index?configurationStubId=${conf.configurationId}" url="/configuration/index?configurationStubId=${conf.configurationId}"><g:message code="configuration.executesim.configure"/></g:link>
                            </td>
                        </tr>
                    </g:each>
                </table>
            </g:if>
            <g:else>
                <span class="simDesc"><g:message code="configuration.executesim.avasim"/></span>
            </g:else>
        </div>
    </div>
</div>
</body>
</html>