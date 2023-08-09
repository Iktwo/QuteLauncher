cmake_minimum_required(VERSION 3.16)

project(QuteLauncher VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

set(CMAKE_AUTORCC ON)

qt_add_executable(qute-launcher
    src/src/main.cpp
    src/src/application.cpp
    src/src/applicationinfo.cpp
    src/src/iconimageprovider.cpp
    src/src/launcher.cpp
    src/src/packagemanager.cpp
    src/src/screenvalues.cpp
    src/src/system.cpp
    src/src/application.h
    src/src/applicationinfo.h
    src/src/iconimageprovider.h
    src/src/launcher.h
    src/src/packagemanager.h
    src/src/screenvalues.h
    src/src/system.h
    src/resources.qrc
)

qt_add_qml_module(qute-launcher
    URI QuteLauncher
    VERSION 1.0
    QML_FILES
        src/qml/main.qml
    RESOURCES
        src/qml/config/qmldir
        src/qml/debug/qmldir
        src/qml/themes/tiles/qmldir
        src/qml/components/qmldir
    RESOURCE_PREFIX
        /qml
)

set(QT_QML_IMPORT_PATH
    "${CMAKE_SOURCE_DIR}/src/qml"
    "${CMAKE_SOURCE_DIR}/src/qml/config")

set_target_properties(qute-launcher PROPERTIES
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR ${CMAKE_SOURCE_DIR}/src/android/
)

target_link_libraries(qute-launcher
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS qute-launcher
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
