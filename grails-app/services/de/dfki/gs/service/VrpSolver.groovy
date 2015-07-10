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
    CustomerPositionSet customerPositionSet;
    private long fleetId;
    private int customerListSize = customerPositionSet.customers.size()+1;//we only have one depot

    private List<Location> customerLocationList = new ArrayList<Location>(customerListSize);
    //private Map<Long, Location> locationMap= new LinkedHashMap<Long, Location>(customerListSize);

    private List<Customer> customerList = new ArrayList<Customer>(customerListSize-1);
    private List<Depot> depotList = new ArrayList<Depot>(customerListSize);
    //constructor
    public VrpSolver(CustomerPositionSet customerPositionSet, long fleetId){
        this.customerPositionSet = customerPositionSet;
        this.fleetId = fleetId;
    }





    //methods
    private void setLocationList(){
        //put depot location
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
    }

    //only if LocationList is there
    private void setCustomerList(){
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
    }
    private  void setDepotList(){
        Depot depot = new Depot();
        depot.setId(customerPositionSet.depot.id);
        Location location = customerLocationList.get(0);
        if (location == null) {
            throw new IllegalArgumentException("The depot with id (" + 1
                    + ") has no location (" + location + ").");
        }
        depot.setLocation(location);
        depotList.add(depot);
    }
    /**
     * Uses optaplanner to solve the given vehicle routing problem (vrp).
     * @return
     */
    public VrpTracks solveVrp(){

        //set up the solver
        SolverFactory solverFactory = SolverFactory.createFromXmlResource(
                "de/dfki/gs/vehicleRoutingOptaplanner/resources/solver/vehicleRoutingSolverConfig.xml");
        Solver solver = solverFactory.buildSolver();

        //set up the solutionclass
        Fleet fleet = Fleet.get(fleetId)
        Company company = Company.get(fleet.getCompany().id)
        int numberOfCars = fleet.cars.size();
        if (numberOfCars <= 0) {
            return null
        }

        VehicleRoutingSolution unsolvedVehicleRoutingSolution = new VehicleRoutingSolution();
        unsolvedVehicleRoutingSolution.setId(0L);
        unsolvedVehicleRoutingSolution.setName("Test Name 1");
        unsolvedVehicleRoutingSolution.setDistanceType(DistanceType.AIR_DISTANCE);
        unsolvedVehicleRoutingSolution.setDistanceUnitOfMeasurement("distance");

        setLocationList();
        unsolvedVehicleRoutingSolution.setLocationList(customerLocationList)
        setCustomerList();
        unsolvedVehicleRoutingSolution.setCustomerList(customerList)
        setDepotList();
        unsolvedVehicleRoutingSolution.setDepotList(depotList)
        List<Vehicle> vehicleList = new ArrayList<Vehicle>(numberOfCars);
        for (long id = 0; id < numberOfCars; id++) {
            Vehicle vehicle = new Vehicle();
            vehicle.setId(id);
            vehicle.setCapacity((int)Math.ceil((customerListSize-1)/numberOfCars));
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
