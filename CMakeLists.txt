cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(MyProject VERSION 0.1.0
        DESCRIPTION "A template for creating a C++ header-only library using CMake."
        HOMEPAGE_URL https://github.com/jwillikers/header-only_library_template
        LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)

include(SetBuildTypes)
include(AddSanitizerBuildTypeFlags)

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
    set_build_types(Debug Release Profile Coverage AddressSanitizer LeakSanitizer MemorySanitizer ThreadSanitizer UndefinedBehaviorSanitizer)
  else()
    set_build_types(Debug Release Profile Coverage AddressSanitizer LeakSanitizer ThreadSanitizer UndefinedBehaviorSanitizer)
  endif()
else()
  set_build_types(Debug Release)
endif()

if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang" OR CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
  set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_RELWITHDEBINFO} -O0 -fno-omit-frame-pointer -g")
  set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_RELWITHDEBINFO} -O0 -fno-omit-frame-pointer -g")
  if(CMAKE_CXX_COMPILER_ID STREQUAL "Clang")
    set(CMAKE_C_FLAGS_PROFILE "${CMAKE_C_FLAGS_PROFILE} -mno-omit-leaf-frame-pointer")
    set(CMAKE_CXX_FLAGS_PROFILE "${CMAKE_CXX_FLAGS_PROFILE} -mno-omit-leaf-frame-pointer")
    set(CMAKE_C_FLAGS_COVERAGE "${CMAKE_C_FLAGS_RELEASE} -fprofile-instr-generate -fcoverage-mapping")
    set(CMAKE_CXX_FLAGS_COVERAGE "${CMAKE_CXX_FLAGS_RELEASE} -fprofile-instr-generate -fcoverage-mapping")
    set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_EXE_LINKER_FLAGS_RELEASE} -fprofile-instr-generate -fcoverage-mapping")
  elseif(CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    set(CMAKE_C_FLAGS_COVERAGE "${CMAKE_C_FLAGS_RELEASE} --coverage")
    set(CMAKE_CXX_FLAGS_COVERAGE "${CMAKE_CXX_FLAGS_RELEASE} --coverage")
    set(CMAKE_EXE_LINKER_FLAGS_COVERAGE "${CMAKE_CXX_FLAGS_RELEASE} --coverage")
  endif()
  set_property(GLOBAL APPEND PROPERTY DEBUG_CONFIGURATIONS Profile)
endif()
add_sanitizer_build_type_flags()

set(BUILD_SHARED_LIBS yes CACHE BOOL "If present and true, this will cause all libraries to be built shared unless the library was explicitly added as a static library.")
set(CMAKE_CXX_STANDARD 20 CACHE STRING "The C++ standard whose features are requested to build this target.")
set(CMAKE_CXX_STANDARD_REQUIRED yes CACHE BOOL "Boolean describing whether the value of CXX_STANDARD is a requirement.")
set(CMAKE_CXX_EXTENSIONS no CACHE BOOL "Boolean specifying whether compiler specific extensions are requested.")
set(CMAKE_UNITY_BUILD yes CACHE BOOL "When this property is set to true, target source files will be combined into batches for faster compilation.")

# How does one handle exporting symbols from a header-only library?
# I would assume that all symbols are private?
# This will probably need changed to be disabled and instead use generate_export_header to hide all of the symbols.
set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS yes CACHE BOOL "")

set(MY_PROJECT_GENERATED_INCLUDEDIR "${PROJECT_BINARY_DIR}/generated/include" CACHE STRING "Where to place the header files configured by CMake.")

# use_compiler_cache
# use_better_linker
# use_split_dwarf

add_subdirectory(src)

#if(BENCHMARK_MY_PROJECT OR CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
#  add_subdirectory(benchmark)
#endif()

#if(TEST_MY_PROJECT OR CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
#  add_subdirectory(test)
#endif()

#if(DOCUMENT_MY_PROJECT OR CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
#  add_subdirectory(doc)
#endif()
