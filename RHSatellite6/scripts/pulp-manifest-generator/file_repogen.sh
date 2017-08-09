#!/bin/bash
#
# PULP_MANIFEST Generator
#
# Use this againt a directory to create a PULP_MANIFEST for use with syncing 'file' repository types to Satellite 6.

REPO="$1"

if [ -z "$REPO" ]; then
    echo "Please specify a directory to run against as an absolute path."
    exit 1
elif [ ! -d "$REPO" ]; then
    echo "Please ensure you specify a directory!"
    exit 1
fi

if ! [[ "$REPO" =~ /$ ]]; then
    REPO="$REPO/"
fi

if [ -e "$REPO/PULP_MANIFEST" ];then
    rm -f "$REPO/PULP_MANIFEST"
    echo "Cleaned old manifest at $REPO/PULP_MANIFEST, creating new!"
fi

function create_pulp_manifest ()
{
    for file in `find $REPO -type f`;do
        checksum=$(sha256sum $file | awk '{print $2","$1}')
        size=$(stat -Lc "%s" $file)
        echo "Adding File: $file.."
        echo -e "$checksum,$size" >> "$REPO/PULP_MANIFEST"
    done
}

create_pulp_manifest

# Ensure file names do not include paths to repo directory
sed -i -e 's-^./--g' $REPO/PULP_MANIFEST
sed -i -e "s-^$REPO--g" $REPO/PULP_MANIFEST
echo "Complete."
