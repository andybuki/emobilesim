package de.dfki.gs.domain.utils

/**
 * Created by glenn on 11.07.14.
 */
public enum CitySize {

    LESS_20000("less than 20000"),
    FROM_20000_TO_100000("from 20,000 to 100,000"),
    MORE_100000 ("more 100000")

    final String value

    CitySize(String value) {
        this.value = value
    }

    String toString() {
        value
    }

}