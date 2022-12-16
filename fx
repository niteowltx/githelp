find . ! -path '*/.git/*' \( -type f -o -type l \) -a ! -name tags -print0 | xargs -0 grep -s "$1"
