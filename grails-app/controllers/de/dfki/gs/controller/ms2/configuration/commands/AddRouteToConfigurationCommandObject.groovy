package de.dfki.gs.controller.ms2.configuration.commands

import de.dfki.gs.domain.simulation.Configuration
import de.dfki.gs.domain.simulation.CustomerPositionSet
import grails.validation.Validateable

/**
 * Created by simon on 14.12.15.
 */
@Validateable
class AddRouteToConfigurationCommandObject
{
    Long configurationStubId
    Long customerPositionSetId

    static constraints = {

        configurationStubId nullable: false, validator: { val,obj ->

            Configuration stub = Configuration.get( val )

            if ( stub == null ) {
                return 'configuration.stub.not.exist'
            }


        }

        customerPositionSetId nullable: false, validator: { val,obj ->

            CustomerPositionSet customerPositionSet = CustomerPositionSet.get( val )

            if ( customerPositionSet == null ) {
                return 'configuration.fleet.not.exist'
            }

        }
    }
}
