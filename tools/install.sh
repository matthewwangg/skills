#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
src_dir="${repo_root}/skills"
dest_dir="${HOME}/.claude/skills"

mkdir -p "${dest_dir}"

for src in "${src_dir}"/*/; do
  src="${src%/}"
  name="$(basename "${src}")"

  [[ -f "${src}/SKILL.md" ]] || continue

  rm -rf "${dest_dir}/${name}"
  ln -s "${src}" "${dest_dir}/${name}"
  echo "linked ${name}"
done
