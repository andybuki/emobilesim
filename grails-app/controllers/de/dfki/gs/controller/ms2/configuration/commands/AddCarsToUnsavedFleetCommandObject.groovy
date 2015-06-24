package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.Fleet
import grails.validation.Validateable

/**
 * Created by simon on 16.04.15.
 */
@Validateable
class AddCarsToUnsavedFleetCommandObject {
    Long configurationStubId

    Integer carCount
    Integer batteryCount

    Long carTypeId

    String nameForFleet
    Long fleetStubId


    static constraints = {

        nameForFleet nullable: false, blank: false
        carCount nullable: true
        batteryCount nullable: true
        carTypeId nullable: true
        //addedCars nullable: true

        configurationStubId nullable: false, validator: { val,obj ->

            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }
        }
        fleetStubId nullable: false, validator: { val,obj ->

            Fleet fleet = Fleet.get( val )
            if ( fleet == null ) {

                return 'configuration.fleet.not.exist'

            }

        }
    }
}
