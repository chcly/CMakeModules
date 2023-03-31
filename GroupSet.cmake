# -----------------------------------------------------------------------------
#
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

function(rel_glob OUT PATTERN)
    
    file(GLOB TEMP_RES ${PATTERN})
    set(FIXUP)

    foreach(FN ${TEMP_RES})
        
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" REL ${FN})

        list(APPEND FIXUP ${REL})
    endforeach()
    set(${OUT} ${FIXUP} PARENT_SCOPE)
endfunction()


function(is_list INPUT IsList)

    string(FIND "${INPUT}" "," SplitIdx)
    if (SplitIdx GREATER_EQUAL 0)
        set(${IsList} TRUE PARENT_SCOPE)
    else()
        set(${IsList} FALSE PARENT_SCOPE)
    endif()

endfunction()

function(is_glob INPUT IsGlob)
    
    string(FIND "${INPUT}" "*" SplitIdx)
    set(Local)
    if (${SplitIdx} GREATER_EQUAL 0)
        set(Local TRUE)
    else()
        set(Local FALSE)
    endif()


    set(${IsGlob} ${Local} PARENT_SCOPE)
endfunction()

function(sanitize_as SRC OUT)

    string(REPLACE "//" "/" I1 ${SRC})
    string(REPLACE "\"" "" INPUT ${I1})
    
    set(${OUT} ${INPUT} PARENT_SCOPE)
endfunction()


function(find_split SRC SplitA SplitB RG IL)
    
    sanitize_as(${SRC} INPUT)
    string(FIND ${INPUT} ":" SplitIdx)

    set(SplitAR )
    set(SplitBR )
    set(RgR )
    set(IlR )


    if (SplitIdx GREATER_EQUAL 0)
        string(LENGTH ${INPUT}  TotalLen)
        math(EXPR SplitIdxN "${SplitIdx}+1")
        string(SUBSTRING  ${INPUT} 0            ${SplitIdx} ResultA)
        string(SUBSTRING  ${INPUT} ${SplitIdxN} ${TotalLen} ResultB)

        if (NOT ${ResultA} STREQUAL "")
            string(REPLACE "/" "\\\\" SplitAR ${ResultA})
        else()
            set(SplitAR FALSE)
        endif()

        if (NOT ${ResultB} STREQUAL "")
            set(SplitBR ${ResultB})

            is_glob(${ResultB} RgR)
            is_list(${ResultB} IlR)
        else()
            set(SplitBR FALSE)
            set(RgR FALSE)
            set(IlR)
        endif()
    else()

        set(SplitAR FALSE)
        set(SplitBR ${INPUT})

        is_glob(${INPUT} RgR)
        is_list(${INPUT} IlR)
    endif()

    set(${SplitA} ${SplitAR} PARENT_SCOPE)
    set(${SplitB} ${SplitBR} PARENT_SCOPE)
    set(${RG} ${RgR} PARENT_SCOPE)
    set(${IL} ${IlR} PARENT_SCOPE)

endfunction()



function(list_to_csv_string OUT)
    set(Local "")
    foreach(Arg ${ARGN})
        if (NOT Local STREQUAL "")
            set(Local "${Local},${Arg}")
        else()
            set(Local "${Arg}")
        endif()
    endforeach()
    
    set(${OUT} ${Local} PARENT_SCOPE)
endfunction()


function(csv_string_to_list OUT)
    
    string(REPLACE "," ";" Local ${ARGN})
    set(${OUT} ${Local} PARENT_SCOPE)
endfunction()



function(glob_csv OUT PATTERN)
    rel_glob(Semicolon ${PATTERN})
    list_to_csv_string(CSV ${Semicolon})

    set(${OUT} ${CSV} PARENT_SCOPE)
endfunction()


set(set_group_DEBUG FALSE)

function(set_group ProjectFiles)
    # Format 
    # Source/Group/Name1:Path/To/*.Pattern1
    # Source/Group/Name2:Path/To/*.Pattern2
    # ...
    set(Dest )
    

    foreach(PS ${ARGN})

        sanitize_as(${PS} PatternString)

        find_split(${PatternString} Group Input NeedsGlob IsList)

        if (set_group_DEBUG)
            message(STATUS "")
            message(STATUS "")
            message("${CMAKE_CURRENT_SOURCE_DIR}")
            message("find_split (")
            message(" ${PatternString}")
            message(")-> (${Group}, ${Input}, ${NeedsGlob}, ${IsList})")
        endif()

        if(NeedsGlob)
            rel_glob(PatternFiles ${Input})

            if (set_group_DEBUG)
                message("    (NeedsGlob)-> ${Input}")
                message("               -> ${PatternFiles}")
            endif()

        elseif(IsList)
            csv_string_to_list(DST ${Input})
            if (set_group_DEBUG)
                message("  (IsList)-> ${Input}")
                message("  (IsList)-> ${DST}")

            endif()

            set(PatternFiles ${DST})
        else()
            if (set_group_DEBUG)
                message("    (Input)-> ${Input}")
            endif()

            set(PatternFiles ${Input})
        endif()

        if (Group)
            source_group(${Group} FILES ${PatternFiles}) 
        endif()

        list(APPEND Dest ${PatternFiles})
    endforeach()

    set(${ProjectFiles} ${Dest} PARENT_SCOPE ) 
endfunction()


function(set_ro_group OutVAR)

    set_group(Local ${ARGN})

    set_source_files_properties(
        ${Local} 
        PROPERTIES 
        VS_TOOL_OVERRIDE "None"
        HEADER_FILE_ONLY TRUE
    )

    set(${OutVAR} ${Local} PARENT_SCOPE)
endfunction()
