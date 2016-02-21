function! CallLang(prog, pre, post)
    normal! gv"xy
    let @a = system(a:prog, a:pre . @x . a:post)
    10new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    execute "silent normal! o\<esc>\"ap"
    1,/./g/^$/d
    setlocal nomodifiable
    nnoremap <buffer> q :q<cr>
endfunction

function! CallPHP()
    call CallLang("php", "<?php ", "?>")
endfunction

function! CallNode()
    call CallLang("node -p", "", "")
endfunction

vnoremap <leader>lp :<c-u>call CallPHP()<cr>
vnoremap <leader>lj :<c-u>call CallNode()<cr>
vnoremap <leader>ls :<c-u>call CallLang("sml", "", "")<cr>
vnoremap <leader>lf :<c-u>call CallLang("fsi", "", "")<cr>
