<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 15.10.14
  Time: 10:08
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="configuration.executesim.accomplishedsimulations"/></title>
    <meta name="layout" content="main" />
</head>

<body>
<div class="pContainer">
    <div class="simulationTypes">
        <div class="rowUp">
            <div class="leftBoldSim"><b><g:message code="configuration.executesim.accomplishedsimulations"/></b></div>
            <div class="right0PX"></div>
            <div class="clear"></div>
        </div>

        <div class="rowMiddle">
            <g:if test="${ configurations.size() > 0}">
                <table border="0">
                    <tr class="tr30px" valign="middle">
                        <th width="120px"><g:message code="configuration.executesim.name"/> </th>
                        <th><g:message code="configuration.executesim.description"/></th>
                        <th width="60px"><g:message code="configuration.executesim.executebutton"/></th>
                    </tr>
                </table>
            </g:if>
        </div>
        <div class="rowDown">
            <g:if test="${ configurations.size() > 0}">
                <table border="0">
                    <g:each in="${configurations}" var="conf">
                        <tr class="tr30px">
                            <td width="130px">${conf.configurationId} <g:message code="configuration.executesim.simulation"/></td>
                            <td>${conf.routeCount} <g:message code="configuration.executesim.cars"/>  ${conf.stationCount} <g:message code="configuration.executesim.fillingstations"/></td>
                            <td width="70px">
                                <g:form controller="execution" action="executeExperiment">
                                    <div class="layoutButton3">
                                        <span class="layoutButtonM3"></span>
                                        <g:hiddenField name="relativeSearchLimit" value="50" />
                                        <g:hiddenField name="configurationId" value="${conf.configurationId}"/>
                                        <span class="layoutButtonR3">
                                            <g:submitButton name="send" value="${message(code: 'configuration.index.execute')}"/>
                                        </span>
                                    </div>
                                </g:form>
                            </td>
                        </tr>
                    </g:each>
                </table>
            </g:if>
            <g:if test="${configurations.size() == null}">
                <span class="simDesc"><g:message code="configuration.executesim.avasim"/></span>
            </g:if>
        </div>
    </div>
</div>
</body>
</html>