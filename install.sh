#!/usr/bin/env bash
set -euo pipefail
HERE="$(cd "$(dirname "$0")" && pwd)"
JAN_DATA="${1:-}"

find_jan() {
  if [[ -n "${JAN_DATA}" && -d "${JAN_DATA}/assistants" ]]; then
    echo "${JAN_DATA}"
    return
  fi
  for c in \
    "${HOME}/Library/Application Support/Jan/data" \
    "${XDG_DATA_HOME:-$HOME/.local/share}/Jan/data" \
    "${HOME}/.config/Jan/data" \
    "${HOME}/jan"; do
    if [[ -d "${c}/assistants" ]]; then
      echo "${c}"
      return
    fi
  done
  return 1
}

DEST="$(find_jan || true)"
if [[ -z "${DEST}" ]]; then
  echo "No encuentro la carpeta de datos de Jan."
  echo "Uso: ./install.sh /ruta/a/Jan"
  exit 1
fi

mkdir -p "${DEST}/assistants"
for dir in "${HERE}/assistants"/*; do
  name="$(basename "${dir}")"
  target="${DEST}/assistants/${name}"
  mkdir -p "${target}"
  if [[ -f "${target}/assistant.json" ]]; then
    cp "${target}/assistant.json" "${target}/assistant.json.bak"
  fi
  cp "${dir}/assistant.json" "${target}/assistant.json"
  echo "Asistente: ${name}"
done

if [[ -d "${HERE}/playbooks" ]]; then
  mkdir -p "${DEST}/workspace/playbooks"
  cp "${HERE}/playbooks/"*.md "${DEST}/workspace/playbooks/"
  echo "Playbooks: ${DEST}/workspace/playbooks"
fi

echo
echo "Listo. Carpeta Jan: ${DEST}"
echo "Reinicia Jan. Asistentes: Jan, Programadora, Apps moviles, Sistemas y SSH, Traductora, Biblioteca, Cineasta, Guionista, Video sin censura.
