package de.dfki.gs.ms2.configuration

import com.vividsolutions.jts.geom.Coordinate
import com.vividsolutions.jts.geom.Point
import de.dfki.gs.domain.DfkiRoutesTimeStatus
import de.dfki.gs.domain.GasolineStationType
import de.dfki.gs.domain.simulation.Car
import de.dfki.gs.domain.simulation.CarType
import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.FillingStation
import de.dfki.gs.domain.simulation.FillingStationGroup
import de.dfki.gs.domain.simulation.FillingStationType
import de.dfki.gs.domain.simulation.Fleet
import de.dfki.gs.domain.simulation.Route
import de.dfki.gs.domain.simulation.Simulation
import de.dfki.gs.domain.simulation.TrackEdge
import de.dfki.gs.domain.stats.ExperimentRunResult
import de.dfki.gs.domain.stats.FillingStationResult
import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.users.Person
import de.dfki.gs.domain.utils.Distribution
import de.dfki.gs.domain.utils.FleetStatus
import de.dfki.gs.domain.utils.GroupStatus
import de.dfki.gs.domain.utils.SimulationArea
import de.dfki.gs.utils.LatLonPoint
import grails.transaction.Transactional

@Transactional
class ConfigurationService {

    def routeService
    def statisticService

    /**
     * configuration can have some fleets
     * this method is used to remove one fleet from configuration
     *
     * @param configurationStubId
     * @param fleetId
     * @return
     */
    def removeFleetFromConfiguration( Long configurationStubId, Long fleetId ) {

        Configuration configuration = Configuration.get( configurationStubId )
        Fleet fleet = Fleet.get( fleetId )

        configuration.removeFromFleets( fleet )

        if ( !configuration.save( flush: true ) ) {

            log.error( "failed to remove fleet from configuarionStub: ${configuration.errors}" )

        }

        return
    }

    /**
     * configuration can have some electric groups
     * this method is used to remove one group from configuration
     *
     * @param configurationStubId
     * @param groupId
     * @return
     */
    def removeGroupFromConfiguration( Long configurationStubId, Long groupId ) {

        Configuration configuration = Configuration.get( configurationStubId )
        FillingStationGroup group = FillingStationGroup.get( groupId )

        configuration.removeFromFillingStationGroups( group )

        if ( !configuration.save( flush: true ) ) {

            log.error( "failed to remove group from configuarionStub: ${configuration.errors}" )

        }

        return
    }

    /**
     * configuration can have some fleets
     * this method is used to add one fleet to configuration
     *
     * @param configurationStubId
     * @param fleetId
     * @return
     */
    def changeSimulationArea(Long configurationStubId , areaId){

        Configuration configuration = Configuration.get( configurationStubId )
        configuration.simulationArea = SimulationArea.valueOf(areaId)

        if ( !configuration.save( flush: true ) ) {

            log.error( "failed to change Area of configuarionStub: ${configuration.errors}" )

        }

        return
    }
    def addFleetToConfiguration( Long configurationStubId , Long fleetId) {

        Configuration configuration = Configuration.get( configurationStubId )
        Fleet fleet = Fleet.get( fleetId )

        configuration.addToFleets( fleet )

        if ( !configuration.save( flush: true ) ) {

            log.error( "failed to add fleet to configuarionStub: ${configuration.errors}" )

        }

        return
    }


    /**
     * configuration can have some electric groups
     * this method is used to add one group to configuration
     *
     * @param configurationStubId
     * @param groupId
     * @return
     */
    def addGroupToConfiguration( Long configurationStubId , Long groupId) {

        Configuration configuration = Configuration.get( configurationStubId )
        FillingStationGroup group = FillingStationGroup.get( groupId )

        configuration.addToFillingStationGroups( group )

        if ( !configuration.save( flush: true ) ) {

            log.error( "failed to add group to configuarionStub: ${configuration.errors}" )

        }

        return
    }


    /**
     * this method creates a configuration stub and persist it to db
     *
     *
     * @param person to find his company, which is then the owner of the configuration
     * @return
     */
    def createConfigurationStub( Person person ) {

        // getting the company
        Company company = Company.get( person.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${person.username}" )
            return
        }

        Configuration configurationStub = new Configuration(
                simulationArea: SimulationArea.BERLIN, //Could also take a different default aria
            company: company,
            stub: true
        )

        if ( !configurationStub.save( flush: true ) ) {
            log.error( "failed to save configurationStub: ${configurationStub.errors}" )
        }


        return configurationStub
    }
    def getSimulationName(long configurationStubId){
        Configuration stub = Configuration.get( configurationStubId )
        if(!stub.simulationName){
            stub.simulationName = "Simulation Nr. ${stub.id}"
            if ( !stub.save( flush: true ) ) {
                log.error( "failed to save simulationName: ${stub.errors}" )
            }
        }
        return stub.simulationName
    }
    def setSimulationName(long configurationStubId, String simulationName){
        Configuration stub = Configuration.get( configurationStubId )
        stub.simulationName = simulationName
        if ( !stub.save( flush: true ) ) {
            log.error( "failed to save simulationName: ${stub.errors}" )
        }
    }

