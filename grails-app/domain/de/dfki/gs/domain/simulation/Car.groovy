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
    float batteryPersent  // Persent from CarType maxEnergyLoad
    Integer pauseTimes
    String ownerName
    Boolean routesConfigured
    Long fleetId


    static constraints = {
        name ( nullable: true, blank: true )
        route nullable: true
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
