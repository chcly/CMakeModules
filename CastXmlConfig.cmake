set(CastXML_EXE      $ENV{CASTXML} CACHE PATH  "")
set(CastXML_VERSION  "1.4.0"       CACHE PATH  "")
set(CastXML_CC       "msvc"        CACHE PATH  "")
set(CastXML_CC_TOOL  "cl"          CACHE PATH  "")

if (EXISTS ${CastXML_EXE})
    set(CastXML_FOUND TRUE)
else()
    set(CastXML_FOUND FALSE)
endif()

macro(cast_xml_include)
    unset(CastXML_INCLUDE)

    set(CastXML_INCLUDE_DIRS)
    foreach(INP ${ARGN})
        list(APPEND CastXML_INCLUDE_DIRS -I ${INP})
    endforeach()
    unset(INP)
endmacro()


macro(cast_xml_cxx_flags)
    unset(CastXML_CXX_FLAGS)

    set(CastXML_CXX_FLAGS)
    foreach(INP ${ARGN})
        list(APPEND CastXML_CXX_FLAGS ${INP})
    endforeach()
    unset(INP)
endmacro()


macro(cast_xml_symbols)
    unset(CastXML_SYMBOLS)
    set(CastXML_SYMBOLS "")
    foreach(INP ${ARGN})
        if (NOT CastXML_SYMBOLS STREQUAL "")
            set(CastXML_SYMBOLS "${INP},${CastXML_SYMBOLS}")
        else()
            set(CastXML_SYMBOLS "${INP}")
        endif()
    endforeach()
    unset(INP)
endmacro()

macro(cast_transfer_dir)
    unset(CastXML_TRANSFER)
    set(CastXML_TRANSFER ${ARGN})
endmacro()

macro(cast_build_dependencies)
    unset(CastXML_BUILD_DEP)

    set(CastXML_BUILD_DEP )
    foreach(INP ${ARGN})
        list(APPEND CastXML_BUILD_DEP ${INP})
    endforeach()
    unset(INP)
endmacro()

function(invoke_cast_xml RESULT INPUT_SRC_FILE)

    string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" INPUT_SRC_REL ${INPUT_SRC_FILE})

    get_filename_component(INPUT_SRC_NAME ${INPUT_SRC_FILE} NAME_WE)
    get_filename_component(INPUT_SRC_PATH ${INPUT_SRC_FILE} PATH)


    # Build depends on the input source file
    set(INPUT_DEP ${INPUT_SRC_FILE})

    # Optionally make the build implicitly depend on 
    # the input source header if it exists
    if (EXISTS "${INPUT_SRC_PATH}/${INPUT_SRC_NAME}.h")
        list (APPEND INPUT_DEP "${INPUT_SRC_PATH}/${INPUT_SRC_NAME}.h")
    endif()

    list(APPEND INPUT_DEP ${CastXML_BUILD_DEP})


    # Go to the binary dir by default
    if (CastXML_TRANSFER)
        set(OUTPUT_SRC_DIR  "${CastXML_TRANSFER}")
    else()
        set(OUTPUT_SRC_DIR  "${CMAKE_CURRENT_BINARY_DIR}")
    endif()

    set(OUTPUT_SRC_NAME "${INPUT_SRC_NAME}.xml")
    set(OUTPUT_SRC_FILE "${OUTPUT_SRC_DIR}/${OUTPUT_SRC_NAME}")


    

    add_custom_command(
	    OUTPUT  ${OUTPUT_SRC_FILE}
	    COMMENT "CastXML -> ${OUTPUT_SRC_NAME}"
        WORKING_DIRECTORY ${OUTPUT_SRC_DIR}
	    COMMAND ${CastXML_EXE} 
                --castxml-start "${CastXML_SYMBOLS}"
                --castxml-output=${CastXML_VERSION} 
                --castxml-cc-${CastXML_CC} ${CastXML_CC_TOOL}
                -o ${OUTPUT_SRC_FILE} 
                ${CastXML_CXX_FLAGS}
                ${CastXML_INCLUDE_DIRS}
                ${INPUT_SRC_REL}
        DEPENDS ${INPUT_DEP}
    )


    set_source_files_properties(${OUTPUT_SRC_FILE} PROPERTIES GENERATED TRUE )
    set(${RESULT} ${OUTPUT_SRC_FILE} PARENT_SCOPE)
endfunction()

function(add_cast_xml RESULT)

    set(TEMP_RES )
    foreach(SRC ${ARGN})
        invoke_cast_xml(OUT ${SRC})
        list(APPEND TEMP_RES ${OUT})
    endforeach()

    set(${RESULT} ${TEMP_RES} PARENT_SCOPE)
endfunction()




function(extract_source OUT SRC_DIR)
    file(GLOB  SOURCE_FILES  ${SRC_DIR}/*.cpp)

    set(TEMP_RES )
    foreach(SRC ${SOURCE_FILES})
        get_filename_component(SRC_ABS ${SRC} ABSOLUTE)
        list(APPEND TEMP_RES ${SRC_ABS})
    endforeach()

    set(${OUT} ${TEMP_RES} PARENT_SCOPE)
endfunction()