    /**
     * get all fleets added to a certain configuration stub
     *
     * @param configurationStubId
     * @return
     */
    def getAddedFleets( Long configurationStubId ) {

        Configuration stub = Configuration.get( configurationStubId )

        List<Fleet> addedFleets = new ArrayList<Fleet>()
        stub.fleets.each { Fleet fleet ->

            addedFleets.add( Fleet.get( fleet.id ) )

        }

        return addedFleets
    }

    def getObuDfki (Long configurationStubId) {
        Configuration stub = Configuration.get( configurationStubId )

        List<DfkiRoutesTimeStatus> obuDfki = new ArrayList<DfkiRoutesTimeStatus>()

    }

    /**
     * get all groups added to a certain configuration stub
     *
     * @param configurationStubId
     * @return
     */
    def getSimulationArea( Long configurationStubId){
        Configuration stub = Configuration.get( configurationStubId )
        SimulationArea simulationArea = stub.simulationArea
        return simulationArea
    }
    def getAddedGroups( Long configurationStubId ) {

        Configuration stub = Configuration.get( configurationStubId )

        List<FillingStationGroup> addedGroups = new ArrayList<FillingStationGroup>()
        stub.fillingStationGroups.each { FillingStationGroup group ->

            addedGroups.add( FillingStationGroup.get( group.id ) )

        }
        log.error("addedGroups---${addedGroups}")
        return addedGroups
    }

    /**
     * is this experiment executable for currentUser's company
     *
     *
     * @param currentUser
     * @return
     */
    def getConfiguredGroups (Long configurationStubId) {
        Configuration stub = Configuration.get( configurationStubId )
        int groupExecutable = 0
        List<FillingStationGroup> configuredGroups = new ArrayList<FillingStationGroup>()
        stub.fillingStationGroups.each { FillingStationGroup group ->

            configuredGroups.add( FillingStationGroup.get( group.id ).groupStatus)
            if (configuredGroups.contains(GroupStatus.CONFIGURED)&& group.simulationArea == stub.simulationArea )
                groupExecutable = 1
        }
        return groupExecutable
    }

    /**
     * is this experiment executable for currentUser's company
     *
     *
     * @param currentUser
     * @return
     */
    def getConfiguredFleets (Long configurationStubId) {
        Configuration stub = Configuration.get( configurationStubId )
        int fleetExecutable = 0

        List<Fleet> addedFleets = new ArrayList<Fleet>()
        stub.fleets.each { Fleet fleet ->
            addedFleets.add( Fleet.get( fleet.id ).fleetStatus )

            if (addedFleets.contains(FleetStatus.CONFIGURED) && fleet.simulationArea == stub.simulationArea)
                fleetExecutable = 1
        }
        return fleetExecutable
    }

    /**
     * is this experiment saveable for currentUser's company
     *
     *
     * @param currentUser
     * @return
     */
    def getGroupsToBeSaved (Long configurationStubId) {

        Configuration stub = Configuration.get( configurationStubId )
        int groupSaveable = 0
        List<FillingStationGroup> configuredGroups = new ArrayList<FillingStationGroup>()
        stub.fillingStationGroups.each { FillingStationGroup group ->

            configuredGroups.add( FillingStationGroup.get( group.id ).groupStatus )
            if (configuredGroups.contains(GroupStatus.SCHEDULED_FOR_CONFIGURING)||group.simulationArea!= stub.simulationArea)
                groupSaveable = 1
        }
        return groupSaveable
    }

    /**
     * is this experiment saveable for currentUser's company
     *
     *
     * @param currentUser
     * @return
     */
    def getFleetsToBeSaved (Long configurationStubId) {
        Configuration stub = Configuration.get( configurationStubId )
        int fleetExecutable = 0

        List<Fleet> addedFleets = new ArrayList<Fleet>()
        stub.fleets.each { Fleet fleet ->
            addedFleets.add( Fleet.get( fleet.id ).fleetStatus )
            if (addedFleets.contains(FleetStatus.SCHEDULED_FOR_CONFIGURING)||fleet.simulationArea != stub.simulationArea)
                fleetExecutable = 1
        }
        return fleetExecutable
    }

