package de.dfki.gs.jobs.routes

/**
 * Created by anbu02 on 15.05.15.
 */
class RouteDfkiJob {

    def routeDfkiFetcherService

    static triggers = {
        simple name:'RouteDfkiJobTest', startDelay:1000,repeatInterval: ( 10 *  3 * 1000 )
    }
    def group = "RouteDfkiGroup"

    def execute() {
        routeDfkiFetcherService.fetchData( "https://efahrung.cloudapp.net/EFahrungPlatform/vehicles/1b3d3519-1cd3-41a4-82c7-6692be9477a2/live" )

        println "RouteDFKI job finished at ${new Date()}"
    }
}



