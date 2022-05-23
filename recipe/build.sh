#!/bin/sh

pushd sources/shiboken2
mkdir build && cd build

cmake \
  -DCMAKE_PREFIX_PATH=${PREFIX} \
  -DCMAKE_INSTALL_PREFIX=${PREFIX} \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_RPATH=${PREFIX}/lib \
  -DBUILD_TESTS=OFF \
  -DPYTHON_EXECUTABLE=${PYTHON} \
  ..
make install -j${CPU_COUNT}
popd

${PYTHON} setup.py dist_info --build-type=shiboken2
_pythonpath=`${PYTHON} -c "from sysconfig import get_python_version; print(get_python_version())"`
cp -r shiboken2-${PKG_VERSION}.dist-info "${PREFIX}"/lib/python"${_pythonpath}"/site-packages/
