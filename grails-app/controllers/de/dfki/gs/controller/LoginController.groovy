package de.dfki.gs.controller

import de.dfki.gs.controller.commands.AllowPersonCommandObject
import de.dfki.gs.controller.commands.ConfirmCommandObject
import de.dfki.gs.controller.commands.ForgotPasswordCommandObject
import de.dfki.gs.controller.commands.ResetPasswordCommandObject
import de.dfki.gs.controller.commands.SaveNewPasswordCommandObject
import de.dfki.gs.controller.commands.SigninCommandObject
import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.users.Person
import de.dfki.gs.domain.users.PersonRole
import de.dfki.gs.domain.users.Role
import grails.plugin.springsecurity.SpringSecurityUtils

import javax.mail.SendFailedException

class LoginController {


    def grailsApplication
    def authenticationTrustResolver
    def springSecurityService
    def mailService
    def grailsLinkGenerator
    def sendMailService

    def personService

    def index = {

        def config = SpringSecurityUtils.securityConfig

        // log.error( "loggedIn? ${((Person)springSecurityService.currentUser).username}" )

        if (springSecurityService.isLoggedIn()) {

            // redirect uri: SpringSecurityUtils.securityConfig.successHandler.defaultTargetUrl


            // redirect( controller: "front", action: "init" )
            redirect uri: config.successHandler.defaultTargetUrl



        }
        else {
            redirect action: 'auth', params: params
        }
    }

    /**
     * Show the login page.
     */
    def auth = {

        // log.error( "auth.." )

        def config = SpringSecurityUtils.securityConfig

        if (springSecurityService.isLoggedIn()) {

            redirect uri: config.successHandler.defaultTargetUrl
            return
        }


        def savedUrl = session.SPRING_SECURITY_SAVED_REQUEST_KEY?.requestURL
        if( session.SPRING_SECURITY_SAVED_REQUEST_KEY?.queryString ) savedUrl = "${ savedUrl }?${ session.SPRING_SECURITY_SAVED_REQUEST_KEY?.queryString }"

        def savedUrlWithoutPrefix = null
        if( savedUrl != null ) savedUrlWithoutPrefix = savedUrl - grailsApplication.config.grails.serverURL

        String view = 'auth'
        String postUrl = "${request.contextPath}${config.apf.filterProcessesUrl}"

        render view: view, model: [
                postUrl: postUrl,
                rememberMeParameter: config.rememberMe.parameter,
                savedUrl: savedUrl,
                availableCompanies : Company.findAll(),
                testLink : "${grailsLinkGenerator.serverBaseURL - "emobilesim"}"
        ]
    }

    def logout = {

        redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl

    }


    def signin = {

        log.error( "params: ${params}" )

        SigninCommandObject cmd = new SigninCommandObject()
        bindData( cmd, params )

        if ( !cmd.validate() && cmd.hasErrors() ) {

            render view: 'auth', model: [ errors : cmd.errors ]

        }

        def m = personService.createSigninPerson(cmd.companyId, cmd.signinGivenName, cmd.signinFamilyName, cmd.signinUserName, cmd.password )

        if ( m.person != null ) {

            Person p = m.person

            String confirmLink = "${grailsLinkGenerator.serverBaseURL}" - "/emobilesim" + createLink( controller: "login", action: "confirm",  params: [ username : p.username, confirmationCode : p.confirmationCode ] )


            log.error( "try sending " )

            try {

                sendMailService.sendConfirmationMailToSigningUser( p, confirmLink )

            } catch ( SendFailedException e ) {
                log.error( "tried to send mail to ${p.username}", e )
            }


        }

        log.error( "hua! success: ${m}" )

        render view: "waiting"
    }

    def forgotPassword = {

        log.error( "params: ${params}" )

        render view: "forgotPassword"

    }

