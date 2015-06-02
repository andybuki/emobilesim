package de.dfki.gs.domain

class Author {

    String name
    BigInteger minEstSales
    BigInteger maxEstSales
    String language
    String nrBooks
    String nationality

//    Date birthDate



    static constraints = {
        nationality blank: false
    }

    static mapping = {
        cache true
    }
}
