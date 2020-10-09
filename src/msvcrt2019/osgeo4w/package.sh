export P=msvcrt2019
export V=14.2
export B=1
export MAINTAINER=JuergenFischer

source ../../../scripts/build-helpers

startlog

vs2019env

export R=$OSGEO4W_REP/x86_64/release/$P
mkdir -p $R

cat <<EOF >$R/setup.hint
sdesc: "Microsoft Visual C++ redistributables 2015-2019 (runtime)"
sdesc: "Microsoft Visual C++ redistributables 2015-2019 (runtime)"
category: Libs
requires: 
maintainer: $MAINTAINER
EOF

(
	cd "$(cygpath -am "$VCToolsRedistDir")/x64/"

	tar -cjf $R/$P-$V-$B.tar.bz2 \
		--xform "s,^.*/,bin/," \
		*CRT/*.dll \
		*CXXAMP/*.dll \
		*OpenMP/*.dll
)

tar -C .. -cjf $R/$P-$V-$B-src.tar.bz2 osgeo4w/package.sh

endlog
