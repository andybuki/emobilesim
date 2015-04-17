package de.dfki.gs.domain.simulation

import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.utils.CompanySize
import de.dfki.gs.domain.utils.Distribution
import de.dfki.gs.domain.utils.EconomicSector
import de.dfki.gs.domain.utils.FleetStatus
import de.dfki.gs.domain.utils.SimulationArea

class Fleet {

    /**
     * to title the fleet
     */
    String name

    List<Car> cars = new ArrayList<Car>()

    Company company

    Integer plannedFromKm
    Integer plannedToKm

    Date dateCreated
    Date lastUpdated


    Boolean stub

    Boolean routesConfigured

    FleetStatus fleetStatus
    CompanySize companySize
    EconomicSector economicSector

    Distribution distribution
    SimulationArea simulationArea = SimulationArea.BERLIN


    static hasMany = [
            cars : Car
    ]

    static constraints = {
        name nullable: true
        plannedFromKm nullable: true
        plannedToKm nullable: true
        companySize nullable: true
        economicSector nullable: true
    }

    static mapping = {

        stub type: 'yes_no'
        routesConfigured type: 'yes_no'

    }

    transient Map dto( qualified = false ) {

        def ret = [ : ]

        ret.id            = id
        ret.name          = name
        ret.carsCount     = cars.size()
        ret.distribution  = distribution.toString()

        ret.plannedFromKm = plannedFromKm
        ret.plannedToKm   = plannedToKm

        // placeholder for cars
        ret.cars = []

        return ret
    }
}
