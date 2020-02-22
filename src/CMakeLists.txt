include(GNUInstallDirs)

configure_file(version.hpp.in ${MY_PROJECT_GENERATED_INCLUDEDIR}/my_project/version.hpp @ONLY)

add_library(MyProject INTERFACE)
add_library(MyProject::MyProject ALIAS MyProject)
target_compile_features(MyProject INTERFACE cxx_std_${CMAKE_CXX_STANDARD})
target_include_directories(MyProject INTERFACE
                           $<BUILD_INTERFACE:${MY_PROJECT_GENERATED_INCLUDEDIR}>
                           $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                           $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)
