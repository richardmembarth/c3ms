* INSTALL

Compilation in debug/development mode
    make

Compilation in production mode
   make PRODUCTION=1

* USAGE

  c3ms [-g] [-v level] <files>

 Calculates Halstead's programming effort based on the number of tokens found in the files. Each file is treated as an independent module, the resulting volume and programming effort being the addition of the one computed for each file. The criteria to distinguish between operands and operators has been:
  - operands: constants, basic types (int, float, ...) and identifiers
  - operators: storage and type modifiers (const, static, ...), language keywords and operators.

 It also prints Halstead's volume as well as the number of conditionals, counting one conditional per case, default, for, if and while statement. The number of conditionals plus one is the cyclomatic number, which is another measure of code complexity.

The following options are available:
 -g   compute also the global effort as if all the files provided were 
      a single module. If -v is active, more global statistics are printed
 -v   print more data depending on the level provided. Namely
      level 1: the effort, volume and number of conditions per file
      level 2: the number of tokens and unique tokens of each kind
      level 3: the number of operands and operators

* REQUEST TO USERS

 If you find this program useful for your work, please cite this paper as source of the tool:

 Carlos H. Gonzalez, Basilio B. Fraguela. A Generic Algorithm Template for Divide-and-Conquer in Multicore Systems. 12th IEEE Intl Conf on High Performance Computing and Communications, HPCC 2010, pp. 79-88. 2010.
