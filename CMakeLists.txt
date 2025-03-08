cmake_minimum_required(VERSION 3.16)

project(digistoapp VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS
    Core
    Quick
    Widgets
    WebView
)

qt_standard_project_setup()

set(CMAKE_AUTORCC ON)
option(STANDALONE_SYSTEM "Enable standalone offline system" ON)

set(SOURCES
    src/main.cpp
    resources.qrc
    src/dscontroller.cpp src/dscontroller.h
    src/requests.cpp src/requests.h
    src/qaesencryption.h src/qaesencryption.cpp
    src/localserver.h src/localserver.cpp
    src/permissionmanager.h src/permissionmanager.cpp
)

if(STANDALONE_SYSTEM)
    add_compile_definitions(STANDALONE_SYSTEM)

    list(APPEND SOURCES
        src/localserver.h src/localserver.cpp
    )

    add_custom_target(copy_assets ALL
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/api ${CMAKE_BINARY_DIR}/api
    )
endif()

qt_add_executable(digisto ${SOURCES}
    src/singleinstanceguard.h src/singleinstanceguard.cpp
    pb/hooks/checkout.pb.js pb/hooks/dashboard.pb.js pb/hooks/main.pb.js pb/hooks/organization.pb.js pb/hooks/supply.pb.js pb/hooks/utils.js)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(digisto PROPERTIES
    MACOSX_BUNDLE_GUI_IDENTIFIER app.digisto
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(digisto
    PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::Widgets
    Qt6::WebView
)

include(GNUInstallDirs)
install(TARGETS digisto
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
