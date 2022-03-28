#!/bin/bash

while read color; do
  old=$(echo $color | awk '{print $2}')
  new=$(echo $color | awk '{print $3}')
  replace=$(echo 's/'$old'/'$new'/gI')
  echo $replace
  sed -i $replace launcher.rasi kitty_theme.conf layout.liquid template.liquid colorscheme.scss
done < ./newcolors.scss
