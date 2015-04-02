#############################################
# Author: Alan Zhan		                	#
# 2010-08-20 created by ALan Zhan    		#
#############################################

#############################################
#The variable of user define
#############################################
# NAME : Name of module
# BUILD_TARGET_TYPE: target file type, 
# available value: static,.a,exe, EXE, Exe, dll, .so, .So
# INCDIR: List of fold path which include header files(Add -I before folder path)
# SRC: Souce files
# TEST_SRC: Source files of testting
# BINDIR: The path of target file
# DYN_LINKS_WITH: Dynamic library which should be linked
# STATIC_LINKS_WITH: Static library which should be linked
# DEPS_TARGET: depend target
#
# DBG: debug or don't, available value:y,n
# PRINT_COMPILER: print compiling info or don't, available value:y, n
#
# CC : C compiler
# CXX : C++ compiler
# LINK: linker
# CFLAGS: c compiler flags
# CXXFLAGS: c++ copmiler flags
# LINKFLAGS: link flags

#############################################

# c++ suffix
CCSUFIX= cpp

# rm
RM= rm -f
#cp
CP := cp -f

# c++ compiler flags
CXXFLAGS += $(CFLAGS)
# preprocessing flags
CPPFLAGS += $(CFLAGS) -MM


####################################################################

ifeq ($(DBG), y)
CFLAGS += -O0 -g -m64 -fPIC
else
CFLAGS += -O2 -m64 -fPIC
endif

Q_ := @

ifeq ($(PRINT_COMPILER), y)
Q_ :=
endif


#Default target
TARGET := lib$(NAME).a

ifeq ($(findstring dll,$(BUILD_TARGET_TYPE)), dll)
TARGET := lib$(NAME).so
LINKFLAGS := -shared -fPIC 
endif

ifeq ($(findstring static,$(BUILD_TARGET_TYPE)), static)
TARGET := lib$(NAME).a
endif


ifeq ($(findstring exe,$(BUILD_TARGET_TYPE)), exe)
TARGET := $(NAME)
SRC += $(TEST_SRC)
endif

CFLAGS += $(INCDIR)


####################################################################

OBJ += $(patsubst %.c,%.o,$(patsubst %.$(CCSUFIX),%.o,$(SRC))) 


BIN := $(BINDIR)/$(TARGET) 

.PHONY:	all clean veryclean tags deps release $(DEPS_TARGET)

all:  deps   $(BIN) $(DEPS_TARGET)

deps: .depend

.depend: $(SRC)
	@echo 'generating depend file ...'
	$(Q_)$(CC) -MM $(CPPFLAGS)  $^ 1>.depend

#Redefine implicit rule
%.o: %.c
	@echo '<$(CC)>[$(DBG)] Compiling object file "$@" ...'
	$(Q_)${CC} $(CFLAGS) -c $< -o $@

%.o: %.$(CCSUFIX)
	@echo '<$(CXX)>[$(DBG)] Compiling object file "$@" ...'
	$(Q_)${CXX} $(CFLAGS) -c $< -o $@


clean:
	@echo remove all objects
	$(RM) $(OBJ) $(BIN) $(CLEAN_OBJ) .depend

veryclean:
	@echo remove all objects and deps
	$(RM) $(OBJ) $(BIN) $(CLEAN_OBJ)  .depend 

#rebuild
re: veryclean all

$(BIN): $(OBJ) 
	@echo 
ifeq ($(findstring exe,$(BUILD_TARGET_TYPE)), exe)
	@echo '<$(LINK)>creating binary "$(BIN)"'
	$(Q_)$(LINK)  $(LINKFLAGS) $(OBJ) $(STATIC_LINKS_WITH) $(DYN_LINKS_WITH)  -o $(BIN) && chmod a+x $(BIN)
else
ifeq ($(findstring dll,$(BUILD_TARGET_TYPE)), dll)
	@echo '<$(LINK)>creating dll "$(BIN)"'
	$(Q_)$(LINK)  $(LINKFLAGS) $(OBJ) $(STATIC_LINKS_WITH) $(DYN_LINKS_WITH) -o $(BIN) && chmod a+x $(BIN)
#	$(CP) $(BIN) $(APIROOT)/lib/$(PLATFORM)
	$(CP) $(BIN) $(ROOTDIR)/lib
ifeq ($(findstring y,$(CP_ISOALIB)), y)
	$(CP) $(BIN) $(LIBDIR)
endif

else
	@echo '<$(AR)>creating static lib "$(BIN)"'
	$(AR) rc $@ $^
#	$(CP) $@ $(APIROOT)/lib/$(PLATFORM)
	$(CP) $(BIN) $(ROOTDIR)/lib
ifeq ($(findstring y,$(CP_ISOALIB)), y)
	$(CP) $(BIN) $(LIBDIR)
endif

endif
endif
	@echo '... done'
	@echo


ifneq ($(wildcard .depend),)
include .depend
endif
