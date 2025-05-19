counter=1
for i in ./*; do
  i="${i#./}"
  if [ "$i" != "index.html" ] && [ "$i" != "style.css" ] && [ "$i" != "favicon.png" ] && [ "$i" != "gen.sh" ] && [ "$i" != "readme.sh" ] && [ "$i" != "link-list.sh" ]; then
    printf '%s:./%s\n' "$counter" "${i#./}"
    : $((counter+=1))
  fi
done
