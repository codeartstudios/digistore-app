cmake_minimum_required(VERSION 3.16)

project(digistore-app VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick)

qt_standard_project_setup()

set(CMAKE_AUTORCC ON)

qt_add_executable(appdigistore
    src/main.cpp
    appsigistore.qrc
)

qt_add_qml_module(appdigistore
    URI ds
    VERSION 1.0
    SOURCES src/dscontroller.h src/dscontroller.cpp
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appdigistore PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appdigistore
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appdigistore
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appdigistore
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
