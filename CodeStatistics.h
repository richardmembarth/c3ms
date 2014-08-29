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

#ifndef CODESTATISTICS_H
#define CODESTATISTICS_H

#include <set>
#include <string>

class CodeStatistics {

  struct ltstr2 {
    bool operator()(const std::string& s1, const std::string& s2) const
    {
      return s1.compare(s2) < 0;
    }
  };

  typedef std::set<std::string, ltstr2> CSSet;

public:

  typedef unsigned int StatSize;

  CodeStatistics() {
    reset();
  }

  void reset() {
    types = 0;
    constants = 0;
    identifiers = 0;
    cspecs = 0;
    keywords = 0;
    operators = 0;
    conditions = 0;

    typesSet.clear();
    constantsSet.clear();
    identifiersSet.clear();
    cspecsSet.clear();
    keywordsSet.clear();
    operatorsSet.clear();
  }

  void type(const char *p)       {       types++;       typesSet.insert(std::string(p)); }
  void constant(const char *p)   {   constants++;   constantsSet.insert(std::string(p)); }
  void identifier(const char *p) { identifiers++; identifiersSet.insert(std::string(p)); }
  void cspec(const char *p)      {      cspecs++;      cspecsSet.insert(std::string(p)); }
  void keyword(const char *p)    {    keywords++;    keywordsSet.insert(std::string(p)); }
  void op(const char *p)         {   operators++;   operatorsSet.insert(std::string(p)); }

  void decOp()      { operators--; }
  void cond()       { conditions++; }

  StatSize getTypes()       const { return types; }
  StatSize getConstants()   const { return constants; }
  StatSize getIdentifiers() const { return identifiers; }
  StatSize getCspecs()      const { return cspecs; }
  StatSize getKeywords()    const { return keywords; }
  StatSize getOps()         const { return operators; }
  StatSize getConds()       const { return conditions; }

  StatSize getOperands()    const { return constants + identifiers; }
  StatSize getOperators()   const { return types + cspecs + keywords + operators;   }

  StatSize getUniqueTypes()       const { return typesSet.size(); }
  StatSize getUniqueConstants()   const { return constantsSet.size(); }
  StatSize getUniqueIdentifiers() const { return identifiersSet.size(); }
  StatSize getUniqueCspecs()      const { return cspecsSet.size(); }
  StatSize getUniqueKeywords()    const { return keywordsSet.size(); }
  StatSize getUniqueOps()         const { return operatorsSet.size(); }

  StatSize getUniqueOperands() const  { return getUniqueConstants() + getUniqueIdentifiers(); }
  StatSize getUniqueOperators() const { return getUniqueTypes() + getUniqueCspecs() + getUniqueKeywords()  + getUniqueOps();   }

  CodeStatistics& operator+= (const CodeStatistics& other) {
    types       += other.types;
    constants   += other.constants;
    identifiers += other.identifiers;
    cspecs      += other.cspecs;
    keywords    += other.keywords;
    operators   += other.operators;
    conditions  += conditions;

    copy(other.typesSet.begin(),       other.typesSet.end(),       inserter(typesSet,       typesSet.begin()));
    copy(other.constantsSet.begin(),   other.constantsSet.end(),   inserter(constantsSet,   constantsSet.begin()));
    copy(other.identifiersSet.begin(), other.identifiersSet.end(), inserter(identifiersSet, identifiersSet.begin()));
    copy(other.cspecsSet.begin(),      other.cspecsSet.end(),      inserter(cspecsSet,      cspecsSet.begin()));
    copy(other.keywordsSet.begin(),    other.keywordsSet.end(),    inserter(keywordsSet,    keywordsSet.begin()));
    copy(other.operatorsSet.begin(),   other.operatorsSet.end(),   inserter(operatorsSet,   operatorsSet.begin()));

    return *this;
  }

private:

  StatSize types, constants, identifiers, cspecs, keywords, operators, conditions;

  CSSet typesSet, constantsSet, identifiersSet, cspecsSet, keywordsSet, operatorsSet;
};

#endif //CODESTATISTICS_H
