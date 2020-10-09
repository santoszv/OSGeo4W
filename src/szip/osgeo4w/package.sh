export P=szip
export V=2.1.1
export B=next
export MAINTAINER=JuergenFischer

source ../../../scripts/build-helpers

startlog

[ -f $P-$V.tar.gz ] || wget https://support.hdfgroup.org/ftp/lib-external/$P/$V/src/$P-$V.tar.gz
[ -f ../CMakeLists.txt ] || tar -C .. --xform s,$P-$V,., -xzf $P-$V.tar.gz

export R=$OSGEO4W_REP/x86_64/release/$P
mkdir -p $R/$P-devel

vs2019env
cmakeenv
ninjaenv

mkdir -p build install

cd build

cmake -G Ninja \
	-D CMAKE_BUILD_TYPE=Release \
	-D BUILD_SHARED_LIBS=ON \
	-D CMAKE_INSTALL_PREFIX=../install \
	../..
ninja
ninja install

cd ..

cat <<EOF >$R/setup.hint
sdesc: "SZIP compression library (runtime)"
ldesc: "SZIP compression library (runtime)"
category: Libs
requires: msvcrt2019
maintainer: $MAINTAINER
EOF

cat <<EOF >$R/$P-devel/setup.hint
sdesc: "SZIP compression library (development)"
ldesc: "SZIP compression library (development)"
category: Libs
requires: $P
external-source: $P
maintainer: $MAINTAINER
EOF

cp ../COPYING $R/$P-$V-$B.txt
cp ../COPYING $R/$P-devel/$P-devel-$V-$B.txt

tar -C install -cjf $R/$P-$V-$B.tar.bz2 \
	bin/szip.dll

tar -C install -cjf $R/$P-devel/$P-devel-$V-$B.tar.bz2 \
	include cmake lib

tar -C .. -cjf $R/$P-$V-$B-src.tar.bz2 osgeo4w/package.sh

endlog
