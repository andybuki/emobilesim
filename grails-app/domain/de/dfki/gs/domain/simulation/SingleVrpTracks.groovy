package de.dfki.gs.domain.simulation

class SingleVrpTracks {
    List<CustomerPosition> vrpRoute = []
    static hasMany = [
            vrpRoute : CustomerPosition
    ]
    static constraints = {
        vrpRoute nullable: true
    }
}

