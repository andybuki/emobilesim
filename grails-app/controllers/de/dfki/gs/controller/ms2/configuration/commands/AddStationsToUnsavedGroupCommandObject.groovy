package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.FillingStationGroup
import grails.validation.Validateable

/**
 * Created by simon on 17.04.15.
 */

@Validateable
class AddStationsToUnsavedGroupCommandObject {
    Long configurationStubId

    Integer stationCount

    Long stationTypeId

    String nameForGroup
    Long groupStubId


    static constraints = {

        nameForGroup nullable: false, blank: false
        stationCount nullable: true
        stationTypeId nullable: true
        //addedCars nullable: true

        configurationStubId nullable: false, validator: { val,obj ->

            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }
        }
        groupStubId nullable: false, validator: { val,obj ->

            FillingStationGroup group = FillingStationGroup.get( val )
            if ( group == null ) {

                return 'configuration.group.not.exist'

            }

        }
    }
}
