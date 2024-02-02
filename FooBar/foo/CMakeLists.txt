configure_file(config.h.in "${CMAKE_CURRENT_BINARY_DIR}/config.h" @ONLY)

if (BUILD_SHARED_LIBS)
   add_definitions(-D_FOO_DYNAMIC_LINKING)
endif()

set(foo_HEADERS
  foo.h
  exports_foo.h
)
set(foo_SOURCES
  foo.c
)

add_library(foo ${LIB_TYPE} ${foo_SOURCES} ${foo_HEADERS} config.h.in)
set_target_properties(foo PROPERTIES
  PUBLIC_HEADER "${foo_HEADERS};${CMAKE_CURRENT_BINARY_DIR}/config.h")

install(TARGETS foo
  # IMPORTANT: Add the foo library to the "export-set"
  EXPORT FooBarTargets
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin
  ARCHIVE DESTINATION "${INSTALL_LIB_DIR}" COMPONENT lib
  LIBRARY DESTINATION "${INSTALL_LIB_DIR}" COMPONENT shlib
  PUBLIC_HEADER DESTINATION "${INSTALL_INCLUDE_DIR}/foo"
    COMPONENT dev)
