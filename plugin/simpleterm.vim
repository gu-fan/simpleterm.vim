" simpleterm.vim        simple terminal in vim
" Author:    gu.fan at https://github.com/gu-fan
" License:   The MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.
"
" Thread:    https://www.reddit.com/r/vim/comments/8vwq5a/vim_81_terminal_is_great/
if !has("terminal")
    echom "[simpleterm.vim] vim should have +terminal support (8.1+)"
    finish
endif

if !exists("g:simpleterm") 
    let g:simpleterm= {}
endif

if !exists("g:simpleterm.bufs") 
    let g:simpleterm.bufs = {}
    let g:simpleterm._binds = {}
    let g:simpleterm._bufs = []
endif

let g:simpleterm.row = 10
let g:simpleterm.delay = 400
let g:simpleterm.pos = "below"

""""""""""""""""""""""""""""
" UTIL
""""""""""""""""""""""""""""

" get the arg , if empty or ''
" return default
"
" created as vim can not handle the value for a:0
" when using nargs=*
fun! s:default_arg(a0, a1, default)
    if a:a0 && !empty(a:a1)
        return a:a1
    else
        return a:default
    endif
endfun

""""""""""""""""""""""""""""
" PRIVATE 
""""""""""""""""""""""""""""

" get binded terminal or main terminal for current buffer
fun! simpleterm._get_buf() dict
    let buf = get(self._binds, bufnr('%'))
    " echom "CHECK" . buf
    if buf != 0 && bufexists(buf)
        " echom "GET BIND" . buf
        return buf
    elseif exists("self.main") && bufexists(self.main)
        " echom "GET MAIN" . self.main
        return self.main
    else
        return 0
    endif
endfun

fun! simpleterm._track(buf, ...) dict
    let self.bufs[a:buf] = a:0 ? a:1 : {}
    call add(self._bufs, a:buf)
endfun


fun! simpleterm._show(buf) dict
    if bufwinnr(a:buf) == -1
        echom "SHOW"
        let cur = winnr()
        exe self.pos.' '. self._row(a:buf). 'sp'
        exe "buf " . a:buf
        exe cur . 'wincmd w'
    endif
    return a:buf
endfun

fun! simpleterm._row(buf) dict
    let _b = get(self.bufs, a:buf, {"row": self.row})
    return get(_b, 'row', self.row)
endfun



" we can not sendkey directly with timer_start,
" so need a function
fun! simpleterm._keylast(...)
    call term_sendkeys(a:1, a:2."\<CR>")
endfun

