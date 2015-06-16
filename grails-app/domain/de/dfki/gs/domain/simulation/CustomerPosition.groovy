package de.dfki.gs.domain.simulation


class CustomerPosition {
    Boolean isDepot
    Double lat,lon

    static constraints = {
        //  customerId nullable: false
        lat nullable: false
        lon nullable: false
        isDepot nullable: false
    }
    static mapping = {

        isDepot type: 'yes_no'

    }
}
