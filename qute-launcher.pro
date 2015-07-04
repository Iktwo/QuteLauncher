lessThan(QT_VERSION, "5.5.0") {
    error("Qt 5.5.0 or above is required.")
}

TEMPLATE = subdirs
CONFIG += ordered

SUBDIRS += \
    src

OTHER_FILES += \
    README.md
