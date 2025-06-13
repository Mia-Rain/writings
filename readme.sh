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
printf '%s\nwritings\n%s\n' "---" "---"
for i in ./*; do
  i="${i#./}"
  case "$ignore_list" in
    *"$i"*) :;;
    *)
    i="${i%.jpg}"; i="${i%.png}"; i="${i%.txt}"
    printf '://%s\n' "${i#./}"
    : $((counter+=1))
    ;;
  esac
done
printf '%s\n' "---"