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
<div class="pContainerResent">
    <div class="d1">
        <fieldset>
            <legend> <g:message code="configuration.executesim.accomplishedsimulations"/> </legend>
            <div class="layoutResent">
                <g:if test="${ configurations.size() > 0}">
                    <table>
                        <tr>
                            <th><g:message code="configuration.executesim.name"/> </th>
                            <th><g:message code="configuration.executesim.description"/></th>
                            <th><g:message code="configuration.executesim.executebutton"/></th>
                        </tr>

                    <g:each in="${configurations}" var="conf">
                        <tr>
                            <td>${conf.configurationId} <g:message code="configuration.executesim.simulation"/></td>
                            <td>${conf.fleetInfo} <g:message code="configuration.executesim.cars"/>  ${conf.stationsInfo} <g:message code="configuration.executesim.fillingstations"/></td>
                             <td>
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
                </g:if>
                <g:if test="${configurations.size() == null}">
                    <span class="simDesc"><g:message code="configuration.executesim.avasim"/></span>
                </g:if>
            </table>

            </div>
        </fieldset>
    </div>
</div>
</body>
</html>