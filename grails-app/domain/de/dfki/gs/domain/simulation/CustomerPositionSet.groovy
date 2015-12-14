package de.dfki.gs.domain.simulation

import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.utils.SimulationArea

class CustomerPositionSet{
    SimulationArea simulationArea
    Company company
    String name
    List<CustomerPosition> customers = [];
    CustomerPosition depot;
    static hasMany = [
            customers : CustomerPosition
    ]
    static constraints = {
        name ( nullable: true, blank: true )
        customers nullable: true
        depot nullable: false

    }
}
