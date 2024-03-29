#!/bin/sh

usage()
{
    echo 'usage: config.sh [options]'
    echo '-h --help            print usage'
    echo '--prefix=<prefix>    install prefix'
    echo '--build-unix         build libbrickredunix'
    echo '--build-test         build test programmes'
    echo '--build-all          build all'
    echo '--enable-baselog     enable base log'
    exit 1
}

opt_prefix='/usr/local'
opt_build_unix='no'
opt_build_test='no'

options=`getopt -o h -l \
help,\
prefix:,\
build-test,\
build-unix,\
build-all,\
enable-baselog\
 -- "$@"`
eval set -- "$options"

while [ $# -gt 0 ]
do
    case "$1" in
    -h|--help) usage;;
    --prefix) opt_prefix=$2; shift;;
    --build-unix) opt_build_unix=yes;;
    --build-test) opt_build_test=yes;;
    --build-all)
        opt_build_unix=yes
        opt_build_test=yes
        ;;
    --enable-baselog)
        core_cpp_flag=$core_cpp_flag' -DBRICKRED_BUILD_ENABLE_BASE_LOG'
        ;;
    --) shift; break;;
    *) usage;;
    esac
    shift
done

# check compiler
which g++ >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo 'can not find g++'
    exit 1
fi

# check make
which make >/dev/null 2>&1
if [ $? -ne 0 ]
then
    echo 'can not find make'
    exit 1
fi

# check epoll_create1
echo '
#include <sys/epoll.h>

int main()
{
    int fd = epoll_create1(EPOLL_CLOEXEC);
}
' | g++ -x c++ -o /dev/null - >/dev/null 2>&1
if [ $? -ne 0 ]
then
    core_cpp_flag=$core_cpp_flag' -DBRICKRED_BUILD_DONT_HAVE_EPOLL_CREATE1'
fi

# output
echo "BR_INSTALL_PREFIX = $opt_prefix" >config.mak
echo "BR_BUILD_UNIX = $opt_build_unix" >>config.mak
echo "BR_BUILD_TEST = $opt_build_test" >>config.mak
echo "BR_CORE_CPP_FLAG = $core_cpp_flag" >>config.mak
