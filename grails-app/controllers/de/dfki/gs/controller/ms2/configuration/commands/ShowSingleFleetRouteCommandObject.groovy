package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Fleet
import grails.validation.Validateable

/**
 * Created by simon on 19.06.15.
 */
@Validateable
class ShowSingleFleetRouteCommandObject {
    Long fleetId
    static constraints = {
        fleetId nullable: false, validator: { val, obj ->

            Fleet fleet = Fleet.get(val)

            if (fleet == null) {
                return 'fleet.not.exist'
            }


        }
    }
}
