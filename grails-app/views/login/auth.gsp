<html>
<head>

<script type='text/javascript' src="${resource(dir: 'js', file: 'prefix-free.js')}"></script>
<script type='text/javascript' src="${resource(dir: 'js', file: 'jquery-1.9.0.js')}"></script>
<link rel="shortcut icon" href="${resource(dir: 'images', file: 'favicon.ico')}" type="image/x-icon">
<link rel="apple-touch-icon" href="${resource(dir: 'images', file: 'apple-touch-icon.png')}">
<link rel="apple-touch-icon" sizes="114x114" href="${resource(dir: 'images', file: 'apple-touch-icon-retina.png')}">
<link rel="stylesheet" href="${resource(dir: 'css', file: 'main.css')}" type="text/css">
<link rel="stylesheet" href="${resource(dir: 'css', file: 'mobile.css')}" type="text/css">
<link href='http://fonts.googleapis.com/css?family=Droid+Sans' rel='stylesheet' type='text/css'>

<link rel='stylesheet' href="${resource(dir: 'css', file: 'style.css')}" type='text/css' />
<link rel='stylesheet' href="${resource(dir: 'css', file: 'iconic.css')}" type='text/css' />

<title><g:message code="login.auth.title"/> </title>
</head>

<body>

<div id="page">
    <div id="spinner" class="spinner" style="display: none;">
        <img src="${createLinkTo(dir:'images',   file:'spinner.gif')}"
             alt="Spinner" />
    </div>
    <g:render template="/login/topbar"/>


    <div class="contentNew">
    <div id="signup">
        <g:if test="${errors != null}" >
            Errors: ${errors}
        </g:if>

        <table align="center" class="imagetable" border="0">
            <tr valign="middle">
                <td align="center"><g:img class="imagesize" uri="${resource(dir: '/images', file: 'routenconf.png')}"/></td>
                <td align="center"><g:img class="imagesize" uri="${resource(dir: '/images', file: 'pfeile.png')}"/></td>
                <td align="center"><g:img class="imagesize" uri="${resource(dir: '/images', file: 'carsconf.png')}"/></td>
                <td align="center"><g:img class="imagesize" uri="${resource(dir: '/images', file: 'pfeile.png')}"/></td>
                <td align="center"><g:img class="imagesize" uri="${resource(dir: '/images', file: 'stationconf.png')}"/></td>
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
        <tr class="neuSimulation" valign="middle">
            <td></td>
            <td></td>
            <td align="center"><g:img uri="${resource(dir: '/images', file: 'simstarten.png')}"/></td>
            <td></td>
            <td></td>
        </tr>
        </table>

        <div id="modal-background"></div>
        <div id="modal-content" class="modalDialogRegistration">
            <button id="modal-close">
                <g:img class="logoutexit" uri="${resource(dir: '/images', file: 'closesim.png')}"/>
            </button>

            <div class="pContainerAuth3">
            <fieldset class="fieldsetAuth3">
                <legend><g:message code="login.auth.registrate" /> <g:message code="login.auth.or"/> <g:message code="login.auth.login"/></legend>
                <div class="layoutRegistration">
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

    <div id='login'>
        <div class='inner'>
            <g:if test='${flash.message}'>
                <div class='login_message'>${flash.message}</div>
            </g:if>
            <div class='fheader'></div>

        </div>
    </div>
    <script type='text/javascript'>
        <!--
        (function(){
            document.forms['loginForm'].elements['j_username'].focus();
        })();
        // -->


        $(function(){
            $("#modal-launcher, #modal-background, #modal-close").click(function () {
                $("#modal-content,#modal-background").toggleClass("active");
            });
        });

    </script>

    </div>

    <g:render template="/layouts/footer" />
</div>
</body>
</html>



