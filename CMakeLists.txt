cmake_minimum_required(VERSION 3.3)

project(VTKPythonPackage NONE)

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})
include(VTKPythonPackage)

if(NOT DEFINED VTKPythonPackage_SUPERBUILD)
  set(VTKPythonPackage_SUPERBUILD 1)
endif()

if(VTKPythonPackage_SUPERBUILD)

  #-----------------------------------------------------------------------------
  #------------------------------------------------------
  #----------------------------------
  # VTKPythonPackage_SUPERBUILD: ON
  #----------------------------------
  #------------------------------------------------------
  #-----------------------------------------------------------------------------

  set(ep_common_cmake_cache_args)
  if(NOT CMAKE_CONFIGURATION_TYPES)
    list(APPEND ep_common_cmake_cache_args
      -DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}
      )
  endif()

  if(CMAKE_OSX_DEPLOYMENT_TARGET)
    list(APPEND ep_common_cmake_cache_args
      -DCMAKE_OSX_DEPLOYMENT_TARGET:STRING=${CMAKE_OSX_DEPLOYMENT_TARGET})
  endif()
  if(CMAKE_OSX_ARCHITECTURES)
    list(APPEND ep_common_cmake_cache_args
      -DCMAKE_OSX_ARCHITECTURES:STRING=${CMAKE_OSX_ARCHITECTURES})
  endif()

  if(CMAKE_MAKE_PROGRAM)
    list(APPEND ep_common_cmake_cache_args
      -DCMAKE_MAKE_PROGRAM:FILEPATH=${CMAKE_MAKE_PROGRAM})
  endif()

  # Avoid "Manually-specified variables were not used by the project" warnings.
  vpp_unused_vars(${PYTHON_VERSION_STRING} ${SKBUILD})

  #-----------------------------------------------------------------------------
  # Options

  # When building different "flavor" of VTK python packages on a given platform,
  # explicitly setting the following options allow to speed up package generation by
  # re-using existing resources.
  #
  #  VTK_SOURCE_DIR: Path to an existing source directory
  #

  option(VTKPythonPackage_BUILD_PYTHON "Build VTK python module" ON)
  mark_as_advanced(VTKPythonPackage_BUILD_PYTHON)


  #-----------------------------------------------------------------------------
  include(ExternalProject)

  set(VTK_REPOSITORY "https://github.com/kitware/VTK.git")
  # VTK nightly-master 2017-07-12
  set(VTK_GIT_TAG "a9add75")

  #-----------------------------------------------------------------------------
  # A separate project is used to download VTK, so that it can reused
  # when building different "flavor" of VTK python packages

  message(STATUS "SuperBuild -")
  message(STATUS "SuperBuild - VTK-source-download")

  # Sanity checks
  if(DEFINED VTK_SOURCE_DIR AND NOT EXISTS ${VTK_SOURCE_DIR})
    message(FATAL_ERROR "VTK_SOURCE_DIR variable is defined but corresponds to nonexistent directory")
  endif()

  if(NOT DEFINED VTK_SOURCE_DIR)

    set(VTK_SOURCE_DIR ${CMAKE_BINARY_DIR}/VTK-source)

    ExternalProject_add(VTK-source-download
      SOURCE_DIR ${VTK_SOURCE_DIR}
      GIT_REPOSITORY ${VTK_REPOSITORY}
      GIT_TAG ${VTK_GIT_TAG}
      USES_TERMINAL_DOWNLOAD 1
      CONFIGURE_COMMAND ""
      BUILD_COMMAND ""
      INSTALL_COMMAND ""
      )
    set(proj_status "")

  else()

    vpp_ExternalProject_Add_Empty(
      VTK-source-download
      ""
      )
    set(proj_status " (REUSE)")

  endif()

  message(STATUS "SuperBuild -   VTK_SOURCE_DIR: ${VTK_SOURCE_DIR}")
  message(STATUS "SuperBuild - VTK-source-download[OK]${proj_status}")

  #-----------------------------------------------------------------------------
  if(NOT VTKPythonPackage_BUILD_PYTHON)
    return()
  endif()

  #-----------------------------------------------------------------------------
  # Search for python interpreter and libraries

  message(STATUS "SuperBuild -")
  message(STATUS "SuperBuild - Searching for python")

  # Sanity checks
  if(DEFINED PYTHON_INCLUDE_DIR AND NOT EXISTS ${PYTHON_INCLUDE_DIR})
    message(FATAL_ERROR "PYTHON_INCLUDE_DIR variable is defined but corresponds to nonexistent directory")
  endif()
  if(DEFINED PYTHON_LIBRARY AND NOT EXISTS ${PYTHON_LIBRARY})
    message(FATAL_ERROR "PYTHON_LIBRARY variable is defined but corresponds to nonexistent file")
  endif()
  if(DEFINED PYTHON_EXECUTABLE AND NOT EXISTS ${PYTHON_EXECUTABLE})
    message(FATAL_ERROR "PYTHON_EXECUTABLE variable is defined but corresponds to nonexistent file")
  endif()

  if(NOT DEFINED PYTHON_INCLUDE_DIR
     OR NOT DEFINED PYTHON_LIBRARY
     OR NOT DEFINED PYTHON_EXECUTABLE)

    find_package ( PythonLibs REQUIRED )
    find_package ( PythonInterp REQUIRED )

  endif()

  message(STATUS "SuperBuild -   PYTHON_INCLUDE_DIR: ${PYTHON_INCLUDE_DIR}")
  message(STATUS "SuperBuild -   PYTHON_LIBRARY: ${PYTHON_LIBRARY}")
  message(STATUS "SuperBuild -   PYTHON_EXECUTABLE: ${PYTHON_EXECUTABLE}")
  message(STATUS "SuperBuild - Searching for python[OK]")



  #-----------------------------------------------------------------------------
  # VTK: This project builds VTK and associated Python modules

  set(VTK_BINARY_DIR "${CMAKE_BINARY_DIR}/VTK-build" CACHE PATH "VTK build directory")

  message(STATUS "SuperBuild -")
  message(STATUS "SuperBuild - VTK => Requires VTK-source-download")
  message(STATUS "SuperBuild -   VTK_BINARY_DIR: ${VTK_BINARY_DIR}")

  set(_stamp "${CMAKE_BINARY_DIR}/VTK-prefix/src/VTK-stamp/VTK-configure")
  if(EXISTS ${_stamp})
    execute_process(COMMAND ${CMAKE_COMMAND} -E remove ${_stamp})
    message(STATUS "SuperBuild -   Force re-configure removing ${_stamp}")
  endif()

  set(install_dir "vtk")

  ExternalProject_add(VTK
    DOWNLOAD_COMMAND ""
    SOURCE_DIR ${VTK_SOURCE_DIR}
    BINARY_DIR ${VTK_BINARY_DIR}
    CMAKE_CACHE_ARGS
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
      -DVTK_INSTALL_PYTHON_MODULE_DIR:STRING=${CMAKE_INSTALL_PREFIX}

      -DBUILD_TESTING:BOOL=OFF
      -DBUILD_EXAMPLES:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DVTK_USE_PARALLEL:BOOL=ON
      -DVTK_DEBUG_LEAKS:BOOL=OFF
      -DVTK_LEGACY_REMOVE:BOOL=ON
      -DVTK_WRAP_TCL:BOOL=ON
      -DVTK_WRAP_PYTHON:BOOL=ON
      -DVTK_INSTALL_RUNTIME_DIR:PATH=${install_dir}
      -DVTK_INSTALL_LIBRARY_DIR:PATH=${install_dir}
      -DVTK_INSTALL_ARCHIVE_DIR:PATH=${install_dir}
      -DVTK_Group_Qt:BOOL=OFF  # XXX Enabled this later
      -DVTK_RENDERING_BACKEND:STRING=OpenGL2
      -DVTK_USE_SYSTEM_ZLIB:BOOL=OFF
      -DVTK_ENABLE_KITS:BOOL=ON

      -DPYTHON_INCLUDE_DIR:PATH=${PYTHON_INCLUDE_DIR}
      -DPYTHON_LIBRARY:FILEPATH=${PYTHON_LIBRARY}
      -DPYTHON_EXECUTABLE:FILEPATH=${PYTHON_EXECUTABLE}
      ${ep_common_cmake_cache_args}
    USES_TERMINAL_DOWNLOAD 1
    USES_TERMINAL_UPDATE 1
    USES_TERMINAL_CONFIGURE 1
    USES_TERMINAL_BUILD 1
    INSTALL_COMMAND ""
    )
  set(proj_status "")

  ExternalProject_Add_StepDependencies(VTK download VTK-source-download)

  message(STATUS "SuperBuild - VTK[OK]${proj_status}")


  #-----------------------------------------------------------------------------
  # VTKPythonPackage: This project adds install rules for the "RuntimeLibraries"
  # components associated with the VTK project.

  message(STATUS "SuperBuild -")
  message(STATUS "SuperBuild - ${PROJECT_NAME} => Requires VTK")

  if(NOT DEFINED VTKPythonPackage_WHEEL_NAME)
    set(VTKPythonPackage_WHEEL_NAME "vtk")
  endif()
  message(STATUS "SuperBuild -   VTKPythonPackage_WHEEL_NAME:${VTKPythonPackage_WHEEL_NAME}")

  ExternalProject_add(${PROJECT_NAME}
    SOURCE_DIR ${CMAKE_SOURCE_DIR}
    BINARY_DIR ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-build
    DOWNLOAD_COMMAND ""
    UPDATE_COMMAND ""
    CMAKE_CACHE_ARGS
      -DVTKPythonPackage_SUPERBUILD:BOOL=0
      -DVTK_BINARY_DIR:PATH=${VTK_BINARY_DIR}
      -DVTK_SOURCE_DIR:PATH=${VTK_SOURCE_DIR}
      -DCMAKE_INSTALL_PREFIX:PATH=${CMAKE_INSTALL_PREFIX}
      -DVTKPythonPackage_WHEEL_NAME:STRING=${VTKPythonPackage_WHEEL_NAME}
      ${ep_common_cmake_cache_args}
    USES_TERMINAL_CONFIGURE 1
    INSTALL_COMMAND ""
    DEPENDS VTK
    )

  install(SCRIPT ${CMAKE_BINARY_DIR}/${PROJECT_NAME}-build/cmake_install.cmake)

  message(STATUS "SuperBuild - ${PROJECT_NAME}[OK]")


else()

  #-----------------------------------------------------------------------------
  #------------------------------------------------------
  #----------------------------------
  # VTKPythonPackage_SUPERBUILD: OFF
  #----------------------------------
  #------------------------------------------------------
  #-----------------------------------------------------------------------------

  set(components "RuntimeLibraries")

  #-----------------------------------------------------------------------------
  # Install VTK components
  message(STATUS "Adding install rules for components:")
  foreach(component IN LISTS components)
    message(STATUS "  ${component}")
    install(CODE "
unset(CMAKE_INSTALL_COMPONENT)
set(COMPONENT \"${component}\")
set(CMAKE_INSTALL_DO_STRIP 1)
include\(\"${VTK_BINARY_DIR}/cmake_install.cmake\")
unset(CMAKE_INSTALL_COMPONENT)
")
  endforeach()

endif()
