package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import grails.validation.Validateable

/**
 * Created by simon on 19.12.15.
 */
@Validateable
class SaveStationsCommandObject {
    Long configurationStubId
    String stations
    static constraints = {

        configurationStubId nullable: false, validator: { val,obj ->


            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }



        }

        stations nullable:true
    }
}