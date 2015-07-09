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

    Date simulationStartTime

    /**
     * all executed experiments.. for the stats
     */
    List<Experiment> experiments = []

    /**
     * possibility to have different fleets, and to plug ready-steady-fleets into Configuration
     */
    List<Fleet> fleets = []

    /**
     * same same for fillingstations
     */
    List<FillingStationGroup> fillingStationGroups = []

    Boolean stub

    String simulationName

    static hasMany = [
            experiments : Experiment,
            fleets : Fleet,
            fillingStationGroups : FillingStationGroup
    ]

    static constraints = {
        simulationName nullable: true
        simulationStartTime nullable: true
    }

    static mapping = {

        stub type: 'yes_no'

    }
}
