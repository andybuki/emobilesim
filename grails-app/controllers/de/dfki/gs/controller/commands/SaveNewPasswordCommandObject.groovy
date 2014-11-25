package de.dfki.gs.controller.commands

import de.dfki.gs.domain.users.Person
import de.dfki.gs.domain.users.ResetPasswordIdent
import grails.validation.Validateable

/**
 * Created by glenn on 25.11.14.
 */
@Validateable
class SaveNewPasswordCommandObject {

    String password
    String confirm
    String username
    String ident

    static constraints = {

        ident ( nullable: false, blank: false, validator: { val,obj ->

            ResetPasswordIdent resetPasswordIdent = ResetPasswordIdent.findByIdentString( val )

            if ( resetPasswordIdent == null ) {
                return "fail"
            }

            Person person = Person.findByUsername( obj.username )
            if ( person == null ) {
                return "fail"
            }

            if ( !person.username.equals( resetPasswordIdent.username ) ) {
                return "fail"
            }

        } )

        username ( nullable: false, validator: { val,obj ->

            if ( val != null && val.length() > 0 ) {

                Person person = Person.findByUsername( val )

                if ( person == null ) {

                    return "fail"

                }


            }

        } )

        password ( nullable: false, blank: false )
        confirm ( nullable: false, blank: false, validator: { val,obj ->
            if ( !val.equals( obj.password ) ) {
                return 'de.dfki.gs.person.password.not.match'
            }
        } )



    }

}
