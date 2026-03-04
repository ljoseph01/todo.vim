nnoremap <leader>t :call JumpToTask()<CR>
nnoremap  ]] :call NextTask()<CR>
nnoremap  [[ :call PrevTask()<CR>
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
