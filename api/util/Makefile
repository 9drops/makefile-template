########################################
#	Author: Alan Zhan
#	2010-08-20 created by Alan Zhan    #
########################################

##Name of module
NAME := util
##exe: excuable file, static:static library,dll:dynamic library
BUILD_TARGET_TYPE := dll 

BINDIR = .

##Path of header files
INCDIR = -I. \
    -I$(APIROOT)/include \
	-I$(ROOTDIR)/include \
	-I /usr/include/libxml2


##Souce files
SRC += util.c

##Switch of Marco
ifeq ($(SUPPORT_DBGOUTPUT), y)
CFLAGS += -DDBGOUTPUT
CFLAGS += -DLOG_BASE_LEVEL='"$(DBG_LOG_LEVEL)"'
##Add static library if the module need
##Add dynamic library if the module need
endif

##Static library
#STATIC_LINKS_WITH += \

##Dynamic library
DYN_LINKS_WITH += -L$(ROOTDIR)/lib/ \
-lyfxml
DYN_LINKS_WITH += -lxml2
DYN_LINKS_WITH += -lpthread
DYN_LINKS_WITH += -ldl

##Common rule
include $(APIROOT)/build/common.Makefile
