package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.FillingStationGroup
import de.dfki.gs.domain.simulation.FillingStationType
import de.dfki.gs.domain.simulation.FillingStation
import de.dfki.gs.domain.simulation.Simulation
import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.utils.LatLonPoint
import grails.validation.Validateable

/**
 * @author: glenn
 * @since: 11.10.13
 */
@Validateable
class StartAndDestinationsCommandObject implements Serializable {

    //Long simulationId
    Long configurationStubId
    Long simulationId
    List<LatLonPoint> destinationPoints = []
    LatLonPoint startPoint
    Long groupId
    String groupName
    Long fillingStationId
    Long fillingStationTypeId

    static constraints = {

        simulationId( nullable: false, validator: { val, obj ->
            if ( !Simulation.get( val ) ) {
                return 'simulation not exist'
            }
        } )

        configurationStubId nullable: false, validator: { val,obj ->

            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }

        }

        groupId nullable: false, validator: { val,obj ->

            FillingStationGroup fillingStations = FillingStationGroup.get( val )

            if ( fillingStations == null ) {

                return 'configuration.group.not.exist'
            }

        }

        groupName( nullable: false, blank: false, validator: { val,obj ->

            if ( !val.equals( "All Filling Stations of Experiment" ) ) {

                FillingStationGroup group = FillingStationGroup.findByName( val )

                if ( group == null ) {

                    return 'fail'

                }

            }

        } )

        fillingStationId( nullable: false, validator: { val, obj ->
            if ( !FillingStation.get( val ) ) return false

            return true;
        })

        fillingStationTypeId nullable: false, validator: { val,obj ->

            FillingStationType fillingStationType = FillingStationType.get( val )

            if ( fillingStationType == null ) {
                return 'configuration.fillingStationType.not.exist'
            }

        }

        destinationPoints( nullable: false)

        startPoint( nullable: false )


    }

}
