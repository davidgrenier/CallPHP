function! CallLang(prog, arg)
    let @a = system(a:prog, a:arg)
    10new
    setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
    execute "normal! o\<esc>\"ap"
    setlocal nomodifiable
    nnoremap <buffer> q :q<cr>
endfunction

function! CallPHP()
    normal! gv"xy
    call CallLang("php", "<?php " . @x . "?>")
endfunction

function! CallNode()
    normal! gv"xy
    call CallLang("node -p", @x)
endfunction

function! CallSML()
    normal! gv"xy
    call CallLang("sml", @x)
endfunction

vnoremap <leader>lp :<c-u>call CallPHP()<cr>
vnoremap <leader>lj :<c-u>call CallNode()<cr>
vnoremap <leader>ls :<c-u>call CallSML()<cr>
