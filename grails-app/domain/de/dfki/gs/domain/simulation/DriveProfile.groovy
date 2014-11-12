package de.dfki.gs.domain.simulation

import de.dfki.gs.domain.utils.CarSize
import de.dfki.gs.domain.utils.CitySize
import de.dfki.gs.domain.utils.CompanySize
import de.dfki.gs.domain.utils.ParkingSpot
import de.dfki.gs.domain.utils.NumberOfUsers
import de.dfki.gs.domain.utils.VehicleUtilization
import de.dfki.gs.domain.utils.EconomicSector
import de.dfki.gs.domain.utils.EconomicSegment

/**
 *
 * DriveProfile based on data from REM 2030
 *
 *
 *
 */



class DriveProfile {


    // car size from little 1400 to big cars ap to 2000 and transporter
    CarSize carSize

    // different cities from 20000 up to 100000
    CitySize citySize

    //little and big companies in enum
    CompanySize companySize

    // different parking spots
    ParkingSpot parkingSpot

    //number of users, who used the car
    NumberOfUsers numberOfUsers

    //fleet or company car
    VehicleUtilization vehicleUtilization

    // look in emum all variants
    EconomicSector economicSector

    //look in emum all variants
    EconomicSegment economicSegment

    static constraints = {

        carSize nullable: false
        citySize nullable: false
        companySize nullable: true
        parkingSpot nullable: true
        numberOfUsers nullable: true
        vehicleUtilization nullable: true
        economicSector nullable: true
        economicSegment nullable: true
    }
}