""""""""""""""""""""""""""""

" BASIC FUNCTION GET OR CREATE
fun! simpleterm.get(...) dict
    if a:0 == 0 || a:1 == ""
        let _buf = self._get_buf()
    else
        let _buf = get(self._bufs, a:1)
        if !bufexists(_buf)
            let _buf = 0
        endif

    endif
    " echom "GET " . _buf
    if _buf != 0
        return [self._show(_buf), 'OLD']
    else
        let cur = winnr()
        exe self.pos.' terminal ++rows='. self.row . ' ++kill=term'
        let self.main = bufnr("$")
        call self._track(self.main)
        exe cur . 'wincmd w'
        return [self.main, 'NEW']
    endif
endfun

" BASIC FUNCTION EXE IN FOREGROUND
fun! simpleterm.exe(cmd) dict
    " \<C-U> not working
    if empty(trim(a:cmd))
        echom "should provide cmds"
    else
        let [buf, type] = self.get()
        if type == 'NEW'
            call timer_start(self.delay, function(self._keylast, [buf, a:cmd]))
        else
            call term_sendkeys(buf, a:cmd."\<CR>")
        endif
    endif

endfun

" BASIC FUNCTION RUN IN BACKGROUND
fun! simpleterm.run(cmd) dict
    if empty(trim(a:cmd))
        echom "should provide cmds"
    else
        " we can not skip, cause no way to reuse the old one
        " let skip_new = 0
        " if exists("self.bg") && bufexists(self.bg)
        "   let job = term_getjob(self.bg)
        "   if job_status(job) == "run"
        "     let skip_new = 1
        "   endif
        " endif

        let self.bg = term_start(a:cmd, {
                    \ "term_rows":1,"hidden":1,
                    \ "norestore":1,
                    \ "term_kill":"term","term_finish":"open",
                    \ "term_opencmd":self.pos." ".self.row."sp|buf %d"
                    \ })
        call self._track(self.bg, {"bg": 1})
        echom "start running at " . self.bg. ": ". a:cmd
    endif
endfun



" SITUATIONS
fun! simpleterm.cd(...) dict
    let lcd = s:default_arg(a:0, a:1, expand('%:p:h'))
    call self.exe("cd ". lcd)
endfun

fun! simpleterm.line(first, last) dict
    if a:first!= a:last
        for line in getline(a:first, a:last)
            call self.exe(line)
        endfor

    else
        call self.exe(getline('.'))
    endif
endfun

fun! simpleterm.paste(...) dict
    let reg = s:default_arg(a:0, a:1, "+")
    if empty(trim(getreg(reg)))
        echom "empty in paste " . reg
    else
        let lines = getreg(reg, 1, 1)
        echo lines
        for line in lines
            call self.exe(line)
        endfor
    endif
endfun

fun! simpleterm.file(...) dict
    let file = s:default_arg(a:0, a:1 , expand('%:p'))
    call self.exe('source '. file)
endfun


" SHOW / HIDE
fun! simpleterm.hide() dict
    let _buf = self._get_buf()
    if _buf == 0 | return | endif

    let win = bufwinnr(_buf)

    if win != -1
        let cur = winnr()
        let cur = win > cur ? cur : cur-1
        " echom string(self.bufs) . ":" . _buf
        if (exists("self.bufs["._buf."].row"))
            let self.bufs[_buf].row = winheight(win)
        endif
        exe win . 'hide'
        exe cur . 'wincmd w'
    endif
endfun

fun! simpleterm.toggle() dict
    let _buf = self._get_buf()
    " echom "TOGGLE"
    " XXX: the bufwinnr(0) will return current buf's win
    if _buf==0 || bufwinnr(_buf) == -1
        " echom "GET IT"
        call self.get()
    else
        " echom "HIDE IT"
        call self.hide()
    endif
endfun

" CREATE / KILL
fun! simpleterm.add(cmd, count) dict
    let cur = winnr()
    let row = a:count==0 ? self.row : a:count
    exe self.pos.' terminal ++rows='. row.' ++kill=term'
    let last = bufnr('$')

    " don't set this to self.main, misleading
    " well, as 'bind' added, its ok
    if !exists("self.main") || !bufexists(self.main)
        let self.main = last
    endif

   
    call self._track(last)
    if (!empty(a:cmd))
        " call term_sendkeys(self.last, a:cmd."\<CR>")
        call timer_start(self.delay, function(self._keylast, [last, a:cmd]))
    endif
    exe cur . 'wincmd w'
    return last
endfun

fun! simpleterm.kill() dict
    " is 'bd!' really kill the terminal? seems work
    for k in self._bufs
        if bufexists(k)
            sil! exe "bd! " . k
        endif
    endfor

    if exists("self.main") && bufexists(self.main)
        sil! exe "bd! " . self.main
        let self.main = v:null
    endif
    let self.bufs = {}
    let self._bufs = []
endfun


fun! simpleterm._hide(buf) dict
endfun


" BINDING

fun! simpleterm.bind(...) dict

    if a:0 == 0 || a:1 == ""
        let idx = -1
    else
        let idx = str2nr(a:1) 
    endif

    if (idx < 0) " -2 , -1
        let buf = get(self._bufs, idx)
    else        " 2, 3 , /bin/node ...
        let idx = idx ? idx : a:1
        let buf = bufnr(idx)
        if !has_key(self.bufs, buf)
            echom "[simpleterm.vim] buf not in term list"
            return
        endif
    endif

    if (buf==0 || buf == -1)
        echom "[simpleterm.vim] buf not found"
        return
    endif

    " dettach from the main
    if exists("self.main") && self.main == buf
        unlet self.main
    endif

    let self._binds[bufnr('%')] = buf
    echom 'bind current buf to '''.bufname(buf) . ''' : ' .  buf 
    
endfun

fun! simpleterm._kill_bind(buf) dict
    " echom "BIND". get(g:simpleterm._binds,a:buf)
    let buf = get(self._binds, a:buf)
    if (buf == 0) | return | endif

    if bufexists(buf)
        sil! exe "bd! " . buf
    endif
    sil! call remove(self._binds, a:buf)
    sil! call remove(self.bufs, buf)
    sil! call remove(self._bufs, index(self._bufs, buf))

endfun

aug simpleterm
    au!
    au! BufUnload * call simpleterm._kill_bind(expand('<abuf>'))
    " seems misleading, skip
    " au! BufWinLeave * call simpleterm._hide(expand('<abuf>'))
aug END


com! -nargs=*  Sshow call simpleterm.get(<q-args>)
com! -nargs=0  Shide call simpleterm.hide()
com! -nargs=0  Stoggle call simpleterm.toggle()

com! -nargs=?  Scd  call simpleterm.cd(<q-args>)

com! -nargs=* -complete=file Sexe call simpleterm.exe(<q-args>)
com! -nargs=*  Srun call simpleterm.run(<q-args>)

com! -range -nargs=0  Sline call simpleterm.line(<line1>, <line2>)
com! -nargs=? Sfile call simpleterm.file(<q-args>)

com! -nargs=0  Skill call simpleterm.kill()
com! -nargs=* -count=0 Sadd call simpleterm.add(<q-args>, <count>)
com! -nargs=*  Sbind call simpleterm.bind(<q-args>)

com! -nargs=*  Spaste call simpleterm.paste(<q-args>)


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
" nnor <Leader>sk :Skill<CR>
nnor <Leader>sb :Sbind<CR>


nnor <Leader>s0 :Sshow -1<CR>

" In terminal, use <ESC> to toggle terminal-mode
" then, use a or i to back to terminal-mode, like insert-mode
tnor <ESC>   <C-\><C-n>          


" vim:fdm=indent:
