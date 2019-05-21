#!/bin/bash

SRCFROM=$1
PROJNAME=$2
VERSION=$3
CONTROL=$4
ARCH=$5
OUTNAME=$6

echo Attributes: $BINFILE $CONTROL $OUTNAME

CUR_DIR=`pwd`
SONAME="${PROJNAME,,}" #to lower
echo SONAME=$SONAME
echo VERSION=$VERSION

PACKAGE_DIR=$CUR_DIR/package-$SONAME-dev-$ARCH/$SONAME-dev
PACKAGE_CTRL_DIR=$PACKAGE_DIR/DEBIAN
SRC_DEST_DIR=$PACKAGE_DIR/usr/include/$SONAME
PACKAGE_DOC_DIR=$PACKAGE_DIR/usr/share/doc/$SONAME-dev
#PACKAGE_DEST_DIR=$DEST_DIR/packages

rm -rf $PACKAGE_DIR

mkdir -p $PACKAGE_DEST_DIR
mkdir -p $PACKAGE_CTRL_DIR
mkdir -p $PACKAGE_DOC_DIR
mkdir -p $SRC_DEST_DIR

cp $CONTROL $PACKAGE_CTRL_DIR/control
cd $PACKAGE_CTRL_DIR/
sed -i "s/SONAME/$SONAME/g" control
sed -i "s/VERSION/$VERSION/g" control
sed -i "s/ARCH/$ARCH/g" control

cp $ROOT_DIR/scripts/changelog $PACKAGE_CTRL_DIR/
gzip -9 -n -f $PACKAGE_CTRL_DIR/changelog
mv $PACKAGE_CTRL_DIR/changelog.gz $PACKAGE_DOC_DIR/changelog.gz

cp $ROOT_DIR/scripts/copyright $PACKAGE_DOC_DIR/

cp -a $SRCFROM/* $SRC_DEST_DIR

cd $PACKAGE_DIR/../
fakeroot dpkg-deb -b $SONAME-dev

mkdir -p $PACKAGE_DEST_DIR
mv $SONAME-dev.deb $CUR_DIR/"$OUTNAME"_"$VERSION"_"$ARCH".deb

lintian $CUR_DIR/"$OUTNAME"_"$VERSION"_"$ARCH".deb
