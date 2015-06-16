package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.CustomerPositionSet
import de.dfki.gs.domain.simulation.Fleet
import grails.validation.Validateable

/**
 * Created by simon on 09.06.15.
 */
@Validateable
class VrpCommandObject {
    Long configurationStubId
    Long customerPositionSetId
    Long fleetId

    String fleetName


    static constraints = {



        configurationStubId nullable: false, validator: { val,obj ->

            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }

        }

        fleetId nullable: false, validator: { val,obj ->

            Fleet cars = Fleet.get( val )

            if ( cars == null ) {

                return 'configuration.fleet.not.exist'
            }

        }

        fleetName( nullable: false, blank: false, validator: { val,obj ->

            if ( !val.equals( "All Cars of Experiment" ) ) {

                Fleet fleet = Fleet.findByName( val )

                if ( fleet == null ) {

                    return 'fail'

                }

            }

        } )

        customerPositionSetId (nullable: false, validator: {val,obj ->
            CustomerPositionSet customerPositionSet = CustomerPositionSet.get(val)

            if (customerPositionSet == null){
                return 'CustomerPositionSet not existent'
            }
        })


    }

}

