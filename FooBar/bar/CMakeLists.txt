set(bar_HEADERS
  bar.h
)
set(bar_SOURCES
  bar.c
)

add_executable(bar ${bar_SOURCES} ${bar_HEADERS})

target_link_libraries(bar foo)

install(TARGETS bar
  # IMPORTANT: Add the bar executable to the "export-set"
  EXPORT FooBarTargets
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}" COMPONENT bin)
