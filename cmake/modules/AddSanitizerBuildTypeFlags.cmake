#[=======================================================================[.rst:
AddSanitizerBuildTypeFlags
--------

Add the compiler and linker flags for the sanitizer build types.
Currently, only Clang and GCC are supported.
Support for MSVC has yet to be added.

Arguments
~~~~~~~~

Provide the names for the build types through the following variables:

ASAN
LSAN
MSAN
TSAN
UBSAN

It is possible to only provide a subset of these variables to only create build types for specific sanitizers.

#]=======================================================================]
function(add_sanitizer_build_type_flags)

  if(NOT ARGC EQUAL 0)
    message(FATAL_ERROR "No arguments were given.")
  endif()

  set(prefix ARG)
  set(no_values "")
  set(single_values ASAN LSAN MSAN TSAN UBSAN)
  set(multi_values "")

  include(CMakeParseArguments)
  cmake_parse_arguments(${prefix}
                        "${no_values}"
                        "${single_values}"
                        "${multi_values}"
                        ${ARGN})

  if(ARG_UNPARSED_ARGUMENTS)
    message(FATAL_ERROR "Unexpected arguments: ${ARG_UNPARSED_ARGUMENTS}")
  endif()

  if(ARG_KEYWORDS_MISSING_VALUES)
    message(FATAL_ERROR "Keywords missing values: ${ARG_KEYWORDS_MISSING_VALUES}")
  endif()

  # todo Add support for the AddressSanitizer for MSVC / 32-bit builds.
  if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    foreach(arg IN LISTS single_values)
      if(${prefix}_${arg})
        set_property(GLOBAL APPEND PROPERTY DEBUG_CONFIGURATIONS ${${prefix}_${arg}})
      endif()
    endforeach()

    if(ARG_ASAN)
      set(CMAKE_C_FLAGS_${ARG_ASAN} "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer" CACHE STRING "Flags used by the C compiler during Address Sanitizer builds.")
      set(CMAKE_CXX_FLAGS_${ARG_ASAN} "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer" CACHE STRING "Flags used by the C++ compiler during Address Sanitizer builds.")
      set(CMAKE_EXE_LINKER_FLAGS_${ARG_ASAN} "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=address -fno-optimize-sibling-calls -fsanitize-address-use-after-scope -fno-omit-frame-pointer" CACHE STRING "Flags used by the linker during Address Sanitizer builds.")
    endif()

    if(ARG_LSAN)
      set(CMAKE_C_FLAGS_${ARG_LSAN} "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fsanitize=leak -fno-omit-frame-pointer" CACHE STRING "Flags used by the C compiler during Leak Sanitizer builds.")
      set(CMAKE_CXX_FLAGS_${ARG_LSAN} "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fsanitize=leak -fno-omit-frame-pointer" CACHE STRING "Flags used by the C++ compiler during Leak Sanitizer builds.")
      set(CMAKE_EXE_LINKER_FLAGS_${ARG_LSAN} "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=leak -fno-omit-frame-pointer" CACHE STRING "Flags used by the linker during Leak Sanitizer builds.")
    endif()

    if(ARG_MSAN)
      set(CMAKE_C_FLAGS_${ARG_MSAN} "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fsanitize=memory -fno-optimize-sibling-calls -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer" CACHE STRING "Flags used by the C compiler during Memory Sanitizer builds.")
      set(CMAKE_CXX_FLAGS_${ARG_MSAN} "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fsanitize=memory -fno-optimize-sibling-calls -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer" CACHE STRING "Flags used by the C++ compiler during Memory Sanitizer builds.")
      set(CMAKE_EXE_LINKER_FLAGS_${ARG_MSAN} "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=memory -fno-optimize-sibling-calls -fsanitize-memory-track-origins=2 -fno-omit-frame-pointer" CACHE STRING "Flags used by the linker during Memory Sanitizer builds.")
    endif()

    if(ARG_TSAN)
      set(CMAKE_C_FLAGS_${ARG_TSAN} "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fsanitize=thread" CACHE STRING "Flags used by the C compiler during Thread Sanitizer builds.")
      set(CMAKE_CXX_FLAGS_${ARG_TSAN} "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fsanitize=thread" CACHE STRING "Flags used by the C++ compiler during Thread Sanitizer builds.")
      set(CMAKE_EXE_LINKER_FLAGS_${ARG_TSAN} "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=thread" CACHE STRING "Flags used by the linker during Thread Sanitizer builds.")
    endif()

    if(ARG_UBSAN)
      set(CMAKE_C_FLAGS_${UBSAN} "${CMAKE_C_FLAGS_RELWITHDEBINFO} -fsanitize=undefined" CACHE STRING "Flags used by the C compiler during Undefined Behaviour Sanitizer builds.")
      set(CMAKE_CXX_FLAGS_${UBSAN} "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -fsanitize=undefined" CACHE STRING "Flags used by the C++ compiler during Undefined Behaviour Sanitizer builds.")
      set(CMAKE_EXE_LINKER_FLAGS_${UBSAN} "${CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO} -fsanitize=undefined" CACHE STRING "Flags used by the linker during Undefined Behavior Sanitizer builds.")
    endif()
  else()
    message("Sanitizers not supported for the current compiler: ${CMAKE_CXX_COMPILER_ID}.")
  endif()
endfunction()
