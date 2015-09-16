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

  /* Portions copied from http://www.lysator.liu.se/c/ANSI-C-grammar-l.html */

#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <stack>

#include "CodeStatisticsGatherer.h"
#include "c3ms.tab.cpp.h"


  extern YYSTYPE yylval;

  int ParserLineno;
  CodeStatisticsGatherer stat;

  void resetLexer() {
    YY_FLUSH_BUFFER;
  }

  void resetFileStatistics() {
    ParserLineno = 0;
    stat.reset();
  }

%}

%option noyywrap

D           [0-9]
L           [a-zA-Z_]
H           [a-fA-F0-9]
E           [Ee][+-]?{D}+
FS          (f|F|l|L)
IS          (u|U|l|L)*

%x comment
%s includestate

%%

  /***************** C comments ***************/

"/*"                    { BEGIN(comment); }
<comment>[^*\n]*        { /* eat anything that's not a '*' */ }
<comment>"*"+[^*/\n]*   { /* eat up '*'s not followed by '/'s */ }
<comment>\n             { ParserLineno++; }
<comment>"*"+"/"        { BEGIN(INITIAL); }

  /********* Preprocessor ********************/

  /* No preprocessor */

  /********* Eat Comments and lines **********/

"//".*      { /* eat C++ style comments */}
[\n\r]      { ParserLineno++; }
[\t ]+

  /***************** Keywords ***************/

int         { stat.type(yytext); }
float       { stat.type(yytext); }
double      { stat.type(yytext); }
i8          { stat.type(yytext); }
i16         { stat.type(yytext); }
i32         { stat.type(yytext); }
i64         { stat.type(yytext); }
u8          { stat.type(yytext); }
u16         { stat.type(yytext); }
u32         { stat.type(yytext); }
u64         { stat.type(yytext); }
f32         { stat.type(yytext); }
f64         { stat.type(yytext); }
bool        { stat.type(yytext); }
simd        { stat.type(yytext); }

let         { stat.keyword(yytext); }
static      { stat.keyword(yytext); }
extern      { stat.keyword(yytext); }
type        { stat.keyword(yytext); }
mut         { stat.keyword(yytext); }
fn          { stat.keyword(yytext); }

break       { stat.keyword(yytext); }
in          { /* Part of the for loop */ }
continue    { stat.keyword(yytext); }
else        { stat.keyword(yytext); }
for         { stat.keyword(yytext); }
if          { stat.keyword(yytext); stat.cond(); }
return      { stat.keyword(yytext); }
struct      { stat.keyword(yytext); }
while       { stat.keyword(yytext); stat.cond(); }

false       { stat.constant(yytext); }
true        { stat.constant(yytext); }

{L}({L}|{D})*   { stat.identifier(yytext); }

  /***************** operators ***************/

"+="    { stat.op(yytext); }
"-="    { stat.op(yytext); }
"*="    { stat.op(yytext); }
"/="    { stat.op(yytext); }
"%="    { stat.op(yytext); }
"&="    { stat.op(yytext); }
"^="    { stat.op(yytext); }
"|="    { stat.op(yytext); }
">>"    { stat.op(yytext); }
"<<"    { stat.op(yytext); }
"++"    { stat.op(yytext); }
"--"    { stat.op(yytext); }
"->"    { stat.op(yytext); }
"&&"    { stat.op(yytext); }
"||"    { stat.op(yytext); }
"<="    { stat.op(yytext); }
">="    { stat.op(yytext); }
"=="    { stat.op(yytext); }
"!="    { stat.op(yytext); }
";"     { stat.op(yytext); }
("{"|"<%")  { stat.openBracket();  }
("}"|"%>")  { stat.closeBracket(); }
","     { stat.op(yytext); }
":"     {  }
"="     { stat.op(yytext); }
"("     { stat.op(yytext); }
")"     {                  }
("["|"<:")  { stat.op(yytext); }
("]"|":>")  {                  }
"."     { stat.op(yytext); }
"&"     { stat.op(yytext); }
"!"     { stat.op(yytext); }
"~"     { stat.op(yytext); }
"-"     { stat.op(yytext); }
"+"     { stat.op(yytext); }
"*"     { stat.op(yytext); }
"/"     { stat.op(yytext); }
"%"     { stat.op(yytext); }
"<"     { stat.op(yytext); }
">"     { stat.op(yytext); }
"^"     { stat.op(yytext); }
"|"     {  }
"@"     { stat.op(yytext); }

  /***************** constants ***************/

0[xX]{H}+{IS}?          { stat.constant(yytext); }
0{D}+{IS}?              { stat.constant(yytext); }
{D}+{IS}?               { stat.constant(yytext); }
L?'(\\.|[^\\'])+'       { stat.constant(yytext); }

{D}+{E}{FS}?            { stat.constant(yytext); }
{D}*"."{D}+({E})?{FS}?  { stat.constant(yytext); }
{D}+"."{D}*({E})?{FS}?  { stat.constant(yytext); }

L?\"(\\.|[^\\"])*\"     { stat.constant(yytext); /* STRING_LITERAL*/ }

.                       { printf("bad character: %c\n", *yytext); }

%%

