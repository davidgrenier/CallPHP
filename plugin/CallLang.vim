set switchbuf+=useopen

function! WriteOut(channel, content)
    if bufwinnr("output") > 0
        sb output
        setlocal modifiable
        %d
    endif
    
    if strlen(a:content)
        if bufwinnr("output") < 0
            15new output
        endif

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
endfunction

function! CallLang(prog, pre, post)
    norm! gv"xy
    let a = system(a:prog, a:pre . @x . a:post)
    call WriteOut("", a)
endfunction

function! CallCSharp()
    call CallLang("csi", "", "")
    setlocal modifiable
    d4
    $d
    setlocal nomodifiable
endfunction

function! CallMatlab()
    if !exists("g:matlabchan")
        let job = job_start("matlab -nodesktop", { "out_mode": "raw" })
        let g:matlabchan = job_getchannel(job)
    endif
    norm! gv"xy
    call ch_sendraw(g:matlabchan, @x, { "callback": "WriteOut" })
endfunction

function! CallTex()
    call CallLang($HOME . "/.vim/bundle/calllang.vim/plugin/pdfltex.sh", "", "")
endfunction

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
au FileType matlab noremap <buffer> <leader>lc :<c-u>call CallMatlab()<cr>
