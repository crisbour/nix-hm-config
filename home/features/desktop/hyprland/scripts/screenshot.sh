#!/usr/bin/env bash

dir="$HOME/Pictures/Screenshots"
time=$(date +'%Y_%m_%d_at_%Hh%Mm%Ss')
file="${dir}/Screenshot_${time}.png"

copy() {
    grimblast --notify --freeze copy area
}

save() {
    grimblast --notify --freeze save area "$file"
}

swappy_() {
    grimblast --notify --freeze save area "$file"
    swappy -f "$file"
}

satty_() {
    grimblast --notify --freeze save area "$file"
    satty -f "$file"
}

ocr() {
    grimblast --notify save area /tmp/ocr_screenshot.png && tesseract /tmp/ocr_screenshot.png stdout 2>/dev/null | wl-copy
}

#pix2tex() {
#  grimblast --notify save area /tmp/pix2tex_screenshot.png && curl -s -X POST -F "file=@/tmp/pix2tex_screenshot.png" -L http://127.0.0.1:8502/predict | jq -r | wl-copy
#}

if [[ ! -d "$dir" ]]; then
    mkdir -p "$dir"
fi

if [[ "$1" == "--copy" ]]; then
    copy
elif [[ "$1" == "--save" ]]; then
    save
elif [[ "$1" == "--swappy" ]]; then
    swappy_
elif [[ "$1" == "--satty" ]]; then
    satty_
elif [[ "$1" == "--ocr" ]]; then
    ocr
else
    echo -e "Available Options: --copy --save --swappy"
fi

exit 0
