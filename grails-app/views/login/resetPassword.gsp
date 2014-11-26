<%--
  Created by IntelliJ IDEA.
  User: glenn
  Date: 25.11.14
  Time: 13:22
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title><g:message code="login.auth.resetregistration"/> </title>
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
</head>
<body>
    <g:render template="/login/topbar"/>
    <g:form controller="login" action="saveNewPassword">
        <g:hiddenField name="username" value="${username}" />
        <g:hiddenField name="ident" value="${ident}" />
        <g:message code="login.auth.passwordhello"/>  ${username}, <g:message code="login.auth.passwordtwice"/>
        <div class="pContainer">
            <div class="carTypes">
                <div class="rowUp">
                    <div class="leftBold">
                        <g:message code="login.auth.newpassword"/>
                    </div>
                    <div class="right0PX"></div>
                    <div class="clear"></div>
                </div>

                <div class="rowMiddle">
                    <div class="leftBoldResetPassword">
                <g:message code="login.auth.password"/>
            </div>
                    <div class="right0PXResetPassword">
                <g:passwordField name="password" />
            </div>
                    <div class="clear"></div>
                </div>
                <div class="rowMiddle">
                    <div class="leftBoldResetPassword">
                <g:message code="login.auth.cofirmpassword"/>
            </div>
                    <div class="right0PXResetPassword">
                <g:passwordField name="confirm" />
            </div>
                    <div class="clear"></div>
                </div>
                <div class="rowDown">
                    <div class="leftBoldResetPassword"></div>
                    <div class="right65PX"><g:submitButton name="signinButton" value="${message(code: 'login.auth.registrate')}" /></div>
                    <div class="clear"></div>
                </div>
            </div>
        </div>
    </g:form>
</body>
</html>