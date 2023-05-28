# =======================================
# copy_target  - copies the target's output to 
# the supplied destination directory.

macro(copy_target TargetName Destination)

    message(STATUS "${TargetName} => ${Destination}")
    
    add_custom_command(TARGET ${TargetName} 
                       POST_BUILD
                       COMMAND ${CMAKE_COMMAND} -E copy_if_different $<TARGET_FILE:${TargetName}> 
                       "${Destination}/$<TARGET_FILE_NAME:${TargetName}>"
                       COMMENT "Copy  ${Destination}/${TargetName}"
                       )

    # Allow for optional files.

    foreach(File ${ARGN})
        get_filename_component(InputFileAbs ${File} ABSOLUTE)
        get_filename_component(InputFileBaseName ${File} NAME)
        get_filename_component(InputFileTar ${File} NAME_WE)

        set(OutFile "${Destination}/${InputFileBaseName}")

        ## message(STATUS "${InputFileAbs} => ${OutFile}")

        add_custom_command(TARGET ${TargetName} 
                    POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy_if_different ${InputFileAbs} ${OutFile}
                    )

    endforeach()

    if (MSVC)

        # Setup debugging from 
        # destination directory.

        set_target_properties(
            ${TargetName} 
            PROPERTIES 
            VS_DEBUGGER_COMMAND  
           "${Destination}/$<TARGET_FILE_NAME:${TargetName}>"
        )

        set_target_properties(
            ${TargetName} 
            PROPERTIES 
            VS_DEBUGGER_WORKING_DIRECTORY  
           "${Destination}"
        )
    endif()

endmacro(copy_target)


