#!/bin/bash

BINFILE=$1
CONTROL=$2
OUTNAME=$3
BINDIR=$4
ARCH=$5

echo Attributes: $BINFILE $CONTROL $OUTNAME

CUR_DIR=`pwd`
SONAME="${OUTNAME,,}" #to lower
echo SONAME=$SONAME
echo VERSION=$VERSION

PACKAGE_DIR=$CUR_DIR/package-$SONAME-$ARCH/$SONAME
PACKAGE_BIN_DIR=$PACKAGE_DIR/$BINDIR
PACKAGE_CTRL_DIR=$PACKAGE_DIR/DEBIAN
PACKAGE_DOC_DIR=$PACKAGE_DIR/usr/share/doc/$SONAME
#PACKAGE_DEST_DIR=$DEST_DIR/packages

rm -rf $PACKAGE_DIR

mkdir -p $PACKAGE_CTRL_DIR
mkdir -p $PACKAGE_BIN_DIR
mkdir -p $PACKAGE_DOC_DIR

cp $BINFILE $PACKAGE_BIN_DIR/$OUTNAME
cp $CONTROL $PACKAGE_CTRL_DIR/control
cd $PACKAGE_CTRL_DIR/
sed -i "s/SONAME/$SONAME/g" control
sed -i "s/VERSION/$VERSION/g" control
sed -i "s/ARCH/$ARCH/g" control

cp $ROOT_DIR/scripts/changelog $PACKAGE_CTRL_DIR/
gzip -9 -n -f $PACKAGE_CTRL_DIR/changelog
mv $PACKAGE_CTRL_DIR/changelog.gz $PACKAGE_DOC_DIR/changelog.gz

cp $ROOT_DIR/scripts/copyright $PACKAGE_DOC_DIR/

cd $PACKAGE_BIN_DIR
strip --strip-unneeded $OUTNAME
chmod 755 $OUTNAME

cd $PACKAGE_DIR/../
fakeroot dpkg-deb -b $SONAME

mkdir -p $PACKAGE_DEST_DIR
mv $SONAME.deb $CUR_DIR/"$OUTNAME"_"$VERSION"_"$ARCH".deb

lintian $CUR_DIR/"$OUTNAME"_"$VERSION"_"$ARCH".deb
