function! CallMatlab()
    call Prep()
    call ch_sendraw(g:matlabchan, @*)
endfunction

function! WriteMatLab(channel, content)
    echo a:content
    call WriteOut(a:channel, substitute(a:content, "^>>[> ]*$", "", ""))
endfunction

if !exists("g:matlabchan") || ch_status(g:matlabchan) == "closed"
    call Prep()
    let job = job_start("matlab -nodesktop -nosplash -nosoftwareopengl ", { "callback": "WriteMatLab" })
    let g:matlabchan = job_getchannel(job)
endif

noremap <buffer> <leader>lc :<c-u>call CallMatlab()<cr>
