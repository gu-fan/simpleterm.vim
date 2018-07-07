simpleterm.vim
==============

simple terminal in vim


.. image::
    https://user-images.githubusercontent.com/579129/42396749-99966032-8195-11e8-9492-a3738b35854a.png


Require and Install
-------------------


Require
    vim 8.1+  with ``+terminal``



Install
    ``Plug 'gu-fan/simpleterm.vim'``



Usage
-----

Example
~~~~~~~

.. code:: vim

    " execute commands (async in terminal window
    Sexe git clone https://github.com/gu-fan/simpleterm.vim.git

    " run background jobs (and show me when finished
    Srun git pull 

    " cd to a dir 
    Scd simpleterm.vim

    " execute current line in buffer
    Sline

    " source target file 
    Sfile  ~/test.sh

    " show another window with test
    Salt test

        
so, as you can easily executing whilst editing, you can

tracking work as scripts, and vice versa
-------------------------------------------------

``e.g.: setup/dev/test/make/deploy/coffee...``


I should say, that's the greatest part of vim's terminal integration


Detail
~~~~~~


**show/hide**

``Sshow`` create/show a minimal terminal.

``Shide`` hide the minimal terminal.

``Stoggle`` toggle the minimal terminal.

**execution**

``Scd`` change dir of terminal, if no ``path``, change to current file's dir

``Sexe`` execute command in terminal, ``cmd`` needed

|

``Srun`` Run a command in background, and show terminal when finished, ``cmd`` needed

``Sline`` execute current line, if visual selected, execute multi line

``Sfile`` source file, if no ``file`` provided, source current file


**alter**


``Salt`` create another terminal and execute ``cmd``, prefix ``num`` to change height,
not triggerd by ``Scd/Sexe/Sline/Sfile``, ``cmd`` needed


``Skill`` Kill all terminal

Maps
~~~~

**Default**

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
    " then, use a or i to back to terminal-mode, like insert-mode
    tnor <ESC>   <C-\><C-n>          

    " see :h CTRL-W_. for terminal commands

**Customize**

.. code:: vim

    " also mapping your works, e.g.
    nnore <Leader>gp :Srun git push<CR>
    nnore <Leader>gP :Srun git pull<CR>

    " need some func?
    " https://gist.github.com/marianposaceanu/6615458
    nnore <Leader>fk :20Salt fortune\|cowsay\|lolcat<CR>

Further
-------



All function and option are in ``g:simpleterm`` object,
change or use it::

    g:simpleterm.row = 10                    win height for new terminal
                                            kept after resize

    g:simpleterm.pos = 'below'              win position for new terminal

    g:simpleterm.bufs                       all the termial of simpleterm
    g:simpleterm.buf                        current main terminal
    g:simpleterm.bg                         current bg terminal


vimrc::

    set shell=/bin/zsh                      " set other shell if needed

Author & License
----------------


Author
    gu.fan at https://github.com/gu-fan


License
    wtfpl at http://sam.zoy.org/wtfpl/COPYING.


Thread
    https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/


Thought
    andreyorst's `great conclusion on terminal integration`__

__ https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/e1rnx8g

