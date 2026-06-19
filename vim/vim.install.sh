#!/bin/sh

./configure --with-features=huge \
    --enable-multibyte \
    --enable-rubyinterp=yes \
    --enable-pythoninterp=yes\
    --with-python-config-dir=/usr/lib/python2.7/config \
    --enable-python3interp=yes\
    --with-python3-config-dir=/usr/lib/python3.5/config \
    --enable-perlinterp=yes \
    --enable-luainterp=yes \
    --enable-cscope \
    --prefix=/depot/Vim-8.0
make
make install
