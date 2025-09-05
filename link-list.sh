#!/bin/sh
ignore_list="$(
  # shellcheck disable=SC2030
  # shellcheck disable=SC2031
  while read -r ignore_line || [ "$ignore_line" ]; do
    # shellcheck disable=SC2031
    printf '%s\n' "$ignore_line"
  done < ./.gen_ignore
)"

counter=1
for i in ./*; do
  i="${i#./}"
  case "$i" in
    *'xcf'*) continue;;
  esac
  case "$ignore_list" in
    *"$i"*) :;;
    *) 
    printf '%s:./%s\n' "$counter" "${i#./}"
    : $((counter+=1)) ;;
  esac
done
