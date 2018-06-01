au BufReadPost *.fs,*.fsx set filetype=fs
au BufReadPost *.csx set filetype=cs

au FileType r vnoremap <buffer> <leader>lc :<c-u>call CallLang("R --vanilla --slave", "", "")<cr>
au FileType php vnoremap <buffer> <leader>lc :<c-u>call CallLang("php", "<?php ", "?>")<cr>
au FileType js vnoremap <buffer> <leader>lc :<c-u>call CallLang("node -p", "", "")<cr>
au FileType sml vnoremap <buffer> <leader>lc :<c-u>call CallLang("sml", "", "")<cr>
au FileType fs vnoremap <buffer> <leader>lc :<c-u>call CallLang("fsi --nologo", "", "")<cr>
au FileType cs vnoremap <buffer> <leader>lc :<c-u>call CallCSharp()<cr>
au FileType clojure noremap <buffer> <leader>lc :Eval<cr>
au FileType python noremap <buffer> <leader>lc :<c-u>call CallLang("python", "", "")<cr>
au FileType tex noremap <buffer> <leader>lc :<c-u>call CallTex()<cr>

set switchbuf+=useopen

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
    let content = substitute(@*, "[^\n]$", "&\n", "")
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
