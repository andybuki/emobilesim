package de.dfki.gs.controller.ms2.configuration.commands

import grails.validation.Validateable

/**
 * Created by glenn on 08.07.14.
 */
@Validateable
class CreateSimulationCommandObject {

    String simulationName
    String simulationDescription


    static constraints = {

        simulationName nullable: false, blank: false
        simulationDescription nullable: false, blank: false


    }

}
