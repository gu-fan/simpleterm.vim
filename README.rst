simpleterm.vim
==============

simple terminal in vim


.. image::
   https://user-images.githubusercontent.com/579129/42217450-da0da526-7ef7-11e8-9943-6e416efc137f.png


Require and Install
-------------------


Require
    vim 8.1+  with ``+terminal``



Install
    ``Plug 'gu-fan/simpleterm.vim'``



vimrc::

    set shell=/bin/zsh                      " set other shell if needed



Usage
-----

Example
~~~~~~~

.. code:: vim

    " execute commands (async in terminal window
    Sexe git clone https://github.com/gu-fan/simpleterm.vim.git

    " run background jobs (and show it when finished
    Srun git pull 

    " cd to a dir (if no path, cd to lcd
    Scd simpleterm.vim

    " execute current line in buffer (multiline in visual mode
    Sline

    " source target file (if no target, source current file
    Sfile  ~/test.sh

    " so, as you can easily run cmds from files
    " you can keep scipt for works: 
    " setup/dev/test/make/deploy/coffee...

    " see https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/e1rnx8g

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


**alter**


``Salt`` create another terminal and execute ``cmds``, not be triggerd by 'Scd/Sexe/Sline/Sfile'


``Skill`` Kill all terminal

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

    nnor <Leader>sa :Salt<Space>
    nnor <Leader>sk :Skill<CR>

    " In terminal, use <ESC> to escape terminal-mode
    tnor <ESC>   <C-\><C-n>          
    " then, use a or i to back to terminal-mode, like insert-mode


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


Thread
    https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/

