package de.dfki.gs.domain.stats

import de.dfki.gs.domain.Owners
import de.dfki.gs.domain.simulation.FillingStationType

class PersistedFillingStationResult {

    // String gasolineStationType

    FillingStationType fillingStationType

    Long groupId
    Date startUsing  // new parameter to show the start time of using the electric station
    long timeLiving
    long timeInUse
    String ownerName

    int failedToRouteCount

    float lat
    float lon


    static constraints = {
        fillingStationType( nullable: false )
        startUsing ( nullable: true )
        ownerName nullable: true
    }
}
