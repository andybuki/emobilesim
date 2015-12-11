
<table class="addcars" border="0" xmlns="http://www.w3.org/1999/html">
    <tr class="borderbottom">
        <td width="300px" align="left" valign="top">
            <a href="http://emobilesim.dfki.de"><img class="efahrungLogo" align="left" width="180px" src="${g.resource( dir: '/images', file: 'emobilesimlogo.png' )}"/></a>
        </td>
        <td>
            <div class="wrap">
                <nav>
                    <ul id="menu">
                        <li><g:link controller="configuration" action="index"><g:message code="layouts._topbar.simulate"/></g:link>

                        </li>

                        <li><g:link controller="configuration" action="viewSimulations"><g:message code="layouts._topbar.view"/></g:link></li>

                        <li class="addcars"><g:link controller="configuration" action="showCarTypes"><g:message code="layouts._topbar.extras"/></g:link>
                            <%--<ul>
                                <li class="addcars"><g:link controller="configuration" action="showCarTypes"><g:message code="layouts._topbar.addnewcartype"/></g:link></li>
                                <li class="addcars"><g:link controller="configuration" action="showFillingStationTypes"><g:message code="layouts._topbar.addnewelectricstation"/></g:link></li>

                            </ul>--%>
                        </li>

                        <li><g:link controller="configuration" action="help"><g:message code="layouts._topbar.help"/></g:link></li>

                        <li><a href="http://www.dfki.de/web/legal-info-de?set_language=de&cl=de"><g:message code="layouts._topbar.contact"/></a></li>

                        <span id="signup">
                            <g:if test="${errors != null}" >

                                Errors: ${errors}

                            </g:if>
                            <span id='login'>
                                <span class='inner'>
                                    <span class="registration1">

                                        <form>

                                        </form action='${postUrl}' method='POST' id='loginForm' class='cssform' autocomplete='off'>

                                        <span class="loggedIn">
                                            <table>
                                                <tr>
                                                    <td><span class="loggedIndrin"><es:welcomeLoggedInUser/></span></td>
                                                    <td>
                                                        <button class="logout" id="modal-launcher">
                                                            <g:img class="logoutexit" uri="${resource(dir: '/images', file: 'eingang.png')}"/>
                                                            <g:message code="layouts._topbar.login"/> /
                                                            <g:message code="registration.index.registration"/>
                                                        </button>
                                                    </td>
                                                    <td>
                                                        <span class="flags">
                                                            <g:link controller="${params.controller}" action="${params.action}" params="[lang:'de']"><img class="flagslittle" width="15" src="${g.resource( dir: '/images', file: 'de.png' )}"></g:link><br/>
                                                            <g:link controller="${params.controller}" action="${params.action}" params="[lang:'en']"><img class="flagslittle" width="15" src="${g.resource( dir: '/images', file: 'uk.png' )}"></g:link>
                                                        </span>
                                                    </td>
                                                </tr>
                                            </table>

                                        </span>



                                    </form>

                                    </span>

                                </span>

                            </span>

                        </span>

                    </ul>
                    <div class="clearfix"></div>
                </nav>
            </div>

        </td>

    </tr>
</table>

<script>
    function myFunction() {
        document.getElementById("openModal").showModal();
    }
</script>