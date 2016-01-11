function! CallPHP()
    normal! gv"xy
    let a = system("php", "<?php " . @x . "?>")
    echo a
endfunction

vnoremap <leader>p :<c-u>call CallPHP()<cr>
