TARGET = bin/base64_decode
SRCS = src/test/base64_decode.cc
LINK_TYPE = exec
INCLUDE = -Isrc
LIB = -Lbuild -lbrickred -lbrtest -pthread -lrt
DEPFILE = build/libbrickred.a build/libbrtest.a
BUILD_DIR = build

include mak/main.mak

