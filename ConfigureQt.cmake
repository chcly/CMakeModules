
macro(configure_qt_windows)
    set(QtConfig_HOME 
        $ENV{Qt6} CACHE STRING  
        "Should point to the Qt installation directory")

    set(QtConfig_VERSION 
        "6.4.1" CACHE STRING  
        "Should be defined as the locally installed Qt version.")

    set(QtConfig_BUILD 
        "msvc2019_64" CACHE STRING  
        "Should be defined as the current Qt build.")

    set(QtConfig_ROOT  
        "${QtConfig_HOME}\\${QtConfig_VERSION}\\${QtConfig_BUILD}" CACHE STRING 
        "Read only variable that should form the full path to the Qt installation" FORCE)

    set(CMAKE_PREFIX_PATH ${QtConfig_ROOT})
    find_package(Qt6 COMPONENTS 
        ${ARGN})
endmacro()

macro(configure_qt_linux)
    set(CMAKE_AUTOMOC ON)
    set(CMAKE_AUTORCC ON)

    find_package(Qt6 COMPONENTS ${ARGN})
endmacro()

function(add_qt_test_file FileName TargetName AutoRun)
    get_filename_component(V1 ${FileName} NAME_WE)

    include_directories(
        ${CMAKE_CURRENT_SOURCE_DIR} 
        ${CMAKE_CURRENT_BINARY_DIR} 
        )

    add_executable(
        ${TargetName} 
        "${V1}.cpp" 
        "${V1}.h"
    )

    target_link_libraries(
        ${TargetName} 
        Qt6::Widgets 
        Qt6::Core 
        Qt6::Gui 
        Qt6::Test 
        Qt::Platform
    )

    set_target_properties(
        ${TargetName} 
        PROPERTIES FOLDER "${TargetGroup}/Qt"
        WIN32_EXECUTABLE   OFF
    )
    
    if (AutoRun)
        add_custom_command(
            TARGET ${TargetName} POST_BUILD
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
            COMMAND  $<TARGET_FILE:${TargetName}>
        )
    endif()
endfunction()





function(copy_to_bin TargetName Bin)

    include(CopyTargets)
    # Include any third party DLLs temporally 
    # copied to the binary dir
    file(GLOB ExtraDeps ${CMAKE_BINARY_DIR}/*.dll)

    copy_target(${TargetName} ${Bin} ${ExtraDeps})

    if (WIN32)
        add_custom_command(
            TARGET ${TargetName} POST_BUILD
            COMMENT "runing windeployqt -> ${TargetName}"
            WORKING_DIRECTORY ${Bin}
            COMMAND Qt6::windeployqt  $<TARGET_FILE:${TargetName}>
        )
    endif()


endfunction()
