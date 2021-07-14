#!/bin/sh

embed_document() {
  while read -r line; do
    echo 'cat <<'\'EMBED\'' >/tmp/'"$line" >/tmp/tmp_header
    echo "EMBED" >/tmp/tmp_footer
    grep ^ "$line" |
      cat /tmp/tmp_header - /tmp/tmp_footer
  done
}

find ./ -type d |
  grep -e "documents" -e "scripts" |
  sed "s|./|/tmp/|" |
  xargs mkdir

echo '#!/bin/sh' >selfcomtainedsh

: 'Export documents' && {
  find documents/*.md |
    embed_document |
    grep -v '```'
} >>selfcomtainedsh

: 'Export scripts' && {
  find scripts/* |
    embed_document
} >>selfcomtainedsh

: 'main' && {
  echo 'ARGS="$*" && export ARGS' >>selfcomtainedsh
  find scripts/ -type f |
    grep -v "compile" |
    sed "s|^|. /tmp/|" >>selfcomtainedsh
}

chmod +x selfcomtainedsh

./selfcomtainedsh -h

rm /tmp/tmp_*
