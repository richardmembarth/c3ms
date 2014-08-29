
# C3MS: C++ Code Complexity Measurement System
# Copyright (C) 2009-2013 Basilio B. Fraguela. Universidade da Coruna
# 
# This file is part of C3MS.
# 
# C3MS is free software; you can redistribute it and/or modify it under the terms
# of the GNU General Public License as published by the Free Software Foundation;
# either version 2, or (at your option) any later version.
# 
# C3MS is distributed in the  hope that it will  be  useful, but  WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
 
# You should  have received a copy of  the GNU General  Public License along with
# C3MS; see the file COPYING.  If not, write to the  Free Software Foundation, 59
# Temple Place - Suite 330, Boston, MA 02111-1307, USA.

INCL := .
CC  := gcc
CXX := g++

objs           := c3ms.o c3mslex.o c3ms.tab.o
outputbinaries := c3ms

ifdef PRODUCTION
  CFLAGS := -I$(INCL) -O3 -DNDEBUG -fomit-frame-pointer
  #-fomit-frame-pointer makes exceptions not work properly for some compilers
  CPPFLAGS := -I$(INCL) -O3 -DNDEBUG
else
  CFLAGS := -I$(INCL) -g -DDEBUG
  CPPFLAGS := -I$(INCL) -g -DDEBUG
endif


all :  $(outputbinaries)

c3ms : $(objs)
	$(CXX) $(CPPFLAGS) -o $@ $^

%.tab.cpp: %.y %.l
	bison  -d -o $@ $<
	-@mv $(@D)/`basename $@ .cpp`.hpp $@.h

%lex.cpp:  %.l %.tab.cpp
	flex -Cemr -o$@ $<

%.o : %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.o : %.cpp
	$(CXX) -c $(CPPFLAGS) $< -o $@

clean:
	-@rm -f $(objs) c3ms.tab* c3mslex.cpp

veryclean: clean
	-@rm -rf $(outputbinaries)
