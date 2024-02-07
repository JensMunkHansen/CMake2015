cmake_minimum_required(VERSION 2.8.9)

set (CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake")

include(SetInstallDir)
include(SetRPath)

project(FooBarUser C)

set(FOOBARUSER_MAJOR_VERSION 0)
set(FOOBARUSER_MINOR_VERSION 7)
set(FOOBARUSER_PATCH_VERSION 1)
set(FOOBARUSER_VERSION
  ${FOOBARUSER_MAJOR_VERSION}.${FOOBARUSER_MINOR_VERSION}.${FOOBARUSER_PATCH_VERSION})

# Not needed if no libraries
set(INSTALL_LIB_DIR lib CACHE PATH "Installation directory for libraries")

set(INSTALL_BIN_DIR bin CACHE PATH "Installation directory for executables")
set(INSTALL_INCLUDE_DIR include CACHE PATH
  "Installation directory for header files")
if(WIN32 AND NOT CYGWIN)
  set(DEF_INSTALL_CMAKE_DIR CMake)
else()
  set(DEF_INSTALL_CMAKE_DIR lib/CMake/FooBarUser)
endif()
set(INSTALL_CMAKE_DIR ${DEF_INSTALL_CMAKE_DIR} CACHE PATH
  "Installation directory for CMake files")

# Pick development version (default)
find_package(FooBar 0.6 REQUIRED)

set(DYN_LINKING ON)

# Automatically determine if dependencies are static or dynamic
if (WIN32)
  if ("${FOOBAR_RUNTIME_DIR}" STREQUAL "")
    set(DYN_LINKING OFF)
  endif()
else()
  set(CMAKE_FIND_LIBRARY_SUFFIXES .lib)
  find_library(FOO_LIB foo PATHS ${FooBar_DIR})
  if (FOO_LIB_FOUND)
    set(DYN_LINKING OFF)
  endif()
endif()

# Allow the developer to select if Dynamic or Static libraries are built
option (USE_SHARED_LIBS "Use Shared Libraries" ${DYN_LINKING})

# Make relative paths absolute (needed later on)
foreach(p LIB BIN INCLUDE CMAKE)
  set(var INSTALL_${p}_DIR)
  if(NOT IS_ABSOLUTE "${${var}}")
    set(${var} "${CMAKE_INSTALL_PREFIX}/${${var}}")
  endif()
endforeach()

# set up include-directories
include_directories(
  "${PROJECT_SOURCE_DIR}"   # to find src/main.h
  "${PROJECT_BINARY_DIR}")  # to find src/config.h

# RPATH settings
# ==============
if (USE_SHARED_LIBS)
  setup_rpath()
endif()

add_subdirectory(src)

# The interesting stuff goes here
# ===============================

# Add all targets to the build-tree export set
export(TARGETS main
  FILE "${PROJECT_BINARY_DIR}/FooBarUserTargets.cmake")

# Export the package for use from the build-tree
# (this registers the build-tree with a global CMake-registry)
export(PACKAGE FooBarUser)

# Create the FooBarUserConfig.cmake and FooBarUserConfigVersion files
file(RELATIVE_PATH REL_INCLUDE_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_INCLUDE_DIR}")

# JEM: The Generation of FooBarUserConfig.cmake needs to know if dynamic linking is used
if (BUILD_SHARED_LIBS)
  set(FOOBARUSER_DYNAMIC_LINKING TRUE)
else()
  set(FOOBARUSER_DYNAMIC_LINKING FALSE)
endif()

# JEM: This is used for installations - no hard coding of directories,
file(RELATIVE_PATH REL_BIN_DIR "${INSTALL_CMAKE_DIR}"
   "${INSTALL_BIN_DIR}")

# ... for the build tree
set(CONF_INCLUDE_DIRS "${PROJECT_SOURCE_DIR}" "${PROJECT_BINARY_DIR}")
set(CONF_LIBRARY_DIRS "") # For build tree, multiple configurations are used
configure_file(FooBarUserConfig.cmake.in
  "${PROJECT_BINARY_DIR}/FooBarUserConfig.cmake" @ONLY)

# ... for the install tree
set(CONF_INCLUDE_DIRS "\${FOOBARUSER_CMAKE_DIR}/${REL_INCLUDE_DIR}")
set(CONF_LIBRARY_DIRS "\${FOOBARUSER_CMAKE_DIR}/${REL_BIN_DIR}")       # JEM: Used for installations
configure_file(FooBarUserConfig.cmake.in
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/FooBarUserConfig.cmake" @ONLY)

# ... for both
configure_file(FooBarUserConfigVersion.cmake.in
  "${PROJECT_BINARY_DIR}/FooBarUserConfigVersion.cmake" @ONLY)

# Install the FooBarUserConfig.cmake and FooBarUserConfigVersion.cmake
install(FILES
  "${PROJECT_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/FooBarUserConfig.cmake"
  "${PROJECT_BINARY_DIR}/FooBarUserConfigVersion.cmake"
  DESTINATION "${INSTALL_CMAKE_DIR}" COMPONENT dev)

# Install the export set for use with the install-tree
install(EXPORT FooBarUserTargets DESTINATION
  "${INSTALL_CMAKE_DIR}" COMPONENT dev)

# Add uninstall target, in linux simply issue xargs rm < install_manifest.txt
configure_file(
    "${CMAKE_CURRENT_SOURCE_DIR}/cmake/cmake_uninstall.cmake.in"
    "${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake"
    IMMEDIATE @ONLY)

add_custom_target(uninstall
    COMMAND ${CMAKE_COMMAND} -P
    ${CMAKE_CURRENT_BINARY_DIR}/cmake/cmake_uninstall.cmake)
