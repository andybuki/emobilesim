package de.dfki.gs.service.datafetching

import de.dfki.gs.domain.DfkiRoutesTimeStatus
import groovyx.net.http.RESTClient

import java.text.SimpleDateFormat


/**
 * Created by anbu02 on 15.05.15.
 */
class RouteDfkiFetcherService {

    def fetchData(String urlDfkiRouteString ) {
        InputStream urlStreamRouteDfki = null;
        URL urlDfkiRoute = null;

        try {
            urlDfkiRoute = new URL( urlDfkiRouteString );
            def client = new RESTClient()
            client.ignoreSSLIssues()
            def routeDfkiFetcherServices = client.get(uri: urlDfkiRouteString,
                    headers: ['Authorization': "Basic dXNpOmRldmVs" , "Accept": "application/json"])

            Map jsonResultDfkiRoute = (Map) routeDfkiFetcherServices.responseData

            int batterySoC  = (int) jsonResultDfkiRoute.get("batterySoC")
            int chargingMode = (int) jsonResultDfkiRoute.get("chargingMode")

            int guid = (int) jsonResultDfkiRoute.get("guid")
            boolean ignitionOn = (Boolean)jsonResultDfkiRoute.get("ignitionOn")
            int mileage = (int) jsonResultDfkiRoute.get("mileage")
            Map position  = (Map) jsonResultDfkiRoute.get("position")
            double latitude = (double) position.get("latitude")
            double longitude = (double) position.get("longitude")
            String recordedWhen = (String)  jsonResultDfkiRoute.get("recordedWhen")

            SimpleDateFormat formatter = new SimpleDateFormat("MMMM d, yyyy HH:mm")
            int secondsR = Integer.parseInt(recordedWhen)

            String recordedData = formatter.format(new Date(secondsR * 1000L))
            int remainingRange = (int)jsonResultDfkiRoute.get("remainingRange")
            int speed = (int)jsonResultDfkiRoute.get("speed")
            String updatedWhen = (String)  jsonResultDfkiRoute.get("updatedWhen")
            int secondsU = Integer.parseInt(updatedWhen)
            String updatedData = formatter.format(new Date(secondsU * 1000L))
            String vehicle = (String)jsonResultDfkiRoute."vehicle"

            try {
                //DfkiRoutesTimeStatus dfkiRoutes = DfkiRoutesTimeStatus.findAllByGuid(guid)

                /*if (!dfkiRoutes) {
                    dfkiRoutes = new DfkiRoutes(
                            guid: guid,
                            vehicle: vehicle

                    )

                    if ( !dfkiRoutes.save(flush:true, validate:false) ) {
                        log.error( "failed to save new carSharing: ${dfkiRoutes.errors}" )
                    }
                }*/

                //if (!dfkiRoutes) {

                    DfkiRoutesTimeStatus status = new DfkiRoutesTimeStatus(
                            guid: guid,
                            vehicle: vehicle,
                            batterySoC: batterySoC,
                            chargingMode: chargingMode,
                            ignitionOn: ignitionOn,
                            mileage: mileage,
                            speed: speed,
                            remainingRange: remainingRange,
                            lat: latitude,
                            lon: longitude,
                            recordedData: recordedData,
                            updatedData: updatedData
                    )

                    if (status.save()) {
                        log.error("failed to save time status: ${status.errors}")

                    } else {
                        log.debug("saved: ${status.properties}")
                    //}

                }
            } catch ( NumberFormatException nfe ) {
                log.error( "cound't  convert String to number", nfe )
            }

        } catch (MalformedURLException mue) {
            log.error( "couldn't create url from ${urlDfkiRouteString}", mue )
        }   finally {
            if (urlStreamRouteDfki != null) {
                urlStreamRouteDfki.close();
            }
        }
    }

}
