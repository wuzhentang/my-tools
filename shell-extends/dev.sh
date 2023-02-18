
alias printEnvs="xargs -0 -L1 -a /proc/self/environ"
alias mkcscopefile="find \`pwd\` -name \"*.[ch]\" -o -name \"*.cpp\" -o -name \"*.java\" > cscope.files"
alias mkctags="ctags -R -L cscope.files && cscope -Rbqv -i cscope.files"
alias dex2jar="~/bin/dex2jar-2.1/dex-tools-2.1/d2j-dex2jar.sh"

