SimpleTerm.vim
==============


Simple Terminal with vim ``+terminal`` support

Require
-------

Vim 8.1+

``+terminal``

if has ``/bin/zsh`` exists, it will be used

Install
-------

``Plug 'gufan/simpleterm.vim'``


Usage
-----

Commands
~~~~~~~~

+ Sshow show a terminal 
+ Shide hide the terminal
+ Stoggle toggle the terminal

+ Scd set terminal's dir
+ Sexe execute in terminal
+ Sline execute in terminal with line
+ Sfile source in terminal with file

+ Salt create an alternative terminal

Maps
~~~~

+ <leader>ss :Stoggle
+ <leader>sw :Sshow
+ <leader>sh :Shide

+ <leader>sc :Scd

+ <leader>sl :Sline
+ visual <leader>sl :Sline with multi line
+ <leader>sf :Sfile source current file

+ <leader>sa :Salt

+ In terminal, use <Esc> to toggle terminal-mode 

Detail
~~~~~~

**Show/Hide/Toggle**

``Sshow`` create/show a minimal terminal.

``Shide`` hide the minimal terminal.

``Stoggle`` toggle the minimal terminal.

.. code:: vim

   Sshow
   Shide
   Stoggle

**execute**

``Scd`` change dir of terminal, if no arg provided, change to current file's dir

``Sexe`` execute command in terminal

``Sline`` execute current line, if visual selected, execute multi line

``Sfile`` source current file, if arg provided, source target file

.. code:: vim


   " terminal cd to %:p:h
   Scd

   " terminal cd to ~
   Scd ~

   " terminal will execute 'echo 1'
   Sexe echo 1

   " execute one line
   Sline

   " execute multi line
   '<,'>Sline


   " source current file
   Sfile

   " source target file
   Sfile  ~/test.sh




**alter**

``Salt`` create another terminal, which wont be triggerd by commands

.. code:: vim

   " create another terminal
   Salt

