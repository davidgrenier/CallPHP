au BufReadPost *.csx set filetype=cs

" au FileType r vnoremap <buffer> <leader>lc :<c-u>call CallLang("R --vanilla --slave", "", "")<cr>
au FileType php vnoremap <buffer> <leader>lc :<c-u>call CallLang("php", "<?php ", "?>")<cr>
au FileType js vnoremap <buffer> <leader>lc :<c-u>call CallLang("node -p", "", "")<cr>
au FileType sml vnoremap <buffer> <leader>lc :<c-u>call CallLang("sml", "", "")<cr>
au FileType cs vnoremap <buffer> <leader>lc :<c-u>call CallCSharp()<cr>
au FileType clojure noremap <buffer> <leader>lc :Eval<cr>
au FileType python noremap <buffer> <leader>lc :<c-u>call CallLang("python", "", "")<cr>
au FileType tex noremap <buffer> <leader>lc :<c-u>call CallTex()<cr>
au FileType julia noremap <buffer> <leader>lc :<c-u>call CallJulia()<cr><c-w>"*<c-w>p
au FileType r noremap <buffer> <leader>lc :<c-u>call CallR()<cr><c-w>"*<c-w>p
au FileType fsharp noremap <buffer> <leader>lc :<c-u>call CallFSharp()<cr><c-w>"*<c-w>p

set switchbuf+=useopen

fu! CallFSharp()
    if bufwinnr("fsharpterm") > 0
        sb fsharpterm
    else
        term++close dotnet fsi --nologo
        file fsharpterm
    endif
    let @* = @*[0:-2] . ';;' . @*[-1:]
endf

fu! CallJulia()
    if bufwinnr("juliaterm") > 0
        sb juliaterm
    else
        term++close julia
        file juliaterm
    endif
endf

fu! CallR()
    if bufwinnr("rterm") > 0
        sb rterm
    else
        term++close R --vanilla --silent
        file rterm
    endif
endf

fu! Prep()
    if bufwinnr("output") > 0
        sb output
        setlocal modifiable
        %d
        setlocal nomodifiable
    else
        15new output
    endif
    wincmd p
endf

fu! WriteOut(_, content)
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
endf

fu! CallLang(prog, pre, post)
    " let content = substitute(@*, "[^\n]$", "&\n", "")
    let a = system(a:prog, a:pre . @* . a:post)
    call Prep()
    call WriteOut("", a)
    sb output
    1
    wincmd p
endf

fu! CallCSharp()
    call CallLang("csi", "", "")
    setlocal modifiable
    d4
    $d
    setlocal nomodifiable
endf

fu! CallTex()
    call CallLang($HOME . "/.vim/bundle/calllang.vim/plugin/pdfltex.sh", "", "")
endf
