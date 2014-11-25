<%--
  Created by IntelliJ IDEA.
  User: glenn
  Date: 25.11.14
  Time: 13:22
--%>

<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title></title>
</head>

<body>

    <g:form controller="login" action="saveNewPassword">

        <g:hiddenField name="username" value="${username}" />

        <g:hiddenField name="ident" value="${ident}" />

        Hello ${username}, please type in new password twice:

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

</body>
</html>