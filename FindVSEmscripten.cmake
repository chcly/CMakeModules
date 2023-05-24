# VSEmscripten - needs removed 

# CMAKE_SYSTEM_NAME Emscripten is defined in their own toolset
string(COMPARE EQUAL "${CMAKE_SYSTEM_NAME}"  "Emscripten" _SystemNameEmscripten) 
string(COMPARE EQUAL "${CMAKE_VS_PLATFORM_TOOLSET}"  "emsdk"  _SystemToolsetEmscripten)



if(_SystemNameEmscripten OR _SystemToolsetEmscripten)
    set(USING_EMSCRIPTEN TRUE)

    if (_SystemNameEmscripten)
        set(USING_EMSCRIPTEN_STD TRUE)
    endif()

    include(VSEmscripten)
else()
    set(USING_EMSCRIPTEN FALSE)
endif()

unset(_SystemNameEmscripten)
unset(_SystemToolsetEmscripten)
