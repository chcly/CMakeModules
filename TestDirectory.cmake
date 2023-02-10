# gen_path_to_here() 
#
# Generates a header in the binary directory
# which points to the corresponding source 
# directory. 
# 
# 
# #include "ThisDir.h" 
#
# void runTest()
# {
#	const char *testFile = AbsTestFile("test.txt")
# }
macro(gen_path_to_here)
	if (NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h.in")
		file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h.in"
			"#pragma once\n#cmakedefine AbsDir \"@AbsDir@/\"\n"
			"#define AbsTestFile(name) AbsDir name\n"
		)
	endif()

	set(AbsDir ${CMAKE_CURRENT_SOURCE_DIR})
	configure_file(
		${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h.in
		${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h
	)
	include_directories(${CMAKE_CURRENT_BINARY_DIR})
	unset(AbsDir)
endmacro()
