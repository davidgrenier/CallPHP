noremap <buffer> <leader>lc :<c-u>call CallMatlab()<cr>

if !exists("g:matlabchan")
    call Prep()
    let job = job_start("matlab -nodesktop -nosplash", { "callback": "WriteOut" })
    let g:matlabchan = job_getchannel(job)
endif
