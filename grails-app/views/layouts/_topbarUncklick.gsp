<table class="addcars" border="0" xmlns="http://www.w3.org/1999/html">
    <tr class="borderbottom">
        <td width="300px" align="left" valign="top">
            <a href="http://emobilesim.dfki.de"><img class="efahrungLogo" align="left" width="180px" src="${g.resource( dir: '/images', file: 'emobilesimlogo.png' )}"/></a>
        </td>
        <td>
            <div class="wrap">
                <nav>
                    <ul id="menu">
                        <li><g:link controller="configuration" action=""><g:message code="simulation.index.quit"/></g:link>

                        </li>

                        <%--<li><g:link controller="configuration" action="executeSimulations"><g:message code="layouts._topbar.execute"/></g:link></li>--%>


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
                                                        <a class="logout" href="<g:createLink controller="login" action="logout" />">
                                                            <g:img class="logoutexit" uri="${resource(dir: '/images', file: 'exitbutton.png')}"/> <g:message code="layouts._topbar.logout2"/>
                                                        </a>
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
        <%--<td width="120px" align="right">
            <img class="dfkiLogo" align="right" width="110px"  src="${g.resource( dir: '/images', file: 'dfki_logo.png' )}"/>
        </td>--%>
    </tr>
</table>