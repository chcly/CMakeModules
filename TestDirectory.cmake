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
#	const char *testFile = TestFile("test.txt")
# }
macro(gen_path_to_here)
	#if ( NOT EXISTS "${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h.in")
		file(WRITE "${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h.in"
			"#pragma once\n\n"
			"#cmakedefine CurrentBuildDirectory \"@CurrentBuildDirectory@/\"\n"
			"#cmakedefine CurrentSourceDirectory \"@CurrentSourceDirectory@/\"\n"
			"#cmakedefine BuildDirectory \"@BuildDirectory@/\"\n"
			"\n\n"
			"#define TestFile(name) CurrentSourceDirectory name\n"
			"#define OutputFile(name) CurrentBuildDirectory name\n"
			"#define TargetFile(name) BuildDirectory name\n"
		)
	#endif()

	set(CurrentSourceDirectory ${CMAKE_CURRENT_SOURCE_DIR})
	set(CurrentBuildDirectory  ${CMAKE_CURRENT_BINARY_DIR})
	set(BuildDirectory         ${CMAKE_BINARY_DIR})
	configure_file(
		${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h.in
		${CMAKE_CURRENT_BINARY_DIR}/ThisDir.h
	)
	include_directories(${CMAKE_CURRENT_BINARY_DIR})
	unset(CurrentSourceDirectory )
	unset(CurrentBuildDirectory  )
	unset(BuildDirectory         )
endmacro()
