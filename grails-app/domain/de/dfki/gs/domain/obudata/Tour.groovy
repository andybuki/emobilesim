package de.dfki.gs.domain.obudata

import de.dfki.gs.domain.utils.TrackEdgeType

class Tour {

    String vin
    String name
    String ownerName

    Integer mileage // neu parameters
    Integer kmh // neu parameters
    int batterySoc // neu parameters
    int remainingRange // neu parameters
    boolean ignitionOn  // neu parameters
    Date recordingDate  // neu parameters
    boolean loadingStatus // neu parameters
    Date remainingChargingTime // neu parameters
    Long routeId // neu parameters
    float cost // neu parameters
    float km // neu parameters
    String type // neu parameters

    float fromLat
    float fromLon

    float toLat
    float toLon


    static constraints = {

        type( nullable: false, blank: false, inList: TrackEdgeType.values()*.toString())
    }
}
