package de.dfki.gs.domain.simulation

import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.utils.SimulationArea

/**
 * this class is to configure simulation experiment
 * different fleets, fillingstation, aso.
 *
 */
class Configuration {
    SimulationArea simulationArea
    Company company

    Date dateCreated
    Date lastUpdated

    /**
     * all executed experiments.. for the stats
     */
    Set<Experiment> experiments = []

    /**
     * possibility to have different fleets, and to plug ready-steady-fleets into Configuration
     */
    Set<Fleet> fleets = []

    /**
     * same same for fillingstations
     */
    Set<FillingStationGroup> fillingStationGroups = []

    Boolean stub

    String simulationName

    static hasMany = [
            experiments : Experiment,
            fleets : Fleet,
            fillingStationGroups : FillingStationGroup
    ]

    static constraints = {
        simulationName nullable: true
    }

    static mapping = {

        stub type: 'yes_no'

    }
}
