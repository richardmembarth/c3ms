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

#ifndef CODESTATISTICSGATHERER_H
#define CODESTATISTICSGATHERER_H

//#include <stack>

#include "CodeStatistics.h"

class CodeStatisticsGatherer : public CodeStatistics {
public:
  CodeStatisticsGatherer()
  : CodeStatistics()
  {
    //cbracketDepth = 0;
    //ignoreMode.push(true);
  }

  void openBracket()  { op("{"); }
  void closeBracket() { }

private:

  //unsigned int cbracketDepth;

  //std::stack<bool> ignoreMode;
};

#endif //CODESTATISTICSGATHERER_H
