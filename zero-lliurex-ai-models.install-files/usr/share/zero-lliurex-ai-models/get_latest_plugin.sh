#!/bin/bash
TMP=$1
FORCE_VERSION_TAG=$2
API_URL="https://api.github.com/repos/Acly/krita-ai-diffusion"
if [ ! -w "$TMP" -a ! -d "$TMP" ]; then
    echo Need valid path
    exit 1
fi
if [ -n "$FORCE_VERSION_TAG" ]; then
    echo Getting plugin for tag $FORCE_VERSION_TAG
    API_URL="$API_URL/releases/tags/$FORCE_VERSION_TAG"
else
    echo Getting latest version plugin
    API_URL="$API_URL/releases/latest"
fi
echo "Checking GitHub..."
curl -sL -H "User-Agent: Linux" "$API_URL" | jq -r '.tag_name + " " + .assets[0].browser_download_url' > .download_info

read -r VERSION DOWNLOAD_URL <<< $(cat .download_info)

echo "---------------------------------------"
echo "Found version: $VERSION"
echo "Download URL:  $DOWNLOAD_URL"
echo "---------------------------------------"

FILENAME=$(basename "$DOWNLOAD_URL")

mkdir -p $TMP/{package,decompressed}
echo "Downloading $FILENAME..."
cd $TMP/package
curl -L -# -O "$DOWNLOAD_URL"
cd $TMP/decompressed
echo "Descompressing..."
unzip -qo "$TMP/package/$FILENAME" 
cd ..
echo "Done!"
