 #!/bin/sh
 
 DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 PWD=$(pwd)
 cd $HOME
 OH_MY_DIRECTORY=.oh-my-zsh
 
 if [ ! -e $OH_MY_DIRECTORY ]; then
    umask g-w,o-w
    git clone --depth 1 git://github.com/robbyrussell/oh-my-zsh.git $OH_MY_DIRECTORY
 else
    echo "Skipping clone of oh-my-zsh"
 fi
 
 for dotfile in $(ls -a $DIR/dots); do
    if [ -f "$DIR/dots/$dotfile" ]; then
        # backup old file, just in case
        if [ -f $dotfile ] && [ ! -h $dotfile ]; then
            mv $dotfile $dotfile.old
        fi
        
        if [ ! -f "$dotfile" ]; then
            ln -s $DIR/dots/$dotfile $dotfile
        fi
    fi
 done;
 
TEST_CURRENT_SHELL=$(expr "$SHELL" : '.*/\(.*\)')
if [ "$TEST_CURRENT_SHELL" != "zsh" ]; then
    # If this platform provides a "chsh" command (not Cygwin), do it, man!
    if hash chsh >/dev/null 2>&1; then
        printf "${BLUE}Time to change your default shell to zsh!${NORMAL}\n"
        chsh -s $(grep /zsh$ /etc/shells | tail -1)
        # Else, suggest the user do so manually.
    else
        printf "I can't change your shell automatically because this system does not have chsh.\n"
        printf "${BLUE}Please manually change your default shell to zsh!${NORMAL}\n"
    fi
fi

cd $PWD

env zsh
