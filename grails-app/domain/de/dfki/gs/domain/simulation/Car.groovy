package de.dfki.gs.domain.simulation

/**
 * this class models a car
 *
 */
class Car {

    CarType carType
    String name
    Route route

    Configuration simulationStartTime
    Date carStartTime
    Integer battery=80  // Persent from CarType maxEnergyLoad
    Integer pauseTimes
    String ownerName
    Boolean routesConfigured
    Long fleetId


    static constraints = {
        name ( nullable: true, blank: true )
        route nullable: true
        battery nullable: true
        carStartTime nullable: true
        routesConfigured nullable: false
        fleetId nullable: false
        simulationStartTime  nullable: true
        pauseTimes nullable: true
        ownerName nullable: true
    }

    static mapping = {
        routesConfigured type: 'yes_no'
    }

}
