cmake_minimum_required(VERSION 3.1)
enable_language(ASM C CXX)
project(target)
set(CMAKE_BUILD_TYPE Debug)

#include_directories(src/include)

set(CXX_MAIN_SOURCE "src/main.cpp")

file(GLOB AS_SOURCES "src/*.S")
file(GLOB CC_SOURCES "src/*.c")
file(GLOB CXX_SOURCES "src/*.cpp")
list(FILTER CXX_SOURCES EXCLUDE REGEX ".*${CXX_MAIN_SOURCE}$")

set(AS_LIBRARY ${CMAKE_PROJECT_NAME}_AS)
set(CC_LIBRARY ${CMAKE_PROJECT_NAME}_CC)
set(CXX_LIBRARY ${CMAKE_PROJECT_NAME}_CXX)

add_library(${AS_LIBRARY} STATIC ${AS_SOURCES})
add_library(${CC_LIBRARY} STATIC ${CC_SOURCES})
add_library(${CXX_LIBRARY} STATIC ${CXX_SOURCES})
add_executable(${CMAKE_PROJECT_NAME} ${CXX_MAIN_SOURCE})

set(WFLAGS -Wall -Wall -pedantic -Wextra -Wconversion -Wfatal-errors)
set(SFLAGS -fno-exceptions -fmessage-length=0 -fstack-usage) # -fstack-check
set(PFLAGS )
set(OFLAGS -Os -Og -g)
set(ASFLAGS )
set(CCFLAGS )
set(CXXFLAGS -std=c++17)
set(CC_AOUTFLAGS -Wa,-adhln=$<TARGET_OBJECTS:${CC_LIBRARY}>.s)  # -fverbose-asm 
set(CXX_AOUTFLAGS -Wa,-adhln=$<TARGET_OBJECTS:${CXX_LIBRARY}>.s)  # -fverbose-asm 
set(LDFLAGS )

target_compile_options(${AS_LIBRARY} PRIVATE ${CFLAGS} ${OFLAGS} ${ASFLAGS} ${WFLAGS} ${SFLAGS} ${PFLAGS})
target_compile_options(${CC_LIBRARY} PRIVATE ${CFLAGS} ${OFLAGS} ${WFLAGS} ${SFLAGS} ${PFLAGS} ${CC_AOUTFLAGS})
target_compile_options(${CXX_LIBRARY} PRIVATE ${CXXFLAGS} ${OFLAGS} ${WFLAGS} ${SFLAGS} ${PFLAGS} ${CXX_AOUTFLAGS})
target_link_libraries(${CMAKE_PROJECT_NAME} ${AS_LIBRARY} ${CC_LIBRARY} ${CXX_LIBRARY})
add_custom_command(TARGET ${CMAKE_PROJECT_NAME} POST_BUILD 
    COMMAND objcopy --only-keep-debug $<TARGET_FILE:${CMAKE_PROJECT_NAME}> $<TARGET_FILE:${CMAKE_PROJECT_NAME}>.debug
    COMMAND strip $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
    COMMAND objcopy --add-gnu-debuglink=$<TARGET_FILE:${CMAKE_PROJECT_NAME}>.debug $<TARGET_FILE:${CMAKE_PROJECT_NAME}>
    COMMAND size -d $<TARGET_FILE:${CMAKE_PROJECT_NAME}> >
    $<TARGET_FILE:${CMAKE_PROJECT_NAME}>.size)




