package de.dfki.gs.vehicleRoutingOptaplanner.app

import de.dfki.gs.vehicleRoutingOptaplanner.domain.Customer
import de.dfki.gs.vehicleRoutingOptaplanner.domain.Depot
import de.dfki.gs.vehicleRoutingOptaplanner.domain.Vehicle
import de.dfki.gs.vehicleRoutingOptaplanner.domain.VehicleRoutingSolution
import de.dfki.gs.vehicleRoutingOptaplanner.domain.location.AirLocation
import de.dfki.gs.vehicleRoutingOptaplanner.domain.location.DistanceType
import de.dfki.gs.vehicleRoutingOptaplanner.domain.location.Location
import de.dfki.gs.vehicleRoutingOptaplanner.domain.location.RoadLocation
import org.optaplanner.core.api.solver.Solver
import org.optaplanner.core.api.solver.SolverFactory

/**
 * Created by simon on 05.06.15.
 */
class VehicleRoutingGetRoute {
    public static void main(String[] args) {
        // Build the Solver
        SolverFactory solverFactory = SolverFactory.createFromXmlResource(
                "de/dfki/gs/vehicleRoutingOptaplanner/resources/solver/vehicleRoutingSolverConfig.xml");
        Solver solver = solverFactory.buildSolver();
        int customerListSize = 4;
        int capacity = 100;

        List<Location> customerLocationList = new ArrayList<Location>(customerListSize);
        Map<Long, Location> locationMap= new LinkedHashMap<Long, Location>(customerListSize);

        VehicleRoutingSolution unsolvedVehicleRoutingSolution = new VehicleRoutingSolution();
        unsolvedVehicleRoutingSolution.setId(0L);
        unsolvedVehicleRoutingSolution.setName("Test Name 1");
        unsolvedVehicleRoutingSolution.setDistanceType(DistanceType.AIR_DISTANCE);
        unsolvedVehicleRoutingSolution.setDistanceUnitOfMeasurement("distance");

        //this will be a loop where all the locations are set.
        def latitudeList = [52.524584,52.525349,52.509403,52.504894];
        def longitudeList = [13.344351,13.368968,13.376146,13.278149];
        def nameList = ["DFKI Projektbüro","HBF","Podsdamer Platz","Messe Berlin"];
        for (int i = 0; i < customerListSize; i++) {
            Location location = new AirLocation();
            location.setId((Long) i+1);
            location.setLatitude(latitudeList[i]);
            location.setLongitude(longitudeList[i]);
            location.setName(nameList[i]);
            customerLocationList.add(location);
            locationMap.put(location.getId(), location);
        }

        unsolvedVehicleRoutingSolution.setLocationList(customerLocationList)

        //create Customer List
        List<Customer> customerList = new ArrayList<Customer>(customerListSize);
        for (int i = 0; i < customerListSize; i++) {
            Customer customer = new Customer();
            customer.setId(i+1);
            Location location = locationMap.get((Long)(i+1));
            if (location == null) {
                throw new IllegalArgumentException("The location with id (" + (i+1) + ") does not exist.");
            }
            customer.setLocation(location);
            if (i==0){
                customer.setDemand(0);//this will be the base
            }
            else {
                customer.setDemand(50); //set a value for demand
            }
            if (/*demand != 0*/i!=0) {
                customerList.add(customer);
            }
        }
        unsolvedVehicleRoutingSolution.setCustomerList(customerList);

        // create depot list
        List<Depot> depotList = new ArrayList<Depot>(customerListSize);
        //here should come a part where the depots are set. now its by default just the first in the customer list
        Depot depot = new Depot();
        depot.setId(1);
        Location location = locationMap.get(1L);
        if (location == null) {
            throw new IllegalArgumentException("The depot with id (" + 1
                    + ") has no location (" + location + ").");
        }
        depot.setLocation(location);
        depotList.add(depot);

        unsolvedVehicleRoutingSolution.setDepotList(depotList);
        //add vehicles
        int vehicleListSize = 2;
        List<Vehicle> vehicleList = new ArrayList<Vehicle>(vehicleListSize);
        long id = 0;
        for (int i = 0; i < vehicleListSize; i++) {
            Vehicle vehicle = new Vehicle();
            vehicle.setId(id);
            id++;
            vehicle.setCapacity(capacity);
            vehicle.setDepot(depotList.get(0));
            vehicleList.add(vehicle);
        }
        unsolvedVehicleRoutingSolution.setVehicleList(vehicleList);


        // Solve the problem
        solver.solve(unsolvedVehicleRoutingSolution);
        VehicleRoutingSolution solvedVehicleRouting = (VehicleRoutingSolution) solver.getBestSolution();

        // Display the result
        System.out.println("\nSolved vehicleRoutingSolution with 4 customers and 2 vehicles\n"
                /*+ toDisplayString(solvedVehicleRouting)*/);

    }

    public static String toDisplayString(VehicleRoutingSolution vehicleRoutingSolution) {
        StringBuilder displayString = new StringBuilder();
        for (Depot depot : vehicleRoutingSolution.getDepotList()) {

            displayString.append("  ").append(depot.getId()).append(" -> ").append("\n");

        }
        return displayString.toString();
    }
}
