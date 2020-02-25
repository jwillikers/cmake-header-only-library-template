#[=======================================================================[.rst:
SetBuildTypes
--------

Set the allowed build types for both single and multi configuration generators.
Additionally, set the default build type.

Arguments
^^^^^^^^^^^^^^^^
This module requires a list of the available build types.
The first item in the list will be the default build type when CMAKE_BUILD_TYPE is empty.
#]=======================================================================]
function(set_build_types)
  if(ARGC EQUAL 0)
    message(FATAL_ERROR "No build types given.")
  endif()

  get_property(_is_multi_config GLOBAL PROPERTY GENERATOR_IS_MULTI_CONFIG)
  if(_is_multi_config)
    foreach(_build_type IN LISTS ARGN)
      if(NOT ${_build_type} IN_LIST CMAKE_CONFIGURATION_TYPES)
        list(APPEND CMAKE_CONFIGURATION_TYPES ${_build_type})
      endif()
    endforeach()
  else()
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "${ARGN}")
    if(NOT CMAKE_BUILD_TYPE)
      set(CMAKE_BUILD_TYPE ${ARGV0} CACHE STRING "" FORCE)
    elseif(NOT CMAKE_BUILD_TYPE IN_LIST ARGN)
      message(FATAL_ERROR "Invalid build type: ${CMAKE_BUILD_TYPE}")
    endif()
  endif()
endfunction()
