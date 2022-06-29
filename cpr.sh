package: cpr
version: v1.8.3
source: https://github.com/libcpr/cpr.git
requires:
  - "GCC-Toolchain:(?!osx)"
  - curl
  - OpenSSL:(?!osx)
build_requires:
  - CMake
  - alibuild-recipe-tools
---
#!/bin/sh
cd $BUILDDIR

LIBEXT=so
case $ARCHITECTURE in
    osx*)
      [[ ! $OPENSSL_ROOT ]] && OPENSSL_ROOT=$(brew --prefix openssl@1.1)
      LIBEXT=dylib
    ;;
esac

cmake $SOURCEDIR                                          \
      ${OPENSSL_ROOT:+-DOPENSSL_ROOT_DIR=$OPENSSL_ROOT}   \
      -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON              \
      ${CURL_ROOT:+-DCURL_ROOT=$CURL_ROOT}                \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT                 \
      -DCMAKE_BUILD_TYPE=Debug

make ${JOBS:+-j $JOBS}
make install

# Modulefile
MODULEDIR="$INSTALLROOT/etc/modulefiles"
MODULEFILE="$MODULEDIR/$PKGNAME"
mkdir -p "$MODULEDIR"
alibuild-generate-module --lib > $MODULEFILE
