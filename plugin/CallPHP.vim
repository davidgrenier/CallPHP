function! CallPHP()
    normal! gv"xy
    let @a = system("php", "<?php " . @x . "?>")
    execute "normal! o\<esc>\"ap"
endfunction

vnoremap <leader>p :<c-u>call CallPHP()<cr>
