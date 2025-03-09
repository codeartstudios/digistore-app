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
    src/globals.h
    src/dscontroller.cpp src/dscontroller.h
    src/requests.cpp src/requests.h
    src/qaesencryption.h src/qaesencryption.cpp
    src/localserver.h src/localserver.cpp
    src/permissionmanager.h src/permissionmanager.cpp
    src/singleinstanceguard.h src/singleinstanceguard.cpp
)

if(STANDALONE_SYSTEM)
    set(BUILD_MODE "standalone")
    add_compile_definitions(STANDALONE_SYSTEM)

    list(APPEND SOURCES
        src/localserver.h
        src/localserver.cpp
        pb/hooks/checkout.pb.js
        pb/hooks/dashboard.pb.js
        pb/hooks/main.pb.js
        pb/hooks/organization.pb.js
        pb/hooks/supply.pb.js
        pb/hooks/utils.js
    )

add_custom_target(copy_assets ALL
    COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/api ${CMAKE_BINARY_DIR}/api
)
else()
    set(BUILD_MODE "client")
endif()

if (WIN32)
    set(APP_ICON_RESOURCE_FILES icon.rc)
    list(APPEND SOURCES ${APP_ICON_RESOURCE_FILES})
endif()

qt_add_executable(digisto ${SOURCES})

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

# Build Assets
# Set output directory format <platform>-<build type>
if (WIN32)
    set(PLATFORM_NAME "win64")
elseif (UNIX)
    set(PLATFORM_NAME "linux")
else()
    set(PLATFORM_NAME "unknown")
endif()

# Add debug/release tag on folder
if(CMAKE_BUILD_TYPE STREQUAL "Debug")
    set(BUILD_TYPE "-debug")
else()
    set(BUILD_TYPE "")
endif()

# Output directory for gathering dependencies
set(OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/build/digisto-${BUILD_MODE}-${PLATFORM_NAME}${BUILD_TYPE}")
set(ZIP_OUTPUT, "${CMAKE_CURRENT_SOURCE_DIR}/build")

# Ensure the output directory exists
file(MAKE_DIRECTORY ${OUTPUT_DIR})

# Copy the binary after build
add_custom_command(TARGET digisto POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:digisto> ${OUTPUT_DIR}/
    COMMENT "📂 Copying binary to ${OUTPUT_DIR}/"
)

# Copy pocketbase as well for standalone systems
if(STANDALONE_SYSTEM)
    add_custom_target(copy_assets_ext ALL
        COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_SOURCE_DIR}/api ${OUTPUT_DIR}/api
    )
endif()

# ------------------------------------------------------------ #
# DEPLOYMENT SECTION                                           #
# ------------------------------------------------------------ #

# Set directory that contains QML files
set(QMLDIR ${CMAKE_SOURCE_DIR}/ui)

# WINDEPLOYQT_EXECUTABLE
# CMAKE_PREFIX_PATH

# Deploy for win32
if (WIN32)

    set(QT_BIN_DIR "${CMAKE_PREFIX_PATH}/bin")
    set(QTPATHS "${QT_BIN_DIR}/qtpaths.exe")
    set(WINDEPLOYQT_BIN "${QT_BIN_DIR}/windeployqt.exe")

    # Set output directory for deployment
    set(DEPLOY_DIR "${OUTPUT_DIR}")
    file(MAKE_DIRECTORY ${DEPLOY_DIR})

    # Copy icon assets
    add_custom_command(TARGET digisto POST_BUILD
        COMMAND ${CMAKE_COMMAND} -E copy "${CMAKE_SOURCE_DIR}/assets/imgs/logo.ico" "${DEPLOY_DIR}/"
        COMMENT "📂 Copying logo.ico to deploy directory"
    )

    # Run windeployqt to deploy dependencies
    add_custom_command(TARGET digisto POST_BUILD
        COMMAND ${WINDEPLOYQT_BIN} --qmldir ${QMLDIR} --qtpaths ${QTPATHS} --dir ${DEPLOY_DIR} "${DEPLOY_DIR}/digisto.exe"
        COMMENT "🚀 Running windeployqt..."
    )

# Run windeployqt to deploy dependencies
add_custom_command(TARGET digisto POST_BUILD
    COMMAND ${CMAKE_COMMAND} -E tar "cf" ${ZIP_OUTPUT} --format=zip ${DEPLOY_DIR}
    COMMENT "Zipping folder ..."
)

endif()
