package de.dfki.gs.domain.utils

/**
 * Created by glenn on 11.07.14.
 */
public enum CompanySize {

    UNDER_10("under 10"),
    FROM_10_TO_50("from 10 to 50"),
    FROM_51_TO_250("from 51 to 250"),
    FROM_251_TO_1000 ("from 251 to 1000"),
    FROM_1001_TO_5000 ("from 1001 to 5000"),
    MORE_5000 ("more 5000")

    final String value

    CompanySize(String value) {
        this.value = value
    }

    String toString() {
        value
    }

}