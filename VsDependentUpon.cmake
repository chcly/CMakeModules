# Allows grouping source files into contexts in visual studio
#
# For example:
# <LargeSourceFile.cpp>
#    <SpecificImpleientationFile1.inl>
#    <SpecificImpleientationFile2.inl>
#    <SpecificImpleientationFile3.inl>
# </LargeSourceFile.cpp>
# 
# LargeSourceFile.cpp
#    - Common Implementation 
#    - #include "SpecificImpleientationFile1.inl"
#    - #include "SpecificImpleientationFile2.inl"
#    - #include "SpecificImpleientationFile3.inl"
macro(vs_dependent_upon SourceTarget) # ARGN = Sub-targets

    if (MSVC)
        get_filename_component(AbsSourceTarget ${SourceTarget} ABSOLUTE)

        foreach(File ${ARGN})
            get_filename_component(AbsSubTarget ${File} ABSOLUTE)

            set_property(SOURCE 
                ${AbsSubTarget} 
                PROPERTY 
                VS_SETTINGS 
                "DependentUpon=${AbsSourceTarget}"
                )
            set_property(SOURCE 
                ${AbsSubTarget} 
                PROPERTY 
                HEADER_FILE_ONLY TRUE 
                )
        endforeach()
    endif()

endmacro(vs_dependent_upon)


