function! CallFSharp()
    call Prep()
    let content = substitute(@*, "$", "&;;\n", "")
    call ch_sendraw(g:fsharpchan, content)
endf

function! WriteFSharp(channel, content)
    call WriteOut(a:channel, substitute(a:content, "^>[> ]*$", "", ""))
endf

if !exists("g:fsharpchan") || ch_status(g:fsharpchan) == "closed"
    call Prep()
    let job = job_start("fsharpi --nologo --debug- --optimize+", { "callback": "WriteFSharp" })
    let g:fsharpchan = job_getchannel(job)
endif

vnoremap <buffer> <leader>lc :<c-u>call CallFSharp()<cr>
