package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.GasolineStation
import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.FillingStation
import grails.validation.Validateable

/**
 * @author: andrey
 * @since: 02.02.15
 */

@Validateable
class ShowInfoStationsCommandObject {
    Long fillingStationId
    Long configurationStubId

    static constraints = {

        fillingStationId( nullable: false, validator: { val, obj ->
            if ( !FillingStation.get( val ) ) return false

            return true;
        })

        configurationStubId nullable: false, validator: { val, obj ->

            Configuration stub = Configuration.get(val)

            if (stub == null) {
                return 'configuration.stub.not.exist'
            }


        }


    }

}
