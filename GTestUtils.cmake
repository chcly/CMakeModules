
# =======================================
# configure_gtest - sets up gtest paths from the supplied paths 
 
macro(configure_gtest SRC INC)
    set(BUILD_GMOCK   OFF CACHE BOOL "" FORCE)
    set(INSTALL_GTEST OFF CACHE BOOL "" FORCE)
    set(GTEST_DIR     ${SRC})
    set(GTEST_INCLUDE ${INC})
    set(GTEST_LIBRARY gtest_main)

    #message(STATUS "Using gtest source and include paths")
    #message(STATUS "GTEST_DIR      : ${SRC}")
    #message(STATUS "GTEST_INCLUDE  : ${INC}")
endmacro(configure_gtest)


 
# =======================================
# add_gtest_source - adds the gtest source directory to the build and groups 
# it into the supplied group folder.
# Assumes that a gtest submodule repository is in a 
# ${CMAKE_SOURCE_DIR}/Test/googletest/ directory 
macro(add_gtest_source GroupName)
  
    set(TargetGroup ${GroupName})
    add_subdirectory(${GTEST_DIR})
    set_target_properties(gtest_main PROPERTIES FOLDER "${TargetGroup}")
    set_target_properties(gtest      PROPERTIES FOLDER "${TargetGroup}")
   
endmacro(add_gtest_source)


# =======================================
# run_test - executes the supplied target after a successful build

macro(run_test TargetName)
    add_custom_command(
        TARGET ${TargetName} POST_BUILD
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        COMMAND  $<TARGET_FILE:${TargetName}>
    )

    set_target_properties(
        ${TargetName} 
        PROPERTIES 
        VS_DEBUGGER_WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
    )
endmacro(run_test)


