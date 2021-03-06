# Copyright (C) 2009,2010,2011,2012,2015 The ESPResSo project
# Copyright (C) 2009,2010 
#   Max-Planck-Institute for Polymer Research, Theory Group
#
# This file is part of ESPResSo.
#
# ESPResSo is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ESPResSo is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
cmake_minimum_required(VERSION 2.6)

project(ESPResSo)

enable_language(CXX)

# Cmake modules/macros are in a subdirectory to keep this file cleaner
set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

######################################################################
# User input options                                                   
######################################################################
if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Choose the type of build, options are: Debug Release RelWithDebInfo MinSizeRel." FORCE)
endif(NOT CMAKE_BUILD_TYPE)

# On Mac OS X, first look for other packages, then frameworks
set(CMAKE_FIND_FRAMEWORK LAST)

option(WITH_MPI    "Build a mpi parallel version of ESPResSo" ON)
option(WITH_TK     "Build with tk support"  OFF)
option(WITH_PYTHON "Build python interface"  ON)
option(WITH_TCL    "Build tcl interface"     ON)
option(WITH_CUDA   "Build with GPU support"  ON)
option(WITH_TESTS  "Enable tests"            ON)

# choose the name of the config file
set(MYCONFIG_NAME "myconfig.hpp"
  CACHE STRING "Default name of the local config file")

######################################################################
# Libraries
######################################################################
#

find_package(MyConfig)

if (WITH_CUDA)
  find_package(CUDA REQUIRED)
  list(APPEND LIBRARIES ${CUDA_CUFFT_LIBRARIES})
  list(APPEND LIBRARIES ${CUDA_LIBRARIES})
  set(CUDA 1)
endif(WITH_CUDA)     

find_package(PythonInterp)

if (WITH_PYTHON)
  find_package(Cython REQUIRED)
  find_package(PythonLibs REQUIRED)
  find_package(NumPy REQUIRED)
  list(APPEND LIBRARIES ${PYTHON_LIBRARY})
endif(WITH_PYTHON)

find_package(FFTW3)
if (FFTW3_FOUND)
  include_directories(${FFTW3_INCLUDE_DIR})
  list(APPEND LIBRARIES ${FFTW3_LIBRARIES})
  set(FFTW 3)
else(FFTW3_FOUND)
  message(STATUS "FFTW3 not found, diabling it.")
endif(FFTW3_FOUND)

if (WITH_TCL)
  find_package(TCL REQUIRED)
  include_directories(${TCL_INCLUDE_PATH})
  list(APPEND LIBRARIES ${TCL_LIBRARY})
endif()

find_package(HDF5)
if(HDF5_FOUND)
  set(H5MD 1)
  list(APPEND LIBRARIES ${HDF5_LIBRARIES})
  include_directories(${HDF5_INCLUDE_DIRS})
endif()

include(RequireCXX11)

#######################################################################
# Testing 
#######################################################################

if(WITH_TESTS)
  enable_testing()
  find_package(Boost COMPONENTS unit_test_framework) 
  if(Boost_UNIT_TEST_FRAMEWORK_FOUND)
    set(WITH_UNIT_TESTS 1)
  endif(Boost_UNIT_TEST_FRAMEWORK_FOUND)

  add_subdirectory(testsuite)
endif(WITH_TESTS)

#######################################################################
# Process MPI settings
#######################################################################
if(WITH_MPI)
  find_package(MPI REQUIRED)
  list(APPEND CMAKE_C_FLAGS ${MPI_COMPILE_FLAGS})
  list(APPEND CMAKE_EXE_LINKER_FLAGS ${MPI_LINK_FLAGS})
  include_directories(${MPI_INCLUDE_PATH})
  list(APPEND LIBRARIES ${MPI_LIBRARIES})
  set(MPI_SOURCE)
  set(HAVE_MPI 1)
else(WITH_MPI)
  include_directories(src/mpifake)  
  set(MPI_SOURCE src/mpifake/mpi.c)
endif(WITH_MPI)

if (NOT DEFINED DATA)
  set(DATA "share/espresso")
endif(NOT DEFINED DATA)
set(SCRIPTDIR ${DATA}/scripts)

#######################################################################
# Subdirectories
#######################################################################

add_subdirectory(scripts)
add_subdirectory(doc)
add_subdirectory(src)
add_subdirectory(config)
