package de.dfki.gs.domain.simulation

import de.dfki.gs.domain.users.Company

class Simulation {

    Date dateCreated
    Date lastUpdated

    Date simulationStartTime
    /*Date simulationsDuration
    Date simulationEndDate*/

    String name

    /**
     * space for long description, if needed
     */
    String description

    /**
     * short abstract, what is it about, if needed
     */
    String abstractText

    /**
     * for the possibility to have different configs for one simulation object
     */
    Set<Configuration> configurations = []

    /**
     * the company of the person, who creates this simulation
     */
    Company company
    Boolean stub

    static hasMany = [
            configurations : Configuration
    ]

    static constraints = {

        name nullable: true
        description nullable: true
        abstractText nullable: true
        simulationStartTime nullable: true

    }

    static mapping = {
    }

}
