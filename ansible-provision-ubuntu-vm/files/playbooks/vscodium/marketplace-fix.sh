#!/bin/bash -eux

declare -r PRODUCT_FILE='/usr/share/codium/resources/app/product.json'

sed -i \
    's|https://open-vsx.org/vscode/gallery|https://marketplace.visualstudio.com/_apis/public/gallery|' \
    "${PRODUCT_FILE}"
sed -i \
    's|https://open-vsx.org/vscode/item|https://marketplace.visualstudio.com/items|' \
    "${PRODUCT_FILE}"
