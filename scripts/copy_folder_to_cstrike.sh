#! /bin/bash

# declare directory for extraction of archive
export TARGET_DIR="/tmp/extracted"

# extract archive to target dir
./extract.sh $1

if [ $? -eq 1 ]; then
  echo "Archive extraction failed"
  exit 1
fi

# copy contents of extracted archive to $HLDS_DIR/cstrike folder
cp -r $TARGET_DIR/cstrike/* $HLDS_DIR/cstrike

# remove extracted archive contents and host dir
rm -rf $TARGET_DIR
