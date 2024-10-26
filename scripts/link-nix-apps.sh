#!/usr/bin/env sh

NIX_PROFILE="$HOME"/.nix-profile
APP_DIR="$HOME"/Applications

if ! [[ $OSTYPE =~ "darwin" ]]; then
    echo "link-nix-apps: not darwin - doing nothing"
    exit 0
fi

echo "link-nix-apps: we're on darwin - creating app symlinks in $APP_DIR"

mkdir -p $APP_DIR

# remove broken links
for f in "$APP_DIR"/*; do
    if [ -L "$f" ] && [ ! -e "$f" ]; then
        echo "link-nix-apps: removing broken link $f"
        rm "$f"
    fi
done

# link new ones
for f in "$NIX_PROFILE"/Applications/*; do
    app_name="$(basename "$f")"
    if [ ! -e "$APP_DIR/$app_name" ]; then
        echo "link-nix-apps: linking $app_name"
        ln -s "$f" "$APP_DIR"/
    fi
done
