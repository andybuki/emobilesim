package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import grails.validation.Validateable

/**
 * Created by sitr01 on 06.02.2015.
 */
@Validateable
class UpdateAreaCommandObject {
    Long configurationStubId
    String areaId
    static constraints = {
        configurationStubId nullable: false, validator: { val,obj ->


            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }



        }
        areaId nullable: true
    }
}