    def getGroupsNotConfigured (Long configurationStubId) {
        Configuration stub = Configuration.get( configurationStubId )
        int groupSaveable = 0
        List<FillingStationGroup> configuredGroups = new ArrayList<FillingStationGroup>()
        stub.fillingStationGroups.each { FillingStationGroup group ->
            configuredGroups.add( FillingStationGroup.get( group.id ).groupStatus )
            if (configuredGroups.contains(GroupStatus.NOT_CONFIGURED))
                groupSaveable = 1
        }
        return groupSaveable

    }
    def getFleetsNotConfigured (Long configurationStubId){
        Configuration stub = Configuration.get( configurationStubId )
        int fleetExecutable = 0

        List<Fleet> addedFleets = new ArrayList<Fleet>()
        stub.fleets.each { Fleet fleet ->

            addedFleets.add( Fleet.get( fleet.id ).fleetStatus )
            if (addedFleets.contains(FleetStatus.NOT_CONFIGURED))
                fleetExecutable = 1
        }
        return fleetExecutable
    }

    /**
     * collect all available fillingStationGroups for currentUser's company
     *
     *
     * @param currentUser
     * @return
     */
    def getFillingStationGroupsForCompany( Person currentUser ) {

        // getting the company
        Company company = Company.get( currentUser.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${currentUser.username}" )
            return
        }

        List<FillingStationGroup> fillingStationGroups = FillingStationGroup.findAllByCompany( company )

        return fillingStationGroups
    }

    /**
     * collect all available fleets for currentUser's company
     * remove those fleets which are added to configuration already, so no fleet is selectable twice
     *
     * @param currentUser
     * @return
     */
    def getFleetsForCompany( Person currentUser, Long configurationStubId ) {

        // getting the company
        Company company = Company.get( currentUser.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${currentUser.username}" )
            return
        }
        SimulationArea simulationArea = getSimulationArea(configurationStubId)
        List<Fleet> fleets = Fleet.findAllByCompanyAndSimulationAreaAndStub(company,simulationArea,false, [ sort: "dateCreated", order: "desc" ] )

        Configuration stub = Configuration.get( configurationStubId )
        List<Fleet> alreadyAddedFleets = new ArrayList<Fleet>()
        stub.fleets.each { Fleet fleet ->
            alreadyAddedFleets.add( Fleet.get( fleet.id ) )
        }

        fleets.removeAll( alreadyAddedFleets )

        return fleets
    }

    /**
     * collect all available filling station groups for currentUser's company
     * remove those groups which are added to configuration already, so no groups is selectable twice
     *
     * @param currentUser
     * @return
     */
    def getGroupsForCompany( Person currentUser, Long configurationStubId ) {

        // getting the company
        Company company = Company.get( currentUser.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${currentUser.username}" )
            return
        }
        SimulationArea simulationArea = getSimulationArea(configurationStubId)
        List<FillingStationGroup> fillingStationGroups = FillingStationGroup.findAllByCompanyAndSimulationAreaAndStub( company,simulationArea,false, [ sort: "dateCreated", order: "desc" ] )

        Configuration stub = Configuration.get( configurationStubId )
        List<FillingStationGroup> alreadyAddedGroups = new ArrayList<FillingStationGroup>()
        stub.fillingStationGroups.each { FillingStationGroup group ->
            alreadyAddedGroups.add( FillingStationGroup.get( group.id ) )
        }

        fillingStationGroups.removeAll( alreadyAddedGroups )

        return fillingStationGroups
    }

    /**
     * update carType
     * the company remains!
     *
     * @param person
     * @param carTypeName
     * @param energyConsumption
     * @param maxEnergyLoad
     */
    def updateCarTypeForCompany( Person person, Long carTypeId, String carTypeName, Double energyConsumption, Double maxEnergyLoad ) {

        // getting the company
        Company company = Company.get( person.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${person.username}" )
            return
        }

        CarType carTypeToUpdate = CarType.get( carTypeId )

        carTypeToUpdate.name = carTypeName
        carTypeToUpdate.energyConsumption = energyConsumption
        carTypeToUpdate.maxEnergyLoad = maxEnergyLoad

        if ( !carTypeToUpdate.save( flush: true ) ) {
            log.error( "failed to update carType with : errors: ${carTypeToUpdate.errors}" )
        }


        return carTypeToUpdate
    }

    /**
     * creates a new Simulation name
     * @param currentUser to save carType for currentUser's company
     * @param simulationName
     * @param simulationDescription
     *
     */
    def createSimulationForCompany (Person currentUser,  Long configurationStubId) {

        // getting the company
        Company company = Company.get( currentUser.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${currentUser.username}" )
            return
        }

        String generatedSimulationName = "Simulation No. ${configurationStubId}"

        Simulation simulationStub = new Simulation( company: company,
                                                    name: generatedSimulationName,
                                                    stub: true
                                                  )

        if ( !simulationStub.save( flush: true ) ) {
            log.error( "failed to save simulation stub: ${simulationStub.errors}" )
            return null
        }

        return simulationStub

    }


