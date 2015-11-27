package de.dfki.gs.ms2.stats

import com.vividsolutions.jts.geom.Coordinate
import de.dfki.gs.domain.simulation.Car
import de.dfki.gs.domain.simulation.CarType
import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.FillingStation
import de.dfki.gs.domain.simulation.FillingStationGroup
import de.dfki.gs.domain.simulation.FillingStationType
import de.dfki.gs.domain.simulation.Fleet
import de.dfki.gs.domain.simulation.Route
import de.dfki.gs.domain.simulation.TrackEdge
import de.dfki.gs.domain.stats.ExperimentRunResult
import de.dfki.gs.domain.stats.PersistedCarAgentResult
import de.dfki.gs.domain.stats.PersistedFillingStationResult
import de.dfki.gs.domain.utils.Distribution
import de.dfki.gs.domain.utils.SimulationArea
import de.dfki.gs.domain.utils.TrackEdgeType
import de.dfki.gs.simulation.CarStatus
import de.dfki.gs.stats.StatsCalculator
import de.dfki.gs.utils.TimeCalculator
import grails.converters.JSON
import grails.transaction.Transactional
import org.apache.commons.math3.distribution.MultivariateNormalDistribution
import org.apache.commons.math3.distribution.NormalDistribution
import org.apache.commons.math3.random.RandomDataGenerator

import java.awt.Color

@Transactional
class StatisticService {

    def getSimulationAreaForMap(Long experimentRunResultId){
        ExperimentRunResult result = ExperimentRunResult.get( experimentRunResultId )
        Configuration configuration = Configuration.get(result.configurationId)
        SimulationArea simulationArea = configuration.simulationArea
        return simulationArea
    }
    def getStationsForMap( Long experimentRunResultId, List<String> successCategoriesToShow ) {

        ExperimentRunResult result = ExperimentRunResult.get( experimentRunResultId )

        List<PersistedFillingStationResult> fillingStations = result.persistedFillingStationResults
        fillingStations.each { PersistedFillingStationResult fillingStationResult ->
            fillingStationResult = PersistedFillingStationResult.get( fillingStationResult.id )
        }

        def groupFillingsMap = [ : ]
        fillingStations.each { PersistedFillingStationResult pfil ->

            List<PersistedFillingStationResult> groupList = (List<PersistedFillingStationResult>) groupFillingsMap.get( pfil.groupId )

            if ( groupList == null ) {

                groupList = new ArrayList<PersistedFillingStationResult>()
                groupFillingsMap.put( pfil.groupId, groupList )

            }

            groupList.add( pfil )

        }


        def fillingStationGroups = []

        groupFillingsMap.keySet().each { Long key ->

            def fillingStationModel = [:]

            FillingStationGroup fillingStationGroup = FillingStationGroup.get( key )

            fillingStationModel.stations = []
            fillingStationModel.name = fillingStationGroup.name

            groupFillingsMap.get( key ).each { PersistedFillingStationResult fillingStation ->

                def stationModel = [:]
                stationModel.name = "station"
                stationModel.power = fillingStation.fillingStationType.power
                stationModel.id = fillingStation.id
                stationModel.time = fillingStation.timeInUse
                stationModel.lat = fillingStation.lat
                stationModel.lon = fillingStation.lon
                stationModel.owner = fillingStation.ownerName
                stationModel.powerCar  =fillingStation.fillingStationType.fillingPortion

                if ( successCategoriesToShow.contains( "all" ) ) {

                    fillingStationModel.stations << stationModel

                } else if ( successCategoriesToShow.contains( "successful" ) && fillingStation.failedToRouteCount == 0 ) {

                    fillingStationModel.stations << stationModel

                } else if ( successCategoriesToShow.contains( "failed" ) && fillingStation.failedToRouteCount > 0 ) {

                    fillingStationModel.stations << stationModel

                }



            }

            fillingStationGroups << fillingStationModel
        }

        return fillingStationGroups
    }
    def getStationsResults( Long experimentRunResultId) {

        ExperimentRunResult result = ExperimentRunResult.get( experimentRunResultId )

        List<PersistedFillingStationResult> fillingStations = result.persistedFillingStationResults
        def featuresUsed = []
        def featuresUnused = []
        fillingStations.each { PersistedFillingStationResult fillingStationResult ->
            if(PersistedFillingStationResult.get(fillingStationResult.id).timeInUse != 0){
                featuresUsed.add(getStationResultJson(fillingStationResult.id))
            }
            else{
                featuresUnused.add(getStationResultJson(fillingStationResult.id))
            }
        }
        def usedStations = ["type":"FeatureCollection","features":featuresUsed] as JSON
        def unusedStations = ["type":"FeatureCollection","features":featuresUnused] as JSON
        return ["usedStations":usedStations,"unusedStations":unusedStations]
    }
    def getStationResultJson ( Long persistedFillingStationResulId){
        PersistedFillingStationResult persistedFillingStationResult = PersistedFillingStationResult.get(persistedFillingStationResulId)

        //TODO Write a method to create GeoJSON and put it somewhere where it makes sense

        if(persistedFillingStationResult.timeInUse == 0){
            return ["type":"Feature",
                          "geometry":["type":"Point","coordinates":[persistedFillingStationResult.lat,persistedFillingStationResult.lon]],//TODO Lat and Lon are wrong in persistedFillingStationResults
                          "properties":["used":"false"]
            ]
        }

        else{
            return["type":"Feature",
                          "geometry":["type":"Point","coordinates":[persistedFillingStationResult.lat,persistedFillingStationResult.lon]],//TODO Lat and Lon are wrong in persistedFillingStationResults
                          "properties":["used":"true"]
            ]
        }
    }

