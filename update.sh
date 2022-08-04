#! /bin/bash

cd $(dirname $0)

LASTCHANGE_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2FLAST_CHANGE?alt=media"

REVISION=$(curl -s -S $LASTCHANGE_URL)

echo "latest revision is $REVISION"

if [ -d $REVISION ] ; then
  echo "already have latest version"
  exit
fi

ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchrome-linux.zip?alt=media"
DRIVER_ZIP_URL="https://www.googleapis.com/download/storage/v1/b/chromium-browser-snapshots/o/Linux_x64%2F$REVISION%2Fchromedriver_linux64.zip?alt=media"

ZIP_FILE="${REVISION}-chrome-linux.zip"
DRIVER_ZIP_FILE="${REVISION}-chromedriver.zip"

echo "fetching $ZIP_URL"

rm -rf $REVISION
mkdir $REVISION
pushd $REVISION
curl -# $ZIP_URL > $ZIP_FILE
curl -# $DRIVER_ZIP_URL > $DRIVER_ZIP_FILE
echo "unzipping.."
unzip $ZIP_FILE
unzip $DRIVER_ZIP_FILE
popd
rm -f ./latest
ln -s $REVISION/chrome-linux/ ./latest
ln -s $(pwd)/$REVISION/chromedriver_linux64/chromedriver ./latest/chromedriver


