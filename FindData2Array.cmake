find_file(Data2Array_EXE NAMES Data2Array Data2Array.exe PATHS "$ENV{PATH}")

if (Data2Array_EXE)
    set(Data2Array_FOUND TRUE)
else()
    set(Data2Array_FOUND FALSE)
endif()