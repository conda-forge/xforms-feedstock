#!/usr/bin/env bash

set -ex

# Update autoconfig source files
cp $BUILD_PREFIX/share/gnuconfig/config.* ./config/
autoconf

# Configure
./configure \
  --prefix="$PREFIX" \
  --libdir="${PREFIX}/lib" \
  --enable-shared \
  --disable-static \
;

# Build
make -j${CPU_COUNT}

# Test
make check

# Install
make install

# Install pkg-config file
mkdir -p "${PREFIX}/lib/pkgconfig"
cat << EOF > "${PREFIX}/lib/pkgconfig/${PKG_NAME}.pc"
prefix=${PREFIX}
libdir=\${prefix}/lib
includedir=\${prefix}/include

Name: ${PKG_NAME}
Description: ${PKG_NAME} library
Version: ${PKG_VERSION}
Libs: -L\${libdir} -lforms
Cflags: -I\${includedir}
EOF
