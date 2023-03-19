
macro(configure_qt_windows)
    set(QtConfig_HOME 
        $ENV{Qt6} CACHE STRING  
        "Should point to the Qt instaliation directory")

    set(QtConfig_VERSION 
        "6.4.1" CACHE STRING  
        "Should be defined as the locally installed Qt version.")

    set(QtConfig_BUILD 
        "msvc2019_64" CACHE STRING  
        "Should be defined as the current Qt build.")

    set(QtConfig_ROOT  
        "${QtConfig_HOME}\\${QtConfig_VERSION}\\${QtConfig_BUILD}" CACHE STRING 
        "Read only variable that should form the full path to the Qt instalation" FORCE)

    set(CMAKE_PREFIX_PATH ${QtConfig_ROOT})
    find_package(Qt6 COMPONENTS 
        ${ARGN})
endmacro()
