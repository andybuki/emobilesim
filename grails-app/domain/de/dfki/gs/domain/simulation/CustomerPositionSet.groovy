package de.dfki.gs.domain.simulation

import de.dfki.gs.domain.users.Company

class CustomerPositionSet{
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
