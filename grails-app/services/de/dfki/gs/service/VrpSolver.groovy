package de.dfki.gs.service

import de.dfki.gs.domain.simulation.*

/**
 * Created by simon on 09.06.15.
 */
import de.dfki.gs.domain.users.Company
import de.dfki.gs.vehicleRoutingOptaplanner.domain.Customer
import de.dfki.gs.vehicleRoutingOptaplanner.domain.Depot
import de.dfki.gs.vehicleRoutingOptaplanner.domain.Vehicle
import de.dfki.gs.vehicleRoutingOptaplanner.domain.VehicleRoutingSolution
import de.dfki.gs.vehicleRoutingOptaplanner.domain.location.AirLocation
import de.dfki.gs.vehicleRoutingOptaplanner.domain.location.DistanceType
import de.dfki.gs.vehicleRoutingOptaplanner.domain.location.Location
import org.optaplanner.core.api.solver.Solver
import org.optaplanner.core.api.solver.SolverFactory

class VrpSolver {
    private long configurationId;

    public VrpSolver(configurationId){
        this.configurationId = configurationId;
    }





    //methods
    def setLocationList(customerPositionSet){
        //put depot location
        def customerListSize = customerPositionSet.customers.size()+1;//we only have one depot
        List<Location> customerLocationList = new ArrayList<Location>(customerListSize);
        Location location = new AirLocation();
        location.setId(customerPositionSet.depot.id)
        location.setLatitude(customerPositionSet.depot.lat)
        location.setLongitude(customerPositionSet.depot.lon)
        // Maybe to come later : location.setName
        customerLocationList.add(location);
       // locationMap.put(location.getId(), location);

        //put customers locations

        customerPositionSet.customers.each{it->
            Location customerLocation = new AirLocation();
            customerLocation.setId(it.id)
            customerLocation.setLatitude(it.lat)
            customerLocation.setLongitude(it.lon)

            customerLocationList.add(customerLocation);
        }
        return customerLocationList
    }

    //only if LocationList is there
    def setCustomerList(customerLocationList,customerPositionSet){
        List<Customer> customerList = new ArrayList<Customer>(customerLocationList.size() -1);
        customerLocationList.each {
            Customer customer = new Customer();
            customer.setId(it.id);
            customer.setLocation(it);
            if (it.id == customerPositionSet.depot.id){
                customer.setDemand(0);//this will be the base
            }
            else {
                customer.setDemand(1); //set a value for demand
                customerList.add(customer);
            }

        }
        return customerList
    }
    def setDepotList(customerLocationList,customerPositionSet){
        List<Depot> depotList = new ArrayList<Depot>(customerLocationList.size());
        Depot depot = new Depot();
        depot.setId(customerPositionSet.depot.id);
        Location location = customerLocationList.get(0);
        if (location == null) {
            throw new IllegalArgumentException("The depot with id (" + 1
                    + ") has no location (" + location + ").");
        }
        depot.setLocation(location);
        depotList.add(depot);
        return depotList
    }
    /**
     * Uses optaplanner to solve the given vehicle routing problem (vrp).
     * @return
     */
    public VrpTracks solveVrp(){

        //set up the solver
        Configuration configuration = Configuration.get(configurationId)
        CustomerPositionSet customerPositionSet = CustomerPositionSet.get(configuration.customerPositionSets.first().id)
        SolverFactory solverFactory = SolverFactory.createFromXmlResource(
                "de/dfki/gs/vehicleRoutingOptaplanner/resources/solver/vehicleRoutingSolverConfig.xml");
        Solver solver = solverFactory.buildSolver();

        //set up the solutionclass
        int numberOfCars = 0;
        configuration.fleets.each {
            Fleet fleet = Fleet.get(it.id)
            numberOfCars += fleet.cars.size()
        }
        Company company = Company.get(configuration.company.id)
        if (numberOfCars <= 0) {
            return null
        }

        VehicleRoutingSolution unsolvedVehicleRoutingSolution = new VehicleRoutingSolution();
        unsolvedVehicleRoutingSolution.setId(0L);
        unsolvedVehicleRoutingSolution.setName("Test Name 1");
        unsolvedVehicleRoutingSolution.setDistanceType(DistanceType.AIR_DISTANCE);
        unsolvedVehicleRoutingSolution.setDistanceUnitOfMeasurement("distance");

        def customerLocationList = setLocationList(customerPositionSet);
        unsolvedVehicleRoutingSolution.setLocationList(customerLocationList)
        def customerList = setCustomerList(customerLocationList,customerPositionSet);
        unsolvedVehicleRoutingSolution.setCustomerList(customerList)
        def depotList = setDepotList(customerLocationList,customerPositionSet);
        unsolvedVehicleRoutingSolution.setDepotList(depotList)
        List<Vehicle> vehicleList = new ArrayList<Vehicle>(numberOfCars);
        for (long id = 0; id < numberOfCars; id++) {
            Vehicle vehicle = new Vehicle();
            vehicle.setId(id);
            vehicle.setCapacity((int)Math.ceil((customerList.size())/numberOfCars));
            vehicle.setDepot(depotList.get(0));
            vehicleList.add(vehicle);
        }
        unsolvedVehicleRoutingSolution.setVehicleList(vehicleList);
        solver.solve(unsolvedVehicleRoutingSolution);
        VehicleRoutingSolution solvedVehicleRouting = (VehicleRoutingSolution) solver.getBestSolution();
        //now we need to convert this solution into vrpTracks
        VrpTracks vrpTracks = new VrpTracks(company: company, numberOfCars: numberOfCars,customerPositionSet: customerPositionSet);
        solvedVehicleRouting.vehicleList.each {
            SingleVrpTracks singleVrpTracks = new SingleVrpTracks()
            Customer customerForIt = it.nextCustomer
            while (customerForIt !=null) {
                singleVrpTracks.vrpRoute.add(CustomerPosition.get(customerForIt.id))
                customerForIt = customerForIt.nextCustomer
            }
            singleVrpTracks.save(flush: true)
            vrpTracks.optaTracks.add(singleVrpTracks)
        }
        vrpTracks.save(flush: true)
        return vrpTracks
    }
}
