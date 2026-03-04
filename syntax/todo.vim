syntax clear
syntax match todoDone /^\s*|.*/ contains=todoKeywordDone,todoKeywordWip
syntax match todoNotDone /^\s*\*.*/ contains=todoKeywordDone,todoKeywordWip,todoKeywordNB,todoKeywordNext
syntax match todoAgendum /\v^[*|]?\d+\..*/
syntax match todoKeywordDone /\<DONE\>/
syntax match todoKeywordWip /\<WIP\>/
syntax match todoKeywordNB /\<NB\>/

highlight default link todoDone        Comment
highlight default link todoNotDone     Special
highlight default link todoKeywordWip  WarningMsg
highlight default link todoKeywordDone String
highlight default link todoKeywordNB   Error
highlight default link todoKeywordNext Number
highlight default link todoAgendum     Statement
highlight default link todoComment     Comment
