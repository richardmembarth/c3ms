%{

  /*
   C3MS: C++ Code Complexity Measurement System
   Copyright (C) 2009-2013 Basilio B. Fraguela. Universidade da Coruna

   This file is part of C3MS.

   C3MS is free software; you can redistribute it and/or modify it under the terms
   of the GNU General Public License as published by the Free Software Foundation;
   either version 2, or (at your option) any later version.

   C3MS is distributed in the  hope that it will  be  useful, but  WITHOUT ANY
   WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
   PARTICULAR PURPOSE. See the GNU General Public License for more details.

   You should  have received a copy of  the GNU General  Public License along with
   C3MS; see the file COPYING.  If not, write to the  Free Software Foundation, 59
   Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */

#include <cassert>
#include <cstdio>
#include <cstdlib>
#include <cstring>

#include "CodeStatisticsGatherer.h"

  extern int ParserLineno; /* Defined in anl.flex */

  int yylex (void);
  void yyerror (char const *);

  extern CodeStatisticsGatherer stat;
%}

%union {

}

%token TOPLEVELBLOCK

%start program

%%
program : top_level_sequence
        ;

top_level_sequence:
           /* empty */
        | TOPLEVELBLOCK top_level_sequence
        ;

%%

extern FILE *yyin;
extern void resetLexer();
extern void resetFileStatistics();

/* Called by yyparse on error.  */
void yyerror (char const *s) {
  fprintf (stderr, "Line %d: %s\n", ParserLineno, s);
}

const CodeStatistics& readFile(const char *fname) {
  yyin = fopen(fname, "r");

  if (yyin == 0) {
    printf("Unable to open file [%s]\n", fname);
    exit(EXIT_FAILURE);
  }

  resetFileStatistics();

  try {
    yyparse();
  } catch (...) {
    fclose(yyin);
    printf("Exception thrown while processing %s\n", fname);
    resetLexer();
    exit(EXIT_FAILURE);
  }

  fclose(yyin);

  return stat;
}

