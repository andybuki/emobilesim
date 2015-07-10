import com.vividsolutions.jts.geom.Coordinate
import com.vividsolutions.jts.geom.Point
import de.dfki.gs.bootstrap.BootstrapHelper
import de.dfki.gs.domain.Author
import de.dfki.gs.domain.simulation.Car
import de.dfki.gs.domain.simulation.CarType
import de.dfki.gs.domain.simulation.FillingStation
import de.dfki.gs.domain.simulation.FillingStationGroup
import de.dfki.gs.domain.simulation.FillingStationType
import de.dfki.gs.domain.simulation.Fleet
import de.dfki.gs.domain.simulation.Route
import de.dfki.gs.domain.simulation.Simulation
import de.dfki.gs.domain.simulation.SimulationRoute
import de.dfki.gs.domain.simulation.Track
import de.dfki.gs.domain.simulation.TrackEdge
import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.utils.Distribution
import de.dfki.gs.domain.utils.FleetStatus
import de.dfki.gs.domain.utils.GroupStatus
import de.dfki.gs.domain.utils.SimulationArea
import de.dfki.gs.domain.utils.TrackEdgeType
import de.dfki.gs.service.RouteService
import de.dfki.gs.threadutils.NotifyingBlockingThreadPoolExecutor
import de.dfki.gs.utils.LatLonPoint
import grails.converters.JSON
import org.geotools.graph.path.Path
import org.geotools.graph.structure.Edge
import org.geotools.graph.structure.basic.BasicEdge
import org.geotools.graph.structure.basic.BasicNode
import org.opengis.feature.simple.SimpleFeature

import java.util.concurrent.Callable
import java.util.concurrent.TimeUnit

class BootStrap {

    def routeService

    def grailsApplication

    transient def securityContextPersistenceFilter


