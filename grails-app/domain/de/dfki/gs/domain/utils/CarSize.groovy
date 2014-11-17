package de.dfki.gs.domain.utils

/**
 * Created by glenn on 11.07.14.
 */
public enum CarSize {

    SMALL_CAR("Small car < 1400ccm"),
    MIDDLE_CAR("Middle car 1400 - 2000 ccm"),
    BIG_CAR("Big car > 2000 ccm"),
    TRANSPORTER ("Transporter > 3,5 t")


    final String value

    CarSize(String value) {
        this.value = value
    }

    String toString() {
        value
    }
}