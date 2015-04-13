lessThan(QT_VERSION, "5.4.0") {
    error("Qt 5.4.0 or above is required.")
}

TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += \
    src

OTHER_FILES += \
    README.md
