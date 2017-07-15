#
# vpp_ExternalProject_Add_Empty(<proj> <depends>)
#
# Add an empty external project
#
function(vpp_ExternalProject_Add_Empty proj depends)
  set(depends_args)
  if(NOT depends STREQUAL "")
    set(depends_args DEPENDS ${depends})
  endif()
  ExternalProject_add(${proj}
    SOURCE_DIR ${CMAKE_BINARY_DIR}/${proj}
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    CONFIGURE_COMMAND ""
    BUILD_COMMAND ""
    BUILD_IN_SOURCE 1
    BUILD_ALWAYS 1
    INSTALL_COMMAND ""
    ${depends_args}
    )
endfunction()

# No-op function allowing to shut-up "Manually-specified variables were not used by the project"
# warnings.
function(vpp_unused_vars)
endfunction()
