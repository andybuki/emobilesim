package de.dfki.gs.controller.ms2.configuration

import de.dfki.gs.domain.Author
import org.grails.plugin.easygrid.Easygrid

@Easygrid
class AuthorController {

    static allowedMethods = [save: "POST", update: "POST", delete: "POST"]

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


    def classic(){

    }
}