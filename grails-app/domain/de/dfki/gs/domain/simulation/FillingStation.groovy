package de.dfki.gs.domain.simulation



class FillingStation {


    String name

    /**
     * Berlin: lat: 52, lon: 13
     */
    float lat
    float lon

    String streetName
    String houseNumber
    String ownerName

    FillingStationType fillingStationType
    Boolean groupsConfigured

    static hasMany = [
    ]

    static constraints = {
        streetName ( nullable: true, blank: true )
        houseNumber nullable: true
        groupsConfigured nullable: true
        ownerName nullable: true
    }

    static mapping = {
        groupsConfigured type: 'yes_no'
    }
}
