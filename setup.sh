#!/bin/bash

if [ ! -e ~/.vim  ] ; then
	mkdir ~/.vim
fi

if [ ! -e ~/.vim/newbundle.git  ] ; then
	git clone https://github.com/Shougo/neobundle.vim ~/.vim/newbundle.git
fi


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

if [ ! -e ~/.vim/bundle ];then
	mkdir -p ~/.vim/bundle
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


