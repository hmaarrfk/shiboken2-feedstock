#!/bin/sh

XVFB_RUN=""
if test `uname` = "Linux"
then
  cp -r /usr/include/xcb ${PREFIX}/include/qt
  XVFB_RUN="xvfb-run -s '-screen 0 640x480x24'"
fi

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
cp -r shiboken2-5.15.3.dist-info "${PREFIX}"/lib/python"${_pythonpath}"/site-packages/

if test `uname` = "Linux"
then
  rm -rf ${PREFIX}/include/qt/xcb
fi
