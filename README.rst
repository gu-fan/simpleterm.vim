simpleterm.vim
==============

simple terminal in vim

*without losing focus*

.. image::
   https://user-images.githubusercontent.com/579129/42217450-da0da526-7ef7-11e8-9943-6e416efc137f.png


Require and Install
-------------------


Require
    Vim 8.1+  with ``+terminal``



Install
    ``Plug 'gu-fan/simpleterm.vim'``



**NOTE** if ``/bin/zsh`` exists, it will be used



Usage
-----

Commands
~~~~~~~~


+ ``Sshow``     show a terminal 
+ ``Shide``     hide the terminal
+ ``Stoggle``   toggle the terminal
+ ``Scd``       set terminal's dir
+ ``Sexe``      execute in terminal
+ ``Srun``      run a background job and show terminal after finished
+ ``Sline``     execute in terminal with line
+ ``Sfile``     source in terminal with file
+ ``Salt``      create an alternative terminal
+ ``SKill``     Kill all the terminal



Maps
~~~~


.. code:: vim

    nnor <Leader>sw :Sshow<CR>
    nnor <Leader>sh :Shide<CR>
    nnor <Leader>ss :Stoggle<CR>

    nnor <Leader>sc :Scd<CR>

    nnor <Leader>se :Sexe<Space>
    nnor <Leader>sr :Srun<Space>

    nnor <Leader>sl :Sline<CR>
    vnor <Leader>sl :Sline<CR>      
    nnor <Leader>sf :Sfile<CR>

    nnor <Leader>sa :Salt<CR>
    nnor <Leader>sk :Skill<CR>

    " In terminal, use <F1> to toggle terminal-mode
    tnor <F1>   <C-\><C-n>          
        


Detail
~~~~~~


**show/hide**

``Sshow`` create/show a minimal terminal.

``Shide`` hide the minimal terminal.

``Stoggle`` toggle the minimal terminal.

**execution**

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


``Skill`` Kill all terminal



Further
-------



All function and option are in ``g:simpleterm`` object,
change or use it::

    g:simpleterm.row = 7                    row height for new terminal
    g:simpleterm.pos = 'below'              row position for new terminal

    g:simpleterm.bufs                       all the termial of simpleterm
    g:simpleterm.buf                        current main terminal
    g:simpleterm.bg                         current bg terminal



Author & License
----------------


Author
    gu.fan at https://github.com/gu-fan


License
    wtfpl at http://sam.zoy.org/wtfpl/COPYING.
