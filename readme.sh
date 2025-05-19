#!/bin/sh
counter=1
printf '%s\nwritings\n%s\n' "---" "---"
for i in ./*; do
  i="${i#./}"
  if [ "$i" != "LICENSE" ] && [ "$i" != "link-list" ] && [ "$i" != "custom-http" ] && [ "$i" != "README" ]  && [ "$i" != "index.html" ] && [ "$i" != "style.css" ] && [ "$i" != "favicon.png" ] && [ "$i" != "gen.sh" ] && [ "$i" != "readme.sh" ] && [ "$i" != "link-list.sh" ]; then
    i="${i%.jpg}"; i="${i%.png}"
    printf '://%s\n' "${i#./}"
    : $((counter+=1))
  fi
done
printf '%s\n' "---"