    /**
     * creates a new CarTyp
     *
     * @param currentUser to save carType for currentUser's company
     * @param carName
     * @param energyDemand
     * @param maxEnergyCapacity
     */
    def createCarTypeForCompany( Person currentUser, String carName, Double energyDemand, Double maxEnergyCapacity ) {

        // getting the company
        Company company = Company.get( currentUser.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${currentUser.username}" )
            return
        }

        CarType carType = new CarType(
                                company:  company,
                                name: carName,
                                energyConsumption: energyDemand,
                                maxEnergyLoad: maxEnergyCapacity
                          )

        if ( !carType.validate() && carType.hasErrors() ) {
            log.error( "failed to vaildate new carType: ${carType.errors}" )
            return
        }

        if ( !carType.save( flush: true ) ) {
            log.error( "failed to save new carType: ${carType.errors}" )
            return
        }

        return carType
    }

    /**
     * this method adds 'count' Cars of type 'carType' to fleet with given fleetStubId
     * these cars are stub cars, i.e. there are no routes persisted for these cars
     *
     * @param fleetStubId
     * @param count
     * @param carTypeId
     * @return
     */
    def addCarsToFleet( Long fleetStubId, Integer count, Long carTypeId, String nameForFleet ) {

        Fleet fleetStub = Fleet.get( fleetStubId )

        CarType carType = CarType.get( carTypeId )

        count.times {

            Car car = new Car(
                carType: carType,
                name: "${carType.name} - No.${it}",
                routesConfigured: false,
                fleetId: fleetStubId
            )

            if ( !car.save( flush: true ) ) {
                log.error( "failed to save car: ${car.errors}" )
            } else {

                fleetStub.addToCars( car )

            }

        }

        fleetStub.name = nameForFleet

        if ( !fleetStub.save( flush: true ) ) {
            log.error( "failed to update fleet: ${fleetStub.errors}" )
        }

        log.error( "fleetStub saved" )
    }

    /**
     * this method adds 'count' Stations of type 'FillingStationType' to group with given groupStubId
     * these stations are stub stations, i.e. there are no routes persisted for these stations
     *
     * @param groupStubId
     * @param count
     * @param stationTypeId
     * @return
     */
    def addStationsToGroup( Long groupStubId, Integer count, Long stationTypeId, String nameForGroup ) {

        FillingStationGroup groupStub = FillingStationGroup.get( groupStubId )

        FillingStationType fillingStationType = FillingStationType.get( stationTypeId )

        count.times {

            FillingStation station = new FillingStation(
                    fillingStationType: fillingStationType,
                    name: "${fillingStationType.name} - No.${it}",
                    groupsConfigured: false
            )

            if ( !station.save( flush: true ) ) {
                log.error( "failed to save car: ${car.errors}" )
            } else {

                groupStub.addToFillingStations( station )

            }

        }

        groupStub.name = nameForGroup

        if ( !groupStub.save( flush: true ) ) {
            log.error( "failed to update group: ${groupStub.errors}" )
        }


    }


    def addSimulation( Long configurationStubId, String nameForSimulation ) {

        Simulation simulationStub = Simulation.get( configurationStubId )

        simulationStub.name = nameForSimulation

        if ( !simulationStub.save( flush: true ) ) {
            log.error( "failed to update simulation: ${simulationStub.errors}" )
        }


    }

    /**
     * this method creates a fleet stub and persists it to db
     * this fleet belongs to a given person's company
     *
     * @param person
     * @param configurationStubId
     * @return
     */
    def createFleetStub( Person person, Long configurationStubId ) {

        Company company = Company.get( person.company.id )
        def stubedFleets = Fleet.findAllByStubAndCompany(true,company)
        stubedFleets.each {
            it.delete(flush: true)

        }
        Configuration stub = Configuration.get( configurationStubId )
        SimulationArea simulationArea = getSimulationArea(configurationStubId)

        String generatedFleetName = "Fleet No. ${Fleet.countByCompany( Company.get( person.company.id ) ) + 1}"

        Fleet fleetStub = new Fleet(
                                company: company,
                                name: generatedFleetName,
                                stub: true,
                                distribution: Distribution.NOT_ASSIGNED,
                                fleetStatus: FleetStatus.NOT_CONFIGURED,
                                routesConfigured: false,
                                simulationArea: simulationArea
                            )

        if ( !fleetStub.save( flush: true ) ) {
            log.error( "failed to save fleet stub: ${fleetStub.errors}" )
            return null
        }


        return fleetStub

    }


