#!/bin/bash


PREFIX=$HOME

function ftype(){
    ftype=`ls -l $1 | sed -e "s/\(.\).*/\1/" `   
    echo $ftype
}

function mklink(){
    fname=$1;
    target=$PREFIX/$fname
    fname=`pwd`/$1;

    if [ ! -e $target ]; then
        echo "ln -s $fname $target"
        ln -s $fname $target
    fi
}

mklink .zshrc
mklink .vimrc


if [ ! -e ~/vim ] ; then
    mkdir -p ~/bin
    mkdir -p ~/opt
    git clone https://github.com/vim/vim.git ~/vim
    pushd ~/vim/
        ./configure --prefix=$HOME --enable-multibyte --enable-xim --enable-fontset --enable-luainterp --with-features=hoge --disable-selinux --enable-luainterp=yes --with-lua-prefix=/husr/local/bin --enable-rubyinterp=yes
        make
        make install
    popd
fi

mkdir -p ~/.vim
if [ ! -e ~/.vim/newbundle.git  ] ; then
    git clone https://github.com/Shougo/neobundle.vim ~/.vim/newbundle.git
fi

if [ ! -e ~/.vim/bundle/newobundle ];then
    git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
fi

if [ ! -e ~/.vim/bundle/vimproc ];then

    git clone https://github.com/Shougo/vimproc ~/.vim/bundle/vimproc
    pushd ~/.vim/bundle/vimproc
        make
    popd
fi

vim -S NeoBundleInstall.vim 

if [! -e ~/.vim/colors/chlordane.vim ];then
    mkdir -p ~/.vim/colors
    ln -s ~/dot_config/vim/chlordone.vim ~/.vim/colors/chlordane.vim
fi

