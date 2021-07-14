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

echo '#!/bin/sh' >selfcomtained

: 'Export documents' && {
  find documents/*.md |
    embed_document |
    grep -v '```'
} >>selfcomtained

: 'Export scripts' && {
  find scripts/* |
    embed_document
} >>selfcomtained

: 'main' && {
  echo 'ARGS="$*" && export ARGS' >>selfcomtained
  find scripts/ -type f |
    grep -v "compile" |
    sed "s|^|. /tmp/|" >>selfcomtained
}

: 'cleanup' && {
  echo 'rm -rf /tmp/documents /tmp/scripts/' >>selfcomtained
}
chmod +x selfcomtained

./selfcomtained -h

rm /tmp/tmp_*