    def getFleetConfigurationOnMap (Long configurationId ) {
        Configuration configuration = Configuration.get( configurationId )

        def fleets = []


        configuration.fleets.each { Fleet fleet ->

            def fleetModel = [:]

            fleet = Fleet.get( fleet.id )

            fleetModel.cars = []
            fleetModel.name = fleet.name
            fleetModel.routesConfigured = fleet.routesConfigured
            if (fleetModel.routesConfigured == false) {
                fleet.cars.each { Car car ->

                    car = Car.get(car.id)

                    def carModel = [:]
                    carModel.name = car.name
                    carModel.route = []



                    Route route = Route.get(car.route.id)

                    route.edges.each { TrackEdge trackEdge ->

                        trackEdge = TrackEdge.get(trackEdge.id)

                        carModel.route << trackEdge

                    }

                    fleetModel.cars << carModel

                }
            }

            fleets << fleetModel

        }

        return fleets
    }

    def getFleetRoutesOfConfiguration( Long configurationId ) {

        Configuration configuration = Configuration.get( configurationId )

        def fleets = []

        configuration.fleets.each { Fleet fleet ->

            def fleetModel = [:]

            fleet = Fleet.get( fleet.id )

            fleetModel.cars = []
            fleetModel.name = fleet.name
            fleetModel.routesConfigured = fleet.routesConfigured
            if (fleetModel.routesConfigured == true) {
                fleet.cars.each { Car car ->

                    car = Car.get(car.id)

                    def carModel = [:]
                    carModel.name = car.name
                    carModel.route = []

                    Route route = Route.get(car.route.id)

                    route.edges.each { TrackEdge trackEdge ->

                        trackEdge = TrackEdge.get(trackEdge.id)

                        carModel.route << trackEdge

                    }

                    fleetModel.cars << carModel

                }
            }

            fleets << fleetModel

        }

        return fleets
    }
    def getFleetRoute( Long fleetID ) {

        Fleet fleet = Fleet.get(fleetID)
        def fleetModel = [:]
        fleet = Fleet.get( fleet.id )

        fleetModel.cars = []
        fleetModel.name = fleet.name
        fleetModel.routesConfigured = fleet.routesConfigured
        if (fleetModel.routesConfigured == true) {
            fleet.cars.each { Car car ->

                car = Car.get(car.id)

                def carModel = [:]
                carModel.name = car.name
                carModel.route = []

                Route route = Route.get(car.route.id)

                route.edges.each { TrackEdge trackEdge ->

                        trackEdge = TrackEdge.get(trackEdge.id)

                        carModel.route << trackEdge

                }

                fleetModel.cars << carModel

                }
            }


        return fleetModel
    }

    def getGroupStationsOfConfiguration( Long configurationId ) {

        Configuration configuration = Configuration.get( configurationId )

        def fillingStationGroups = []

        configuration.fillingStationGroups.each { FillingStationGroup fillingStationGroup ->

            def fillingStationModel = [:]

            fillingStationGroup = FillingStationGroup.get( fillingStationGroup.id )

            fillingStationModel.stations = []
            fillingStationModel.name = fillingStationGroup.name

            fillingStationGroup.fillingStations.each { FillingStation fillingStation ->

                fillingStation = FillingStation.get( fillingStation.id )

                def stationModel = [:]
                stationModel.name = fillingStation.name
                stationModel.id = fillingStation.id
                stationModel.power = fillingStation.fillingStationType.power
                stationModel.lat = fillingStation.lat
                stationModel.lon = fillingStation.lon
                stationModel.id = fillingStation.id
                //stationModel.stations = []

                fillingStationModel.stations << stationModel

            }

            fillingStationGroups << fillingStationModel

        }

        return fillingStationGroups
    }


