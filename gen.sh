#!/bin/sh
IFS=""
space=" "
nl="
"
bail() {
  unset ERR
  "${ERR:?$1}" || exit "${3:-1}"
}
[ "$domain" ] || domain="transcendent.ink"
[ "$license" ] || license="Licensed under Unlicense ~ Set it Free."
[ "$stack" ] || stack="ssh"
[ "$root" ] || root="~git"
[ "$foot" ] && addon="1"
[ "$hyperlink" ] || hyperlink="://"
[ "$linkend" ] || hyperlink="//"

[ "$1" ] && . $1  
# load custom data last so variables may be unset
# YMMV
in=$(while read -r p || [ "$p" ]; do
  printf '%s\n' "$p"
done) # set in to STDIN as we need it several times
l=0; while read -r p || [ "$p" ]; do 
    [ ${#p} -gt $l ] && : $((l=${#p})) # add length of lines together
done << EOF
$in
EOF
: $((l+=4))
printf '<head>\n'
if [ "$favicon" ]; then 
  printf '<link rel="icon" href="https://%s">\n' "${domain}/${path}/${favicon}"
else 
  printf '<link rel="icon" href="favicon.png">\n;'
fi
[ "$css" ] && printf '<link rel="stylesheet" href="https://%s">\n' "${domain}/${path}/${css}"
i=0; [ "$name" ] || while read -r p || [ "$p" ]; do
  [ "$i" -eq 1 ] && {
      p="${p#\#?}"; p=${p% *} # yank out any trailing/leading spaces
      name="${p}" 
      break
    }
  : $((i+=1)) 
done << EOF
$in
EOF
###[ $((${#name}%3)) != 0 ] && bail "TITLE MUST BE AN ODD LENGTH"
# the title should be odd for proper centering; not my problem tho
[ "$((${#name}%3))" -ne 0 ] && : $((l+=1))
echo "<title>${root:+:"${root}"/}${title:-"${name}"}</title>"
printf '</head>
<body class="vsc-initialized">
<div class="%s">
<font>
<pre>
<center>
 ' "${div_class:-div}" # print initial setup
### next gen header based on mean
# lmao once I code do math
n=0; header=$(printf '┌'; until [ "$n" -eq "$((l+2))" ]; do   
  printf '─'
  : $((n+=1))
done; printf '┐')
n=0; mid=$(printf '├'; until [ "$n" -eq "$((l+2))" ]; do
  printf '─'
  : $((n+=1))
done; printf '┤')
n=0; footer=$(printf '└'; until [ "$n" -eq "$((l+2))" ]; do
  printf '─'
  : $((n+=1))
done; printf '┘')
echo
link_num=1
while read -r p || [ "$p" ]; do
  unset op
  # injection is used for hyperlink support
  # hyperlink support

  #[ "$((${#p}%2))" = 0 -a "${#p}" != 0 ] && bail "LINE IS TOO LONG${nl}LINE IS:$nl$p${nl}LENGTH IS ${#p}" 
  # note that if lines and title are not odd that things will break
  [ "$p" != "---" ] && {
    [ "${p##*-- }" = "$p" -a "${#p}" -ne 0 ] && name="$p" 
    p="${p##*-- }";
    [ "$p" = "$name" ] && {
      np="$nl $mid"
    } || unset np
      op="${#p}"
      [ "${p##*"${hyperlink}"}" != "$p" -a -e "${linkfile:-./link-list}" ] && { 
        while read -r c || [ "$c" ]; do
          [ "${c%%:*}" -eq "$link_num" ] && {
            clink="${c#*:}"
            break
          }
        done < "$linkfile"
        for i in ${p}; do
          case $i in
            (*"$hyperlink"*)
            [ "$clink" ] && p="${p%%"${hyperlink}"*}<a href=\"$clink\">${i#*"${hyperlink}"}</a>${p##*"${hyperlink}"*}"
            unset clink
            break
            ;;
        esac
      done
      : $((link_num+=1))
    }
    [ "$op" != "${#p}" ] && {
      diff="$((${#p}-op+2))"
    } || diff=0
    [ "${#p}" -ne 0 ] && {
      case "$p" in
        (*"$hyperlink"*) ex="$((${#hyperlink}))";;
      esac
      until [ "$((${#p}-diff))" -ge $(((l-ex) -2)) ]; do
        p="$space$p$space"
      done
      until [ "$((${#p}-diff))" -ge $((l)) ]; do
        p="$space$p$space"
      done
      [ "${#p}" -gt $l -a "$diff" -eq 0 ] && {
        p="${p%"$space"}"
      }
      p="│ $p │"
      unset ex op diff
    }
    # hyperlink injection
    printf '%s\n' " $p$np"
  } || printf '%s\n' " $footer"
done << EOF
$in
EOF
[ "$foot" ] || printf '

</center>
</pre>
</font>
</div>
'
[ "$addon" ] || echo '</body>'
[ "$addon" -a "$ascript" ] && ${ascript}
