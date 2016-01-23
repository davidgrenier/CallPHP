function! CallPHP()
    normal! gv"xy
    let @a = system("php", "<?php " . @x . "?>")
    execute "normal! o\<esc>\"ap"
endfunction

function! CallNode()
    normal! gv"xy
    let @a = system("node -p", @x)
    execute "normal! o\<esc>\"ap"
endfunction

vnoremap <leader>lp :<c-u>call CallPHP()<cr>
vnoremap <leader>lj :<c-u>call CallNode()<cr>
