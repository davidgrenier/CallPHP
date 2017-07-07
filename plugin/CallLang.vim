set switchbuf+=useopen

function! CallLang(prog, pre, post)
    norm! gv"xy
    let @a = system(a:prog, a:pre . @x . a:post)
    
    if bufwinnr("output") > 0
        sb output
        setlocal modifiable
        %d
    else
        15new output
    endif

    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    execute "silent norm! o\<esc>\"ap"
    silent 1,/./g/^$/d
    setlocal nomodifiable
    nnoremap <buffer> q :q<cr>
endfunction

function! CallPHP()
    call CallLang("php", "<?php ", "?>")
endfunction

function! CallNode()
    call CallLang("node -p", "", "")
endfunction

function! CallCSharp()
    call CallLang("csi", "", "")
    setlocal modifiable
    d4
    $,$d
    setlocal nomodifiable
endfunction

au BufReadPost *.fs,*.fsx set filetype=fs
au BufReadPost *.csx set filetype=cs

au FileType r vnoremap <buffer> <leader>lc :<c-u>call CallLang("R --vanilla --slave", "", "")<cr>
au FileType php vnoremap <buffer> <leader>lc :<c-u>call CallPHP()<cr>
au FileType js vnoremap <buffer> <leader>lc :<c-u>call CallNode()<cr>
au FileType sml vnoremap <buffer> <leader>lc :<c-u>call CallLang("sml", "", "")<cr>
au FileType fs vnoremap <buffer> <leader>lc :<c-u>call CallLang("fsi --nologo", "", "")<cr>
au FileType cs vnoremap <buffer> <leader>lc :<c-u>call CallCSharp()<cr>
au FileType clojure noremap <buffer> <leader>lc :Eval<cr>
au FileType python noremap <buffer> <leader>lc :<c-u>call CallLang("python", "", "")<cr>
