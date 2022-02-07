# Copyright (C) 2017 Jonathan Müller <jonathanmueller.dev@gmail.com>
# This file is subject to the license terms in the LICENSE file
# found in the top-level directory of this distribution.

include(FetchContent)

#
# install type safe
#
find_package(type_safe QUIET)
if(NOT type_safe_FOUND)
    message(STATUS "Fetching type_safe")
    FetchContent_Declare(type_safe GIT_REPOSITORY https://github.com/foonathan/type_safe GIT_TAG origin/main)
    FetchContent_MakeAvailable(type_safe)
endif()

#
# install the tiny-process-library
#
find_package(Threads REQUIRED QUIET)

# create a target here instead of using the one provided
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/external/tpl)
add_library(_cppast_tiny_process INTERFACE)
target_include_directories(_cppast_tiny_process INTERFACE ${tiny_process_dir})
target_link_libraries(_cppast_tiny_process INTERFACE tiny-process-library::tiny-process-library Threads::Threads)

#
# install cxxopts, if needed
#
if(build_tool)
    set(CXXOPTS_BUILD_TESTS OFF CACHE BOOL "")

    message(STATUS "Fetching cxxopts")
    FetchContent_Declare(cxxopts URL https://github.com/jarro2783/cxxopts/archive/v2.2.1.zip)
    FetchContent_MakeAvailable(cxxopts)
endif()


#install llvm, clang through vcpkg

if(POLICY CMP0075)
  cmake_policy(SET CMP0075 NEW)
endif()
if(POLICY CMP0077)
  cmake_policy(SET CMP0077 NEW)
endif()


find_package(LLVM CONFIG REQUIRED)

list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
# include(HandleLLVMOptions)
# add_definitions(${LLVM_DEFINITIONS})
# Find the libraries that correspond to the LLVM components that we wish to use
# llvm_map_components_to_libnames(llvm_libs Core Support)

find_package(Clang CONFIG REQUIRED)

set(CLANG_LIBS
        libclang
        clangIndex
)

message(STATUS "Found Clang (LLVM version: ${LLVM_VERSION})")
message(STATUS "Include dirs: ${CLANG_INCLUDE_DIRS}")
message(STATUS "Clang libraries: ${CLANG_LIBS}")
