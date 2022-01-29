PROJECT_ROOT = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SRC_DIR = src/
BUILD_DIR = build/
INCLUDE_DIR = src/include
TARGET = $(BUILD_DIR)target


WFLAGS = -Wall -Wall -pedantic -Wextra -Wconversion -Wfatal-errors
SFLAGS = -fno-exceptions -fmessage-length=0 -fstack-usage # -fstack-check
PFLAGS = 
OFLAGS = -Os -Og -g
ASFLAGS = 
CCFLAGS = 
CXXFLAGS = -std=c++17
AOUTFLAGS = -Wa,-adhln="$(@:%.o=%.s)" # -fverbose-asm 
LDFLAGS = 

########### DERIVED DATA

AS_SRC	= $(shell find $(SRC_DIR) -name *.S)
CC_SRC	= $(shell find $(SRC_DIR) -name *.c)
CXX_SRC	= $(shell find $(SRC_DIR) -name *.cpp)

AS_OBJS	= $(addprefix $(BUILD_DIR), $(AS_SRC:.S=.AS.o) )
CC_OBJS	= $(addprefix $(BUILD_DIR), $(CC_SRC:.c=.CC.o) )
CXX_OBJS = $(addprefix $(BUILD_DIR), $(CXX_SRC:.cpp=.CXX.o) )

all: $(TARGET)

$(BUILD_DIR)%.AS.o: %.S
	@echo "-----> Building AS"
	$(CC) -c $(CFLAGS) -I$(INCLUDE_DIR) $(OFLAGS) $(ASFLAGS) $(WFLAGS) $(SFLAGS) $(PFLAGS) -o $@ $<

$(BUILD_DIR)%.CC.o: %.c 
	@echo "-----> Building CC"
	$(CC) -c $(CFLAGS) -I$(INCLUDE_DIR) $(OFLAGS) $(WFLAGS) $(SFLAGS) $(PFLAGS) $(AOUTFLAGS) -o $@ $<

$(BUILD_DIR)%.CXX.o: %.cpp 
	@echo "-----> Building CXX"
	@mkdir -p $(dir $@)
	$(CXX) -c $(CXXFLAGS) -I$(INCLUDE_DIR) $(OFLAGS) $(WFLAGS) $(SFLAGS) $(PFLAGS) $(AOUTFLAGS) -o $@ $<

$(TARGET): $(CXX_OBJS) $(CC_OBJS) $(AS_OBJS)
	@echo "-----> Linking TARGET"
	$(CXX) $(LDFLAGS) $(PFLAGS) -o $(TARGET) $^
	objcopy --only-keep-debug $(TARGET) $(TARGET).debug
	strip $(TARGET)
	objcopy --add-gnu-debuglink=$(TARGET).debug $(TARGET)
	size -d $(TARGET)

clean:
	@echo "-----> Cleaning"
	rm -fr $(BUILD_DIR)

run: $(TARGET)
	@echo "-----> Running"
	./build/target
