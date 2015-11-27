package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import grails.validation.Validateable

/**
 * Created by simon on 27.11.15.
 */
@Validateable
class SaveBaseAndTargetsCommandObject {
    Long configurationStubId
    String base
    String targets
    static constraints = {

        configurationStubId nullable: false, validator: { val,obj ->


            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }



        }

        base nullable: false
        targets nullable:false
    }
}
