" underscored.vim - Space to underscore
" Maintainer:   Pirey <https://github.com/pirey>
" Version:      0.1

if exists("g:loaded_underscored") || v:version < 700 || &cp
    finish
endif
let g:loaded_underscored = 1

function! s:enable() abort
    let b:underscored = 1

    " preserve current file 'readonly'ness
    let &l:readonly = &l:readonly

    " prevent vim to send any char when enabling
    return ''
endfunction

function! s:disable() abort
    unlet! b:underscored

    " preserve current file 'readonly'ness
    let &l:readonly = &l:readonly

    " prevent vim to send any char when disabling
    return ''
endfunction

function! s:toggle() abort
    if s:enabled()
        return s:disable()
    else
        return s:enable()
    endif
endfunction

function! s:enabled() abort
    if exists('##InsertCharPre')
        return get(b:, 'underscored', 0)
    else
        return 0
    endif
endfunction

function! s:exitcallback() abort
    if s:enabled() == 1
        call s:disable()
    endif
endfunction

augroup underscored
    autocmd!

    autocmd InsertLeave * call s:exitcallback()

    if exists('##InsertCharPre')
        autocmd InsertCharPre *
            \ if s:enabled() |
            \   let v:char = v:char ==# ' ' ? '_' : v:char ==# '_' ? ' ' : v:char |
            \ endif
    endif
augroup END

inoremap <silent> <Plug>UnderscoredToggle  <C-R>=<SID>toggle()<CR>
inoremap <silent> <Plug>UnderscoredEnable  <C-R>=<SID>enable()<CR>
inoremap <silent> <Plug>UnderscoredDisable <C-R>=<SID>disable()<CR>

if empty(mapcheck("<C-_>", "i"))
  imap <C-_> <Plug>UnderscoredToggle
endif
imap <C-G><Space> <Plug>UnderscoredToggle
