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

\#[\t ]*define          { stat.keyword(yytext); }
\#[\t ]*else            { stat.keyword(yytext); /*stat.cond();*/ }
\#[\t ]*endif           { /* nothing*/ }
\#[\t ]*if              { stat.keyword(yytext); stat.cond(); }
\#[\t ]*ifdef           { stat.keyword(yytext); stat.cond(); }
\#[\t ]*ifndef          { stat.keyword(yytext); stat.cond(); }
\#[\t ]*include         { stat.keyword(yytext); BEGIN(includestate); }
\#[\t ]*pragma          { stat.keyword(yytext); }
\#[\t ]*line.*          { }

<includestate>\<              { /* do not count as operator */ }
<includestate>\>              { /* do not count as operator */ }
<includestate>[\n\r]          { ParserLineno++; BEGIN(INITIAL); }

  /********* Eat Comments and lines **********/

"//".*      { /* eat C++ style comments */}
[\n\r]      { ParserLineno++; }
[\t ]+

  /***************** Keywords ***************/

int         { stat.type(yytext); }
float       { stat.type(yytext); }
char        { stat.type(yytext); }
double      { stat.type(yytext); }
long        { stat.type(yytext); }
short       { stat.type(yytext); }
signed      { stat.type(yytext); }
unsigned    { stat.type(yytext); }
void        { stat.type(yytext); }

auto        { stat.cspec(yytext); }
extern      { stat.cspec(yytext); }
register    { stat.cspec(yytext); }
static      { stat.cspec(yytext); }
typedef     { stat.cspec(yytext); }

const       { stat.cspec(yytext); }
volatile    { stat.cspec(yytext); }

break       { stat.keyword(yytext); }
case        { stat.keyword(yytext); stat.cond(); }
continue    { stat.keyword(yytext); }
default     { stat.keyword(yytext); stat.cond(); }
do          { stat.keyword(yytext); }
else        { stat.keyword(yytext); /*stat.cond();*/ }
enum        { stat.keyword(yytext); }
for         { stat.keyword(yytext); stat.cond(); stat.decOp(); }
goto        { stat.keyword(yytext); }
if          { stat.keyword(yytext); stat.cond(); stat.decOp(); }
return      { stat.keyword(yytext); }
sizeof      { stat.keyword(yytext); }
struct      { stat.keyword(yytext); }
switch      { stat.keyword(yytext); /*cond counted in cases+default*/ stat.decOp(); }
union       { stat.keyword(yytext); }
while       { stat.keyword(yytext); stat.cond(); stat.decOp(); }

  /***************** C++ - specific ***************/

bool        { stat.type(yytext); }
wchar_t     { stat.type(yytext); }

false       { stat.constant(yytext); }
true        { stat.constant(yytext); }

inline      { stat.cspec(yytext); }
mutable     { stat.cspec(yytext); }
virtual     { stat.cspec(yytext); }

catch       { stat.keyword(yytext); stat.decOp(); }
class       { stat.keyword(yytext); }
const_cast  { stat.keyword(yytext); stat.decOp(); }
delete      { stat.keyword(yytext); }
dynamic_cast { stat.keyword(yytext); stat.decOp(); }
explicit    { stat.keyword(yytext); }
export      { stat.keyword(yytext); }
friend      { stat.keyword(yytext); }
namespace   { stat.keyword(yytext); }
new         { stat.keyword(yytext); }
operator    { stat.keyword(yytext); }
private     { stat.keyword(yytext); }
protected   { stat.keyword(yytext); }
public      { stat.keyword(yytext); }
reinterpret_cast { stat.keyword(yytext); stat.decOp(); }
static_cast { stat.keyword(yytext); stat.decOp(); }
template    { stat.keyword(yytext); stat.decOp(); /* either < or > is not an operator */ }
this        { stat.keyword(yytext); }
throw       { stat.keyword(yytext); }
try         { stat.keyword(yytext); }
typeid      { stat.keyword(yytext); }
typename    { stat.keyword(yytext); }
using       { stat.keyword(yytext); }
asm         { printf("asm is unsupported\n"); }

  /***************** CUDA specific ***************/
