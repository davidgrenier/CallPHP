function! CallPHP()
    execute "silent normal! `<v`>y"
    let a = system("php", "<?php " . @@ . "?>")
    echo a
endfunction

vnoremap <leader>p :<c-u>call CallPHP()<cr>
