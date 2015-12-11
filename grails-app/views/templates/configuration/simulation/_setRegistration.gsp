<div id="openModal" class="modalDialog">
        <div class="pContainerAuth">
            <fieldset class="fieldsetAuth">
                <legend><g:message code="login.auth.registrate" /> <g:message code="login.auth.or"/> <g:message code="login.auth.login"/></legend>
                <div class="layout">
                    <div class="layoutLeft">
                        <div class="contentAuth">
                            <g:form controller="login" action="signin" id="signinForm" class="cssform" autocomplete="off">
                                <div class="rowUp">
                                    <div class="leftBold"><b><g:message code="login.auth.registrate" /></b></div>
                                    <div class="right"></div>
                                    <div class="clear"></div>
                                </div>
                                <div class="rowMiddle">
                                    <div class="left"><g:message code="login.auth.givenname"/></div>
                                    <div class="right">
                                        <g:textField name="signinGivenName" id="signinGivenName" value="" />
                                    </div>
                                    <div class="clear"></div>
                                </div>

                                <div class="rowMiddle">
                                    <div class="left">
                                        <g:message code="login.auth.familyname"/>
                                    </div>
                                    <div class="right">
                                        <g:textField name="signinFamilyName" id="signinFamilyName" value="" />
                                    </div>
                                    <div class="clear"></div>
                                </div>

                                <div class="rowMiddle">
                                    <div class="left">
                                        <g:message code="login.auth.email"/>
                                    </div>
                                    <div class="right">
                                        <g:textField name="signinUserName" id="signinUserName" value="" />
                                    </div>
                                    <div class="clear"></div>
                                </div>

                                <div class="rowMiddle">
                                    <div class="left">
                                        <g:message code="login.auth.company"/>
                                    </div>
                                    <div class="right">
                                        <g:select name="companyId" from="${availableCompanies}" optionKey="id" optionValue="${{it.name}}" />
                                    </div>
                                    <div class="clear"></div>
                                </div>

                                <div class="rowMiddle">
                                    <div class="left">
                                        <g:message code="login.auth.password"/>
                                    </div>
                                    <div class="right">
                                        <g:passwordField name="password" />
                                    </div>
                                    <div class="clear"></div>
                                </div>

                                <div class="rowMiddle">
                                    <div class="left">
                                        <g:message code="login.auth.cofirmpassword"/>
                                    </div>
                                    <div class="right">
                                        <g:passwordField name="confirm" />
                                    </div>
                                    <div class="clear"></div>
                                </div>

                                <div class="rowDown">
                                    <div class="left"></div>
                                    <div class="right"><g:submitButton name="signinButton" value="${message(code: 'login.auth.registrate')}" /></div>
                                    <div class="clear"></div>
                                </div>
                            </g:form>
                        </div>
                    </div>
                    <div class="layoutRightSignIn">
                        <div class="contentAuth">
                            <form action='${postUrl}' method='POST' id='loginForm' class='cssform' autocomplete='off'>
                                <div class="rowUp">
                                    <div class="leftbig"><b><g:message code="login.auth.login"/></b></div>
                                    <div class="clear"></div>
                                </div>
                                <div class="rowMiddle">
                                    <div class="left"><g:message code="login.auth.username"/></div>
                                    <div class="right"><input type="text" size="20%" name='j_username' id='username' value=""></div>
                                    <div class="clear"></div>
                                </div>

                                <div class="rowMiddle">
                                    <div class="left"><g:message code="login.auth.password"/></div>
                                    <div class="right"><input type="password" size="20%" name='j_password' id='password' value="" /></div>
                                    <div class="clear"></div>
                                </div>
                                <div class="rowDown">
                                    <div class="left"></div>
                                    <div class="right"><input type="submit" value="<g:message code="layouts._topbar.login"/>"></div>
                                    <div class="clear"></div>
                                </div>
                            </form>
                        </div>

                        <div class="contentAuth">
                            <div class="rowUp">
                                <div class="leftbig"><b><g:message code="login.auth.fogotPassword"/></b></div>
                                <div class="clear"></div>
                            </div>

                            <g:form controller="login" action="sendResetPasswordLink">
                                <div class="rowMiddle">
                                    <div class="left"><g:message code="registration.index.email"/><span class="probel20px"/></div>
                                    <div class="right"><g:textField name="emailAddress" /> </div>
                                    <div class="clear"></div>
                                </div>
                                <div class="rowDown">
                                    <div class="left"></div>
                                    <div class="right"><g:submitButton name="Send New Password" value="${message(code: 'login.auth.send')}" /></div>
                                    <div class="clear"></div>
                                </div>
                            </g:form>

                        </div>
                    </div>
                </div>
                <br><br><br>
                <span class="confirmationMessage"><g:message code="login.auth.configuration"/></span>
            </fieldset>
        </div>
</div>