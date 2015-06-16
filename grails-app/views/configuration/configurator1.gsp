<%--
  Created by IntelliJ IDEA.
  User: anbu02
  Date: 27.05.15
  Time: 16:16
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Version 3</title>
    <meta name="layout" content="mainConfiguration" />
    <g:javascript library="jquery-1.11.2" />
    <g:javascript src="jquery-ui.min.js"/>
    <g:javascript src="slider/jshashtable-2.1_src.js"/>
    <g:javascript src="slider/jquery.numberformatter-1.2.3.js"/>
    <g:javascript src="slider/tmpl.js"/>
    <g:javascript src="slider/jquery.dependClass-0.1.js"/>
    <g:javascript src="slider/draggable-0.1.js"/>
    <g:javascript src="slider/jquery.slider.js"/>

    <g:javascript src="application.js" />

    <g:javascript src="jquery.loading.js"/>

    <g:javascript src="jquery-ui-timepicker-addon.js"/>


    <script type="text/javascript" src="http://openstreetmap.org/openlayers/OpenStreetMap.js"></script>
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jquery-ui-timepicker-addon.css')}" type='text/css' />
    <link rel='stylesheet' href="${resource(dir: 'css', file: 'jslider.css')}" type='text/css' />
    <link rel="stylesheet" href="${resource(dir: 'css', file: 'mainV3.css')}" type="text/css">
    <script src="http://maps.google.com/maps/api/js?v=3&amp;sensor=false"></script>
</head>

<body>
<div class="pContainerConfigure">

    <div class="layout">

        <div class="layoutLeft">
            <g:submitButton name="create" value="Create Simulation" />
        </div>

        <div class="layoutRight">
            <fieldset class="fieldsetAuth">
                <legend>Exisiting Simulations</legend>
                <%--<grid:grid name='authorClassic'/>
                <grid:exportButton name='authorClassic'/>--%>
                <g:textField name="nameForSimulation" value="${speed}"/>
            </fieldset>
        </div>
    </div>



</div>


</body>
</html>