    def createDefaultFleet() {

        Company company = Company.findByName( "dfki" )

        if ( company == null ) {
            log.error( "no company for name dfki found" )
            return
        }
//Create Dfki-Fleet One
        Fleet dfki1Fleet = new Fleet(
                company: company,
                name: "Dfki-Fleet One",
                distribution: Distribution.OBU_ROUTES,
                routesConfigured: false,
                fleetStatus: FleetStatus.NOT_CONFIGURED,
                stub: false
        )

        if ( !dfki1Fleet.save( flush: true, failOnError: true ) ) {

            log.error( "failed to save fleet: ${dfki1Fleet.errors}" )
            return
        }

        List<Car> dfki1FleetCars = new ArrayList<Car>()

        CarType carType1 = CarType.get( 1 )
        if ( carType1 == null ) {
            log.error( "no cartype found" )
            return
        }
        2.times {

            List<Route> routeList = null

            boolean havingRoute = false

            while ( !havingRoute ) {
                routeList = routeService.createRandomFixedDistanceRoutes( 1, 90, SimulationArea.BERLIN )
                if( routeList != null &&
                        routeList.size() > 0 &&
                        routeList.get( 0 ) != null &&
                        routeList.get( 0 ).edges != null &&
                        routeList.get( 0 ).edges.size() > 0 ) {


                    int trackEdgeSize = routeList.get( 0 ).edges.size()
                    TrackEdge lastEdge = (TrackEdge) routeList.get( 0 ).edges.get( trackEdgeSize - 1 )
                    lastEdge.type = TrackEdgeType.target.toString()

                    if ( !lastEdge.save( flush: true ) ) {
                        log.error( "failed to save last edge of route: ${lastEdge.errors}" )
                    }


                    break;
                }
            }

            Route route = routeList.get( 0 )

            Car car = new Car(
                    carType: carType1,
                    name: "car no.${it}",
                    route: route,
                    routesConfigured: true,
                    fleetId: dfki1Fleet.id
            )
            if ( !car.save( flush: true, failOnError: true ) ) {
                log.error( "failed to save car: ${car.errors}" )
            } else {
                dfki1FleetCars.add( car )
            }
        }

        CarType carType2 = CarType.get( 2 )
        if ( carType2 == null ) {
            log.error( "no cartype found" )
            return
        }
        2.times {

            List<Route> routeList = null
            boolean havingRoute = false

            while ( !havingRoute ) {
                routeList = routeService.createRandomFixedDistanceRoutes( 1, 90, SimulationArea.BERLIN )
                if( routeList != null &&
                        routeList.size() > 0 &&
                        routeList.get( 0 ) != null &&
                        routeList.get( 0 ).edges != null &&
                        routeList.get( 0 ).edges.size() > 0 ) {
                    int trackEdgeSize = routeList.get( 0 ).edges.size()
                    TrackEdge lastEdge = (TrackEdge) routeList.get( 0 ).edges.get( trackEdgeSize - 1 )
                    lastEdge.type = TrackEdgeType.target.toString()

                    if ( !lastEdge.save( flush: true ) ) {
                        log.error( "failed to save last edge of route: ${lastEdge.errors}" )
                    }

                    break;
                }
            }

            Route route = routeList.get( 0 )

            Car car = new Car(
                    carType: carType2,
                    name: "car no.${it}",
                    route: route,
                    routesConfigured: true,
                    fleetId: dfki1Fleet.id
            )
            if ( !car.save( flush: true, failOnError: true ) ) {
                log.error( "failed to save car: ${car.errors}" )
            } else {
                dfki1FleetCars.add( car )
            }
        }

        dfki1FleetCars.each { Car car ->

            dfki1Fleet.addToCars( car )

        }
        dfki1Fleet.routesConfigured = true
        dfki1Fleet.fleetStatus = FleetStatus.CONFIGURED

        if ( !dfki1Fleet.save( flush: true, failOnError: true ) ) {

            log.error( "failed to update dfkifleet: ${dfki1Fleet.errors}" )

        }

//Create Dfki-Fleet One
        Fleet dfki2Fleet = new Fleet(
                company: company,
                name: "Dfki-Fleet Two",
                distribution: Distribution.OBU_ROUTES,
                fleetStatus: FleetStatus.NOT_CONFIGURED,
                stub: false,
                routesConfigured: false
        )

        if ( !dfki2Fleet.save( flush: true, failOnError: true ) ) {

            log.error( "failed to save fleet: ${dfki2Fleet.errors}" )
            return
        }

        CarType carType3 = CarType.get( 3 )
        if ( carType3 == null ) {
            log.error( "no cartype found" )
            return
        }
        List<Car> twentyOtherCars = new ArrayList<Car>()
        2.times {

            List<Route> routeList = null
            boolean havingRoute = false

            while ( !havingRoute ) {
                routeList = routeService.createRandomFixedDistanceRoutes( 1, 90, SimulationArea.BERLIN )
                if( routeList != null &&
                        routeList.size() > 0 &&
                        routeList.get( 0 ) != null &&
                        routeList.get( 0 ).edges != null &&
                        routeList.get( 0 ).edges.size() > 0 ) {

                    int trackEdgeSize = routeList.get( 0 ).edges.size()
                    TrackEdge lastEdge = (TrackEdge) routeList.get( 0 ).edges.get( trackEdgeSize - 1 )
                    lastEdge.type = TrackEdgeType.target.toString()

                    if ( !lastEdge.save( flush: true ) ) {
                        log.error( "failed to save last edge of route: ${lastEdge.errors}" )
                    }

                    break
                }
            }

            Route route = routeList.get( 0 )

            Car car = new Car(
                    carType: carType3,
                    name: "car no.${it}",
                    route: route,
                    routesConfigured: true,
                    fleetId: dfki2Fleet.id
            )
            if ( !car.save( flush: true, failOnError: true ) ) {
                log.error( "failed to save car: ${car.errors}" )
            } else {
                twentyOtherCars.add( car )
            }
        }

        CarType carType4 = CarType.get( 4 )
        if ( carType4 == null ) {
            log.error( "no cartype found" )
            return
        }
        2.times {

            List<Route> routeList = null
            boolean havingRoute = false

            while ( !havingRoute ) {
                routeList = routeService.createRandomFixedDistanceRoutes( 1, 90, SimulationArea.BERLIN )
                if( routeList != null &&
                        routeList.size() > 0 &&
                        routeList.get( 0 ) != null &&
                        routeList.get( 0 ).edges != null &&
                        routeList.get( 0 ).edges.size() > 0 ) {

                    int trackEdgeSize = routeList.get( 0 ).edges.size()
                    TrackEdge lastEdge = (TrackEdge) routeList.get( 0 ).edges.get( trackEdgeSize - 1 )
                    lastEdge.type = TrackEdgeType.target.toString()

                    if ( !lastEdge.save( flush: true ) ) {
                        log.error( "failed to save last edge of route: ${lastEdge.errors}" )
                    }

                    break
                }
            }

            Route route = routeList.get( 0 )

            Car car = new Car(
                    carType: carType4,
                    name: "car no.${it}",
                    route: route,
                    routesConfigured: true,
                    fleetId: dfki2Fleet.id
            )
            if ( !car.save( flush: true, failOnError: true ) ) {
                log.error( "failed to save car: ${car.errors}" )
            } else {
                twentyOtherCars.add( car )
            }

        }

        twentyOtherCars.each { Car car ->

            dfki2Fleet.addToCars( car )

        }

        dfki2Fleet.routesConfigured = true
        dfki2Fleet.fleetStatus = FleetStatus.CONFIGURED
        if ( !dfki2Fleet.save( flush: true, failOnError: true ) ) {

            log.error( "failed to update dfkifleet: ${dfki2Fleet.errors}" )

        }
        log.error( "create default Obu Fleet.." )
        createAllObuFleets()



    }
    def createAllObuFleets(){
    //first fleet
        createObuFleet("dfki","obuFleetBerlin_01_07",SimulationArea.BERLIN,CarType.get(7),"resources/obu_berlin_01_07.json","ZOE 12")//
        createObuFleet("dfki","obuFleetBerlin_03_07",SimulationArea.BERLIN,CarType.get(7),"resources/obu_berlin_03_07.json","ZOE 12")
        createObuFleet("dfki","obuFleetWiesloch_09_07",SimulationArea.WIESLOCH,CarType.get(7),"resources/obu_wiesloch_09_07.json","ZOE 14")
    }
    /**
     * Creates a ObuFleet with one Car with the Route given in the JSON of
     * lokated at filePathObu
     * we could make this to be also for multible Cars by giving lists for carType,
     * filePathObu and carName
     * @param companyName
     * @param fleetName
     * @param simulationArea
     * @param carType
     * @param filePathObu
     * @param carName
     * @return void
     */
    def createObuFleet(String companyName,String fleetName,SimulationArea simulationArea,CarType carType,String filePathObu,String carName){
        Company company = Company.findByName(companyName)

        if ( company == null ) {
            log.error( "no company for name dfki found" )
            return
        }
        Fleet fleet = new Fleet(
                company: company,
                name: fleetName,
                distribution: Distribution.OBU_ROUTES,
                fleetStatus: FleetStatus.NOT_CONFIGURED,
                stub: false,
                routesConfigured: false,
                simulationArea: simulationArea
        )

        if ( !fleet.save( flush: true, failOnError: true ) ) {

            log.error( "failed to save fleet: ${fleet.errors}" )
            return
        }
        if ( carType == null ) {
            log.error( "no cartype found" )
            return
        }

        def textObu = grailsApplication.getParentContext().getResource("classpath:$filePathObu").getInputStream().getText()
        def jsonObu = JSON.parse(textObu)
        def routeList = routeService.createObuRoutes(jsonObu,simulationArea)
        Car car = new Car(
                carType: carType,
                name: carName,
                routesConfigured: false,
                fleetId: fleet.id
        )
        if ( !car.save( flush: true, failOnError: true ) ) {
            log.error( "failed to save car: ${car.errors}" )
        }
        routeService.persistRouteToCar( car, routeList )
        fleet.addToCars( car )
        fleet.routesConfigured = true
        fleet.fleetStatus = FleetStatus.CONFIGURED
        if ( !fleet.save( flush: true, failOnError: true ) ) {

            log.error( "failed to update obuFleetBerlin_01_07: ${fleet.errors}" )

        }
    }
    def createDefaultGroup() {

        Company company = Company.findByName( "dfki" )

        if ( company == null ) {
            log.error( "no company for name dfki found" )
            return
        }

        FillingStationGroup dfki1Group = new FillingStationGroup(
                company: company,
                name: "Dfki-Group One",
                stub: false,
                groupsConfigured: false,
                distribution: Distribution.SELF_MADE_ROUTES,
                groupStatus: GroupStatus.NOT_CONFIGURED,
        )

        if ( !dfki1Group.save( flush: true, failOnError: true ) ) {

            log.error( "failed to save group: ${dfki1Group.errors}" )
            return
        }

        List<FillingStation> dfki1GroupStations = new ArrayList<FillingStation>()
        FillingStationType.findAll().each { FillingStationType fillingStationType ->

            10.times {

                Point point = routeService.getRandomValidPoint()

                FillingStation station = new FillingStation(
                        fillingStationType: fillingStationType,
                        name: "${fillingStationType.name}-${it}",
                        lat: point.coordinate.x.toFloat(),
                        lon: point.coordinate.y.toFloat()
                )

                if ( !station.save( flush: true, failOnError: true ) ) {

                    log.error( "fail : ${station.errors}" )

                } else {
                    dfki1Group.addToFillingStations( station )
                }

            }

        }
        dfki1Group.groupStatus = GroupStatus.CONFIGURED
        dfki1Group.groupsConfigured = true
        if ( !dfki1Group.save( flush: true, failOnError: true ) ) {

            log.error( "failed to update (add fillingStations) dfkigroup: ${dfki1Group.errors}" )

        }

        FillingStationGroup dfki2Group = new FillingStationGroup(
                company: company,
                name: "Dfki-Group Two",
                stub: false,
                groupsConfigured: false,
                distribution: Distribution.SELF_MADE_ROUTES,
                groupStatus: GroupStatus.NOT_CONFIGURED
        )

        if ( !dfki2Group.save( flush: true, failOnError: true ) ) {

            log.error( "failed to save group: ${dfki2Group.errors}" )
            return
        }

        List<FillingStation> dfki2GroupStations = new ArrayList<FillingStation>()
        FillingStationType.findAll().each { FillingStationType fillingStationType ->

            20.times {

                Point point = routeService.getRandomValidPoint()

                FillingStation station = new FillingStation(
                        fillingStationType: fillingStationType,
                        name: "${fillingStationType.name}-${it}",
                        lat: point.coordinate.x.toFloat(),
                        lon: point.coordinate.y.toFloat()
                )

                if ( !station.save( flush: true, failOnError: true ) ) {

                    log.error( "fail : ${station.errors}" )

                } else {
                    dfki2Group.addToFillingStations( station )
                }

            }

        }
        dfki2Group.groupStatus = GroupStatus.CONFIGURED
        dfki2Group.groupsConfigured = true

        if ( !dfki2Group.save( flush: true, failOnError: true ) ) {

            log.error( "failed to update (add fillingStations) dfkigroup: ${dfki2Group.errors}" )

        }

        //-------VATENFALL ELECTRIC STATIONS
        FillingStationGroup vattenfallGroup = new FillingStationGroup(
                company: company,
                name: "Vattenfall",
                stub: false,
                groupsConfigured: false,
                distribution: Distribution.SELF_MADE_ROUTES,
                groupStatus: GroupStatus.NOT_CONFIGURED
        )

        if ( !vattenfallGroup.save( flush: true, failOnError: true ) ) {

            log.error( "failed to save group: ${vattenfallGroup.errors}" )
            return
        }

        List<FillingStation> vattenfallGroupStations = new ArrayList<FillingStation>()

        def filePath = "resources/vattenfall.json"
        def text = grailsApplication.getParentContext().getResource("classpath:$filePath").getInputStream().getText()
        def json = JSON.parse(text)

        ///hier mistake
        FillingStationType fillingStationType = FillingStationType.get(3)
            for (stationVattenfall in json) {
                FillingStation station = new FillingStation(
                        fillingStationType: fillingStationType,
                        name: "Vattenfall",
                        lat: stationVattenfall["lon"],
                        lon: stationVattenfall["lat"],
                )

                if (!station.save(flush: true, failOnError: true)) {

                    log.error("fail : ${station.errors}")

                } else {
                    vattenfallGroup.addToFillingStations(station)
                }
        }
        vattenfallGroup.groupStatus = GroupStatus.CONFIGURED
        vattenfallGroup.groupsConfigured = true

        if ( !vattenfallGroup.save( flush: true, failOnError: true ) ) {

            log.error( "failed to update (add fillingStations) vattenfallGroup: ${vattenfallGroup.errors}" )
        }

        //-------RWE ELECTRIC STATIONS
        FillingStationGroup rweGroup = new FillingStationGroup(
                company: company,
                name: "Rwe",
                stub: false,
                groupsConfigured: false,
                distribution: Distribution.SELF_MADE_ROUTES,
                groupStatus: GroupStatus.NOT_CONFIGURED
        )

        if ( !vattenfallGroup.save( flush: true, failOnError: true ) ) {

            log.error( "failed to save group: ${vattenfallGroup.errors}" )
            return
        }

        List<FillingStation> rweGroupStations = new ArrayList<FillingStation>()

        def filePathRwe = "resources/rwe.json"
        def textRwe = grailsApplication.getParentContext().getResource("classpath:$filePathRwe").getInputStream().getText()
        def jsonRwe = JSON.parse(textRwe)

        ///hier mistake
        FillingStationType fillingStationTypeRwe = FillingStationType.get(5)
        for (stationRwe in jsonRwe) {
            FillingStation station = new FillingStation(
                    fillingStationType: fillingStationTypeRwe,
                    name: "Rwe",
                    lat: stationRwe["lon"],
                    lon: stationRwe["lat"],
            )

            if (!station.save(flush: true, failOnError: true)) {

                log.error("fail : ${station.errors}")

            } else {
                rweGroup.addToFillingStations(station)
            }
        }
        rweGroup.groupStatus = GroupStatus.CONFIGURED
        rweGroup.groupsConfigured = true

        if ( !rweGroup.save( flush: true, failOnError: true ) ) {

            log.error( "failed to update (add fillingStations) rweGroup: ${rweGroup.errors}" )
        }

    }


