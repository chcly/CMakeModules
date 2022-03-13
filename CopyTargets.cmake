# -----------------------------------------------------------------------------
#   Copyright (c) Charles Carley.
#
#   This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
#   Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
# 1. The origin of this software must not be misrepresented; you must not
#    claim that you wrote the original software. If you use this software
#    in a product, an acknowledgment in the product documentation would be
#    appreciated but is not required.
# 2. Altered source versions must be plainly marked as such, and must not be
#    misrepresented as being the original software.
# 3. This notice may not be removed or altered from any source distribution.
# ------------------------------------------------------------------------------

# =======================================
# copy_target  - copies the target's output to 
# the supplied destination directory.

macro(copy_target TargetName Destination)

    message(STATUS "${TargetName} => ${Destination}")
    
    add_custom_command(TARGET ${TargetName} 
                       POST_BUILD
                       COMMAND ${CMAKE_COMMAND} -E copy $<TARGET_FILE:${TargetName}> 
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
                    COMMAND ${CMAKE_COMMAND} -E copy ${InputFileAbs} ${OutFile}
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
           "${CMAKE_CURRENT_SOURCE_DIR}"
        )
    endif()

endmacro(copy_target)