    def getStationsForMaps( Long configurationId ) {

        Configuration configuration = Configuration.get( configurationId )

        Double fillingPortion = 0.000001;
        String fillingType
        switch ( fillingType ) {
            case GasolineStationType.AC_2_3KW.toString() :
                fillingPortion = 2.3 / (60*60);
                break;
            case GasolineStationType.AC_3_7KW.toString() :
                fillingPortion = 3.7 / (60*60);
                break;
            case GasolineStationType.AC_7_4KW.toString() :
                fillingPortion = 4.7 / (60*60);
                break;
            case GasolineStationType.AC_11_1KW.toString() :
                fillingPortion = 11.1 / (60*60);
                break;
            case GasolineStationType.AC_22_2KW.toString() :
                fillingPortion = 22.2 / (60*60);
                break;
            case GasolineStationType.AC_43KW.toString() :
                fillingPortion = 43 / (60*60);
                break;
            case GasolineStationType.DC_49_8KW.toString() :
                fillingPortion = 49.8 / (60*60);
                break;
            default:
                fillingPortion = 0.000638;
                break;
        }

        fillingPortion  = Math.round( fillingPortion  * 1000000 ) / 1000000

        def fillingStationGroups = []

        configuration.fillingStationGroups.each { FillingStationGroup fillingStationGroup ->

            def fillingStationModel = [:]

            fillingStationGroup = FillingStationGroup.get( fillingStationGroup.id )

            fillingStationModel.stations = []
            fillingStationModel.name = fillingStationGroup.name

            fillingStationGroup.fillingStations.each { FillingStation fillingStation ->

                fillingStation = FillingStation.get( fillingStation.id )


                def stationModel = [:]
                double x =0.0
                double y =0.0
                Coordinate nearestPoint = routeService.getNearestValidPoint(new Coordinate( x,  y));
                stationModel.name = fillingStation.name
                stationModel.id = fillingStation.id
                stationModel.power = fillingStation.fillingStationType.power
                stationModel.fillingPortion = fillingStation.fillingStationType.fillingPortion
                stationModel.lon = nearestPoint.x
                stationModel.lat = nearestPoint.y

                fillingStationModel.stations << stationModel

            }

            fillingStationGroups << fillingStationModel

        }

        return fillingStationGroups
    }
    /**
     * this method creates a group stub and persists it to db
     * this group belongs to a given person's company
     *
     * @param person
     * @param configurationStubId
     * @return
     */
    def createGroupStub( Person person, Long configurationStubId ) {

        Company company = Company.get( person.company.id )
        def stubedGroups = FillingStationGroup.findAllByStubAndCompany(true,company)
        stubedGroups.each {
            it.delete(flush: true)
        }
        Configuration stub = Configuration.get( configurationStubId )
        SimulationArea simulationArea = getSimulationArea(configurationStubId)

        String generatedFleetName = "Group No. ${FillingStationGroup.countByCompany( Company.get( person.company.id ) ) + 1}"


        FillingStationGroup groupStub = new FillingStationGroup(
                company: company,
                name: generatedFleetName,
                groupStatus: GroupStatus.NOT_CONFIGURED,
                distribution: Distribution.NOT_ASSIGNED,
                groupsConfigured: false,
                stub: true,
                simulationArea: simulationArea
        )

        if ( !groupStub.save( flush: true ) ) {
            log.error( "failed to save fleet stub: ${groupStub.errors}" )
            return null
        }

        return groupStub

    }

    /**
     * collect carTypes of the company and adds the default ones of dfki
     *
     * @param currentUser to fetch available carType of the company
     * @return list of available carTypes sbd. of company's persons created
     */
    def getCarTypesForCompany( Person currentUser ) {

        Company company = Company.get( currentUser.company.id )
        List<CarType> carTypes = CarType.findAllByCompany( company )

        if ( !company.name.equals( "dfki" ) ) {
            Company dfkiCompany = Company.findByName( "dfki" )

            carTypes.addAll( CarType.findAllByCompany( dfkiCompany ) )

        }

        return carTypes
    }

    def getAllSimulationsForCompany( Person currentUser ) {

        Company company = Company.get( currentUser.company.id )
        List<Simulation> simulationNames = Simulation.findAllByCompany( company )

        if ( !company.name.equals( "dfki" ) ) {
            Company dfkiCompany = Company.findByName( "dfki" )

            simulationNames.addAll( Simulation.findAllByCompany( dfkiCompany ) )

        }

        return simulationNames
    }

    /**
     * collect FillingStationtype of the company and adds the default ones of dfki
     *
     * @param currentUser to fetch available carType of the company
     * @return list of available carTypes sbd. of company's persons created
     */
    def getFillingStationTypesForCompany( Person currentUser ) {

        Company company = Company.get( currentUser.company.id )
        List<FillingStationType> fillingStationTypes = FillingStationType.findAllByCompany( company )

        if ( !company.name.equals( "dfki" ) ) {
            Company dfkiCompany = Company.findByName( "dfki" )

            fillingStationTypes.addAll( FillingStationType.findAllByCompany( dfkiCompany ) )

        }

        return fillingStationTypes
    }

    /**
     * collect electricStationType of the company and adds the default ones of dfki
     *
     * @param currentUser to fetch available electricStationType of the company
     * @return list of available electricStationType sbd. of company's persons created
     */
    def getElectricStationTypesForCompany( Person currentUser ) {

        Company company = Company.get( currentUser.company.id )
        List<FillingStationType> electricStationTypes = FillingStationType.findAllByCompany( company )

        if ( !company.name.equals( "dfki" ) ) {
            Company dfkiCompany = Company.findByName( "dfki" )

            electricStationTypes.addAll( FillingStationType.findAllByCompany( dfkiCompany ) )

        }

        return electricStationTypes
    }


