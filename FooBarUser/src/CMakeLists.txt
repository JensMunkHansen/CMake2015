include_directories("${FOOBAR_INCLUDE_DIRS}")
add_executable(main client.c)

target_link_libraries(main foo)

install(TARGETS main
  # IMPORTANT: Add the main executable to the "export-set"
  EXPORT FooBarUserTargets
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin)

# Copy dependencies
if (WIN32)
  if (USE_SHARED_LIBS)
    # TODO: Not found for installed version - skip this (check include dir)
    if ("${FOOBAR_RUNTIME_DIR_RELEASE}" STREQUAL "")
      message(FATAL_ERROR "Dynamic library not found")
    endif()
  
    # Check if the library is installed or under development
    string( FIND ${FOOBAR_RUNTIME_DIR_RELEASE} "bin" APOSITION )
    if (${APOSITION} EQUAL -1)
      # Library is under development (debug or release)
      add_custom_command(TARGET main POST_BUILD
          COMMAND ${CMAKE_COMMAND} -E copy_if_different
              "${FOOBAR_RUNTIME_DIR}/$<CONFIGURATION:main>/${FOOBAR_RUNTIME_LIBRARIES}"
      "$<TARGET_FILE_DIR:main>")
    else()
      # Library is installed
      add_custom_command(TARGET main POST_BUILD
          COMMAND ${CMAKE_COMMAND} -E copy_if_different
              "${FOOBAR_RUNTIME_DIR_RELEASE}/${FOOBAR_RUNTIME_LIBRARIES}"
      "$<TARGET_FILE_DIR:main>")
    endif()
  endif()
endif()