__device__              { stat.cspec(yytext); }
__global__              { stat.cspec(yytext); }
__host__                { stat.cspec(yytext); }
__constant__            { stat.cspec(yytext); }
__shared__              { stat.cspec(yytext); }
__inline__              { stat.cspec(yytext); }
__align__               { stat.cspec(yytext); }
__thread__              { stat.cspec(yytext); }
__restrict__            { stat.cspec(yytext); }
__launch_bounds__       { stat.cspec(yytext); }
__attribute__           { stat.cspec(yytext); printf("attribute: %s\n", yytext); }
__restrict              { stat.cspec(yytext); }
uchar                   { stat.type(yytext); }
ushort                  { stat.type(yytext); }
uint                    { stat.type(yytext); }
ulong                   { stat.type(yytext); }
ufloat                  { stat.type(yytext); }
char1                   { stat.type(yytext); }
char2                   { stat.type(yytext); }
char3                   { stat.type(yytext); }
char4                   { stat.type(yytext); }
uchar1                  { stat.type(yytext); }
uchar2                  { stat.type(yytext); }
uchar3                  { stat.type(yytext); }
uchar4                  { stat.type(yytext); }
short1                  { stat.type(yytext); }
short2                  { stat.type(yytext); }
short3                  { stat.type(yytext); }
short4                  { stat.type(yytext); }
ushort1                 { stat.type(yytext); }
ushort2                 { stat.type(yytext); }
ushort3                 { stat.type(yytext); }
ushort4                 { stat.type(yytext); }
int1                    { stat.type(yytext); }
int2                    { stat.type(yytext); }
int3                    { stat.type(yytext); }
int4                    { stat.type(yytext); }
uint1                   { stat.type(yytext); }
uint2                   { stat.type(yytext); }
uint3                   { stat.type(yytext); }
uint4                   { stat.type(yytext); }
long1                   { stat.type(yytext); }
long2                   { stat.type(yytext); }
long3                   { stat.type(yytext); }
long4                   { stat.type(yytext); }
ulong1                  { stat.type(yytext); }
ulong2                  { stat.type(yytext); }
ulong3                  { stat.type(yytext); }
ulong4                  { stat.type(yytext); }
float1                  { stat.type(yytext); }
float2                  { stat.type(yytext); }
float3                  { stat.type(yytext); }
float4                  { stat.type(yytext); }
ufloat1                 { stat.type(yytext); }
ufloat2                 { stat.type(yytext); }
ufloat3                 { stat.type(yytext); }
ufloat4                 { stat.type(yytext); }
dim3                    { stat.type(yytext); }

texture                 { stat.type(yytext); }
textureReference        { stat.type(yytext); }
cudaError_t             { stat.type(yytext); }
cudaDeviceProp          { stat.type(yytext); }
cudaMemcpyKind          { stat.type(yytext); }
cudaArray               { stat.type(yytext); }
cudaChannelFormatKind   { stat.type(yytext); }
cudaChannelFormatDesc   { stat.type(yytext); }
cudaTextureAddressMode  { stat.type(yytext); }
cudaTextureFilterMode   { stat.type(yytext); }
cudaTextureReadMode     { stat.type(yytext); }
blockIdx\.[x|y|z]       { stat.keyword(yytext); }
blockDim\.[x|y|z]       { stat.keyword(yytext); }
gridDim\.[x|y|z]        { stat.keyword(yytext); }
threadIdx\.[x|y|z]      { stat.keyword(yytext); }
__syncthreads           { stat.keyword(yytext); }

{L}({L}|{D})*   { stat.identifier(yytext); }

  /***************** operators ***************/

"..."   { stat.op(yytext); }
"::"    { stat.op(yytext); }
">>="   { stat.op(yytext); }
"<<="   { stat.op(yytext); }
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
":"     {            }
"="     { stat.op(yytext); }
"("     { stat.op(yytext); }
")"     {            }
("["|"<:")  { stat.op(yytext); }
("]"|":>")  {            }
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
"|"     { stat.op(yytext); }
"?"     { stat.op(yytext); stat.cond(); }

\\      { /* macro continuation */ }

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

