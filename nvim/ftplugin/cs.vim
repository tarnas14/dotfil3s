" setlocal tabstop=4

" if has('patch-8.1.1880')
  " setlocal completeopt=longest,menuone,popuphidden
  " " Highlight the completion documentation popup background/foreground the same as
  " " the completion menu itself, for better readability with highlighted
  " " documentation.
  " setlocal completepopup=highlight:Pmenu,border:off
" else
  " setlocal completeopt=longest,menuone,preview
  " " Set desired preview window height for viewing documentation.
  " setlocal previewheight=5
" endif

" augroup omnisharp_commands
  " autocmd!

  " " Show type information automatically when the cursor stops moving.
  " " Note that the type is echoed to the Vim command line, and will overwrite
  " " any other messages in this space including e.g. ALE linting messages.
  " autocmd CursorHold *.cs OmniSharpTypeLookup
" augroup END

" " The following commands are contextual, based on the cursor position.
" nmap <silent> <buffer> <Leader>g <Plug>(omnisharp_go_to_definition)
" nmap <silent> <buffer> <Leader>u <Plug>(omnisharp_find_usages)
" nmap <silent> <buffer> <Leader>i <Plug>(omnisharp_find_implementations)
" nmap <silent> <buffer> <Leader>pd <Plug>(omnisharp_preview_definition)
" nmap <silent> <buffer> <Leader>pi <Plug>(omnisharp_preview_implementations)
" nmap <silent> <buffer> <Leader>tlu <Plug>(omnisharp_type_lookup)
" nmap <silent> <buffer> <Leader>doc <Plug>(omnisharp_documentation)
" nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)
" nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)
" nmap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)
" imap <silent> <buffer> <C-\> <Plug>(omnisharp_signature_help)

" " Navigate up and down by method/property/field
" nmap <silent> <buffer> [[ <Plug>(omnisharp_navigate_up)
" nmap <silent> <buffer> ]] <Plug>(omnisharp_navigate_down)
" " Find all code errors/warnings for the current solution and populate the quickfix window
" nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)
" " Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
" nmap <silent> <buffer> <Leader>ca <Plug>(omnisharp_code_actions)
" xmap <silent> <buffer> <Leader>ca <Plug>(omnisharp_code_actions)
" " Repeat the last code action performed (does not use a selector)
" nmap <silent> <buffer> <Leader>. <Plug>(omnisharp_code_action_repeat)
" xmap <silent> <buffer> <Leader>. <Plug>(omnisharp_code_action_repeat)

" nmap <silent> <buffer> <Leader>kl <Plug>(omnisharp_code_format)

" nmap <silent> <buffer> <Leader>R <Plug>(omnisharp_rename)

" nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)
" nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)
" nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)

" nmap <silent> <buffer> <Leader>ost <Plug>(omnisharp_run_test)
" nmap <silent> <buffer> <Leader>ostf <Plug>(omnisharp_run_tests_in_file)
