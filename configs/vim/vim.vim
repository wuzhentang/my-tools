
set number
set relativenumber
let g:go_version_warning = 0

if filereadable("cscope.out") 
    cs add cscope.out
elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
endif

set fileencodings=ucs-bom,utf-8,utf-16,gbk,big5,gb18030,latin1

" Return to last edit position when opening files (You want this!)
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" todo: use relative path of vim config
autocmd bufnewfile *.c,*.h,*.hpp,*.cc,*.cpp,*.java,*.go so ~/.my-configs/configs/vim/code_header.txt
autocmd bufnewfile *.sh so ~/.my-configs/configs/vim/shell_code_header.txt
"autocmd bufnewfile *.c exe "1," . 10 . "g/File Name :.*/s//File Name : " .expand("%")
autocmd bufnewfile *.c,*.h,*.hpp,*.cc,*.cpp,*.java,*.go,*.sh exe "1," . 10 . "g/Author :.*/s//Author : Wu ZhenTang"
autocmd bufnewfile *.c,*.h,*.hpp,*.cc,*.cpp,*.java,*.go,*.sh  exe "1," . 10 . "g/Email  :.*/s//Email  : wuzhentang@hotmail.com"
autocmd bufnewfile *.c,*.h,*.hpp,*.cc,*.cpp,*.java,*.go,*.sh  exe "1," . 10 . "g/Creation Time :.*/s//Creation Time : " .strftime("%Y-%m-%d %T")
autocmd Bufwritepre,filewritepre *.c,*.h,*.hpp,*.cc,*.cpp,*.java,*.go,*.sh  execute "normal ma"
autocmd Bufwritepre,filewritepre *.c,*.h,*.hpp,*.cc,*.cpp,*.java,*.go,*.sh  exe "1," . 10 . "g/Last Modified :.*/s/Last Modified :.*/Last Modified : " .strftime("%c")
autocmd bufwritepost,filewritepost *.c,*.h,*.hpp,*.cc,*.cpp,*.java,*.go,*.sh  execute "normal `a"
