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

WARNINGS=/W4 /WX /analyze /w14445 /w14640 /w14242 /w4191 /w14263 /w14265 /w4061 /w4702

INCLUDES=/I. /Isrc
CFLAGS = /std:c17 /DSTDC_WANT_LIB_EXT2__=1 /nologo /MD /D_CRT_SECURE_NO_WARNINGS $(INCLUDES) $(WARNINGS)

!IFDEF DEV
CPPFLAGS = $(CPPFLAGS) /Od /Zi /GS /W4
!ELSE
CPPFLAGS = $(CPPFLAGS) /O2 /GL /GS /D_FORTIFY_SOURCE=2
LDFLAGS  = /LTCG /INCREMENTAL:NO /OPT:REF /OPT:ICF
!ENDIF

CPPFLAGS_CONTRIB = /nologo /MD /I. /O2 /GL

#
# Targets
#

.SUFFIXES: .c .obj

.c.obj:
	cl /c $(CPPFLAGS) /Fo$@ $<

$(PROJECT).exe: src\main.obj $(OBJ)
	link /nologo $(LDFLAGS) /OUT:$@ $(OBJ)

$(PROJECT)-test.exe: tests\tests.obj $(OBJ)
	link /nologo $(LDFLAGS) /OUT:$@ $(OBJ)

check: $(PROJECT)-test
	$(PROJECT)-test.exe

dev:
	nmake all DEV=1

clean:
	del $(PROJECT).exe $(PROJECT)-test.exe
	cmd /V:ON /C "set P=$(OBJ) & del !P:/=\!"
