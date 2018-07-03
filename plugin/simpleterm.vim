if !has("terminal")
    echom "[simpleterm.vim] vim should have +terminal support (8.1+)"
    finish
endif

set title                       " set the terminal title to the current file
set ttyfast                     " better screen redraw
set visualbell                  " turn on the visual bell
tnoremap <F1>   <C-\><C-n>


if executable('/bin/zsh')
    set shell=/bin/zsh
endif

if !exists("g:simpleterm") 
    let g:simpleterm= {"bufs":[]}
endif

let g:simpleterm.row = 7
let g:simpleterm.pos = "below"

fun! simpleterm.get() dict
    if exists("self.buf") && bufexists(self.buf)
        if bufwinnr(self.buf) != -1
            " SKIP
            " exe bufwinnr(self.buf) . "wincmd w"
        else
            let cur = winnr()
            exe self.pos.' '. self.row. 'sp'
            exe "buf " . self.buf
            exe cur . 'wincmd w'
        endif
    else
        let cur = winnr()
        exe self.pos.' terminal ++rows='. self.row.' ++kill=term'
        let self.buf = bufnr("$")
        exe cur . 'wincmd w'
    endif
    return self.buf
endfun

" run a job NotImplemented
" fun! simpleterm.run(cmd) dict
"     let self.buf = term_start(a:cmd, {"term_rows":3,"term_kill":"term"})
" endfun

fun! simpleterm.exe(cmd) dict
    let buf = self.get()
    " \<C-U> not working
    call term_sendkeys(buf, "\<C-W>".a:cmd."\<CR>")
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
    if exists("self.buf") && bufexists(self.buf)
        let win = bufwinnr(self.buf)
        if win != -1
            let cur = winnr()
            let cur = win > cur ? cur : cur-1
            exe win.'hide'
            exe cur . 'wincmd w'
        endif
    endif
endfun

fun! simpleterm.toggle() dict
    if exists("self.buf") && bufexists(self.buf) && bufwinnr(self.buf) != -1
        call self.hide()
    else
        call self.get()
    endif
endfun

fun! simpleterm.alt() dict
    let cur = winnr()
    exe self.pos.' terminal ++rows='. self.row.' ++kill=term'
    let last = bufnr('$')
    if !exists("self.buf") || !bufexists(self.buf)
        let self.buf = last
    endif
    call add(self.bufs, bufnr('$'))
    exe cur . 'wincmd w'
    return last
endfun

fun! simpleterm.kill() dict
    for k in self.bufs
        if bufexists(k)
            sil! exe "bd! " . k
        endif
    endfor

    if bufexists(self.buf)
        sil! exe "bd! " . self.buf
    endif
    let self.bufs = []
    let self.buf = v:null
endfun


com! -nargs=0  Salt call simpleterm.alt()
com! -nargs=0  Sshow call simpleterm.get()
com! -nargs=0  Shide call simpleterm.hide()
com! -nargs=0  Stoggle call simpleterm.toggle()
com! -nargs=* -complete=file Sexe call simpleterm.exe(<q-args>)
com! -nargs=?  Scd  call simpleterm.cd(<q-args>)
com! -range -nargs=0  Sline call simpleterm.line(<line1>, <line2>)
com! -nargs=?  Sfile call simpleterm.file(<q-args>)
com! -nargs=0  Skill call simpleterm.kill()



nnor <Leader>ss :Stoggle<CR>
nnor <Leader>sw :Sshow<CR>
nnor <Leader>sh :Shide<CR>


nnor <Leader>sc :Scd<CR>

nnor <Leader>se :Sexe<Space>
nnor <Leader>sl :Sline<CR>
vnor <Leader>sl :Sline<CR>
nnor <Leader>sf :Sfile<CR>

nnor <Leader>sa :Salt<CR>
nnor <Leader>sk :Skill<CR>
