package de.dfki.gs.domain.stats

import de.dfki.gs.domain.simulation.Car
import de.dfki.gs.domain.simulation.CarType
import de.dfki.gs.domain.simulation.TrackEdge
import de.dfki.gs.simulation.CarStatus

class PersistedCarAgentResult {

    String    name
    Float     energyConsumed
    CarType   carType
    String    carStatus
    Float     plannedDistance
    Float     realDistance
    Integer   targets

    Long      fleetId
    Date      carStartTime
    Integer   battery
    Long      timeForPlannedDistance
    Long      timeForRealDistance
    Long      timeForLoading
    Long      timeForDetour

    Float     energyLoaded

    Integer   fillingStationsVisited

    float     relativeSearchLimit

    List  trackEdges



    static constraints = {
        name ( nullable: true, blank: true )
        battery nullable: true
        carStartTime nullable: true
    }
    static hasMany = [
            trackEdges: TrackEdge
    ]
}