    /**
     * update FillingStation
     * the company remains!
     *
     * @param person
     * @param fillingStationTypeId
     * @param fillingStationTypeName
     * @param power
     */
    def updateFillingStationTypeForCompany( Person person, Long fillingStationTypeId, String fillingStationTypeName, String power ) {

        // getting the company
        Company company = Company.get( person.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${person.username}" )
            return
        }

        FillingStationType fillingStationTypeToUpdate = FillingStationType .get( fillingStationTypeId )

        fillingStationTypeToUpdate.name = fillingStationTypeName
        fillingStationTypeToUpdate.power = power

        try {

            Float powerValue = Float.parseFloat( power )
            fillingStationTypeToUpdate.fillingPortion = ( 1 / 3600 ) * powerValue

            if ( !fillingStationTypeToUpdate.save( flush: true ) ) {
                log.error( "failed to update carType with : errors: ${fillingStationTypeToUpdate.errors}" )
            }

        } catch ( NumberFormatException nfe ) {
            log.error( "failed to convert string to float: ", nfe )
        }


        return fillingStationTypeToUpdate
    }

    /**
     * creates a new FillingStationtype
     *
     * @param currentUser to save carType for currentUser's company
     * @param carName
     * @param energyDemand
     * @param maxEnergyCapacity
     */
    def createFillingStationTypeForCompany( Person person, String fillingStationTypeName, Double power  ) {

        // getting the company
        Company company = Company.get( person.company.id )

        if ( !company ) {
            log.error( "no company found for user: ${person.username}" )
            return
        }

        FillingStationType fillingStationType = new FillingStationType(
                company:  company,
                name: fillingStationTypeName,
                power: power,
                fillingPortion: ( 1 / 3600 ) * power
        )

        if ( !fillingStationType.validate() && fillingStationType.hasErrors() ) {
            log.error( "failed to vaildate new fillingStationType: ${fillingStationType.errors}" )
            return
        }

        if ( !fillingStationType.save( flush: true ) ) {
            log.error( "failed to save new fillingStationType: ${fillingStationType.errors}" )
            return
        }


        return fillingStationType
    }




    def removeConfigurationStub( Long configurationStubId ) {

        Configuration configurationToRemove = Configuration.get( configurationStubId )

        configurationToRemove.delete( flush: true )

        if ( Configuration.get( configurationStubId ) == null ) {

            log.error( "configuration stub with id ${configurationStubId} is removed again" )

        } else {

            log.error( "something wrent deeply wrong during removing of configuration stub" )

        }

    }

    def saveFinishedConfigurationStub( Long configurationStubId ) {

        Configuration configurationStubToSave = Configuration.get( configurationStubId )
        configurationStubToSave.stub = false
        SimulationArea simulationArea = configurationStubToSave.simulationArea

        // creating routes for distribution, set all FleetStatus
        configurationStubToSave.fleets.each { Fleet fleet ->

            fleet = Fleet.get( fleet.id )

            fleet = routeService.createRandomDistanceRoutesForFleet( fleet.id,simulationArea)

        }

        configurationStubToSave.fillingStationGroups.each { FillingStationGroup group ->

            group = FillingStationGroup.get( group.id )

            if ( group.groupStatus == GroupStatus.SCHEDULED_FOR_CONFIGURING || group.simulationArea != simulationArea) {
                group = routeService.createRandomPositionsForFillingStations( group.id, simulationArea )
                group.simulationArea = simulationArea
            }

        }



        if ( !configurationStubToSave.save( flush: true ) ) {
            log.error( "failed to save configuration: ${configurationStubToSave.errors}" )
        } else {

            log.error( "configuration with id ${configurationStubId} is now unStubbed!" )

        }


    }


    def saveFinishedConfigurationStubFleet ( Long configurationStubId ) {

        Configuration configurationStubToSave = Configuration.get( configurationStubId )
        configurationStubToSave.stub = false
        SimulationArea simulationArea = configurationStubToSave.simulationArea

        // creating routes for distribution, set all FleetStatus
        configurationStubToSave.fleets.each { Fleet fleet ->

            fleet = Fleet.get( fleet.id )

            fleet = routeService.createRandomDistanceRoutesForFleet( fleet.id,simulationArea)

        }

        if ( !configurationStubToSave.save( flush: true ) ) {
            log.error( "failed to save configuration: ${configurationStubToSave.errors}" )
        } else {

            log.error( "configuration with id ${configurationStubId} is now unStubbed!" )

        }
    }



    /**
     *
     * @param configurationId
     * @return List of experimentRunResults with duration grater than 0
     */
    def getRecentlyEditedExperimentResultsOfConfiguration( Long configurationId ) {


        List<ExperimentRunResult> experimentRunResultList = ExperimentRunResult.findAllByConfigurationIdAndSimTimeMillisGreaterThan( configurationId,0 )

        return experimentRunResultList
    }
    def getRecentlyEditedConfigurationsOfCompany( Person person ) {

        Company company = Company.get( person.company.id )

        List<Configuration> configurations = Configuration.findAllByCompany( company )

        return configurations
    }

