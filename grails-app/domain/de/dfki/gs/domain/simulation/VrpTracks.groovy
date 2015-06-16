package de.dfki.gs.domain.simulation

import de.dfki.gs.domain.users.Company

class VrpTracks {
    Company company
    int numberOfCars
    CustomerPositionSet customerPositionSet
    List<SingleVrpTracks> optaTracks = []

    static hasMany = [
            optaTracks : SingleVrpTracks
    ]
    static constraints = {
        numberOfCars nullable:false
        customerPositionSet nullable: false
        optaTracks nullable:true
    }
}
