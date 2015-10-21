package de.dfki.gs.model.elements.results

import de.dfki.gs.domain.simulation.Car
import de.dfki.gs.domain.simulation.CarType
import de.dfki.gs.domain.simulation.TrackEdge

/**
 * Created by glenn on 01.04.14.
 */
class CarAgentResult {


    float energyConsumed


    CarType carType

    String carAgentStatus

    float plannedDistance
    float realDistance

    int targets

    long timeForPlannedDistance
    long timeForRealDistance
    long timeForLoading

    long timeForDetour
    float energyLoaded

    int fillingStationsVisited

    long configurationId
    Date  carStartTime
    float relativeSearchLimit

    long fleetId
    int battery

    int lastPositionIndex

    List<TrackEdge> trackEdges




}