    def createDefaultCarTypes() {

        BootstrapHelper helper = new BootstrapHelper()

        helper.createDefaultCarTypeIfNotExist()

    }


    def createDefaultFillingStationTypes() {

        BootstrapHelper helper = new BootstrapHelper()

        helper.createDefaultFillingStationTypesIfNotExits()

    }



    def securityStuff() {

        securityContextPersistenceFilter.forceEagerSessionCreation = true


        def helper = new BootstrapHelper()

        def roleAdmin = helper.findOrCreateRole("ROLE_ADMIN")
        def roleEmployee = helper.findOrCreateRole("ROLE_EMPLOYEE")
        def roleUser = helper.findOrCreateRole("ROLE_USER")

        Company company = helper.findOrCreateCompany( "dfki" )

        // def userUser = helper.findOrCreatePersonInRole("glenn.schuetze@gmail.com", "Glenn", "Schütze", roleAdmin)
        def andreyUser = helper.findOrCreatePersonInRole( company, "andrey.bukhman@dfki.de", "Andrey", "Bukhman", roleUser )
        helper.findOrCreatePersonInRole( company, "andrey.bukhman@dfki.de", "Andrey", "Bukhman", roleAdmin )

        def simonUser = helper.findOrCreatePersonInRole( company, "simon.treu@dfki.de", "Simon", "Treu", roleUser )
        helper.findOrCreatePersonInRole( company, "simon.treu@dfki.de", "Simon", "Treu", roleAdmin )


        helper.findOrCreatePersonInRole( company, "glennsen@googlemail.com", "Glenn", "Schütze", roleUser)
        helper.findOrCreatePersonInRole( company, "glennsen@googlemail.com", "Glenn", "Schütze", roleAdmin)


        // helper.findOrCreateRequestmap( "/login/success", "IS_AUTHENTICATED_ANONYMOUSLY" )

        helper.findOrCreateRequestmap( "/configuration", "ROLE_USER" )

        helper.findOrCreateRequestmap( "/simulation", "ROLE_USER" )

        helper.findOrCreateRequestmap( "/configuration", "ROLE_USER" )

        //

        // helper.findOrCreateRequestmap( "/gas", "ROLE_USER" )
        //helper.findOrCreateRequestmap( "/logout", "ROLE_USER" )

        // helper.findOrCreateRequestmap( "/gasapi", "IS_AUTHENTICATED_ANONYMOUSLY" )
        helper.findOrCreateRequestmap( "/**", "IS_AUTHENTICATED_ANONYMOUSLY" )


    }

