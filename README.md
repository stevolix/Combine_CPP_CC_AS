### This is a simple example for combining C++, C and Assembly in the same program.

## Purpose of this example
The purpose of this code is to demonstrate how C++, C and Assembly can be used in combination with C++ as main file, using:
* A very minimalistic [C++ main file](src/main.cpp) that calls three external functions and prints their results to cout.
* One external [C++ file](src/subfunc1.cpp) with a very minimalistic C++ subfunction that just returns 1.
* One external [C file](src/subfunc2.c) with a very minimalistic C subfunction that just returns 2.
* One external [Assembly file](src/subfunc3.S) with a very minimalistic Assembly subfunction (X86) that just returns
  3.
* A basic [Makefile](Makefile) that can serve as basis for other programs.
* An alternative basic [CMakeLists.txt](CMakeLists.txt) that can be used with CMake to generate a
  build structure for make, ninja, etc.

## About the provided Makefile
The [Makefile](Makefile) file has the following main sections:
* First the source variables are defined and some compiler options are defined for the subsequent
  steps.
* Next, all src files are automatically included into the Makefile variables and a list of target
  objects is generated.
* Next, the targets are defined:
  * The default target **all** points to **$(TARGET)**, which is the linker step using **CXX**.
  * The prerequisites for target **$(TARGET)** are the defined output objects that are automatically
    derived.
  * Each list of output object targets is compiled separately using the previously defined compiler commands. The
    utilised compilers are:
    * **CC** for C and Assembly.
    * **CXX** for C++.

## About CMakeLists.txt
If you use CMake, you may also alternatively use the provided CMake generator file [CMakeLists.txt](CMakeLists.txt) to generate a classical makefile:
```
mkdir build_cmake && cd build_cmake && cmake -H../ -G"Unix Makefiles"
```
or a ninja.build file:
```
mkdir build_cmake && cd build_cmake && cmake ../ -GNinja
```
etc.

## How to use this example
The source code may be compiled using:
```
make
```

The program can be run using:
```
make run
```
with output:
```
-----> Running
./build/target
1 2 3
```
Here, 1 is the return value of the external C++ function call, 2 is the return value coming from the external function call to the C function
and 3 is the return value of the external Assembly file.


Finally, the generated build directory .build/ can be cleaned using:
```
make clean
```
