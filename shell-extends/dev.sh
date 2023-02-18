
alias printEnvs="xargs -0 -L1 -a /proc/self/environ"
alias mkcscopefile="find \`pwd\` -name \"*.[ch]\" -o -name \"*.cpp\" -o -name \"*.java\" > cscope.files"
alias mkctags="ctags -R -L cscope.files && cscope -Rbqv -i cscope.files"
alias dex2jar="$CURRENT_PATH/bin/common/dex-tools-2.1/d2j-dex2jar.sh"