    def init = { servletContext ->

        /**
         * MOP: appending 'grailsApplication'-bean to each of the domain objects
         */
        for ( dc in grailsApplication.domainClasses ) {
            dc.clazz.metaClass.getGrailsApplication = { -> grailsApplication }
            dc.clazz.metaClass.static.getGrailsApplication = { -> grailsApplication }
        }

        def helper = new BootstrapHelper()
        helper.findOrCreateCompany("dfki")
        log.error( "..created or found: ${ Company.name }" )


        log.error( "check security config.." )
        securityStuff()
        log.error( " .. security config finished" )

        log.error( "preloading feature graph into application scope.." )
        routeService.getFeatureGraph( "osmGraph",SimulationArea.BERLIN )

        log.error( "create some default car types if not exist.." )
        createDefaultCarTypes()
        log.error( "..created or found: ${CarType.findAllByCompany( Company.findByName( "dfki" ) )*.name }" )

        log.error( "create some default electric stations.." )
        createDefaultFillingStationTypes()
        log.error( "..created or found: ${FillingStationType.findAllByCompany( Company.findByName( "dfki" ) )*.name} " )


        log.error( "create default fleet.." )
        createDefaultFleet()

        log.error( "create default group.." )
        createDefaultGroup()

        this.class.getResourceAsStream("authors.txt").eachLine { line ->

            try {
                Author author = new Author()
                def values = line.split('\t')
                author.name = values[0]
                author.minEstSales = values[1] ? (values[1].split('\\[')[0] as long) * 1000 * 1000 : 0
                author.maxEstSales = values[2] ? (values[2].split('\\[')[0] as long) * 1000 * 1000 : 0
                author.language = values[3]
                author.nrBooks = values[5]
                author.nationality = values[6]

                author.save(failOnError: true)
            } catch (Exception e) {
                e.printStackTrace()
                //do nothing
            }
        }

        def currentAuthor

    }
    def destroy = {
    }
}