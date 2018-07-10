simpleterm.vim
==============

simple terminal in vim


.. image::
    https://user-images.githubusercontent.com/579129/42396749-99966032-8195-11e8-9492-a3738b35854a.png

Changes
--------

`d23714312767816793753c96c1a859da98b9545f`__

__  https://github.com/gu-fan/simpleterm.vim/commit/d23714312767816793753c96c1a859da98b9545f

- Salt to Sadd
- Add Sbind


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

    " execute commands (async in terminal
    Sexe git clone https://github.com/gu-fan/simpleterm.vim.git

    " cd to a dir
    Scd simpleterm.vim

    " edit some file
    e simpleterm.vim/README.rst

    " execute current line
    Sline

    " source target file
    Sfile build/dev.sh

    " run background jobs (show me when finished
    Srun git push

    " edit another file
    sp test/test.rst

    " start another terminal
    Sadd

    " bind buffer with last terminal
    Sbind

    " execute command in binded terminal
    Sexe test.sh

    " finish and close buffer
    wq

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
|

``Srun`` Run a command in background, and show terminal when finished, ``cmd`` needed

``Sline`` execute current line, if visual selected, execute multi line

``Sfile`` source file, if no ``file`` provided, source current file


**alter**


``Sadd`` create another terminal and execute ``cmd``, prefix ``num`` to change height,
not triggerd by ``Scd/Sexe/Sline/Sfile``, ``cmd`` needed

|

``Sbind`` bind current buffer with terminal ``idx`` in terminal list,
then it only triggered by bind buffer

use ``0 / -2`` to bind to ``first / one before last``, if no ``idx`` provided, bind to last terminal ``-1``

|

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

    nnor <Leader>sa :Sadd<Space>
    nnor <Leader>sb :Sbind<CR>
    nnor <Leader>sk :Skill<CR>

    " In terminal, use <ESC> to escape terminal-mode
    " then, use a or i to back to terminal-mode, like insert-mode
    tnor <ESC>   <C-\><C-n>          

    " see :h CTRL-W_. for terminal commands

**Customize**

.. code:: vim

    " mapping your works, e.g.
    nnore <Leader>gp :Srun git push<CR>
    nnore <Leader>gP :Srun git pull<CR>

    " have some func?
    " https://gist.github.com/marianposaceanu/6615458
    nnore <Leader>fk :20Sadd fortune\|cowsay\|lolcat<CR>

Further
-------


All function and option are in ``g:simpleterm`` object,
change or use it::

    g:simpleterm.row = 10                   initial win height for new terminal
                                            kept for each terminal after resize

    g:simpleterm.pos = 'below'              win position for new terminal

    g:simpleterm.bufs                       all the termial of simpleterm
    g:simpleterm.main                       current main terminal
    g:simpleterm.bg                         current bg terminal


vimrc::

    set shell=/bin/zsh                      " set other shell if needed

Thought & Thread
----------------

Thought
    so, as you can easily executing whilst editing, you can
    tracking your work as scripts
    ``e.g.: setup/dev/test/make/deploy/coffee...``

also see andreyorst's `great conclusion on terminal integration`__

__ https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/e1rnx8g


Thread
    https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/


Author & License
----------------


Author
    gu.fan at https://github.com/gu-fan


License ::

    The MIT License

    Permission is hereby granted, free of charge, to any person obtaining a copy
    of this software and associated documentation files (the "Software"), to deal
    in the Software without restriction, including without limitation the rights
    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
    copies of the Software, and to permit persons to whom the Software is
    furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all
    copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
    SOFTWARE.


