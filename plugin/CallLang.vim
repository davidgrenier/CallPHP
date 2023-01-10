au BufReadPost *.csx set filetype=cs

" au FileType r vnoremap <buffer> <leader>lc :<c-u>call CallLang("R --vanilla --slave", "", "")<cr>
au FileType php vnoremap <buffer> <leader>lc :<c-u>call CallLang("php", "<?php ", "?>")<cr>
au FileType wast noremap <buffer> <leader>lb :<c-u>call CallWasm()<cr>
au FileType wast noremap <buffer> <leader>lc :<c-u>call CallInterp()<cr>
au FileType js vnoremap <buffer> <leader>lc :<c-u>call CallLang("node -p", "", "")<cr>
au FileType sml vnoremap <buffer> <leader>lc :<c-u>call CallLang("sml", "", "")<cr>
au FileType cs vnoremap <buffer> <leader>lc :<c-u>call CallCSharp()<cr>
au FileType clojure noremap <buffer> <leader>lc :Eval<cr>
au FileType python noremap <buffer> <leader>lc :<c-u>call CallPython()<cr><c-w>"*<c-w>p
au FileType tex noremap <buffer> <leader>lc :<c-u>call CallTex()<cr>
au FileType julia noremap <buffer> <leader>lc :<c-u>call CallJulia()<cr><c-w>"*<c-w>p
au FileType r noremap <buffer> <leader>lc :<c-u>call CallR()<cr><c-w>"*<c-w>p
au FileType fsharp noremap <buffer> <leader>lc :<c-u>call CallFSharp()<cr><c-w>"*<c-w>p
au FileType cpp noremap <buffer> <leader>lc :<c-u>call CallCpp()<cr>

set switchbuf+=useopen

fun! CallCpp()
    let progname = expand("%:r")
    let opt = { "term_name" : progname . "-term", "exit_cb" : "DoneHandler"}
    if bufwinnr(opt.term_name) > 0
        execute "sb " . opt.term_name
        let opt.curwin = 1
    endif
    call term_start("./" . progname, opt)
    nnoremap <buffer> q :q<cr>
endfun

fun! DoneHandler(job, status)
    wincmd p
endfun

fun! CallFSharp()
    if bufwinnr("fsharpterm") > 0
        sb fsharpterm
    else
        term++close dotnet fsi --nologo
        file fsharpterm
    endif
    let @* = @*[0:-2] . ';;' . @*[-1:]
endfun

fun! CallJulia()
    if bufwinnr("juliaterm") > 0
        sb juliaterm
    else
        term++close julia
        file juliaterm
    endif
endfun

fun! CallR()
    if bufwinnr("rterm") > 0
        sb rterm
    else
        term++close R --vanilla --silent
        file rterm
    endif
endfun

fun! CallPython()
    if bufwinnr("pythonterm") > 0
        sb pythonterm
    else
        term++close python3
        file pythonterm
    endif
endfun

fun! Prep()
    if bufwinnr("output") > 0
        sb output
        setlocal modifiable
        %d
        setlocal nomodifiable
    else
        20new output
    endif
    wincmd p
endfun

fun! WriteOut(_, content)
    if strlen(a:content)
        sb output
        setlocal modifiable
        setlocal buftype=nofile bufhidden=delete nobuflisted noswapfile nowrap
        silent put =a:content
        silent! 1,/./g/^\s*$/d
        silent! %s/\($\n\s*\)\+\%$//
        setlocal nomodifiable
        nnoremap <buffer> q :q<cr>
    endif
    if @% == "output"
        wincmd p
    endif
endfun

fun! CallInterp()
    let a = system("wat2wasm " . expand("%:t"))
    let a = system("wasm-interp --run-all-exports " . expand("%:r") . ".wasm 2>&1")
    call Prep()
    call WriteOut("", a)
    sb output
    1
    wincmd p
endfun

fun! CallWasm()
    let a = system("wat2wasm -v " . expand("%:t"))
    call Prep()
    call WriteOut("", a)
    sb output
    1
    wincmd p
endfun

fun! CallLang(prog, pre, post)
    " let content = substitute(@*, "[^\n]$", "&\n", "")
    let a = system(a:prog, a:pre . @* . a:post)
    call Prep()
    call WriteOut("", a)
    sb output
    1
    wincmd p
endfun

fun! CallCSharp()
    call CallLang("csi", "", "")
    setlocal modifiable
    d4
    $d
    setlocal nomodifiable
endfun

fun! CallTex()
    call CallLang($HOME . "/.vim/bundle/calllang.vim/plugin/pdfltex.sh", "", "")
endfun
