package: BookkeepingApiCpp
version: v0.21.0
tag: "@aliceo2/bookkeeping@0.21.0"
requires:
  - boost
  - "GCC-Toolchain:(?!osx)"
  - cpprestsdk
  - cpr
build_requires:
  - CMake
  - alibuild-recipe-tools
source: https://github.com/AliceO2Group/Bookkeeping
---
#!/bin/bash -ex

case $ARCHITECTURE in
  osx*)
    [[ ! $BOOST_ROOT ]] && BOOST_ROOT=$(brew --prefix boost)
    [[ ! $OPENSSL_ROOT ]] && OPENSSL_ROOT=$(brew --prefix openssl@1.1)
  ;;
esac

cmake $SOURCEDIR/cpp-api-client                     \
      -DCMAKE_INSTALL_PREFIX=$INSTALLROOT           \
      ${BOOST_REVISION:+-DBOOST_ROOT=$BOOST_ROOT}   \
      -DCPPREST_ROOT=${CPPRESTSDK_ROOT}             \
      -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
      ${OPENSSL_ROOT:+-DOPENSSL_ROOT_DIR=$OPENSSL_ROOT}

VERBOSE=1 make ${JOBS+-j $JOBS} install

#ModuleFile
mkdir -p etc/modulefiles
alibuild-generate-module --bin --lib > etc/modulefiles/$PKGNAME
cat >> etc/modulefiles/$PKGNAME <<EoF
EoF
mkdir -p $INSTALLROOT/etc/modulefiles && rsync -a --delete etc/modulefiles/ $INSTALLROOT/etc/modulefiles
