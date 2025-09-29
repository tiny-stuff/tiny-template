# This file is meant to be used by 'nmake' on Windows. See GNUmakefile for other POSIX OSes.

PROJECT=tiny-template

all: $(PROJECT).exe

# 
# Objects
#

OS=win32
OS_GENERIC=win32
!INCLUDE objects.mk
OBJ = $(OBJ:.o=.obj)

#
# Flags
#

WARNINGS=/W4 /WX /w14445 /w14640 /w14242 /w14263 /w14265

INCLUDES = /I. /Isrc
CFLAGS = /std:c17 /DSTDC_WANT_LIB_EXT2__=1 /nologo /MD /D_CRT_SECURE_NO_WARNINGS $(INCLUDES)

!IFDEF DEV
CFLAGS = $(CFLAGS) /Od /Zi /GS /W4 $(WARNINGS)
!ELSE
CFLAGS = $(CFLAGS) /O2 /GL /GS /D_FORTIFY_SOURCE=2
LDFLAGS = /LTCG /INCREMENTAL:NO /OPT:REF /OPT:ICF
!ENDIF

CFLAGS_CONTRIB = /nologo /MD /I. /O2 /GL

#
# Targets
#

.SUFFIXES: .c .obj

.c.obj:
	cl /c $(CFLAGS) /Fo$@ $<

$(PROJECT).exe: src\main.obj $(OBJ)
	link /nologo $(LDFLAGS) /OUT:$@ $**

$(PROJECT)-test.exe: tests\tests.obj $(OBJ)
	link /nologo $(LDFLAGS) /OUT:$@ $**

check: $(PROJECT)-test.exe
	$(PROJECT)-test.exe

dev:
	nmake all DEV=1

clean:
	del $(PROJECT).exe $(PROJECT)-test.exe src\main.obj tests\tests.obj
	cmd /V:ON /C "set P=$(OBJ) & del !P:/=\!"
