package de.dfki.gs.security

import de.dfki.gs.domain.users.Person
import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.users.PersonRole
import de.dfki.gs.domain.users.ResetPasswordIdent
import de.dfki.gs.domain.users.Role
import grails.transaction.Transactional

@Transactional
class PersonService {

    def sendMailService

    def createNewPasswordForPerson( String userName ) {

        Person person = Person.findByUsername( userName )

        UUID uuid = UUID.randomUUID();
        String newPassword = uuid.toString().substring( 0, 9 );

        try {

            sendMailService.sendMailWithNewPassword( person, newPassword );

            person.password = newPassword

            if ( !person.save( flush: true ) ) {

                log.error( "failed to save person: ${userName} : ${person.errors}" )

            }

        } catch ( Exception e ) {
            log.error( "failed to send email: ${e.toString()}" )
        }

    }

    boolean invalidateResetPasswordIdent( String ident ) {

        ResetPasswordIdent resetPasswordIdent = ResetPasswordIdent.findByIdentString( ident )

        if( !resetPasswordIdent.delete( flush: true ) ) {
            log.error( "failed to delete resetPasswordIdent" )
            return false
        }

        return true
    }

    String createResetPasswordIdent( String username ) {

        String ident = UUID.randomUUID().toString()

        ResetPasswordIdent resetPasswordIdent = ResetPasswordIdent.findByUsername( username )
        if ( resetPasswordIdent ) {
            return resetPasswordIdent.identString
        }

        resetPasswordIdent = new ResetPasswordIdent(
            username: username,
            identString: ident
        )

        if ( !resetPasswordIdent.save() ) {
            log.error( "failed to create resetPasswordIdent for ${username}: ${resetPasswordIdent.errors}" )
            return null
        }

        return ident
    }

    boolean saveNewPasswordForUser( String username, String ident, String password ) {

        ResetPasswordIdent resetPasswordIdent = ResetPasswordIdent.findByUsername( username )
        if ( !resetPasswordIdent ) {
            return false
        }

        Person person = Person.findByUsername( username )
        if ( !person ) {
            return false
        }

        resetPasswordIdent.delete( flush: true )


        person.password = password

        if ( !person.save( flush: true ) ) {
            log.error( "failed to save new password for person: ${username} : ${person.errors}" )
        }

        return true
    }

    def createSigninPerson(  Long companyId, String givenName, String familyName, String emailAddress, String password ) {

        def m = [:]

        Company company =Company.get(companyId)


        Person p = Person.findByUsername( emailAddress )
        if ( p != null ) {
            log.error( "person with email ${emailAddress} already exists" )

            // ende der geschichte!
            m.message = "person with email ${emailAddress} already exists"
            return m
        }

        UUID uuid = UUID.randomUUID()

        p = new Person(
                familyName: familyName,
                givenName: givenName,
                username: emailAddress,
                company: company,
                password: password,
                accountLocked: true,
                enabled: false,
                confirmationCode: uuid.toString()
        )

        if ( !p.save( flush: true ) ) {

            log.error( "error saving new signin user with email: ${emailAddress} -- errors: ${p.errors}" )

            m.message = "error saving new signin user with email: ${emailAddress} -- errors: ${p.errors}"
            return m
        }

        // otherwise inform admins with email to activate and enable user

        m.message = "signin request saved with email address ${emailAddress}"
        m.person = p


        return m
    }

    def allowPersonToLogin( Person p ) {

        p.accountLocked = false

        if ( !p.save( flush: true ) ) {
            log.error( "failed to save person: ${p.errors}" )
        }

    }

    def confirmPersonAsUser( Person p ) {

        p.enabled = true
        p.accountLocked = false

        Role role = findOrCreateRole( "ROLE_USER" )

        if (!PersonRole.create(p, role, true)) log.error("failed to add Persion[ $p ] to Role[ $role ] -- errors: ${p?.errors}")


        if ( !p.save( flush: true ) ) {
            log.error( "failed to save person: ${p.errors}" )
        }


    }

    Role findOrCreateRole( String roleName, failOnError = true ) {

        def role = Role.findByAuthority(roleName)
        if (!role) {
            role = new Role(authority: roleName)
            if (!role.save(flush: true, failOnError: true)) log.error("failed to save ROLE[ $roleName ] -- errors: ${role.errors}")
        }

        return role
    }
}
