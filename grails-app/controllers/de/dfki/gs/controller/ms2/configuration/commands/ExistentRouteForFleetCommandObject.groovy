package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.CustomerPositionSet
import de.dfki.gs.domain.simulation.Fleet
import grails.validation.Validateable

/**
 * Created by simon on 09.07.15.
 */
@Validateable
class ExistentRouteForFleetCommandObject {

    Long configurationStubId
    Long fleetId
    Long selectedRouteId


    static constraints = {

        configurationStubId nullable: false, validator: { val,obj ->

            Configuration configuration = Configuration.get( val )
            if ( configuration == null ) {
                return 'configuration.stub.not.exist'
            }

        }

        fleetId nullable: false, validator: { val,obj ->

            Fleet fleet = Fleet.get( val )

            if ( fleet == null ) {
                return 'configuration.fleet.not.exist'
            }

        }
        selectedRouteId nullable: false, validator: {val,obj ->

            CustomerPositionSet customerPositionSet = CustomerPositionSet.get(val)

            if (customerPositionSet == null){
                return 'configuration.customerPositionSet.not.exist'
            }
        }

    }

}