    def getCarsFromFleetTypeOrdered( Long fleetId ) {

        def cars = []
        Fleet fleet = Fleet.get( fleetId )

        fleet.cars.each { Car car ->
            cars << Car.get( car.id )
        }

        def types = cars.groupBy { Car car -> car.carType }

        return types
    }

    def getFillingStationsFromGroupTypeOrdered (Long groupId) {

        def stations = []
        FillingStationGroup fillingStationGroup = FillingStationGroup.get( groupId )

        fillingStationGroup.fillingStations.each { FillingStation fillingStation ->
            stations << FillingStation.get( fillingStation.id )
        }

        def types = stations.groupBy { FillingStation fillingStation -> fillingStation.fillingStationType.name }

        return types
    }

    def getCarsFromFleet( Long fleetId ) {

        def cars = []

        Fleet fleet = Fleet.get( fleetId )

        fleet.cars.each { Car car ->
            cars << Car.get( car.id )
        }

        return cars
    }


    def setDistributionForGroup( Distribution distribution, Long groupId ) {

        FillingStationGroup group = FillingStationGroup.get( groupId )

        group.distribution = distribution
        group.groupsConfigured = false


        group.groupStatus = GroupStatus.SCHEDULED_FOR_CONFIGURING

        if ( !group.save( flush: true ) ) {

            log.error( "failed to save fleet: ${group.errors}" )

        }


    }

    def setDistributionForFleet( Distribution distribution, Long fleetId, Integer fromKm, Integer toKm ) {

        Fleet fleet = Fleet.get( fleetId )

        fleet.distribution = distribution
        fleet.routesConfigured = false

        fleet.plannedFromKm = fromKm
        fleet.plannedToKm = toKm

        fleet.fleetStatus = FleetStatus.SCHEDULED_FOR_CONFIGURING

        if ( !fleet.save( flush: true ) ) {

            log.error( "failed to save fleet: ${fleet.errors}" )

        }


    }

    def updateNameOfFleet( String nameForFleet, Long fleetStubId ) {

        Fleet fleet = Fleet.get( fleetStubId )
        fleet.name = nameForFleet

        if ( !fleet.save( flush: true ) ) {

            log.error( "failed to update fleetName for fleet: ${fleet.errors}" )

        }



    }

    def unstubFleet(Long fleetStubId){
        Fleet fleet = Fleet.get( fleetStubId )
        if(!fleet.cars.empty){
            fleet.stub = false
            if ( !fleet.save( flush: true ) ) {

                log.error( "failed to unstub fleet: ${fleet.errors}" )

            }
        }
    }

    def unstubGroup(Long groupStubId){
        FillingStationGroup group = FillingStationGroup.get(groupStubId)
        if(!group.fillingStations.empty){
            group.stub = false
            if ( !group.save( flush: true ) ) {

                log.error( "failed to unstub group: ${group.errors}" )

            }
        }
    }
    def getNameOfFleet( Long fleetId ) {
        Fleet fleet = Fleet.get( fleetId )
        return fleet.name
    }

    def getFleetSize (Long fleetId) {
        Fleet fleet = Fleet.get( fleetId )
        int fleetSize
        fleetSize = fleet.cars.size()
        return fleetSize
    }

    def getSimulationTime (Long fleetId) {
        Fleet fleet = Fleet.get( fleetId )
        String simulationTime
        simulationTime =fleet.dateCreated.hours + ':'+ fleet.dateCreated.minutes
        return simulationTime
    }

    def getCarId (Long fleetId) {
        Fleet fleet = Fleet.get( fleetId )
        List carList = fleet.cars
        return carList
    }

    def getNumberOfGroup (Long groupId) {
        FillingStationGroup fillingStationGroup = FillingStationGroup.get(groupId)
        return fillingStationGroup.fillingStations
    }

    def getNameOfGroup (Long groupId) {

        FillingStationGroup fillingStationGroup = FillingStationGroup.get(groupId)
        return fillingStationGroup.name
    }

    def getInfoOfFillingStation (Long fillingStationId) {

        FillingStationType fillingStationType = FillingStationType.get(fillingStationId)
        //return fillingStationType.name

    }

    def getfillingStationParameters (Long groupId) {
        FillingStationGroup fillingStationGroup = FillingStationGroup.get(groupId)

        return fillingStationGroup
    }

    def getBatteryStatus(Long fleetId ) {
        Fleet fleet = Fleet.get( fleetId )
        def cars = []
        fleet.cars.each { Car car ->
            car.batteryPersent = 100
            cars << Car.get( car.id )
        }

        return cars


    }


}
