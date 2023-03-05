macro(TARGET_DEBUG TargetName DIR) 
    if (MSVC)
        set_target_properties(
            ${TargetName} 
            PROPERTIES  VS_DEBUGGER_WORKING_DIRECTORY ${DIR}
        )

        if (${ARGC} GREATER 2)
            set_target_properties(
               ${TargetName} 
               PROPERTIES  VS_DEBUGGER_COMMAND_ARGUMENTS ${ARGV2}
            )
        endif()
    endif()
endmacro()



