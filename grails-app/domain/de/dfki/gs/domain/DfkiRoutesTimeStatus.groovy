package de.dfki.gs.domain

class DfkiRoutesTimeStatus {

    int batterySoC
    int chargingMode

    boolean ignitionOn
    int mileage
    int speed
    int remainingRange

    Double lat
    Double lon
    int guid
    String vehicle

    String recordedData
    String updatedData
    Date dateCreated
    Date lastUpdated

    static constraints = {

        batterySoC ( nullable: true, blank: true )
        chargingMode ( nullable: true, blank: true )

        ignitionOn ( nullable: true, blank: true )
        mileage ( nullable: true, blank: true )
        speed ( nullable: true, blank: true )
        remainingRange ( nullable: true, blank: true )
        lat ( nullable: true, blank: true )
        lon ( nullable: true, blank: true )

        guid ( nullable: true, blank: true )
        vehicle( nullable: true, blank: true )
        recordedData ( nullable: true, blank: true )
        updatedData ( nullable: true, blank: true )

    }

    static mapping = {
        autoTimestamp true
    }
}
