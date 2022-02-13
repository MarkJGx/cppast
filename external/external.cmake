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



#install clang

if(POLICY CMP0075)
  cmake_policy(SET CMP0075 NEW)
endif()
if(POLICY CMP0077)
  cmake_policy(SET CMP0077 NEW)
endif()


if(WIN32)
  if(MSVC)
    set(CLANG_STATIC_BUILD_URL https://download.qt.io/development_releases/prebuilt/libclang/qt/libclang-release_120-based-windows-vs2019_64.7z)
  elseif(MINGW)
    # not tested
    set(CLANG_STATIC_BUILD_URL https://download.qt.io/development_releases/prebuilt/libclang/qt/libclang-release_120-based-windows-mingw_64.7z)
  endif()
elseif(APPLE)
  # not tested
  set(CLANG_STATIC_BUILD_URL https://download.qt.io/development_releases/prebuilt/libclang/qt/libclang-release_120-based-mac.7z)
elseif(UNIX)
  # not tested (defaults to Ubuntu, CentOS also a thing https://download.qt.io/development_releases/prebuilt/libclang/qt/libclang-release_110-based-linux-Rhel7.6-gcc5.3-x86_64.7z)
  set(CLANG_STATIC_BUILD_URL https://download.qt.io/development_releases/prebuilt/libclang/qt/libclang-release_120-based-linux-Ubuntu20.04-gcc9.3-x86_64.7z)
endif()

message(STATUS "Fetching libclang (QT fork, static build) ${CLANG_STATIC_BUILD_URL}")
set(LIBCLANG_ARCHIVE "${CMAKE_BINARY_DIR}/external/libclang-release_120.7z")
if (NOT EXISTS "${LIBCLANG_ARCHIVE}")
  file(DOWNLOAD "${CLANG_STATIC_BUILD_URL}" "${LIBCLANG_ARCHIVE}" SHOW_PROGRESS)
  execute_process(COMMAND ${CMAKE_COMMAND} -E tar xf "${LIBCLANG_ARCHIVE}" WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/external/")
endif()

set(LIBCLANG_ROOT "${CMAKE_BINARY_DIR}/external/libclang")
set(LIBCLANG_INCLUDE "${CMAKE_BINARY_DIR}/external/libclang/include")
set(LIBCLANG_LIBRARY "${CMAKE_BINARY_DIR}/external/libclang/lib")

# can't be bothered to use the LLVM cmake modules, @FIXME


add_library(libclang_internal STATIC IMPORTED)
  set_target_properties(libclang_internal PROPERTIES IMPORTED_LOCATION ${LIBCLANG_LIBRARY}/libclang.lib)
  set_property(TARGET libclang_internal APPEND PROPERTY INTERFACE_COMPILE_DEFINITIONS CINDEX_NO_EXPORTS)
  target_include_directories(libclang_internal INTERFACE ${LIBCLANG_INCLUDE})


set(IMPORT_LIBRARIES "libclang_internal")

macro(import_library libName)
  add_library(${libName} STATIC IMPORTED)
    set_target_properties(${libName} PROPERTIES IMPORTED_LOCATION "${LIBCLANG_LIBRARY}/${libName}.lib")
  message(STATUS "Imported static library: ${libName}")
  set(IMPORT_LIBRARIES "${IMPORT_LIBRARIES};${libName}")
endmacro()


import_library(clangAST)
import_library(clangBasic)
import_library(clangDriver)
import_library(clangFrontend)
import_library(clangIndex)
import_library(clangLex)
import_library(clangSema)
import_library(clangSerialization)
import_library(clangTooling)
import_library(clangARCMigrate)
import_library(LLVMX86CodeGen)
import_library(LLVMX86AsmParser)
import_library(LLVMX86Desc)
import_library(LLVMX86Disassembler)
import_library(LLVMX86Info)
import_library(LLVMCore)
import_library(LLVMSupport)
import_library(clangFormat)
import_library(clangToolingInclusions)
import_library(clangToolingCore)
import_library(LLVMOption)
import_library(clangParse)
import_library(clangEdit)
import_library(clangRewrite)
import_library(clangAnalysis)
import_library(clangASTMatchers)
import_library(LLVMMIRParser)

import_library(LLVMipo)
import_library(LLVMVectorize)
import_library(LLVMIRReader)
import_library(LLVMAsmParser)
import_library(LLVMInstrumentation)
import_library(LLVMLinker)
import_library(LLVMGlobalISel)
import_library(LLVMAsmPrinter)
import_library(LLVMDebugInfoDWARF)
import_library(LLVMSelectionDAG)
import_library(LLVMCodeGen)
import_library(LLVMScalarOpts)
import_library(LLVMAggressiveInstCombine)
import_library(LLVMInstCombine)
import_library(LLVMBitWriter)
import_library(LLVMTransformUtils)
import_library(LLVMTarget)
import_library(LLVMAnalysis)
import_library(LLVMProfileData)
import_library(LLVMTextAPI)
import_library(LLVMObject)
import_library(LLVMBitReader)
import_library(LLVMRemarks)
import_library(LLVMBitstreamReader)
import_library(LLVMMCParser)
import_library(LLVMMCDisassembler)
import_library(LLVMMC)
import_library(LLVMBinaryFormat)
import_library(LLVMDebugInfoCodeView)
import_library(LLVMDebugInfoMSF)
import_library(LLVMCFGuard)
import_library(LLVMFrontendOpenMP)
import_library(LLVMDemangle)
import_library(LLVMPasses)
import_library(LLVMCoroutines)
import_library(LLVMObjCARCOpts)

string(STRIP "${IMPORT_LIBRARIES}" IMPORT_LIBRARIES)

message(STATUS "Linking import libraries for libclang: ${IMPORT_LIBRARIES}")
add_library(libclang INTERFACE IMPORTED)
  set_property(TARGET libclang PROPERTY
    INTERFACE_LINK_LIBRARIES ${IMPORT_LIBRARIES})





message(STATUS "Found Clang (LLVM version: ${LIBCLANG_ROOT})")
message(STATUS "Include dirs: ${LIBCLANG_INCLUDE}")
message(STATUS "Clang libraries: ${LIBCLANG_LIBRARY}")
