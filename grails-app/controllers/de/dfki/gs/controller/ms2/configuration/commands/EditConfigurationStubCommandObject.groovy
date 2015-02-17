package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.stats.ExperimentRunResult
import grails.validation.Validateable
import de.dfki.gs.domain.simulation.Simulation

/**
 * Created by glenn on 09.07.14.
 */
@Validateable
class EditConfigurationStubCommandObject {

    Long configurationStubId
    String areaId
    String simulationName
    String simulationDescription

    static constraints = {

        areaId nullable: true, blank: true
        simulationName nullable: true, blank: true

        simulationDescription nullable: true

        configurationStubId nullable: true, validator: { val,obj ->

            if ( val != null ) {

                Configuration stub = Configuration.get( val )

                if ( stub == null ) {
                    return 'configuration.stub.not.exist'
                }

            }

        }

    }

}
