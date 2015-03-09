package de.dfki.gs.controller.ms2.configuration

import com.vividsolutions.jts.geom.Point
import de.dfki.gs.controller.ms2.configuration.commands.ChangeAreaCommandObject
import com.vividsolutions.jts.geom.Coordinate
import de.dfki.gs.controller.ms2.configuration.commands.RoutingCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.StartAndDestinationsCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.ShowInfoStationsCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.AddCarsToFleedCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.AddFleetToConfigurationCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.AddGroupToConfigurationCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.AddFillingStationsToGroupCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateGroupForConfigurationCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateGroupForConfigurationViewCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateCarTypeCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateFillingStationTypeCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateFleetForConfigurationCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateFleetForConfigurationViewCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateGroupSelectorCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateRouteSelectorCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.DistributionForFleetCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.DistributionForGroupCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.EditCarTypeCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.EditConfigurationStubCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.EditFillingStationCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.ShowFleetRoutesCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.ShowGroupStationsCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.UpdateAreaCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.UpdateCarTypeCommandObject

import de.dfki.gs.controller.ms2.configuration.commands.UpdateFillingStationTypeCommandObject
import de.dfki.gs.controller.ms2.stats.commands.ExperimentResultCommandObject
import de.dfki.gs.domain.GasolineStation
import de.dfki.gs.domain.GasolineStationType
import de.dfki.gs.domain.simulation.Car
import de.dfki.gs.domain.simulation.Route
import de.dfki.gs.domain.simulation.Track
import de.dfki.gs.domain.simulation.CarType
import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.Experiment
import de.dfki.gs.domain.simulation.FillingStationGroup
import de.dfki.gs.domain.simulation.FillingStationType
import de.dfki.gs.domain.simulation.FillingStation
import de.dfki.gs.domain.simulation.Fleet
import de.dfki.gs.domain.simulation.SimulationRoute
import de.dfki.gs.domain.simulation.Simulation
import de.dfki.gs.domain.simulation.TrackEdge
import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.users.Person
import de.dfki.gs.domain.utils.Distribution
import de.dfki.gs.domain.utils.FleetStatus
import de.dfki.gs.domain.utils.SimulationArea
import de.dfki.gs.utils.LatLonPoint
import de.dfki.gs.utils.ResponseConstants
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityUtils
import de.dfki.gs.domain.users.Person
import org.geotools.graph.structure.basic.BasicEdge
import org.geotools.graph.structure.basic.BasicNode


/**
 * this controller is to handle all user inputs for configurainf simulation configurations
 * intially config-object is persisted as stub and after finished editing persisted as
 * executable
 * a) manage cartypes
 * b) manage cars-stubs
 * c) manage fleets
 * d) manage fillingStations
 * e) manage groups of fillingStations
 *
 */
class ConfigurationController {

    def springSecurityService
    def configurationService
    def grailsLinkGenerator
    def statisticService
    def routeService

    /**
     * this part handles all about fillingStationType manageing
     *
     *
     */


    def editFillingStationType() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        UpdateFillingStationTypeCommandObject cmd = new UpdateFillingStationTypeCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find fillingStationType for id. errors: ${cmd.errors}")

        } else {

            FillingStationType updatedfillingStationType = configurationService.updateFillingStationTypeForCompany(person, cmd.fillingStationTypeId, cmd.fillingStationTypeName, cmd.power)

        }

        redirect(controller: 'configuration', action: 'showFillingStationTypes')
    }

    def editFillingStationTypeView() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        EditFillingStationCommandObject cmd = new EditFillingStationCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find fillingStationType for id. errors: ${cmd.errors}")

        } else {

            def m = [:]

            FillingStationType fillingStationType = FillingStationType.get(cmd.fillingStationTypeId)
            m.fillingStationTypeName = fillingStationType.name
            m.power = fillingStationType.power
            m.fillingPortion = fillingStationType.fillingPortion
            m.fillingStationTypeId = fillingStationType.id

            render template: '/templates/configuration/fillingstationtype/editFillingStationType', model: m

        }

    }

    def createFillingStationTypeView() {

        render template: '/templates/configuration/fillingstationtype/createFillingStationType'

    }

    /**
     * show the FillingStationTypes available with edit button for each
     * show the add button
     *
     * @return
     */
    def showFillingStationTypes() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        // plug the model..
        def m = [:]

        m.fillingStationTypes = []
        List<FillingStationType> fillingStationTypes = configurationService.getElectricStationTypesForCompany(person)
        fillingStationTypes.each { FillingStationType fillingStationType ->

            m.fillingStationTypes << fillingStationType
        }
        m.lightboxlink = g.createLink(controller: 'configuration', action: 'createFillingStationTypeView')

        render view: "showFillingStationTypes", model: m
    }

    /**
     * show the cartypes available with edit button for each
     * show the add button
     *
     * @return
     */
    def showCarTypes() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        // plug the model..
        def m = [:]

        m.carTypes = []
        List<CarType> carTypes = configurationService.getCarTypesForCompany(person)
        carTypes.each { CarType carType ->

            def carTypeModel = [:]
            carTypeModel.carType = carType
            carTypeModel.lightboxlink = g.createLink(controller: 'configuration', action: 'editCarType', params: [carTypeId: carType.id])

            m.carTypes << carTypeModel
        }
        m.lightboxlink = g.createLink(controller: 'configuration', action: 'createCarTypeView')
        // m.carTypes = configurationService.getCarTypesForCompany( person )


        render view: "showCarTypes", model: m
    }

    def showSimulation() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        // plug the model..
        def m = [:]

        m.simulationNames = []

        List<Simulation> simulationNames = configurationService.getAllSimulationsForCompany(person)
        simulationNames.each { Simulation simulationName ->

            def simulationTypeModel = [:]
            simulationTypeModel.simulationName = simulationName
            simulationTypeModel.lightboxlink = g.createLink(controller: 'configuration', action: 'editSimulationType', params: [simulationTypeId: simulationType.id])

            m.simulationNames << simulationTypeModel
        }
        m.lightboxlink = g.createLink(controller: 'configuration', action: 'createSimulationTypeView')


        render view: "showSimulation", model: m
    }


    def removeFleetFromConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        AddFleetToConfigurationCommandObject cmd = new AddFleetToConfigurationCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("failed to vaildate AddFleetToConfigurationCommandObject to remove fleet: ${cmd.errors}")
        } else {

            configurationService.removeFleetFromConfiguration(cmd.configurationStubId, cmd.fleetId)

        }
        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: params.configurationStubId])

    }

    def removeGroupFromConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        AddGroupToConfigurationCommandObject cmd = new AddGroupToConfigurationCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("failed to vaildate AddGroupToConfigurationCommandObject to remove group: ${cmd.errors}")
        } else {

            configurationService.removeGroupFromConfiguration(cmd.configurationStubId, cmd.groupId)

        }
        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: params.configurationStubId])

    }


    def addExistentFleetToConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        AddFleetToConfigurationCommandObject cmd = new AddFleetToConfigurationCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("failed to vaildate AddFleetToConfigurationCommandObject: ${cmd.errors}")
        } else {

            configurationService.addFleetToConfiguration(cmd.configurationStubId, cmd.fleetId)

        }


        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: params.configurationStubId])

    }


    def addExistentGroupToConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        AddGroupToConfigurationCommandObject cmd = new AddGroupToConfigurationCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("failed to vaildate AddGroupToConfigurationCommandObject: ${cmd.errors}")
        } else {

            configurationService.addGroupToConfiguration(cmd.configurationStubId, cmd.groupId)

        }


        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: params.configurationStubId])

    }


    def index() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        EditConfigurationStubCommandObject cmd = new EditConfigurationStubCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate configuration stub: ${cmd.errors}")

        }


        Long configurationStubId = null

        // plug the model..
        def m = [:]

        if (cmd.configurationStubId == null) {
            configurationStubId = configurationService.createConfigurationStub(person).id;
        } else {
            configurationStubId = cmd.configurationStubId
        }

        /*if (cmd.simulationName==null) {
            String sim = "Simulation ${configurationStubId}"
            m.simulationName = sim
        } else {
            simulationName = configurationService.createSimulationForCompany( person, cmd.simulationName )
            m.simulationName = simulationName
        }*/

        // to know what we are talking about
        m.configurationStubId = configurationStubId

        //simulation
        m.simulationName = configurationService.createSimulationForCompany(person, configurationStubId).name

        m.simulationArea = (configurationService.getSimulationArea(configurationStubId)).name()

        // fleets
        m.availableFleets = configurationService.getFleetsForCompany(person, configurationStubId)

        // fleets already added to configuration stub
        m.addedFleets = configurationService.getAddedFleets(configurationStubId)

        // filling station groups
        m.availableFillingStationGroups = configurationService.getGroupsForCompany(person, configurationStubId)

        // groups already added to configuration stub
        m.addedGroups = configurationService.getAddedGroups(configurationStubId)

        // groups that allready configured
        m.configuredGroups = configurationService.getConfiguredGroups(configurationStubId)

        // fleets that allready configured
        m.configuredFleets = configurationService.getConfiguredFleets(configurationStubId)

        // groups that need to be saveble
        m.savedGroups = configurationService.getGroupsToBeSaved(configurationStubId)

        // fleets that need to be saveble
        m.savedFleets = configurationService.getFleetsToBeSaved(configurationStubId)

        m.notConfiguredFleets = configurationService.getFleetsNotConfigured(configurationStubId)

        m.notConfiguredGroups = configurationService.getGroupsNotConfigured(configurationStubId)

        render view: 'index', model: m
    }


    def editCarType() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        UpdateCarTypeCommandObject cmd = new UpdateCarTypeCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find carType for id. errors: ${cmd.errors}")

        } else {

            CarType updatedCarType = configurationService.updateCarTypeForCompany(person, cmd.carTypeId, cmd.carName, cmd.energyDemand, cmd.maxEnergyCapacity)

        }

        redirect(controller: 'configuration', action: 'showCarTypes')
    }


    def editCarTypeView() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        EditCarTypeCommandObject cmd = new EditCarTypeCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find carType for id. errors: ${cmd.errors}")

        } else {

            def m = [:]

            CarType carType = CarType.get(cmd.carTypeId)
            m.carTypeName = carType.name
            m.energyConsumption = carType.energyConsumption
            m.maxEnergyLoad = carType.maxEnergyLoad
            m.carTypeId = carType.id

            render template: '/templates/configuration/cartype/editCarType', model: m

        }

    }

    def createFleet() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")


        CreateFleetForConfigurationCommandObject cmd = new CreateFleetForConfigurationCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to vaildate CreateFleetForConfigurationCommandObject: ${cmd.errors}")

        } else {

            log.error("hua!! ${cmd.configurationStubId}")
            configurationService.updateNameOfFleet(cmd.nameForFleet, cmd.fleetStubId)

        }


        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: params.configurationStubId])
    }

    def createGroup() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")


        CreateGroupForConfigurationCommandObject cmd = new CreateGroupForConfigurationCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to vaildate CreateGroupForConfigurationCommandObject: ${cmd.errors}")

        } else {

            // configurationService.createFleetForCompany(  )
            log.error("hua!! ${cmd.configurationStubId}")

        }


        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: params.configurationStubId])
    }

    def createGroupSelectorView() {
        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        CreateGroupSelectorCommandObject cmd = new CreateGroupSelectorCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate : ${cmd.errors}")

        } else {

            def m = [:]

            // put fleetId
            m.groupId = cmd.groupId

            m.configurationStubId = cmd.configurationStubId

            m.groupName = configurationService.getNameOfGroup(cmd.groupId)
            m.groupNumber = configurationService.getNumberOfGroup(cmd.groupId)
            m.fillingStation = configurationService.getInfoOfFillingStation(cmd.groupId)
            m.parameters = configurationService.getfillingStationParameters(cmd.groupId)
            // put all cars from fleet
            // m.cars = configurationService.getCarsFromFleet( cmd.fleetId )

            m.groupTypes = configurationService.getFillingStationsFromGroupTypeOrdered(cmd.groupId)

            m.distributions = Distribution.values() - Distribution.SELF_MADE_ROUTES
            m.simulationArea = (configurationService.getSimulationArea(cmd.configurationStubId)).name()

            render template: '/templates/configuration/group/distribution', model: m

        }
    }


    def createRouteSelectorView() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        CreateRouteSelectorCommandObject cmd = new CreateRouteSelectorCommandObject()

        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate : ${cmd.errors}")

        } else {

            def m = [:]

            // put fleetId
            m.fleetId = cmd.fleetId

            m.configurationStubId = cmd.configurationStubId

            m.fleetName = configurationService.getNameOfFleet(cmd.fleetId)
            // put in available Distributions
            m.distributions = Distribution.values() - Distribution.SELF_MADE_ROUTES

            // put all cars from fleet
            // m.cars = configurationService.getCarsFromFleet( cmd.fleetId )

            m.carTypes = configurationService.getCarsFromFleetTypeOrdered(cmd.fleetId)
            m.simulationArea = (configurationService.getSimulationArea(cmd.configurationStubId)).name()


            render template: '/templates/configuration/fleet/distribution', model: m

        }
    }

    def setDistributionForFleet() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        DistributionForFleetCommandObject cmd = new DistributionForFleetCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate distribution for fleet: ${cmd.errors}")

        } else {

            configurationService.setDistributionForFleet(cmd.selectedDist, cmd.fleetId, cmd.fromKm, cmd.toKm)

        }

        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: cmd.configurationStubId])
    }

    /**
     * TODO: adapt impl to filling station groups
     *
     * @return
     */
    def setDistributionForGroup() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        DistributionForGroupCommandObject cmd = new DistributionForGroupCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate distribution for group: ${cmd.errors}")

        } else {

            configurationService.setDistributionForGroup(cmd.selectedDist, cmd.groupId)

        }

        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: cmd.configurationStubId])
    }

    /**
     * this calls a new modal window to put cars into a fleet
     * there must be a configuration object identified by a configurationStubId
     *
     * a new fleet is created, which is than filled with cars
     *
     *
     * @return
     */
    def changeArea() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        ChangeAreaCommandObject cmd = new ChangeAreaCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find configurationStub for id. errors: ${cmd.errors}")

        } else {

            def m = [:]

            m.configurationStubId = cmd.configurationStubId
            m.availableAreas = SimulationArea.getAllAriasAsString()

            render template: '/templates/configuration/area/changeArea', model: m

        }
    }

    def createFleetView() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        CreateFleetForConfigurationViewCommandObject cmd = new CreateFleetForConfigurationViewCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find configurationStub for id. errors: ${cmd.errors}")

        } else {

            def m = [:]

            Long fleetStubId = configurationService.createFleetStub(person, cmd.configurationStubId)?.id
            m.fleetStubId = fleetStubId

            m.configurationStubId = cmd.configurationStubId
            m.availableCarTypes = configurationService.getCarTypesForCompany(person)
            m.generatedName = Fleet.get(fleetStubId).name

            render template: '/templates/configuration/fleet/createFleet', model: m

        }

    }

    def createGroupView() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        CreateGroupForConfigurationViewCommandObject cmd = new CreateGroupForConfigurationViewCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find configurationStub for id. errors: ${cmd.errors}")

        } else {

            def m = [:]

            Long groupStubId = configurationService.createGroupStub(person, cmd.configurationStubId)?.id
            m.groupStubId = groupStubId

            m.configurationStubId = cmd.configurationStubId
            m.availableFillingStationTypes = configurationService.getFillingStationTypesForCompany(person)

            m.generatedName = FillingStationGroup.get(groupStubId).name

            render template: '/templates/configuration/group/createGroup', model: m

        }

    }

    /**
     *
     *
     * @return

     def openLayersWithAction() {
     log.debug( "params openlayers: ${params}" )
     log.debug( "sessionId: ${request.requestedSessionId}" )


     // params.simulationId can be null
     try {
     Long configurationStubId = Long.parseLong( params.configurationStubId as String )

     SimulationCommand cmd = new SimulationCommand()
     bindData( cmd, params )

     if ( !cmd.validate() ) {
     log.error( "failed to get simulation for provided simulationId: ${cmd.simulationId} -- ${cmd.errors}" )
     }def m =  simulationCollectDataService.collectSimulationModelForRendering( simulationId )

     render view: 'showRoutes', model: m
     } catch ( Exception e ) {
     log.error( "cannot parse string to long ${params.configurationStubId}", e  )
     }

     }
     */

    def showFleetRoutesOnMap() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")
        log.debug("params openlayers: ${params}")
        log.debug("sessionId: ${request.requestedSessionId}")

        ShowFleetRoutesCommandObject cmd = new ShowFleetRoutesCommandObject()
        bindData(cmd, params)


        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("failed to get simulation for provided simulationId: ${cmd.simulationId} -- ${cmd.errors}")
        } else {
            def m = [:]
            m.fleets = configurationService.getFleetRoutesOfConfiguration(cmd.configurationStubId)
            m.simulationArea = (configurationService.getSimulationArea(cmd.configurationStubId)).name()
            render template: '/templates/configuration/routes/showRoutesOnMap', model: m
        }
    }

    def showGasolineInfo() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        ShowInfoStationsCommandObject cmd = new ShowInfoStationsCommandObject()
        bindData(cmd, params)

        FillingStation fillingStation = FillingStation.get(fillingStationId)

        def m = [:]
        //m.fillingStationId = cmd.fillingStationId
        //m.fillingStationType = FillingStationType.values()*.toString()

        //m.showGasolineInfoLink = g.createLink( controller: 'configuration', action: 'showGasolineInfo', params: [ fillingStationId: m.fillingStationId ] )

        render(template: '/templates/configuration/stations/showGasolineInfo', model: m)

    }

    def showGroupStationsOnMap() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        ShowGroupStationsCommandObject cmd = new ShowGroupStationsCommandObject()
        bindData(cmd, params)


        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("failed to get simulation for provided simulationId: ${cmd.simulationId} -- ${cmd.errors}")
        } else {
            def m = [:]
            m.fillingStationGroups = configurationService.getGroupStationsOfConfiguration(cmd.configurationStubId)
            m.simulationArea = (configurationService.getSimulationArea(cmd.configurationStubId)).name()
            render template: '/templates/configuration/stations/showStationsOnMap', model: m
        }
    }


    def updateArea() {
        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        UpdateAreaCommandObject cmd = new UpdateAreaCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to change Area: ${cmd.errors}")

        } else {
            log.error("hua!! ${cmd.configurationStubId}")
            configurationService.changeSimulationArea(cmd.configurationStubId, cmd.areaId)
        }

        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: params.configurationStubId])
    }

    def updateFleetOfConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")


        AddCarsToFleedCommandObject cmd = new AddCarsToFleedCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to add cars to fleet: ${cmd.errors}")

        } else {

            int count = 0
            if (cmd.carCountList != null && cmd.carCountList.size() > 0) {
                count = cmd.carCountList.get(cmd.carCountList.size() - 1)
            } else {
                count = cmd.carCount
            }

            Long carTypeId = null
            if (cmd.carTypeSelect != null && cmd.carTypeSelect.size() > 0) {
                carTypeId = cmd.carTypeSelect.get(cmd.carTypeSelect.size() - 1)
            } else if (cmd.carTypeId != null) {
                carTypeId = cmd.carTypeId
            }

            if (carTypeId != null) {
                configurationService.addCarsToFleet(cmd.fleetStubId, count, carTypeId, cmd.nameForFleet)
            }

        }

        def m = [:]
        m.uuid = UUID.randomUUID()
        m.fleetStubId = cmd.fleetStubId
        m.configurationStubId = cmd.configurationStubId
        m.availableCarTypes = configurationService.getCarTypesForCompany(person)

        render template: "/templates/configuration/fleet/anotherCarRow", model: m
    }

    def updateGroupOfConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")


        AddFillingStationsToGroupCommandObject cmd = new AddFillingStationsToGroupCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to add filling stations to group: ${cmd.errors}")

        } else {

            int count = 0
            if (cmd.stationCountList != null && cmd.stationCountList.size() > 0) {
                count = cmd.stationCountList.get(cmd.stationCountList.size() - 1)
            } else {
                count = cmd.stationCount
            }

            Long stationTypeId = null
            if (cmd.stationTypeSelect != null && cmd.stationTypeSelect.size() > 0) {
                stationTypeId = cmd.stationTypeSelect.get(cmd.stationTypeSelect.size() - 1)
            } else if (cmd.stationTypeId != null) {
                stationTypeId = cmd.stationTypeId
            }

            if (stationTypeId != null) {
                configurationService.addStationsToGroup(cmd.groupStubId, count, stationTypeId, cmd.nameForGroup)
            }

        }

        def m = [:]
        m.uuid = UUID.randomUUID()
        m.groupStubId = cmd.groupStubId
        m.configurationStubId = cmd.configurationStubId
        m.availableFillingStationTypes = configurationService.getFillingStationTypesForCompany(person)

        render template: "/templates/configuration/group/anotherFillingStationRow", model: m
    }


    def createCarTypeView() {

        render template: '/templates/configuration/cartype/createCarType'

    }


    def createFillingStationType() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [:]

        CreateFillingStationTypeCommandObject cmd = new CreateFillingStationTypeCommandObject()
        bindData(cmd, params)

        FillingStationType fillingStationType = null
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate user input for creating fillingStationType: ${cmd.errors}")
            m.errors = cmd.errors
            m.cmd = cmd

        } else {

            fillingStationType = configurationService.createFillingStationTypeForCompany(person, cmd.fillingStationTypeName, cmd.power)
            m.fillingStationType = fillingStationType
        }

        redirect(controller: 'configuration', action: 'showFillingStationTypes')
    }

    /**
     * creates a carType for a company
     */
    def createCarType() {

        log.error("params: ${params}")

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [:]

        CreateCarTypeCommandObject cmd = new CreateCarTypeCommandObject()
        bindData(cmd, params)

        CarType carType = null
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate user input for creating carType: ${cmd.errors}")
            m.errors = cmd.errors
            m.cmd = cmd

        } else {

            carType = configurationService.createCarTypeForCompany(person, cmd.carName, cmd.energyDemand, cmd.maxEnergyCapacity)
            m.carType = carType


        }

        redirect(controller: 'configuration', action: 'showCarTypes')
    }

    /**
     * list available carTypes for company
     */
    def listAvailableCarType() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [:]

        List<CarType> carTypes = configurationService.getCarTypesForCompany(person)

        m.carTypes = carTypes

        // TODO: render
    }


    def removeStubConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        CreateFleetForConfigurationViewCommandObject cmd = new CreateFleetForConfigurationViewCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("nothing to remove, no coniguration stub found for ${cmd.configurationStubId} : ${cmd.errors}")
        } else {

            configurationService.removeConfigurationStub(cmd.configurationStubId)

        }


        redirect controller: 'front', action: 'init'
    }

    def saveFinishedConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        CreateFleetForConfigurationViewCommandObject cmd = new CreateFleetForConfigurationViewCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("nothing to save, no coniguration stub found for ${cmd.configurationStubId} : ${cmd.errors}")
        } else {

            configurationService.saveFinishedConfigurationStub(cmd.configurationStubId)

        }

        //redirect controller: 'front', action: 'init'
        redirect(controller: 'configuration', action: 'index', params: [configurationStubId: cmd.configurationStubId])
    }

    def showRecentlyEditedConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        EditConfigurationStubCommandObject cmd = new EditConfigurationStubCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate configuration stub: ${cmd.errors}")

        }

        Long configurationStubId = null

        if (cmd.configurationStubId == null) {
            configurationStubId = configurationService.createConfigurationStub(person).id;
        } else {
            configurationStubId = cmd.configurationStubId
        }


        def m = [:]
        m.configurations = []

        List<Configuration> configurations = configurationService.getRecentlyEditedConfigurationsOfCompany(person)

        configurations.each { Configuration configuration ->

            def conf = [:]

            List<Fleet> existedFleets = new ArrayList<Fleet>()
            configuration.fleets.each { Fleet fleet ->
                existedFleets.add(Fleet.get(fleet.id))

            }

            List<FillingStationGroup> existedStations = new ArrayList<FillingStationGroup>()
            configuration.fillingStationGroups.each { FillingStationGroup fillingStationGroup ->
                existedStations.add(FillingStationGroup.get(fillingStationGroup.id))

            }

            if (configuration.fleets.size() > 0 && configuration.fillingStationGroups.size() > 0) {

                int routeCount = 0
                configuration.fleets.each { Fleet fleet ->
                    fleet = Fleet.get(fleet.id)
                    routeCount += fleet.cars.size()
                }

                int stationCount = 0

                configuration.fillingStationGroups.each { FillingStationGroup fillingStation ->
                    fillingStation = FillingStationGroup.get(fillingStation.id)
                    stationCount += fillingStation.fillingStations.size()
                }

                conf.configurationId = configuration.id
                conf.fleetInfo = existedFleets.cars[0].size()
                conf.stationsInfo = existedStations.fillingStations[0].size()
                conf.routeCount = routeCount
                conf.stationCount = stationCount

                m.configurations << conf
            }

        }

        render view: 'recentConfigurations', model: m
    }

    def help() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [:]

        render view: 'help', model: m
    }

    def contact() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [:]

        render view: 'contact', model: m
    }

    def loadFromFile() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [:]

        render view: 'loadFromFile', model: m
    }


    def viewSimulations() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        EditConfigurationStubCommandObject cmd = new EditConfigurationStubCommandObject()

        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate configuration stub: ${cmd.errors}")

        }

        Long configurationStubId = null

        if (cmd.configurationStubId == null) {
            configurationStubId = configurationService.createConfigurationStub(person).id;
        } else {
            configurationStubId = cmd.configurationStubId
        }


        def m = [:]
        m.configurations = []

        List<Configuration> configurations = configurationService.getRecentlyEditedConfigurationsOfCompany(person)

        configurations.each { Configuration configuration ->

            def conf = [:]


            List<Fleet> existedFleets = new ArrayList<Fleet>()
            configuration.fleets.each { Fleet fleet ->
                existedFleets.add(Fleet.get(fleet.id))

            }

            List<FillingStationGroup> existedStations = new ArrayList<FillingStationGroup>()
            configuration.fillingStationGroups.each { FillingStationGroup fillingStationGroup ->
                existedStations.add(FillingStationGroup.get(fillingStationGroup.id))

            }

            // listz of all configs allowed, use service
            // List<Configuration> configurationsList = Configuration.findAllByCompany( Company.get( person.company.id ) )

            /*List<Experiment> existedExperiments = new ArrayList<Experiment>()
            configuration.experiments.each { Experiment experiment ->
                existedExperiments.add( Experiment.get( experiment.id ) )

            }*/

            if (configuration.fleets.size() > 0 && configuration.fillingStationGroups.size() > 0) {

                int routeCount = 0
                configuration.fleets.each { Fleet fleet ->
                    fleet = Fleet.get(fleet.id)
                    routeCount += fleet.cars.size()
                }

                int stationCount = 0

                configuration.fillingStationGroups.each { FillingStationGroup fillingStation ->
                    fillingStation = FillingStationGroup.get(fillingStation.id)
                    stationCount += fillingStation.fillingStations.size()
                }

                int experimentCount = 0

                /*configuration.experiments.each { Experiment experiment ->
                    experiment = Experiment.get( experiment.id )
                    experimentCount += experiment.experimentResult.size()
                }*/


                conf.configurationId = configuration.id
                conf.fleetInfo = existedFleets.cars[0].size()
                conf.stationsInfo = existedStations.fillingStations[0].size()
                conf.routeCount = routeCount
                conf.stationCount = stationCount
                conf.stationsConfiguration = existedStations[0].groupsConfigured
                conf.routesConfiguration = existedFleets[0].routesConfigured

                //conf.experimentRunResultId = experiment.experiments

                m.configurations << conf
            }

        }

        render view: 'viewSimulations', model: m

    }

    def executeSimulations() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        EditConfigurationStubCommandObject cmd = new EditConfigurationStubCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate configuration stub: ${cmd.errors}")

        }

        Long configurationStubId = null

        if (cmd.configurationStubId == null) {
            configurationStubId = configurationService.createConfigurationStub(person).id;
        } else {
            configurationStubId = cmd.configurationStubId
        }


        def m = [:]
        m.configurations = []

        List<Configuration> configurations = configurationService.getRecentlyEditedConfigurationsOfCompany(person)

        configurations.each { Configuration configuration ->

            def conf = [:]

            List<Fleet> existedFleets = new ArrayList<Fleet>()
            configuration.fleets.each { Fleet fleet ->
                existedFleets.add(Fleet.get(fleet.id))

            }

            List<FillingStationGroup> existedStations = new ArrayList<FillingStationGroup>()
            configuration.fillingStationGroups.each { FillingStationGroup fillingStationGroup ->
                existedStations.add(FillingStationGroup.get(fillingStationGroup.id))

            }


            if (configuration.fleets.size() > 0 && configuration.fillingStationGroups.size() > 0) {

                int routeCount = 0
                configuration.fleets.each { Fleet fleet ->
                    fleet = Fleet.get(fleet.id)
                    routeCount += fleet.cars.size()
                }

                int stationCount = 0

                configuration.fillingStationGroups.each { FillingStationGroup fillingStation ->
                    fillingStation = FillingStationGroup.get(fillingStation.id)
                    stationCount += fillingStation.fillingStations.size()
                }



                conf.configurationId = configuration.id
                conf.fleetInfo = existedFleets.cars[0].size()
                conf.stationsInfo = existedStations.fillingStations[0].size()
                conf.routeCount = routeCount
                conf.stationCount = stationCount
                conf.stationsConfiguration = existedStations[0].groupsConfigured
                conf.routesConfiguration = existedFleets[0].routesConfigured

                m.configurations << conf
            }

        }

        render view: 'executeSimulations', model: m
    }

    def checkPerson() {

    }

    def retrieveTypeForFillingStation() {

        // what we get
        def json = request.JSON.data

        // what we return
        def data = [:]

        FillingStation fillingStation = FillingStation.get(json.fillingStationId)
        if (fillingStation) {
            data.fillingStationType = fillingStation.type
        }

        response.status = ResponseConstants.RESPONSE_STATUS_OK
        response.addHeader("Content-Type", "application/json");

        render "${(data as JSON).toString()}"

    }

    def calculateChargingStation() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        StartAndDestinationsCommandObject cmd = new StartAndDestinationsCommandObject();
        bindData(cmd, params)
        // what we get

        def json = request.JSON.data
        // what we return
        def data = [:]

        data.currentLat = json.currentLat;
        data.currentLon = json.currentLon;
        data.currentZoom = json.currentZoom;
        data.configurationStubId = cmd.configurationStubId
        data.groupId = cmd.groupId
        data.groupName = cmd.groupName
        data.fillingStationId = cmd.fillingStationId
        // could be either a gasoline station or a route start point

        cmd.startPoint = new LatLonPoint(json.startPoint.y, json.startPoint.x)

        // in any case we have a simulation id! if not, it should fail!

        if (json.type == "gasolinePoint") {

            Coordinate nearestPoint = routeService.getNearestValidPoint(new Coordinate(cmd.startPoint.x, cmd.startPoint.y),configurationService.getSimulationArea(cmd.configurationStubId));
            data.type = "gasolinePoint"
            data.gasolinePoint = [x: nearestPoint.x, y: nearestPoint.y]

            FillingStationGroup fillingStationGroup = FillingStationGroup.get(cmd.groupId)
            FillingStation fillingStation = FillingStation.get(fillingStationGroup.fillingStations.id)

            if (fillingStationGroup.groupsConfigured != true) {

                fillingStationGroup.groupStatus = "CONFIGURED"
                fillingStationGroup.groupsConfigured = true
                data.groupsConfigured = fillingStationGroup.groupsConfigured
                data.fillingStationGroup = fillingStationGroup
                fillingStation.lat = nearestPoint.x
                fillingStation.lon = nearestPoint.y

                data.fillingStationId = fillingStation.id
                data.fillingStationLat = fillingStation.lat
                data.fillingStationLon = fillingStation.lon

                int fillingStationsSize = fillingStationGroup.fillingStations.size()
                fillingStationGroup.fillingStations.add(fillingStationsSize, fillingStationGroup.fillingStations.get(0))
                fillingStationGroup.fillingStations.remove(0)
            } else {

                int fillingStationsSize = fillingStationGroup.fillingStations.size()
                fillingStationGroup.fillingStations.add(fillingStationsSize, fillingStationGroup.fillingStations.get(0))
                fillingStationGroup.fillingStations.remove(0)
                fillingStation.lat = nearestPoint.x
                fillingStation.lon = nearestPoint.y

                data.fillingStationId = fillingStation.id
                data.fillingStationLat = fillingStation.lat
                data.fillingStationLon = fillingStation.lon

                data.fillingStationGroup = fillingStationGroup
            }

        }

        response.status = ResponseConstants.RESPONSE_STATUS_OK
        response.addHeader("Content-Type", "application/json");

        render "${(data as JSON).toString()}"
    }

    def calculateRouting() {
        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        RoutingCommandObject cmd = new RoutingCommandObject();
        bindData(cmd, params)
        // what we get

        def json = request.JSON.data
        // what we return
        def data = [:]
        data.currentLat = json.currentLat;
        data.currentLon = json.currentLon;
        data.currentZoom = json.currentZoom;
        data.configurationStubId = cmd.configurationStubId
        data.fleetId = cmd.fleetId
        data.fleetName = cmd.fleetName
        data.carTypeId = cmd.carTypeId

        cmd.startPoint = new LatLonPoint(json.startPoint.y, json.startPoint.x)

        if (json.type == "lineRoute") {

            def destinations = []

            json.destinationPoints.each {
                destinations << new LatLonPoint(it.y, it.x) //x is lon y is lat
            }

            cmd.destinationPoints = destinations

            if (!cmd.validate()) {
                log.error("failed: ${cmd.errors}")
                return
            }

            Simulation simulation = Simulation.get(cmd.configurationStubId)



            def points = [];
            points << cmd.startPoint;
            cmd.destinationPoints.each { points << it }

            def pairs = points.collate( 2, 1, false );
            List<List<BasicEdge>> multiTargetRoute = new ArrayList<List<BasicEdge>>()
            data.routes = [];
            data.type = "lineRoute"
            List<BasicEdge> edgesToRender = new ArrayList<BasicEdge>()
            SimulationArea simulationArea = configurationService.getSimulationArea(cmd.configurationStubId)
            Fleet fleet = Fleet.get(cmd.fleetId)
            Car carToRoute

            for(Car car : fleet.cars){
                car = Car.get(car.id)
                if(!car.routesConfigured) {
                    carToRoute = car
                    break
                }
            }
            pairs.each {

                Coordinate currentStart  = new Coordinate( it[0].x, it[0].y );
                Coordinate currentTarget = new Coordinate( it[1].x, it[1].y );

                List<BasicEdge> pathEdges = routeService.calculatePath( currentStart,currentTarget, simulationArea)
//calculatePath will use the graph for the selected simulationArea

                if ( pathEdges.size() < 1 ) {
                    log.error( "path broken.. from: ${currentStart.x},${currentStart.y}  to: ${currentTarget.x},${currentTarget.y}" )
                    return null
                }

                multiTargetRoute.add( routeService.repairEdges( pathEdges ) )
                edgesToRender.addAll( pathEdges )

            }

            routeService.persistRouteToCar( carToRoute, multiTargetRoute )

            Car lastCar = fleet.cars.last()
            lastCar = Car.get(lastCar.id)
            if (carToRoute== lastCar) {
                fleet.routesConfigured = true
                fleet.fleetStatus = FleetStatus.CONFIGURED
            }
            if ( !fleet.save( flush: true ) ) {
                log.error( "failed to save fleet: ${fleet.errors}" )
            }
            fleet.simulationArea= simulationArea
            data.fleet = fleet
        }


        response.status = ResponseConstants.RESPONSE_STATUS_OK
        response.addHeader("Content-Type", "application/json");

        render "${(data as JSON).toString()}"
    }

}
