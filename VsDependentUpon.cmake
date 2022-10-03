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


