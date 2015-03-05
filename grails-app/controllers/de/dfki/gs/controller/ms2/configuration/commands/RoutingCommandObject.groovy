package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.*
import de.dfki.gs.utils.LatLonPoint
import grails.validation.Validateable

/**
 * @author: glenn
 * @since: 11.10.13
 */
@Validateable
class RoutingCommandObject implements Serializable {

    //Long simulationId
    Long configurationStubId

    List<LatLonPoint> destinationPoints = []
    LatLonPoint startPoint

    Long fleetId

    String fleetName

    Long carTypeId

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

        carTypeId nullable: true



        fleetName( nullable: false, blank: false, validator: { val,obj ->

            if ( !val.equals( "All Cars of Experiment" ) ) {

                Fleet fleet = Fleet.findByName( val )

                if ( fleet == null ) {

                    return 'fail'

                }

            }

        } )

        destinationPoints( nullable: false)

        startPoint( nullable: false )


    }

}
