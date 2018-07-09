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
let g:simpleterm.pos = "below"


""""""""""""""""""""""""""""
" PRIVATE 
""""""""""""""""""""""""""""


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

fun! simpleterm._track(buf, opt) dict
    let self.bufs[a:buf] = a:opt
    call add(self._bufs, a:buf)
endfun


fun! simpleterm._show(buf) dict
    if bufwinnr(a:buf) == -1
        let cur = winnr()
        exe self.pos.' '. self._row(a:buf). 'sp'
        exe "buf " . a:buf
        exe cur . 'wincmd w'
    endif
    return a:buf
endfun

fun! simpleterm._row(buf) dict
    let _b = get(self.bufs,a:buf, {"row": 10})
    return _b.row
endfun

""""""""""""""""""""""""""""

fun! simpleterm.get() dict
    let _buf = self._get_buf()
    " echom "GET " . _buf
    if _buf != 0
        return self._show(_buf)
    else
        let cur = winnr()
        exe self.pos.' terminal ++rows='. self.row.' ++kill=term'
        let self.main = bufnr("$")
        call self._track(self.main, {"row": self.row})
        exe cur . 'wincmd w'
        return self.main
    endif
endfun

fun! simpleterm.exe(cmd) dict
    " \<C-U> not working
    if empty(trim(a:cmd))
        echom "should provide cmds"
    else
        let buf = self.get()
        call term_sendkeys(buf, a:cmd."\<CR>")
    endif

endfun

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
            call self._track(self.bg, {"bg": true, "row": self.row})
            echom "start running at " . self.bg. ": ". a:cmd
        endif
endfun

fun! simpleterm.cd(...) dict
    if a:0 == 0 || a:1 == ""
        let lcd = expand('%:p:h')
        call self.exe("cd ". lcd)
    else
        call self.exe("cd ". a:1)
    endif
endfun

fun! simpleterm.line(first, last) dict
    if a:0 == 0
        if a:first!= a:last
            for line in getline(a:first, a:last)
                call self.exe(line)
            endfor

        else
            call self.exe(getline('.'))
        endif
    endif
endfun

fun! simpleterm.file(...) dict
    if a:0 == 0 || a:1 == ""
        let file = expand('%:p')
        call self.exe('sh '. file)
    else
        call self.exe('sh ' . a:1)
    endif
endfun

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
    " echom _buf

    " XXX: the bufwinnr(0) will return current buf's win
    if _buf == 0
        return self.get()
    endif
    if bufwinnr(_buf) == -1
        " echom "GET IT"
        call self.get()
    else
        " echom "HIDE IT"
        call self.hide()
    endif
endfun

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
   
    call self._track(last, {"row" : self.row})
    if (!empty(a:cmd))
        call term_sendkeys(last, a:cmd."\<CR>")
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


fun! simpleterm._kill_bind(buf) dict
    " echom "KILL" . a:buf
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
fun! simpleterm._hide(buf) dict
endfun


fun! simpleterm.bind(...) dict

    if a:0 == 0 || a:1 == ""
        let idx = -1
    else
        let idx = str2nr(a:1)
    endif

    let buf = get(self._bufs, idx)
    if (buf==0)
        echom "[simpleterm.vim] buf not found"
        return
    endif

    " dettach from the main
    if exists("self.main") && self.main == buf
        unlet self.main
    endif

    let g:simpleterm._binds[bufnr('%')] = buf
    echom "bind:". buf . " to " .  "current win: ".bufnr('%')
    
endfun

aug simpleterm
    au!
    au! BufUnload * call simpleterm._kill_bind(expand('<abuf>'))
    " seems misleading, skip
    " au! BufWinLeave * call simpleterm._hide(expand('<abuf>'))
aug END


com! -nargs=0  Sshow call simpleterm.get()
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



nnor <Leader>sw :Sshow<CR>
nnor <Leader>sh :Shide<CR>
nnor <Leader>ss :Stoggle<CR>

nnor <Leader>sc :Scd<CR>

nnor <Leader>se :Sexe<Space>
nnor <Leader>sr :Srun<Space>

nnor <Leader>sl :Sline<CR>
vnor <Leader>sl :Sline<CR>      
nnor <Leader>sf :Sfile<CR>

nnor <Leader>sa :Sadd<CR>
nnor <Leader>sk :Skill<CR>
nnor <Leader>sb :Sbind<CR>

" In terminal, use <ESC> to toggle terminal-mode
tnor <ESC>   <C-\><C-n>          


" vim:fdm=indent:
