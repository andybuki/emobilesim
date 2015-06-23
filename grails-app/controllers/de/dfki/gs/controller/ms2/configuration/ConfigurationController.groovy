package de.dfki.gs.controller.ms2.configuration

import de.dfki.gs.controller.ms2.configuration.commands.AddCarsToUnsavedFleetCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.AddStationsToUnsavedGroupCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.ChangeAreaCommandObject
import com.vividsolutions.jts.geom.Coordinate
import de.dfki.gs.controller.ms2.configuration.commands.ChangeNameCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateBatteryStatusCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.CreateStartTimeCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.RoutingCommandObject
import de.dfki.gs.controller.ms2.configuration.commands.ShowSingleFleetRouteCommandObject
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
import de.dfki.gs.controller.ms2.configuration.commands.VrpCommandObject
import de.dfki.gs.domain.DfkiRoutesTimeStatus
import de.dfki.gs.domain.simulation.Car
import de.dfki.gs.domain.simulation.CarType
import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.CustomerPosition
import de.dfki.gs.domain.simulation.CustomerPositionSet
import de.dfki.gs.domain.simulation.FillingStationGroup
import de.dfki.gs.domain.simulation.FillingStationType
import de.dfki.gs.domain.simulation.FillingStation
import de.dfki.gs.domain.simulation.Fleet
import de.dfki.gs.domain.simulation.Simulation
import de.dfki.gs.domain.simulation.SingleVrpTracks
import de.dfki.gs.domain.simulation.VrpTracks
import de.dfki.gs.domain.stats.ExperimentRunResult
import de.dfki.gs.domain.users.Company
import de.dfki.gs.domain.utils.Distribution
import de.dfki.gs.domain.utils.FleetStatus
import de.dfki.gs.domain.utils.SimulationArea
import de.dfki.gs.service.VrpSolver
import de.dfki.gs.utils.LatLonPoint
import de.dfki.gs.utils.ResponseConstants
import grails.converters.JSON
import grails.plugin.springsecurity.SpringSecurityUtils
import de.dfki.gs.domain.users.Person
import org.geotools.graph.structure.basic.BasicEdge

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
        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: params.configurationStubId])

    }

    def removeFleetFromConfigurationRoute() {

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
        redirect(controller: 'configuration', action: 'configureSimulationRoute', params: [configurationStubId: params.configurationStubId])

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
        redirect(controller: 'configuration', action: 'configureSimulationStation', params: [configurationStubId: params.configurationStubId])

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


        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: params.configurationStubId])

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


        redirect(controller: 'configuration', action: 'configureSimulationStation', params: [configurationStubId: params.configurationStubId])

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
        m.configurations = []

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
                conf.simulationName = configuration.simulationName

                m.configurations << conf
            }

        }

        render view: 'index', model: m
    }

    def configureSimulation (){
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
        m.configurations = []

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
        m.simulationName = configurationService.getSimulationName(configurationStubId)

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


        render view: 'configureSimulationFleet', model: m
    }


    def configureSimulationRoute () {
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
        m.configurations = []

        if (cmd.configurationStubId == null) {
            configurationStubId = configurationService.createConfigurationStub(person).id;
        } else {
            configurationStubId = cmd.configurationStubId
        }


        // to know what we are talking about
        m.configurationStubId = configurationStubId

        //simulation
        m.simulationName = configurationService.getSimulationName(configurationStubId)

        m.simulationArea = (configurationService.getSimulationArea(configurationStubId)).name()

        // fleets
        m.availableFleets = configurationService.getFleetsForCompany(person, configurationStubId)

        // fleets already added to configuration stub
        m.addedFleets = configurationService.getAddedFleets(configurationStubId)

        // fleets that allready configured
        m.configuredFleets = configurationService.getConfiguredFleets(configurationStubId)

        // fleets that need to be saveble
        m.savedFleets = configurationService.getFleetsToBeSaved(configurationStubId)

        m.notConfiguredFleets = configurationService.getFleetsNotConfigured(configurationStubId)


        render view: 'configureSimulationRoute', model: m
    }

    def configureSimulationStation () {

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
        m.configurations = []

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
        m.simulationName = configurationService.getSimulationName(configurationStubId)

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


        render view: 'configureSimulationStation', model: m
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
            configurationService.unstubFleet(cmd.fleetStubId)

        }


        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: params.configurationStubId])
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

            configurationService.unstubGroup(cmd.groupStubId)
            log.error("hua!! ${cmd.configurationStubId}")

        }


        redirect(controller: 'configuration', action: 'configureSimulationStation', params: [configurationStubId: params.configurationStubId])
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
            m.fleetSize = configurationService.getFleetSize (cmd.fleetId)
            // put in available Distributions
            m.distributions = Distribution.values() - Distribution.SELF_MADE_ROUTES

            // put all cars from fleet
            // m.cars = configurationService.getCarsFromFleet( cmd.fleetId )
            m.simulationTime = configurationService.getSimulationTime (cmd.fleetId)
            m.carId = configurationService.getCarId (cmd.fleetId)
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

        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: cmd.configurationStubId])
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

        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: cmd.configurationStubId])
    }


    def changeArea() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }


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
    def changeName(){

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }
        ChangeNameCommandObject cmd = new ChangeNameCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find configurationStub for id. errors: ${cmd.errors}")

        } else if(cmd.nameForSimulation == null) {
            log.error("no input")
        }
        else {
            configurationService.setSimulationName(cmd.configurationStubId, cmd.nameForSimulation)
        }
        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: params.configurationStubId])

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
            m.nameForFleet = Fleet.get(fleetStubId).name

            render template: '/templates/configuration/fleet/createFleet', model: m

        }

    }

    def configureBatteryStatus () {
        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        CreateBatteryStatusCommandObject cmd  = new CreateBatteryStatusCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find configurationStub for id. errors: ${cmd.errors}")

        } else {
            def m = [:]
            m.fleetId = cmd.fleetId
            m.configurationStubId = cmd.configurationStubId
            m.batteryStatus = configurationService.getBatteryStatus(cmd.fleetId)

            render template: '/templates/configuration/fleet/configureBatteryStatus', model: m
        }

    }

    def configureStartTime() {
        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        CreateStartTimeCommandObject cmd  = new CreateStartTimeCommandObject()
        bindData(cmd, params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to find configurationStub for id. errors: ${cmd.errors}")

        } else {
            def m = [:]
            m.fleetId = cmd.fleetId
            m.configurationStubId = cmd.configurationStubId
            m.startTime = configurationService.getStartTime(cmd.fleetId)
            render template: '/templates/configuration/fleet/configureStartTimeStatus', model: m
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

            m.nameForGroup = FillingStationGroup.get(groupStubId).name

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
            log.error("failed to get simulation for provided configurationStubId: ${cmd.configurationStubId} -- ${cmd.errors}")
        } else {
            def m = [:]
            m.fleets = configurationService.getFleetRoutesOfConfiguration(cmd.configurationStubId)
            m.simulationArea = (configurationService.getSimulationArea(cmd.configurationStubId)).name()
            render template: '/templates/configuration/routes/showRoutesOnMap', model: m
        }
    }
    def showSingleFleetRouteOnMap() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")
        log.debug("params openlayers: ${params}")
        log.debug("sessionId: ${request.requestedSessionId}")

        ShowSingleFleetRouteCommandObject cmd = new ShowSingleFleetRouteCommandObject()
        bindData(cmd, params)


        if (!cmd.validate() && cmd.hasErrors()) {
            log.error("failed to get simulation for provided simulationId: ${cmd.simulationId} -- ${cmd.errors}")
        } else {
            Fleet fleet = Fleet.get(cmd.fleetId)
            def m = [:]
            m.fleet = configurationService.getFleetRoute(cmd.fleetId)
            m.simulationArea = fleet.getSimulationArea().name()
            render template: '/templates/configuration/routes/showSingleRouteOnMap', model: m
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

        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: params.configurationStubId])
    }


    def addCarsToUnsavedFleet(){
        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        AddCarsToUnsavedFleetCommandObject cmd = new AddCarsToUnsavedFleetCommandObject()
        bindData(cmd,params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to add cars to fleet: ${cmd.errors}")

        }else{
            configurationService.addCarsToFleet(cmd.fleetStubId, cmd.carCount, cmd.carTypeId, cmd.nameForFleet)
        }
        Fleet fleetStub = Fleet.get(cmd.fleetStubId)
        def carsStub
        def carTypeList = []
        carsStub = fleetStub.cars
        def carTypeIds = carsStub.collect{ it.carType.id}.unique()
        for ( Long carTypeId : carTypeIds ) {

            def carTypeMap = [:]
            CarType carType = CarType.get( carTypeId )
            carTypeMap.name = carType.name
            carTypeMap.count = carsStub.count { it.carType.id == carType.id }
            carTypeList << carTypeMap
        }

        def m = [:]

        m.addedFleet = Fleet.get(cmd.fleetStubId)
        m.configurationStubId = cmd.configurationStubId
        m.availableCarTypes = configurationService.getCarTypesForCompany(person)
        m.nameForFleet = cmd.nameForFleet
        m.addedCars = carTypeList
        //m.fleetStubId = cmd.fleetStubId

        render template: "/templates/configuration/fleet/addedCars", model: m

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
    def addStationsToUnsavedGroup(){
        Person person = (Person) springSecurityService.currentUser

        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        log.error("params: ${params}")

        AddStationsToUnsavedGroupCommandObject cmd = new AddStationsToUnsavedGroupCommandObject()
        bindData(cmd,params)

        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to add cars to fleet: ${cmd.errors}")

        }else{
            configurationService.addStationsToGroup(cmd.groupStubId, cmd.stationCount, cmd.stationTypeId, cmd.nameForGroup)
        }
        FillingStationGroup group = FillingStationGroup.get(cmd.groupStubId)
        def stationsStub
        def stationTypeList = []
        stationsStub = group.fillingStations
        def stationTypeIds = stationsStub.collect{ it.fillingStationType.id}.unique()
        for ( Long stationTypeId : stationTypeIds ) {

            def stationTypeMap = [:]
            FillingStationType stationType = FillingStationType.get( stationTypeId )
            stationTypeMap.name = stationType.name
            stationTypeMap.count = stationsStub.count { it.fillingStationType.id == stationType.id }
            stationTypeList << stationTypeMap
        }

        def m = [:]

        m.addedGroup = FillingStationGroup.get(cmd.groupStubId)
        m.configurationStubId = cmd.configurationStubId
        m.availableFillingStationTypes = configurationService.getFillingStationTypesForCompany(person)
        m.nameForGroup = cmd.nameForGroup
        m.addedStations = stationTypeList

        render template: "/templates/configuration/group/addedGroups", model: m

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
        redirect(controller: 'configuration', action: 'configureSimulation', params: [configurationStubId: cmd.configurationStubId])
    }


    def saveFinishedConfigurationFleet(){

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
        redirect(controller: 'configuration', action: 'configureSimulationRoute', params: [configurationStubId: cmd.configurationStubId])
    }

    def saveFinishedConfigurationRoute(){

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
        redirect(controller: 'configuration', action: 'configureSimulationStation', params: [configurationStubId: cmd.configurationStubId])
    }

    def saveFinishedConfigurationStation () {

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
        redirect(controller: 'configuration', action: 'configureSimulationStation', params: [configurationStubId: cmd.configurationStubId])
    }


    def showRecentlyEditedConfiguration() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        /*
        //TODO If there are no errors delet this
        TEditConfigurationStubCommandObject cmd = new EditConfigurationStubCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate configuration stub: ${cmd.errors}")

        }

        Long configurationStubId = null

        if (cmd.configurationStubId == null) {
            configurationStubId = configurationService.createConfigurationStub(person).id;
        } else {
            configurationStubId = cmd.configurationStubId
        }*/


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
                conf.simulationName = configuration.simulationName

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

    /*def configurator1() {

        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [:]

        def authorClassicGrid = {
            domainClass Author
            gridImpl 'classic'
            columns {
                id {
                    type 'id'
                }
                name
                minEstSales {
                    formatName 'nrToString'
                }
                maxEstSales {
                    formatName 'nrToString'
                }
                language
                nrBooks
                nationality
            }
        }

        render view: 'configurator1', model: m
    }*/

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

        /*
        //TODO If there are no errors delet this
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
        }*/


        def m = [:]
        m.configurations = []

        List<Configuration> configurations = configurationService.getRecentlyEditedConfigurationsOfCompany(person)

        configurations.each { Configuration configuration ->




            List<Fleet> existedFleets = new ArrayList<Fleet>()
            configuration.fleets.each { Fleet fleet ->
                existedFleets.add(Fleet.get(fleet.id))

            }

            List<FillingStationGroup> existedStations = new ArrayList<FillingStationGroup>()
            configuration.fillingStationGroups.each { FillingStationGroup fillingStationGroup ->
                existedStations.add(FillingStationGroup.get(fillingStationGroup.id))

            }

            List<ExperimentRunResult> experimentRunResultList = configurationService.getRecentlyEditedExperimentResultsOfConfiguration(configuration.id)
            experimentRunResultList.each{ExperimentRunResult experimentRunResult ->



             if (configuration.fleets.size() > 0 && configuration.fillingStationGroups.size() > 0) {
                def conf = [:]
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
                conf.simulationName = configuration.simulationName

                conf.experimentRunResultId = experimentRunResult.id

                m.configurations << conf
            }
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

        /*
        //TODO If there are no errors delet this
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
        }*/


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
                conf.simulationName = configuration.simulationName
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
            data.strokeColor = "#00ff00"
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

           // int counter = 0
            pairs.each {
                  //  Boolean pathBroken = true
                    Coordinate currentStart = new Coordinate(it[0].x, it[0].y);
                    Coordinate currentTarget = new Coordinate(it[1].x, it[1].y);
              //  while (pathBroken && counter<100) {
                    List<BasicEdge> pathEdges = routeService.calculatePath(currentStart, currentTarget, simulationArea)
//calculatePath will use the graph for the selected simulationArea

                    if (pathEdges.size() < 1) {
                        log.error("path broken.. from: ${currentStart.x},${currentStart.y}  to: ${currentTarget.x},${currentTarget.y}")
                       // pathBroken = true
                       // counter++
                       // currentStart = new Coordinate(currentStart.x+0.001,currentStart.y)
                       // currentTarget = new Coordinate(currentTarget.x+0.001,currentTarget.y)
                        return null //Todo: This might resolve in an error FIX IT
                    }
                   // else {
                   //     pathBroken = false
                        multiTargetRoute.add( routeService.repairEdges( pathEdges ) )
                        edgesToRender.addAll( pathEdges )}
               // }



           // }

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

    /**
     * calculates for the given fleet and the given targets a good root for every car, s.th. the total distance is as
     * small as possible and that every car has the same amount of targets
     * it uses optaplanner to get this solution.
     * @return
     */
    def calculateVrp(){
        Person person = (Person) springSecurityService.currentUser
        Company company = Company.get( person.company.id )
        if (!person) {

            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }
        VrpCommandObject cmd = new VrpCommandObject();
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
        //data.carTypeId = cmd.carTypeId
        CustomerPosition depot = new CustomerPosition(isDepot: true,lat: json.startPoint.y, lon: json.startPoint.x)
        if ( !depot.save( flush: true ) ) {
            log.error( "failed to save depot: ${depot.errors}" )
        }
        if (json.type == "lineRoute") {

            List<CustomerPosition> destinations = []//TODO look here

            int id = 0;
            json.destinationPoints.each {
                CustomerPosition customerPosition =  new CustomerPosition(isDepot: false,lat: it.y, lon: it.x)
                if ( !customerPosition.save( flush: true ) ) {
                    log.error( "failed to save customerPosition: ${customerPosition.errors}" )
                }
                destinations << customerPosition
                id++
            }
            CustomerPositionSet customerPositionSet = new CustomerPositionSet(company: company, depot: depot, customers: destinations)
            if ( !customerPositionSet.save( flush: true ) ) {
                log.error( "failed to save customerPositionSet: ${customerPositionSet.errors}" )
            }
            cmd.customerPositionSetId = customerPositionSet.id

            if (!cmd.validate()) {
                log.error("failed: ${cmd.errors}")
                return
            }

            VrpSolver vrpSolver = new VrpSolver(customerPositionSet, cmd.fleetId);
            VrpTracks vrpRouteTracks = vrpSolver.solveVrp();
            //now we have to calculate exact routes for the cars (we could also save them to VrpTracks)

            Fleet fleet = Fleet.get(cmd.fleetId)
            SimulationArea simulationArea = configurationService.getSimulationArea(cmd.configurationStubId)
            if(fleet.cars.size()!=vrpRouteTracks.optaTracks.size()){
                log.error("a bad error accured vrpRouteTracks has not the proper nr. of cars")
            }
            else {
                Stack<SingleVrpTracks> vrpTracksStack = new Stack<SingleVrpTracks>()
                vrpRouteTracks.optaTracks.each {vrpTracksStack.push(it)}
                for(Car car: fleet.cars){
                    def destinationsForCar = []
                    destinationsForCar.add(vrpRouteTracks.customerPositionSet.depot)
                    destinationsForCar.addAll(vrpTracksStack.pop().vrpRoute)
                    destinationsForCar.add(vrpRouteTracks.customerPositionSet.depot)
                    def pairs = destinationsForCar.collate(2,1,false)
                    List<List<BasicEdge>> multiTargetRoute = new ArrayList<List<BasicEdge>>()
                    data.routes = [];
                    data.type = "lineRoute"
                    pairs.each {
                        Coordinate currentStart = new Coordinate(it[0].lat,it[0].lon)
                        Coordinate currentTarget = new Coordinate(it[1].lat,it[1].lon)
                        List<BasicEdge> pathEdges = [];
                        if(currentStart.equals(currentTarget)){
                            log.error("start and target are same from: ${currentStart.x},${currentStart.y}  to: ${currentTarget.x},${currentTarget.y}")

                        }
                        else{
                            pathEdges = routeService.calculatePath(currentStart, currentTarget, simulationArea)
                            if (pathEdges.size() < 1) {
                                log.error("path broken.. from: ${currentStart.x},${currentStart.y}  to: ${currentTarget.x},${currentTarget.y}")
                                return null //Todo: This might resolve in an error FIX IT
                            }
                        }
                        multiTargetRoute.add( routeService.repairEdges( pathEdges ) )
                    }
                    routeService.persistRouteToCar( car, multiTargetRoute )

                }
                fleet.routesConfigured = true
                fleet.fleetStatus = FleetStatus.CONFIGURED
                fleet.simulationArea= simulationArea
                if ( !fleet.save( flush: true ) ) {
                    log.error( "failed to save fleet: ${fleet.errors}" )
                }
                data.fleet = fleet

            }
        }
        response.status = ResponseConstants.RESPONSE_STATUS_OK
        response.addHeader("Content-Type", "application/json");


        render "${(data as JSON).toString()}"
    }



    def configurator1 () {
        Person person = (Person) springSecurityService.currentUser

        if (!person) {
            redirect uri: SpringSecurityUtils.securityConfig.logout.filterProcessesUrl
            return
        }

        def m = [ : ]
        EditConfigurationStubCommandObject cmd = new EditConfigurationStubCommandObject()
        bindData(cmd, params)
        if (!cmd.validate() && cmd.hasErrors()) {

            log.error("failed to validate configuration stub: ${cmd.errors}")

        }

        Long configurationStubId
        if (cmd.configurationStubId == null) {
            configurationStubId = configurationService.createConfigurationStub(person).id;
        } else {
            configurationStubId = cmd.configurationStubId
        }
        m.configurationStubId = configurationStubId
        def json = request.JSON.data
        def data =[:]
        //simulation
        m.simulationName = configurationService.getSimulationName(configurationStubId)

        int dfkiId=10
        DfkiRoutesTimeStatus dfkiR
        int i;
        for (i=1; i<dfkiId; i++) {
             dfkiR= DfkiRoutesTimeStatus.get(i)


        }

        DfkiRoutesTimeStatus dfkiRoutesTimeStatus = new DfkiRoutesTimeStatus(
                lat: "lat",
                lon: "lon",
                speed: dfkiR.batterySoC
        )
        m.speed = dfkiRoutesTimeStatus.speed
        //def obuLat =  dfkiRoutesTimeStatus.lat
         //m.speed = dfkiRoutesTimeStatus.speed
        //m.lat = dfkiRoutesTimeStatus.lat
        //m.lon = dfkiRoutesTimeStatus.lon
        render view: 'configurator1', model: m
    }
}
