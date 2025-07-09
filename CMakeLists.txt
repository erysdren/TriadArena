cmake_minimum_required(VERSION 3.21)
project(TriadArena LANGUAGES C CXX)

#
# external dependencies
#

cmake_policy(SET CMP0077 NEW)
cmake_policy(SET CMP0135 NEW)

include(FetchContent)

FetchContent_Declare(
	fteqw
	GIT_REPOSITORY https://github.com/erysdren/fteqw.git
	GIT_TAG origin/rott
	EXCLUDE_FROM_ALL
)

FetchContent_Declare(
	librequake
	URL https://github.com/lavenderdotpet/LibreQuake/releases/download/v0.08-beta/mod.zip
	URL_HASH MD5=bf771328a559effba7542b8ba03cf59f
)

FetchContent_MakeAvailable(fteqw librequake)

# override suffix
if(NOT DEFINED CMAKE_SYSTEM_PROCESSOR)
	set(system_processor "unknown")
else()
	string(TOLOWER ${CMAKE_SYSTEM_PROCESSOR} system_processor)
endif()
if(CMAKE_SYSTEM_NAME STREQUAL "Windows")
	set_target_properties(fteqw fteqw-sv fteqcc PROPERTIES SUFFIX "_${system_processor}.exe")
else()
	set_target_properties(fteqw fteqw-sv fteqcc PROPERTIES SUFFIX ".${system_processor}")
endif()

# override where they end up
set_target_properties(fteqcc
	PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game/bin
		RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game/bin
)
set_target_properties(fteqw fteqw-sv plug_rott
	PROPERTIES
		LIBRARY_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game
		RUNTIME_OUTPUT_DIRECTORY ${PROJECT_SOURCE_DIR}/game
)

# copy librequake assets
add_custom_command(
	OUTPUT ${PROJECT_SOURCE_DIR}/game/lq1
	COMMAND ${CMAKE_COMMAND} -E copy_directory ${FETCHCONTENT_BASE_DIR}/librequake-src/lq1 ${PROJECT_SOURCE_DIR}/game/lq1
)
add_custom_target(librequake DEPENDS ${PROJECT_SOURCE_DIR}/game/lq1)

#
# qc code
#

define_property(TARGET PROPERTY QC_SOURCES INHERITED)

function(target_progs target name)
	cmake_parse_arguments(PARSE_ARGV 1 ARG "" "" "SOURCES;FLAGS")
	string(REPLACE "/" "-" output ${target}-${name})

	add_custom_command(
		OUTPUT ${PROJECT_SOURCE_DIR}/game/triadarena/${name}.dat
		DEPENDS fteqcc fteextensions ${PROJECT_SOURCE_DIR}/source/${name}.src
		IMPLICIT_DEPENDS C ${PROJECT_SOURCE_DIR}/source/${name}.src
		COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:fteqcc>" ${name}.src -v ${ARG_FLAGS} -o ${PROJECT_SOURCE_DIR}/game/triadarena/${name}.dat
		WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/source
		COMMAND_EXPAND_LISTS
		VERBATIM
	)
	add_custom_target(${output} DEPENDS ${PROJECT_SOURCE_DIR}/game/triadarena/${name}.dat)
	add_dependencies(${target} ${output})

	foreach(srcfile IN LISTS ARG_SOURCES)
		set_property(TARGET ${output} APPEND PROPERTY QC_SOURCES ${srcfile})
	endforeach()

	file(GENERATE
		OUTPUT ${PROJECT_SOURCE_DIR}/source/${name}.src
		CONTENT
[[#include $<QUOTE>$<LIST:JOIN,$<GENEX_EVAL:$<TARGET_PROPERTY:QC_SOURCES>>,$<QUOTE>
#include $<QUOTE>>$<QUOTE>
]]
		TARGET ${output}
	)
endfunction()

# fteextensions.qc
add_custom_command(
	OUTPUT ${PROJECT_SOURCE_DIR}/source/shared/fteextensions.qc
	DEPENDS fteqw
	COMMAND ${CMAKE_CROSSCOMPILING_EMULATOR} "$<TARGET_FILE:fteqw>" +pr_dumpplatform +quit
	COMMAND ${CMAKE_COMMAND} -E copy triadarena/src/fteextensions.qc ${PROJECT_SOURCE_DIR}/source/shared/fteextensions.qc
	COMMAND ${CMAKE_COMMAND} -E rm -r triadarena/src
	WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}/game
)
add_custom_target(fteextensions DEPENDS ${PROJECT_SOURCE_DIR}/source/shared/fteextensions.qc)

add_custom_target(quakec)
add_dependencies(quakec fteextensions)

# qwprogs.dat
target_progs(quakec qwprogs
	SOURCES
		shared/fteextensions.qc
		shared/defs.qc
		shared/utilities.qc
		darkwar/defs.qc
		darkwar/wad.qc
		darkwar/music.qc
		darkwar/rtl.qc
		darkwar/rott_map.qc
		server/defs.qc
		server/player.qc
		server/main.qc
		server/entities/info_player_start.qc
		server/entities/prop_disk.qc
		server/entities/worldspawn.qc
	FLAGS
		-DQWSSQC
		-DSERVER
		-Tfte_6614
		-Fassumeint
		-Fsubscope
		-Ffastarrays
		-Flo
)

# csprogs.dat
target_progs(quakec csprogs
	SOURCES
		shared/fteextensions.qc
		shared/defs.qc
		shared/utilities.qc
		darkwar/defs.qc
		darkwar/wad.qc
		darkwar/music.qc
		darkwar/rtl.qc
		darkwar/rott_map.qc
		client/defs.qc
		client/upload.qc
		client/chat.qc
		client/main.qc
	FLAGS
		-DCSQC
		-DCLIENT
		-Tfte_6614
		-Fassumeint
		-Fsubscope
		-Ffastarrays
		-Flo
)

# menu.dat
target_progs(quakec menu
	SOURCES
		shared/fteextensions.qc
		shared/defs.qc
		shared/utilities.qc
		darkwar/rtl.qc
		darkwar/fonts.qc
		menu/sui_sys.qc
		menu/defs.qc
		menu/mapcache.qc
		menu/widgets.qc
		menu/main.qc
	FLAGS
		-DMENU
		-Tfte_6614
		-Fassumeint
		-Fsubscope
		-Ffastarrays
		-Flo
)
