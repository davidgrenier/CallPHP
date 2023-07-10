function! CallMatlab()
    call Prep()
    let content = substitute(@*, "$", "&\n", "")
    call ch_sendraw(g:matlabchan, content)
endfunction

function! WriteMatLab(channel, content)
    call WriteOut(a:channel, substitute(a:content, "^>>[> ]*", "", ""))
endfunction

if !exists("g:matlabchan") || ch_status(g:matlabchan) == "closed"
    call Prep()
    let opt = { "callback": "WriteMatLab", "env": { "LD_PRELOAD": "/usr/lib/x86_64-linux-gnu/libstdc++.so.6" } }
    let job = job_start("matlab -nodesktop -nosplash", opt)
    let g:matlabchan = job_getchannel(job)
endif

noremap <buffer> <leader>lc :<c-u>call CallMatlab()<cr>
