simpleterm.vim
==============

simple terminal in vim


.. image::
    https://user-images.githubusercontent.com/579129/42484368-4d1b1f94-8425-11e8-9413-9a4cd1f48db9.png


Recent Change
-------------

`538191ab6`__ add ``Spaste``

__  https://github.com/gu-fan/simpleterm.vim/commit/538191ab6390d561e60b6cda0447cffeb0db20ee

`32a618e9f`__ slightly improve ``Sbind`` arguments

__  https://github.com/gu-fan/simpleterm.vim/commit/32a618e9fc2c92cee3510ebe2ac8c9ae340aaa3e

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
    Sexe cat test.sh |  grep msg


    " execute current line
    Sline


    " start another file
    sp build.sh


    " start another terminal
    Sadd


    " bind buffer with last terminal
    Sbind


    " execute command in clipboard
    Spaste
    

    " run background jobs (show me when finished
    Srun git push


    " finish
    wq



Detail
~~~~~~


**show/hide**

``Sshow`` create or show a minimal terminal. 
if ``idx`` provided, show terminal of that index

    ``idx``:  index of simpleterm's terminal list, ``0 , -2`` is ``first , one before last``

``Shide`` hide the minimal terminal.

``Stoggle`` toggle the minimal terminal.

|

**execution**


``Sexe`` execute command in terminal, ``cmd`` needed

|


``Sline`` execute current line, if visual selected, execute multi line


``Sfile`` source file, if no ``file`` provided, source current file

``Spaste`` execute from register ``{reg}``, if no ``{reg}`` provided, execute clipboard 'reg+'

|



**alter**

``Scd`` change dir of terminal, if no ``path``, change to current file's dir

``Sadd`` create another terminal and execute ``cmd``, prefix ``num`` to change height

    not triggerd by ``Scd/Sexe/Sline/Sfile``, ``cmd`` needed

|

``Srun`` run a command in background, and show terminal when finished, ``cmd`` needed

|

``Sbind`` bind current buffer with terminal ``arg`` in simpleterm's terminal list,
then it only triggered by bind buffer

    if no ``arg`` provided, bind to last terminal

    ``arg``:  arg to find buf in terminal list

    ``-1 , -2`` is ``last, one before last``

    ``1 , 2`` is find by buf number,  buf 1, buf 2

    ``!/bin/zsh`` find terminal by name

|

``Skill`` kill all terminal

    exit current terminal ?  use ``exit``

|



| 


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
    nnor <Leader>sp :Spaste<CR>

    nnor <Leader>sa :Sadd<CR>
    nnor <Leader>sb :Sbind<CR>
    " nnor <Leader>sk :Skill<CR>

    nnor <Leader>s0 :Sshow -1<CR>

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


vimrc ::

    set shell=/bin/zsh                      " set other shell if needed


Thought & Thread
----------------

Thought
    so, as you can easily executing while editing, you can
    tracking your work as scripts

    ``setup/dev/test/make/deploy/coffee...``

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


