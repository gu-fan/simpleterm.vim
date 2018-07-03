simpleterm.vim
==============

Simple terminal in vim

.. image::
    https://user-images.githubusercontent.com/579129/42194902-d54fadd0-7ea8-11e8-9a15-310e4f1611d7.png


Require and Install
-------------------
Require
    Vim 8.1+  with ``+terminal``

Install
    ``Plug 'gu-fan/simpleterm.vim'``


if ``/bin/zsh`` exists, it will be used


Usage
-----

Commands
~~~~~~~~

+ ``Sshow`` show a terminal 
+ ``Shide`` hide the terminal
+ ``Stoggle`` toggle the terminal

+ ``Scd`` set terminal's dir
+ ``Sexe`` execute in terminal
+ ``Srun`` Run a background job and open terminal when finished
+ ``Sline`` execute in terminal with line
+ ``Sfile`` source in terminal with file

+ ``Salt`` create an alternative terminal
+ ``SKill`` Kill all the terminal

Maps
~~~~

::

    <leader>ss :Stoggle
    <leader>sw :Sshow
    <leader>sh :Shide

    <leader>sc :Scd
    <leader>se :Sexe
    <leader>sr :Srun

    <leader>sl :Sline
    visual <leader>sl :Sline with multi line
    <leader>sf :Sfile source current file

    <leader>sa :Salt
    <leader>sk :Skill

    In terminal, use <F1> to toggle terminal-mode to scroll up

Detail
~~~~~~

**Show/Hide/Toggle**

``Sshow`` create/show a minimal terminal.

``Shide`` hide the minimal terminal.

``Stoggle`` toggle the minimal terminal.

**execute**

``Scd`` change dir of terminal, if no ``path`` provided, change to current file's dir

``Sexe`` execute command in terminal, ``cmd`` needed

``Srun`` Run a command in background, and show terminal when finished, ``cmd`` needed

``Sline`` execute current line, if visual selected, execute multi line

``Sfile`` source file, if no ``file`` provided, source current file

.. code:: vim


   " terminal cd to %:p:h
   Scd

   " terminal cd to ~
   Scd ~

   " terminal will execute 'echo 1'
   Sexe echo 1

   " run a background job
   Srun git pull

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

``Skll`` Kill all the terminal.

