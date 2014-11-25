package de.dfki.gs.controller.commands

import de.dfki.gs.domain.stats.PersistedCarAgentResult
import de.dfki.gs.domain.users.Person
import grails.validation.Validateable

/**
 * Created by glenn on 24.11.14.
 */
@Validateable
class ForgotPasswordCommandObject {

    String emailAddress

    static constraints = {

        emailAddress ( nullable: false, validator: { val,obj ->

            if ( val != null && val.length() > 0 ) {

                Person person = Person.findByUsername( val )

                if ( person == null ) {

                    return "fail"

                }


            }

        } )

    }

}
