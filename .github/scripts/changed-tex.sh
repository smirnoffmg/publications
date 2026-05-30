#!/usr/bin/env bash
# Sets GitHub Actions outputs: should_build, build_all, tex_list (one root .tex per line).
set -euo pipefail

should_build=false
build_all=false
tex_files=()

emit_outputs() {
  {
    echo "should_build=${should_build}"
    echo "build_all=${build_all}"
    echo "tex_list<<EOF"
    if [[ "${build_all}" == false && ${#tex_files[@]} -gt 0 ]]; then
      printf '%s\n' "${tex_files[@]}"
    fi
    echo "EOF"
  } >> "${GITHUB_OUTPUT}"
}

add_tex() {
  local f=$1
  case "$f" in
    *.tex)
      if [[ "$f" != */* ]]; then
        tex_files+=("$f")
      fi
      ;;
  esac
}

event_name=${1:?event name required}
before_ref=${2:-}
after_ref=${3:?after ref required}

# Tags, manual runs, or unknown parent: compile everything.
if [[ "${event_name}" == "workflow_dispatch" ]] || [[ "${GITHUB_REF:-}" == refs/tags/* ]]; then
  build_all=true
  should_build=true
  emit_outputs
  exit 0
fi

if [[ "${event_name}" == "push" && ( -z "${before_ref}" || "${before_ref}" == 0000000000000000000000000000000000000000 ) ]]; then
  build_all=true
  should_build=true
  emit_outputs
  exit 0
fi

changed=()
while IFS= read -r line; do
  changed+=("$line")
done < <(git diff --name-only "${before_ref}" "${after_ref}")

if [[ "${event_name}" != "pull_request" && "${event_name}" != "push" ]]; then
  build_all=true
  should_build=true
  emit_outputs
  exit 0
fi

if ((${#changed[@]} > 0)); then
  for f in "${changed[@]}"; do
    case "$f" in
      references.bib | Makefile)
        build_all=true
        should_build=true
        emit_outputs
        exit 0
        ;;
      *)
        add_tex "$f"
        ;;
    esac
  done
fi

if ((${#tex_files[@]} > 0)); then
  should_build=true
  build_all=false
fi

emit_outputs
