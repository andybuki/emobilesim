package de.dfki.gs.domain.users

class ResetPasswordIdent {

    String identString
    String username

    static constraints = {

        identString ( nullable: false, blank: false )
        username( nullable: false, blank: false, validator: { val,obj ->

            Person person = Person.findByUsername( val )
            if ( person == null ) {
                return "fail"
            }

        } )

    }
}
