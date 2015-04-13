package de.dfki.gs.domain.stats

import de.dfki.gs.domain.simulation.FillingStationType

class FillingStationResult {


    FillingStationType fillingStationType

    long fillingStationId

    Date startUsing   // new parameter to show the start time of using the electric station
    long timeLiving

    /**
     *
     */
    long timeInUse

    /**
     * count of cars which used fillingStation
     */
    int countOfVisitingCars


    static constraints = {

    }
}
