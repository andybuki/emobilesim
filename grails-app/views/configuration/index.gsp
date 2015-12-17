<%--
  Created by IntelliJ IDEA.
  User: glenn
  Date: 18.09.13
  Time: 18:11
  To change this template use File | Settings | File Templates.
--%>

<%@ page import="de.dfki.gs.domain.utils.GroupStatus; de.dfki.gs.domain.utils.FleetStatus"  contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="configuration.index.newsimulation"/></title>
    <meta name="layout" content="main" />
    <g:javascript library="jquery-1.11.2" />
    <g:javascript src="jquery-ui.min.js"/>
    <g:javascript src="slider/jshashtable-2.1_src.js"/>
    <g:javascript src="slider/jquery.numberformatter-1.2.3.js"/>
    <g:javascript src="slider/tmpl.js"/>
    <g:javascript src="slider/jquery.dependClass-0.1.js"/>
    <g:javascript src="slider/draggable-0.1.js"/>
    <g:javascript src="slider/jquery.slider.js"/>

    <g:javascript src="application.js" />
    <g:javascript src="ol/OpenLayers.js" />
    <g:javascript src="jquery.loading.js"/>

    <g:javascript src="jquery-ui-timepicker-addon.js"/>


    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui-timepicker-addon.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jslider.css')}" type='text/css' />

    <script type='text/javascript'>

        jQuery(function(){
            jQuery("#modal-launcher, #modal-background, #modal-close").click(function () {
                jQuery("#modal-content,#modal-background").toggleClass("active");
            });
        });

    </script>
</head>
<body>

<%--<table align="center" class="imagetable" border="0">
    <tr valign="middle">
        <td align="center"><g:img uri="${resource(dir: '/images', file: 'routenconf.png')}"/></td>
        <td align="center"><g:img uri="${resource(dir: '/images', file: 'pfeile.png')}"/></td>
        <td align="center"><g:img uri="${resource(dir: '/images', file: 'carsconf.png')}"/></td>
        <td align="center"><g:img uri="${resource(dir: '/images', file: 'pfeile.png')}"/></td>
        <td align="center"><g:img uri="${resource(dir: '/images', file: 'stationconf.png')}"/></td>
    </tr>
    <tr valign="middle">
        <td align="center" class="fontBig"><g:message code="registration.index.route"/>
        </td>
        <td></td>
        <td align="center" class="fontBig"><g:message code="registration.index.car"/></td>
        <td></td>
        <td align="center" class="fontBig"><g:message code="registration.index.station"/></td>
    </tr>
    <tr valign="middle">
        <td height="100px"></td>
        <td></td>

        <td></td>
        <td></td>
    </tr>
    <tr valign="middle">
        <td></td>
        <td></td>
        <td align="center"><g:img uri="${resource(dir: '/images', file: 'simstarten.png')}"/></td>
        <td></td>
        <td></td>
    </tr>
</table>--%>


<table width="800px" class="startSimulation">
    <td style="vertical-align: top; padding-top: 15px; ">

        <div>
        <g:form action="configureSimulation">
            <g:submitToRemote class="newSimulation"

                              url="[controller: 'configuration', action: 'configureSimulation']"
                              update="updateMe"
                              name="submit"
                              value="${message(code: 'configuration.index.createNewSimulation')}" />
            <div class="clear"></div>
        </g:form>
        <div id="updateMe"></div>


            <%--<g:render template="/templates/configuration/simulation/setSimulationName" />--%>
        </div>

    </td>
    <td>
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
                                    <td width="130px"><g:link uri="/configuration/configureSimulationTargets?configurationStubId=${conf.configurationId}" url="/configuration/configureSimulation?configurationStubId=${conf.configurationId}">${conf.simulationName}</g:link></td>
                                    <td>${conf.routeCount} <g:message code="configuration.executesim.cars"/>  ${conf.stationCount} <g:message code="configuration.executesim.fillingstations"/></td>

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
    </td>
</table>


</body>

</html>
