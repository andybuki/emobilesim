<table border="0" xmlns="http://www.w3.org/1999/html">
    <tr>
        <td width="90px" align="left">
            <a href="http://emobilesim.dfki.de"><img class="efahrungLogo" align="left" width="80px"  src="${g.resource( dir: '/images', file: 'logo_efahrung.png' )}"/></a>
        </td>
        <td>

            <div class="wrap">
                <nav>
                    <ul id="menu">
                        <li><g:link controller="configuration" action=""><g:message code="simulation.index.quit"/></g:link>

                        </li>
                        <%--<li><g:link><g:message code="layouts._topbar.execute"/></g:link></li>
                        <li><g:link><g:message code="layouts._topbar.view"/></g:link></li>
                        <li><g:link><g:message code="layouts._topbar.extras"/></g:link></li>
                        <li><g:link><g:message code="layouts._topbar.help"/></g:link></li>

                        <li><g:link><g:message code="layouts._topbar.contact"/></g:link></li>
                        --%>
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
                                                    <span class="flags">
                                                        <g:link controller="${params.controller}" action="${params.action}" params="[lang:'de']"><img width="22" src="${g.resource( dir: '/images', file: 'de.png' )}"></g:link>&nbsp;
                                                        <g:link controller="${params.controller}" action="${params.action}" params="[lang:'en']"><img width="22" src="${g.resource( dir: '/images', file: 'uk.png' )}"></g:link>
                                                    </span>

                                                    <span class="loggedIndrin"><g:message code="layouts._topbar.logged"/>&nbsp;
                                                        <b>
                                                            <%-- ${welcome?.givenName} ${welcome?.familyName} --%>
                                                            <es:welcomeLoggedInUser/>
                                                        </b>
                                                    </span>
                                                    <a class="logout" href="<g:createLink controller="login" action="logout" />"> <g:message code="layouts._topbar.logout2"/></a>
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
        <td width="120px" align="right">
            <img class="dfkiLogo" align="right" width="110px"  src="${g.resource( dir: '/images', file: 'dfki_logo.png' )}"/>
        </td>
    </tr>
</table>