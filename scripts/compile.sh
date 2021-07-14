#!/bin/sh

embed_document() {
  while read -r line; do
    echo 'cat <<'\'EMBED\'' >/tmp/'"$line" >/tmp/tmp_header
    echo "EMBED" >/tmp/tmp_footer
    grep ^ "$line" |
      cat /tmp/tmp_header - /tmp/tmp_footer
  done
}

echo '#!/bin/sh' >selfcontained
echo 'set -ue' >>selfcontained

: 'Create directories' && {
  find ./ -type d |
    grep -e "documents" -e "scripts" |
    sed "s|./|mkdir -p /tmp/|"
} >>selfcontained

: 'Export documents' && {
  find documents/*.md |
    embed_document |
    grep -v '```'
} >>selfcontained

: 'Export scripts' && {
  find scripts/* |
    embed_document
} >>selfcontained

: 'main' && {
  echo 'ARGS="$*" && export ARGS' >>selfcontained
  find scripts/ -type f |
    grep -v "compile" |
    sed "s|^|. /tmp/|" >>selfcontained
}

: 'cleanup' && {
  echo 'rm -rf /tmp/documents /tmp/scripts/' >>selfcontained
}
chmod +x selfcontained

./selfcontained -h

rm /tmp/tmp_*
