cmake_minimum_required(VERSION 2.8)

find_package(CUDA QUIET REQUIRED)

#PCL
set(PCL_DIR "/home/ziqi/pcl-1.8/share/pcl-1.8")
find_package(PCL 1.8 REQUIRED COMPONENTS)

message("\nPCL_INCLUDE_DIRS are:" ${PCL_INCLUDE_DIRS})
include_directories(${PCL_INCLUDE_DIRS})

message("\nPCL_LIBRARY_DIRS are:" ${PCL_LIBRARY_DIRS})
link_directories(${PCL_LIBRARY_DIRS})

message("\nPCL_DEFINITIONS are:" ${PCL_DEFINITIONS})
add_definitions(${PCL_DEFINITIONS})

#VTK BUG FIXING
get_directory_property(dir_defs DIRECTORY ${CMAKE_SOURCE_DIR} COMPILE_DEFINITIONS)
set(vtk_flags)

foreach(it ${dir_defs})
    if(it MATCHES "vtk*")
    list(APPEND vtk_flags ${it})
    endif()
endforeach()

foreach(d ${vtk_flags})
    remove_definitions(-D${d})
endforeach()

#add executable
cuda_add_executable (pcl_points_gpu src/pcl_points_gpu.cpp src/gpu_draw_cloud.cu)
target_link_libraries (pcl_points_gpu ${PCL_LIBRARIES})

cuda_add_executable(squaresum src/test.cpp src/squaresum.cu src/utils.cu)