    def getFleetsForMap(Long experimentRunResultId){
        ExperimentRunResult result = ExperimentRunResult.get(experimentRunResultId)
        Configuration configuration = Configuration.get(result.configurationId)
        def fleets = []
        configuration.fleets.each {
            fleets.add(getFleetRoute(it.id))

        }
        return fleets

    }



    def getRealRoutesForAllFleets(Long experimentRunResultId){ //TODO Schould return a Map with carId and real route
        ExperimentRunResult result = ExperimentRunResult.get(experimentRunResultId)
        /*def allRealFleetRoutes = [:]
        result.persistedCarAgentResults.each {
            allRealFleetRoutes.put(it.id,getTrackEdges(it.id))
        }*/
        def allRealFleetRoutes = []
        result.persistedCarAgentResults.each {
            allRealFleetRoutes.add(getTrackEdges(it.id))
        }
        return allRealFleetRoutes


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
                carModel.id   = car.id
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

    def getFleetInfo( Long fleetID ) {

        Fleet fleet = Fleet.get(fleetID)
        def fleetModel = [:]
        fleet = Fleet.get( fleet.id )
        fleetModel.cars = fleet.cars.battery

        if (fleetModel.routesConfigured == true) {
            fleet.cars.each { Car car ->
                car = Car.get(car.id)

                def carModel = [:]
                carModel.name = car.name
                carModel.battery = car.battery
                carModel.carStartTime = car.carStartTime
                fleetModel.cars << carModel
            }
        }
        return fleetModel.cars
    }

    def getTrackEdges( Long persistedCarAgentResulId){
        PersistedCarAgentResult persistedCarAgentResult = PersistedCarAgentResult.get(persistedCarAgentResulId)

        TrackEdge startEdge = TrackEdge.get(persistedCarAgentResult.trackEdges.first().id)


        def viaTargets = []
        def coordinatesOfRoute = []
        def coordinatesOfRouteFailedToDrive =[]
        def lineString = []
        def lineStringFailedToDrive = []
        def routeToEnergy = []
        def routeToEnergyFailedToDrive = []
        def allRoutesToEnergy = []
        def allRoutesToEnergyFailedToDrive = []
        def previousCoordinates
        def drivenTrack = persistedCarAgentResult.trackEdges.subList(0,persistedCarAgentResult.lastPositionIndex-1)
        def failedToDrive=persistedCarAgentResult.trackEdges.subList(persistedCarAgentResult.lastPositionIndex-1,persistedCarAgentResult.trackEdges.size()-1)
        def finalPosition = drivenTrack.last()

        drivenTrack.each{TrackEdge trackEdge ->
            //If there are breaks in the route or some part goes to the filling station then we have multible line strings
            trackEdge = TrackEdge.get(trackEdge.id)
            if(trackEdge.type == TrackEdgeType.to_filling_station.toString()){
                //Add The coordinates of the normal route to the multilineString the first time we change to route to energy
                if(lineString.size()>0){
                    coordinatesOfRoute.add(lineString)
                    lineString = []
                    previousCoordinates = null
                }

                def coordinates = [trackEdge.fromLon,trackEdge.fromLat]
                if(previousCoordinates == null || previousCoordinates == coordinates){
                    routeToEnergy.add(coordinates)
                }
                else
                {
                    //TODO make visible that route is broken here
                    allRoutesToEnergy.add(routeToEnergy)
                    routeToEnergy = []
                    previousCoordinates = null
                    log.error("route Broken From $previousCoordinates To $coordinates")
                }
                previousCoordinates = [trackEdge.toLon,trackEdge.toLat]
            }
            else{//Normal Route
                if(routeToEnergy.size()>0){
                    allRoutesToEnergy.add(routeToEnergy)
                    routeToEnergy = []
                    previousCoordinates = null
                }
                if(trackEdge.type=='via_target'){
                    viaTargets.add(trackEdge)
                }
                def coordinates = [trackEdge.fromLon,trackEdge.fromLat]
                if(previousCoordinates == null || previousCoordinates == coordinates){
                    lineString.add(coordinates)
                }
                else
                {
                    //TODO make visible that route is broken here
                    coordinatesOfRoute.add(lineString)
                    lineString = []
                    previousCoordinates = null
                    log.error("route Broken From $previousCoordinates To $coordinates")
                }
                previousCoordinates = [trackEdge.toLon,trackEdge.toLat]
            }

        }
        if(finalPosition.type == TrackEdgeType.to_filling_station.toString()){
            routeToEnergy.add([finalPosition.toLon,finalPosition.toLat])
            allRoutesToEnergy.add(routeToEnergy)
        }
        else{
            lineString.add([finalPosition.toLon,finalPosition.toLat])
            coordinatesOfRoute.add(lineString)
        }

        previousCoordinates = null
        failedToDrive.each{TrackEdge trackEdge ->
            //If there are breaks in the route or some part goes to the filling station then we have multible line strings
            trackEdge = TrackEdge.get(trackEdge.id)
            if(trackEdge.type == TrackEdgeType.to_filling_station.toString()){
                //Add The coordinates of the normal route to the multilineString the first time we change to route to energy
                if(lineStringFailedToDrive.size()>0){
                    coordinatesOfRouteFailedToDrive.add(lineStringFailedToDrive)
                    lineStringFailedToDrive = []
                    previousCoordinates = null
                }

                def coordinates = [trackEdge.fromLon,trackEdge.fromLat]
                if(previousCoordinates == null || previousCoordinates == coordinates){
                    routeToEnergyFailedToDrive.add(coordinates)
                }
                else
                {
                    //TODO make visible that route is broken here
                    allRoutesToEnergyFailedToDrive.add(routeToEnergyFailedToDrive)
                    routeToEnergyFailedToDrive = []
                    previousCoordinates = null
                    log.error("route Broken From $previousCoordinates To $coordinates")
                }
                previousCoordinates = [trackEdge.toLon,trackEdge.toLat]
            }

            else{//Normal Route
                if(routeToEnergyFailedToDrive.size()>0){
                    allRoutesToEnergyFailedToDrive.add(routeToEnergyFailedToDrive)
                    routeToEnergyFailedToDrive = []
                    previousCoordinates = null
                }
                if(trackEdge.type=='via_target'){
                    viaTargets.add(trackEdge)
                }
                def coordinates = [trackEdge.fromLon,trackEdge.fromLat]
                if(previousCoordinates == null || previousCoordinates == coordinates){
                    lineStringFailedToDrive.add(coordinates)
                }
                else
                {
                    //TODO make visible that route is broken here
                    coordinatesOfRouteFailedToDrive.add(lineStringFailedToDrive)
                    lineStringFailedToDrive = []
                    previousCoordinates = null
                    log.error("route Broken From $previousCoordinates To $coordinates")
                }
                previousCoordinates = [trackEdge.toLon,trackEdge.toLat]
            }

        }
        coordinatesOfRouteFailedToDrive.add(lineStringFailedToDrive)
        Random random = new Random();
        final float hue = random.nextFloat();
        final float saturation = 0.7f;//1.0 for brilliant, 0.0 for dull
        final float luminance = 0.9f; //1.0 for brighter, 0.0 for black
        def randomColorHsb = Color.getHSBColor(hue, saturation, luminance);
        def red = randomColorHsb.getRed()
        def green = randomColorHsb.getGreen()
        def blue = randomColorHsb.getBlue()
        def randomColor = "#${Integer.toHexString(red)}${Integer.toHexString(green)}${Integer.toHexString(blue)}";

        //Creating a GeoJSON for start,target,and via_target
        def features = [] //TODO Write a method to create GeoJSON and put it somewhere where it makes sense
//TODO the last edge should not go back, continue planned route...
        features.add(["type":"Feature","geometry":["type":"MultiLineString","coordinates":coordinatesOfRoute],"properties":["geoType":"route","color":randomColor,
                                                                                                                       "carStatus":persistedCarAgentResult.carStatus,
                                                                                                                       "carType":CarType.get(persistedCarAgentResult.carType.id).name,
                                                                                                                       "consumedEnergy":"${persistedCarAgentResult.energyConsumed}",
                                                                                                                       "loadedEnergy":"${persistedCarAgentResult.energyLoaded}",
                                                                                                                       "plannedDistance":"${persistedCarAgentResult.plannedDistance}",
                                                                                                                       "realDistance":"${persistedCarAgentResult.realDistance}",
                                                                                                                       "plannedTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForPlannedDistance)}",
                                                                                                                       "realTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForRealDistance)}",
                                                                                                                       "fillingStationsVisited":persistedCarAgentResult.fillingStationsVisited,
                                                                                                                       "carStartTime":"${persistedCarAgentResult.carStartTime.format('HH:mm / dd MMMM yyyy')}",
                                                                                                                       "endCarTime":"${persistedCarAgentResult.endCarTime.format('HH:mm / dd MMMM yyyy')}",
                                                                                                                       "battery":"${persistedCarAgentResult.battery}",
                                                                                                                       "endBattery":"${Math.round(persistedCarAgentResult.endBattery*100)}"

        ]])

        features.add(["type":"Feature","geometry":["type":"MultiLineString","coordinates":coordinatesOfRouteFailedToDrive],"properties":["geoType":"route_failed","color":randomColor,
                                                                                                                            "carStatus":persistedCarAgentResult.carStatus,
                                                                                                                            "carType":CarType.get(persistedCarAgentResult.carType.id).name,
                                                                                                                            "consumedEnergy":"${persistedCarAgentResult.energyConsumed}",
                                                                                                                            "loadedEnergy":"${persistedCarAgentResult.energyLoaded}",
                                                                                                                            "plannedDistance":"${persistedCarAgentResult.plannedDistance}",
                                                                                                                            "realDistance":"${persistedCarAgentResult.realDistance}",
                                                                                                                            "plannedTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForPlannedDistance)}",
                                                                                                                            "realTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForRealDistance)}",
                                                                                                                            "fillingStationsVisited":persistedCarAgentResult.fillingStationsVisited
        ]])

        features.add(["type":"Feature","geometry":["type":"MultiLineString","coordinates":allRoutesToEnergy],"properties":["geoType":"to_filling_station","color":randomColor,
                                                                                                                            "carStatus":persistedCarAgentResult.carStatus,
                                                                                                                            "carType":CarType.get(persistedCarAgentResult.carType.id).name,
                                                                                                                            "consumedEnergy":"${persistedCarAgentResult.energyConsumed}",
                                                                                                                            "loadedEnergy":"${persistedCarAgentResult.energyLoaded}",
                                                                                                                            "plannedDistance":"${persistedCarAgentResult.plannedDistance}",
                                                                                                                            "realDistance":"${persistedCarAgentResult.realDistance}",
                                                                                                                            "plannedTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForPlannedDistance)}",
                                                                                                                            "realTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForRealDistance)}",
                                                                                                                            "fillingStationsVisited":persistedCarAgentResult.fillingStationsVisited,
                                                                                                                            "carStartTime":"${persistedCarAgentResult.carStartTime.format('HH:mm/dd MMMM yyyy')}",
                                                                                                                            "endCarTime":"${persistedCarAgentResult.endCarTime.format('HH:mm/dd MMMM yyyy')}",
                                                                                                                            "battery":"${persistedCarAgentResult.battery}",
                                                                                                                            "endBattery":"${Math.round(persistedCarAgentResult.endBattery*100)}"
        ]])
        features.add(["type":"Feature","geometry":["type":"MultiLineString","coordinates":allRoutesToEnergyFailedToDrive],"properties":["geoType":"to_filling_station_failed","color":randomColor,
                                                                                                                           "carStatus":persistedCarAgentResult.carStatus,
                                                                                                                           "carType":CarType.get(persistedCarAgentResult.carType.id).name,
                                                                                                                           "consumedEnergy":"${persistedCarAgentResult.energyConsumed}",
                                                                                                                           "loadedEnergy":"${persistedCarAgentResult.energyLoaded}",
                                                                                                                           "plannedDistance":"${persistedCarAgentResult.plannedDistance}",
                                                                                                                           "realDistance":"${persistedCarAgentResult.realDistance}",
                                                                                                                           "plannedTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForPlannedDistance)}",
                                                                                                                           "realTime":"${TimeCalculator.readableTime(persistedCarAgentResult.timeForRealDistance)}",
                                                                                                                           "fillingStationsVisited":persistedCarAgentResult.fillingStationsVisited
        ]])
        //adding start
        features.add(["type":"Feature","geometry":["type":"Point","coordinates":[startEdge.fromLon,startEdge.fromLat]],"properties":["geoType":"start","color":randomColor,"streetName":startEdge.streetName]])

        //adding finalPosition
        features.add(["type":"Feature","geometry":["type":"Point","coordinates":[finalPosition.toLon,finalPosition.toLat]],"properties":["geoType":"finalPosition","color":randomColor,"streetName":finalPosition.streetName]])

        //adding all viatargets
        int viaCounter=1 //To know the order of the via_targets
        viaTargets.each {TrackEdge viaTarget ->
            features.add(["type":"Feature","geometry":["type":"Point","coordinates":[viaTarget.fromLon,viaTarget.fromLat]],"properties":["geoType":"via_target","color":randomColor,"streetName":viaTarget.streetName,"viaCounter":"$viaCounter"]])
            viaCounter++
        }

        def startViaTargetPoints = ["type":"FeatureCollection","features":features] as JSON
        return  startViaTargetPoints


        /*       ["Coordinates":[startEdge.fromLon,startEdge.fromLat],"StreetName":startEdge.streetName]
       trackEdgesModel.finalPosition = ["Coordinates":[finalPosition.toLon,finalPosition.toLat],"StreetName":finalPosition.streetName]
       trackEdgesModel.via_target = viaTargets

       def geometry = ["type":"LineString","coordinates":[[14.38,52.52],[12.37,52.52],[13.37,52.53]]]
       def properties = ["name":"route1"]
       def features = ["type":"Feature","geometry":geometry,"properties":properties]
       def route1MapJSON = ["type":"FeatureCollection","features":[features]] as JSON
*/
    }
    def generateStatisticMapForExperiment( Long experimentResultId ) {//TODO rewrite this!!!

        def m = [ : ]

        ExperimentRunResult result = ExperimentRunResult.get( experimentResultId )
        Configuration configuration = Configuration.get( result.configurationId )

        if ( result == null ) {
            m.errors = "no experiment result data found for id: ${experimentResultId}"
            return m
        }

        // fill carAgentResults with full qualified objects
        List<PersistedCarAgentResult> carAgents = result.persistedCarAgentResults
        carAgents.each { PersistedCarAgentResult carAgentResult ->
            carAgentResult = PersistedCarAgentResult.get( carAgentResult.id )
        }

        // fill fillingStationResults with full qualified objects
        List<PersistedFillingStationResult> fillingStations = result.persistedFillingStationResults
        fillingStations.each { PersistedFillingStationResult fillingStationResult ->
            fillingStationResult = PersistedFillingStationResult.get( fillingStationResult.id )
        }


        def cars = [ : ]

        def successFullCars = []
        def failedCars = []
        for ( PersistedCarAgentResult carAgent : carAgents ) {

            // each car
            if ( carAgent.carStatus.equals( CarStatus.MISSION_ACCOMBLISHED.toString() ) ) {
                successFullCars << carAgent
            }
            if ( carAgent.carStatus.equals( CarStatus.WAITING_EMPTY.toString() ) ) {
                failedCars << carAgent
            }


        }
        cars.'success' = successFullCars
        cars.'failed'  = failedCars

        m.'cars' = cars


        def fleets = []
        def groups = []

        // split up carAgents results in a map fleet id -> list of cars
        def fleetCarsMap = [ : ]
        carAgents.each { PersistedCarAgentResult pcar ->

            List<PersistedCarAgentResult> fleetList = (List<PersistedCarAgentResult>) fleetCarsMap.get( pcar.fleetId )

            if ( fleetList == null ) {

                fleetList = new ArrayList<PersistedCarAgentResult>()
                fleetCarsMap.put( pcar.fleetId, fleetList )

            }

            fleetList.add( pcar )

        }

        // split up fillingAgents results in a map group id -> list of filling stations
        def groupFillingsMap = [ : ]
        fillingStations.each { PersistedFillingStationResult pfil ->

            List<PersistedFillingStationResult> groupList = (List<PersistedFillingStationResult>) groupFillingsMap.get( pfil.groupId )

            if ( groupList == null ) {

                groupList = new ArrayList<PersistedFillingStationResult>()
                groupFillingsMap.put( pfil.groupId, groupList )

            }

            groupList.add( pfil )

        }


        for ( FillingStationGroup group : configuration.fillingStationGroups ) {

            group = FillingStationGroup.get( group.id )

            def groupMap = [ : ]
            groupMap.id = group.id
            groupMap.name = group.name

            def stats = calculateStatsForGroupOfFillingStations( groupFillingsMap.get( group.id ) )
            def stationTypes = calculateStatForStationTypes( groupFillingsMap.get( group.id ) )

            groupMap.stationTypes = stationTypes
            groupMap.stats = stats

            groups << groupMap

        }

        def groupMap = [ : ]
        groupMap.id = 0
        groupMap.name = "All Filling Stations of Experiment"

        def stationTypes = calculateStatForStationTypes( fillingStations )

        groupMap.stationTypes =  stationTypes

        groups << groupMap



        for ( Fleet fleet : configuration.fleets ) {
            fleet = Fleet.get( fleet.id )

            def fleetMap = fleet.dto()
            fleetMap.carResults = fleetCarsMap.get( fleet.id )

            // stats per fleet
            def stats = calculateStatsForGroupOfCars( fleetCarsMap.get( fleet.id ) )


            def carTypes = calculateStatsForCarTypes( fleetCarsMap.get( fleet.id ) )


            fleetMap.carTypes = carTypes

            fleetMap.stats = stats

            fleets << fleetMap

        }

        // all fleets together
        def fleetMap = [ : ]

        fleetMap.id            = 0
        fleetMap.name          = "All cars of Experiment"
        fleetMap.carsCount     = cars.size()
        fleetMap.distribution  = "Mixed Distribution"

        fleetMap.carResults = carAgents

        fleetMap.plannedFromKm = 0
        fleetMap.plannedToKm   = 0

        def carTypes = calculateStatsForCarTypes( carAgents )
        fleetMap.carTypes = carTypes

        fleets << fleetMap

        m.simulationName = configuration.simulationName
        m.fleets = fleets
        m.groups = groups
        m.successFullCars = successFullCars
        m.failedCars = failedCars
        m.fillingStations = fillingStations
        m.carsNumbers = fleets.get(fleets.size()-1).carResults
        m.stationsInUse = stationTypes.get(stationTypes.size()-1).stats.succeededStations.timeInUse.sum
        def usedStationsAll = []
        usedStationsAll = stationTypes.get(stationTypes.size()-1).stats.succeededStations.timeInUse.valuez
        def visitedStations =[]
        visitedStations = usedStationsAll.findAll({it > "0"})
        m.usedStations = visitedStations.size()
        m.stationTypes = stationTypes.get(0).name

        m.powerStation = fillingStations.fillingStationType.fillingPortion
        m.wholeRoute = fleets.get(fleets.size()-1).carTypes.get(carTypes.size()-1).stats.succeededCars.realDistance.valuez
        m.wholePower = fleets.get(fleets.size()-1).carTypes.get(carTypes.size()-1).stats.succeededCars.energyDemanded.valuez
        m.configurationArea = configuration.simulationArea



        return m
    }


    def detailsStatsForGroupOfStations( List<PersistedFillingStationResult> stationResults ) {

        def details = [ : ]

        def timeInUse = [ : ]
        def timeLiving = [ : ]
        def failedToRoute = [ : ]

        timeInUse.mean = StatsCalculator.meanTimeInUse( stationResults*.timeInUse )
        timeInUse.sum = stationResults.sum { it.timeInUse }
        timeInUse.valuez = stationResults*.timeInUse
        details.timeInUse = timeInUse

        timeLiving.mean = StatsCalculator.meanTimeLiving( stationResults*.timeLiving )
        timeLiving.valuez = stationResults*.timeLiving
        details.timeLiving = timeLiving

        failedToRoute.mean = StatsCalculator.meanFailedToRoute( stationResults*.failedToRouteCount )
        failedToRoute.valuez = stationResults*.failedToRouteCount
        details.failedToRoute = failedToRoute

        return details
    }

    def detailsStatsForGroupOfCars( List<PersistedCarAgentResult> persistedCarAgentResults ) {

        def details = [ : ]

        def plannedTime = [ : ]
        def plannedDistance = [ : ]
        def realDistance = [ : ]
        def realTime = [ : ]
        def loadingTime = [ : ]
        def energyLoaded = [ : ]
        def energyDemanded = [ : ]
        def realDrivingTime = [ : ]
        def endBattery = [ : ]

        plannedTime.mean        = StatsCalculator.meanPlannedTime( persistedCarAgentResults*.timeForPlannedDistance )
        plannedTime.valuez      = persistedCarAgentResults*.timeForPlannedDistance
        details.plannedTime     = plannedTime

        plannedDistance.mean    = StatsCalculator.meanPlannedDistance( persistedCarAgentResults*.plannedDistance )
        plannedDistance.valuez  = persistedCarAgentResults*.plannedDistance
        details.plannedDistance = plannedDistance

        realDistance.mean       = StatsCalculator.meanRealDistance( persistedCarAgentResults*.realDistance )
        realDistance.valuez     = persistedCarAgentResults*.realDistance
        details.realDistance    = realDistance

        realTime.mean           = StatsCalculator.meanRealTime( persistedCarAgentResults*.timeForRealDistance )
        realTime.valuez         = persistedCarAgentResults*.timeForRealDistance
        details.realTime        = realTime

        loadingTime.mean        = StatsCalculator.meanRealLoadingTime( persistedCarAgentResults*.timeForLoading )
        loadingTime.valuez      = persistedCarAgentResults*.timeForLoading
        details.loadingTime     = loadingTime

        energyLoaded.mean       = StatsCalculator.meanEnergyLoaded( persistedCarAgentResults*.energyLoaded )
        energyLoaded.valuez     = persistedCarAgentResults*.energyLoaded
        details.energyLoaded    = energyLoaded

        endBattery.mean       = StatsCalculator.meanEndBattery( persistedCarAgentResults*.endBattery )
        endBattery.valuez     = persistedCarAgentResults*.endBattery
        details.endBattery    = endBattery

        energyDemanded.mean     = StatsCalculator.meanEnergyDemanded( persistedCarAgentResults*.energyConsumed )
        energyDemanded.valuez   = persistedCarAgentResults*.energyConsumed
        details.energyDemanded  = energyDemanded

        List<Float> drivingTimes = new ArrayList<Float>()
        for ( PersistedCarAgentResult result : persistedCarAgentResults ) {

            drivingTimes.add( ( result.timeForRealDistance - result.timeForLoading ) )

        }

        realDrivingTime.mean    = StatsCalculator.meanRealDrivingTime( drivingTimes )
        realDrivingTime.valuez  = drivingTimes
        details.realDrivingTime = realDrivingTime

        return details
    }

    def calculateStatForStationTypes( List<PersistedFillingStationResult> fillingStationResults ) {

        def stationTypeList = []
        def stationTypeIds = fillingStationResults.collect { it.fillingStationType.id }.unique()
        for ( Long stationTypeId : stationTypeIds ) {

            def stationTypeMap = [ : ]
            FillingStationType type = FillingStationType.get( stationTypeId )
            stationTypeMap.name = type.name

            stationTypeMap.stats = calculateStatsForGroupOfFillingStations( fillingStationResults.findAll { it.fillingStationType.id == type.id } )
            stationTypeMap.time = type.beforeUpdate()

            stationTypeList << stationTypeMap
        }

        def stationTypeMap = [ : ]
        stationTypeMap.name = "All Stations"

        stationTypeMap.stats = calculateStatsForGroupOfFillingStations( fillingStationResults )

        stationTypeList << stationTypeMap

        return stationTypeList
    }

    def calculateStatsForCarTypes( List<PersistedCarAgentResult> carResults ) {

        def carTypeList = []
        def carTypeIds = carResults.collect { it.carType.id }.unique()
        for ( Long carTypeId : carTypeIds ) {

            def carTypeMap = [ : ]
            CarType carType = CarType.get( carTypeId )
            carTypeMap.name = carType.name

            carTypeMap.countSuccessful = carResults.count { it.carType.id == carType.id && it.carStatus.equals( CarStatus.MISSION_ACCOMBLISHED.toString() ) }
            carTypeMap.countFails = carResults.count { it.carType.id == carType.id && it.carStatus.equals( CarStatus.WAITING_EMPTY.toString() ) }
            carTypeMap.countAll = carResults.count { it.carType.id == carType.id }

            carTypeMap.stats = calculateStatsForGroupOfCars( carResults.findAll { it.carType.id == carType.id } )

            carTypeList << carTypeMap
        }

        def carTypeMap = [ : ]
        carTypeMap.name = "All Cars"
        carTypeMap.countSuccessful = carResults.count { it.carStatus.equals( CarStatus.MISSION_ACCOMBLISHED.toString() ) }
        carTypeMap.countFails = carResults.count { it.carStatus.equals( CarStatus.WAITING_EMPTY.toString() ) }
        carTypeMap.countAll = carResults.size()

        carTypeMap.stats = calculateStatsForGroupOfCars( carResults )

        carTypeList << carTypeMap




        return carTypeList
    }


    def calculateStatsForGroupOfFillingStations( List<PersistedFillingStationResult> fillingStationResults ) {

        def stats = [ : ]
        List<PersistedFillingStationResult> failed = new ArrayList<PersistedFillingStationResult>()
        List<PersistedFillingStationResult> succeeds = new ArrayList<PersistedFillingStationResult>()

        fillingStationResults.each { PersistedFillingStationResult result ->

            if ( result.failedToRouteCount > 0 ) {
                failed << result
            } else {
                succeeds << result
            }

        }

        stats.allStations = detailsStatsForGroupOfStations( fillingStationResults )
        stats.failedStations = detailsStatsForGroupOfStations( failed )
        stats.succeededStations = detailsStatsForGroupOfStations( succeeds )

        return stats
    }

    def calculateStatsForGroupOfCars( List<PersistedCarAgentResult> carResults ) {

        def stats = [ : ]

        def allCars = [ : ]
        def successfulCars = [ : ]
        def failedCars = [ : ]

        List<PersistedCarAgentResult> failedResults = new ArrayList<PersistedCarAgentResult>()
        List<PersistedCarAgentResult> successfulResults = new ArrayList<PersistedCarAgentResult>()
        carResults.each { PersistedCarAgentResult pcar ->
            if ( pcar.carStatus.equals( CarStatus.MISSION_ACCOMBLISHED.toString() ) ) {
                successfulResults << pcar
            } else if ( pcar.carStatus.equals( CarStatus.WAITING_EMPTY.toString() ) ) {
                failedResults << pcar
            }
        }


        stats.allCars = detailsStatsForGroupOfCars( carResults )
        stats.failedCars = detailsStatsForGroupOfCars( failedResults )
        stats.succeededCars = detailsStatsForGroupOfCars( successfulResults )



        return stats
    }



    def generateRandomGaussianDistributedList( Integer count, Double mean, Double sigma ) {

        int seed = 123;

        List<Double> randomList = new ArrayList<Double>( count )

        RandomDataGenerator randomData = new RandomDataGenerator();
        randomData.reSeed( seed );

        for ( int i = 0; i < count; i++ ) {

            randomList.add( randomData.nextGaussian( mean, sigma ) )

        }

        return randomList
    }

    def generateRandomUniformDistributedList( Integer count, Integer fromKm, Integer toKm ) {

        int seed = 123;

        List<Double> randomList = new ArrayList<Double>( count )

        RandomDataGenerator randomData = new RandomDataGenerator();
        randomData.reSeed( seed );

        for ( int i = 0; i < count; i++ ) {

            randomList.add( ( randomData.nextLong( fromKm, toKm )).doubleValue() )

        }

        return randomList

    }

    def generateRandomGaussianVectors( int count, double meanLat, double meanLon, double sigmaLat, double sigmaLon ) {

        NormalDistribution distributionLat = new NormalDistribution( meanLat, sigmaLat );
        NormalDistribution distributionLon = new NormalDistribution( meanLon, sigmaLon );

        long seed = 123;
        distributionLat.reseedRandomGenerator( seed );
        distributionLon.reseedRandomGenerator( seed + seed );

        double [][] randomVectors = new double [2][count];

        for ( int i = 0; i < count; i++ ) {

            double sampleLat = distributionLat.sample()
            double sampleLon = distributionLon.sample()

            randomVectors[ 0 ][ i ] = sampleLat
            randomVectors[ 1 ][ i ] = sampleLon

        }

        return randomVectors
    }

    def generateMultivariateGaussianVectors( int count, double[] meanVector, double[][] covarianceMatrix ) {

        MultivariateNormalDistribution distribution = new MultivariateNormalDistribution( meanVector, covarianceMatrix );
        long seed = 123
        distribution.reseedRandomGenerator( seed );

        double [][] randomVectors = new double [3][count];

        for ( int i = 0; i < count; i++ ) {

            double [] sample = distribution.sample()

            for ( int j = 0; j < 3; j++ ) {

                randomVectors[ j ][ i ] = sample[ j ]

            }

        }

        return randomVectors
    }

    def generateRandomListFromDistribution( Integer count, Integer fromKm, Integer toKm, Distribution distribution ) {


        List<Double> randomList = new ArrayList<Double>( count )

        int seed = 123;


        switch ( distribution ) {

            case Distribution.EQUAL_DISTRIBUTION:

                RandomDataGenerator randomData = new RandomDataGenerator();
                randomData.reSeed( seed );

                for ( int i = 0; i < count; i++ ) {

                    randomList.add( randomData.nextLong( fromKm, toKm ) )

                }

                break;
            case Distribution.NORMAL_DISTRIBUTION:

                double mean = fromKm + ( ( toKm-fromKm ) / 2 )
                double diff = toKm - mean

                NormalDistribution normalDistribution = new NormalDistribution( mean , diff * 0.2  )
                normalDistribution.reseedRandomGenerator( seed )

                for ( int i = 0; i < count; i++ ) {
                    randomList.add( normalDistribution.sample())
                }



                // randomList = generateRandomUniformDistributedList( count, fromKm, toKm )
                break;

        }

        return randomList
    }


}
