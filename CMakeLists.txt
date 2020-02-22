cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(MyProject VERSION 0.1.0
        DESCRIPTION "A template for creating a C++ header-only library using CMake."
        HOMEPAGE_URL https://github.com/jwillikers/header-only_library_template
        LANGUAGES CXX)

list(APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake/modules)

include(SetBuildTypes)
include(AddSanitizerBuildTypeFlags)

set_build_types(Debug Release AddressSanitizer LeakSanitizer MemorySanitizer ThreadSanitizer UndefinedBehaviorSanitizer)
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

add_subdirectory(src)