    /**
     * user types in his username (must be a email address)
     * if username is in our database
     * 1) a resetPasswordIdent for the user is generated, which identifies the user during the password change process
     * 2) a mail to the username is sent containing the resetPassword link and the resetPasswordIdent
     *
     *
     */
    def sendResetPasswordLink = {

        ForgotPasswordCommandObject cmd = new ForgotPasswordCommandObject()
        bindData( cmd, params )

        if ( cmd.validate() && !cmd.hasErrors() ) {

            log.error( "try sending reset password link" )

            String ident = personService.createResetPasswordIdent( cmd.emailAddress )

            if ( ident ) {

                String link = "${grailsLinkGenerator.serverBaseURL}" - "/emobilesim" + createLink( controller: "login", action: "resetPassword", params: [ ident: ident, email: cmd.emailAddress ] )

                try {
                    sendMailService.sendResetPasswordLink( cmd.emailAddress, link )
                } catch ( Exception e ) {

                    // TODO: tell the user that email service is out of order...
                    log.error( "failed to send email to ${cmd.emailAddress}" )
                }

            }

        }


        redirect action: 'index'
    }

    /**
     * user typed new password two times,
     * 1.) both must be the same
     * 2.) resetPasswordIdent and email address must be valid
     *
     * if all is well, resetPasswordIdent is deleted again and password is updated
     *
     */
    def saveNewPassword = {

        SaveNewPasswordCommandObject cmd = new SaveNewPasswordCommandObject()

        bindData( cmd, params )

        if ( cmd.validate() && !cmd.hasErrors() ) {

            Person person = Person.findByUsername( cmd.username )

            if ( personService.saveNewPasswordForUser( cmd.username, cmd.ident, cmd.password ) ) {

                def m = [ : ]
                m.givenName = person.givenName
                m.familyName = person.familyName
                m.loginLink = "${grailsLinkGenerator.serverBaseURL}" - "/emobilesim" + createLink( controller: "front", action: "init" )

                render view: "success", model: m

            }
        }

    }

    /**
     * user clicks link in email, which consists of email address and the resetPasswordIdent
     *
     * email and resetPasswordIdent must be valid
     *
     * id all is well, user can create new password
     */
    def resetPassword = {

        ResetPasswordCommandObject cmd = new ResetPasswordCommandObject()
        bindData( cmd, params )

        if ( cmd.validate() && !cmd.hasErrors()  ) {

            def m = [ : ]
            m.username = cmd.email
            m.ident = cmd.ident

            render view: "resetPassword", model: m

        }

    }

    /**
     * this method completes signing request of the user
     * next step is to allow user to log in
     */
    def confirm = {

        log.error( "params: ${params}" )

        ConfirmCommandObject cmd = new ConfirmCommandObject()
        bindData( cmd, params )

        if ( !cmd.validate() && cmd.hasErrors() ) {

            // show errorPage
            log.error( "confirmation not successful: ${cmd.errors}" )

            redirect action: 'index'
        } else {

            Person p = Person.findByUsername( cmd.username )

            personService.confirmPersonAsUser( p )

            sendMailService.sendConfirmationRequestToAdmins( p )

            def m = [ : ]
            m.givenName = p.givenName
            m.familyName = p.familyName
            m.loginLink = "${grailsLinkGenerator.serverBaseURL}" - "/emobilesim" + createLink( controller: "front", action: "init" )

            render view: "success", model: m

        }

    }

    def showPendingUsers() {

        def m = [ : ]

        Person requestingUser = (Person)springSecurityService.currentUser
        Role adminRole = Role.findByAuthority( "ROLE_ADMIN" )
        List<PersonRole> adminPersonRoles = PersonRole.findAllByRoleAndPerson( adminRole, requestingUser )

        if ( adminPersonRoles != null && adminPersonRoles.size() > 0 ) {
            List<Person> pendingPersons = Person.findAllByAccountLocked( true )

            m.pendingUsers = pendingPersons

        }



        render view: "pendings", model: m
    }

    def allowPersonToLogin() {

        AllowPersonCommandObject cmd = new AllowPersonCommandObject()

        bindData( cmd, params )

        if ( !cmd.validate() && cmd.hasErrors() ) {

            log.error( "Validation of requesting sign in user failed: ${cmd.errors}" )

        } else {

            Person person = Person.get( cmd.personId )
            personService.allowPersonToLogin( person )

            sendMailService.sendLoginAllowedMailToPerson( person )

        }



    }

}
