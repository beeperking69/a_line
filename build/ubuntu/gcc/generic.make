include ./definitions.$(TGT).make

DIR_ROOT=../../..
DIR_OUT=out

EXT_HDR=h
EXT_SRC=c
EXT_OBJ=o

AR = ar rcs
CC = gcc

DEBUG ?= 1
ifeq (DEBUG, 1)
    CFLAGS = -std=c99 -g -Wall
else
    CFLAGS = -std=c99 -O3 -Wall
endif

DIR_SRC = $(DIR_ROOT)/$(TGT)
DIR_BIN = $(DIR_OUT)/$(TGT)
DIR_OBJ = $(DIR_BIN)

SRC_FILES := $(wildcard $(DIR_SRC)/*.$(EXT_SRC))
OBJ_FILES := $(SRC_FILES:$(DIR_SRC)/%.$(EXT_SRC)=$(DIR_OBJ)/%.$(EXT_OBJ))

.PHONY: all clean
.SECONDARY: main-build

all: clean pre-build main-build

pre-build:
	@mkdir -p $(DIR_BIN)
	@mkdir -p $(DIR_OBJ)

main-build: $(TGT)
	@echo Success: $(TGT)

$(OBJ_FILES): $(DIR_OBJ)/%.$(EXT_OBJ) : $(DIR_SRC)/%.$(EXT_SRC) 
	@echo "Compiling "$<" "
	@$(CC) $(CFLAGS) -I$(DIR_ROOT) -c $< -o $@

$(TGT): $(OBJ_FILES)

static: $(OBJ_FILES)
	@$(AR) $(DIR_OUT)/$(TGT).a $(OBJ_FILES)

shared: $(OBJ_FILES)
	@$(CC) -shared -Wl,-soname,lib$(TGT).so -o $(DIR_OUT)/lib$(TGT).so $^ -lc $(LFLAGS)

clean:
	@rm -rf $(DIR_BIN)
	@rm -f $(DIR_OUT)/lib$(TGT).so
	@rm -f $(DIR_OUT)/$(TGT).a