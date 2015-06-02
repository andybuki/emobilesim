package de.dfki.gs.domain.sec

class Rolen {

    String authority

    static mapping = {
        cache true
    }

    static constraints = {
        authority blank: false, unique: true
    }
}