#############################################                                                                                       
# Author: Alan Zhan                         #
# 2010-08-20 created by ALan Zhan           #
#############################################
#Compiler
CC:=gcc
CXX:=g++
LINK:=g++
AR:=ar


ifndef BINDIR
BINDIR := $(APIROOT)/lib/$(PLATFORM)
endif

ifndef BUILD_TARGET_TYPE
BUILD_TARGET_TYPE := static
else
ifeq ($(findstring dll,$(BUILD_TARGET_TYPE)), dll)
BUILD_TARGET_TYPE := dll 
endif
endif


CFLAGS+= -Wall -DLINUX

CFLAGS	+= -DSUPPORT_DYNAMIC_LINK

LINKFLAGS += -lpthread -lm -lrt

