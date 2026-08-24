nnoremap <leader>t :call JumpToTask()<CR>
nnoremap  ]] :call NextTask()<CR>
nnoremap  [[ :call PrevTask()<CR>
nnoremap  ]n :call FindMarked()<CR>
nnoremap  [n :call FindMarkedPrev()<CR>
nnoremap  <leader>m :call MarkNext()<CR>
nnoremap  <leader>u :call UnMarkNext()<CR>
nnoremap  <leader>n :call FindMarked()<CR>
nnoremap  <leader>c :s/^\(\s\+\)\*/\1\|<CR>

command NewTask call StartNew()

function! JumpToTask()
    let task_number = input("Enter a task number: ")
    if task_number != ''
        execute 'call search("^[*|]\\?' . task_number . '\\.")'
    endif
endfunction

function! NextTask()
    execute 'call search("^[*|]\\?\\d\\+\\.")'
endfunction

function! PrevTask()
    execute 'call search("^[*|]\\?\\d\\+\\.", "b")'
endfunction

if exists('*fzf#run')
    function! FzfMatchingLines(pattern) abort
        let l:lines = []
        let l:lnum = 1
        for l:line in getline(1, '$')
            if l:line =~# a:pattern
                call add(l:lines, printf("%4d\t%s", l:lnum, l:line))
            endif
            let l:lnum += 1
        endfor

        if empty(l:lines)
            echo 'No matches for pattern: ' .. a:pattern
            return
        endif

        let l:current_file = expand('%:p')
        let l:current_file_escaped = shellescape(l:current_file)
        let l:preview_cmd = "bash -c '"
                    \ .. "n={1}; "
                    \ .. "if command -v bat &>/dev/null; then "
                    \ ..     "bat "
                    \ ..         "--style=numbers "
                    \ ..         "--color=always "
                    \ ..         "--highlight-line \$n "
                    \ ..         "--line-range \$((n>5?n-5:1)):\$((n+25)) -- "
                    \ ..         l:current_file_escaped .. "; "
                    \ .. "else "
                    \ ..     "sed -n \"\$((n>5?n-5:1)),\$((n+25))p\" "
                    \ ..     l:current_file_escaped .. "; "
                    \ .. "fi'"

        call fzf#run(fzf#wrap({
                    \ 'source': l:lines,
                    \ 'options': [
                    \   '--delimiter', "\t",
                    \   '--preview', l:preview_cmd,
                    \   '--preview-window', 'right:60%:wrap',
                    \   '--expect', 'ctrl-x,ctrl-v,ctrl-t',
                    \   '--prompt', 'Lines> ',
                    \ ],
                    \ 'sink*': funcref('s:fzf_line_sink')
                    \ }))
    endfunction

    function! s:fzf_line_sink(lines) abort
        echom string(a:lines)
        if len(a:lines) < 2
            return
        endif
        let l:key = a:lines[0]
        let l:entry = a:lines[1]
        let l:lnum = str2nr(split(l:entry, '\t')[0])

        let l:cmds = {
                    \ '': 'normal! ',
                    \ 'ctrl-x': 'split',
                    \ 'ctrl-v': 'vsplit',
                    \ 'ctrl-t': 'tabedit',
                    \}
        let l:cmd = get(l:cmds, l:key, '')

        if l:cmd ==# 'normal! '
            execute l:lnum
        else
            execute l:cmd .. ' +' .. l:lnum .. ' ' .. expand('%:p')
        endif

        normal! zz
    endfunction

    command! FindTask call FzfMatchingLines('^[*|]\?\d\+\.')
    nnoremap <buffer> <leader>ft :FindTask<CR>
endif

" let b:todo_next_mark = '     <==== THIS NEXT'
let b:todo_next_mark = '     ← NEXT'

" This is a little gross but doesn't work if you put it in the syntax file as
" the variable doesn't exist yet.
execute 'syntax match todoKeywordNext "' . escape(b:todo_next_mark, '\/.*$^~[]') . '"'

function! MarkNext()
    execute "normal! A" . b:todo_next_mark . "`^"
endfunction

function! UnMarkNext()
    let l:pattern = escape(b:todo_next_mark, '\')
    execute "silent! s/" . l:pattern . "$//"
endfunction

function! FindMarked()
    let l:pattern = escape(b:todo_next_mark, '\')
    execute "silent /" . l:pattern
endfunction


function! FindMarkedPrev()
    let l:pattern = escape(b:todo_next_mark, '\')
    execute "silent ?" . l:pattern
endfunction



function! StartNew()
    " Go to end of file
    normal! G

    " Call your existing custom function
    call PrevTask()

    " Yank from cursor to the next '.' into register a
    normal! "ayf.

    " Go to end of file again
    normal! G

    " Open a new line and immediately exit insert mode
    execute "normal! o\<CR>\<Esc>"

    " Paste from register a, move to start, increment number under cursor
    normal! "ap0

    " Move to end of line and enter insert mode
    execute "normal! A "
endfunction
