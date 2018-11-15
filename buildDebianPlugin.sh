#!/bin/bash

LIBFILE=$1
CONTROL=$2
OUTNAME=$3
LIBDIR=$4

echo Attributes: $LIBFILE $CONTROL $OUTNAME

SONAME="${OUTNAME,,}" #to lower
echo SONAME=$SONAME
echo VERSION=$VERSION

PACKAGE_DIR=$BUILD_DIR/package-x64/$SONAME
PACKAGE_LIB_DIR=$PACKAGE_DIR/$LIBDIR
PACKAGE_CTRL_DIR=$PACKAGE_DIR/DEBIAN
PACKAGE_DOC_DIR=$PACKAGE_DIR/usr/share/doc/$SONAME
PACKAGE_DEST_DIR=$DEST_DIR/packages

rm -rf $PACKAGE_DIR

mkdir -p $PACKAGE_CTRL_DIR
mkdir -p $PACKAGE_LIB_DIR
mkdir -p $PACKAGE_DOC_DIR

cp $LIBFILE $PACKAGE_LIB_DIR/$OUTNAME.so
cp $CONTROL $PACKAGE_CTRL_DIR/control
cd $PACKAGE_CTRL_DIR/
sed -i "s/SONAME/$SONAME/g" control
sed -i "s/VERSION/$VERSION/g" control


cp $ROOT_DIR/scripts/changelog $PACKAGE_CTRL_DIR/
gzip -9 -n -f $PACKAGE_CTRL_DIR/changelog
mv $PACKAGE_CTRL_DIR/changelog.gz $PACKAGE_DOC_DIR/changelog.gz

cp $ROOT_DIR/scripts/copyright $PACKAGE_DOC_DIR/

strip --strip-unneeded $PACKAGE_LIB_DIR/$OUTNAME.so
cd $PACKAGE_LIB_DIR
chmod 644 $OUTNAME.so

cd $BUILD_DIR/package-x64/
fakeroot dpkg-deb -b $SONAME

mkdir -p $PACKAGE_DEST_DIR
mv $SONAME.deb $PACKAGE_DEST_DIR/"$OUTNAME"_"$VERSION"_amd64.deb

lintian $PACKAGE_DEST_DIR/"$OUTNAME"_"$VERSION"_amd64.deb
