package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import grails.validation.Validateable

/**
 * Created by simon on 23.11.15.
 */
@Validateable
class SetNameAndAreaCommandObject {
    Long configurationStubId
    String nameForSimulation
    String areaId
    static constraints = {

        configurationStubId nullable: false, validator: { val,obj ->


            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }



        }

        nameForSimulation nullable: true
        areaId nullable:true
    }
}
