#!/usr/bin/env bash
set -o noglob

POLINT='/go/bin/po-lint'

error() {
  echo >&2 ":: [Error]: $*"
  exit 1
}

info() {
  echo >&1 ":: [Info]: $*"
  return 0
}

_command() {
  local _return cmd
  cmd="$1"
  _return=1
  command -v "$cmd" >/dev/null && _return=0
  return ${_return}
}

# shellcheck disable=SC2086
_find() {
    local path="$1"
    local glob_pattern="${2:-*.y*ml}"
    local cmd="$path -name ${glob_pattern}"
    local files
    files="$(find $cmd)"
    echo "$files"
}

_check() {
    local files="$1"
    local exclude="${2:-""}"
    local errors=0
    for file in $files; do
      if [[ -n $exclude ]]; then
        if echo "$file" | grep -Eq "$exclude"; then
          info "Skipping file: $file"
          continue
        fi
      fi
      info "Checking file: $file"
      if ! "$POLINT" "$file"; then
          ((errors+=1))
      fi
    done
    return $errors
}

lint() {
  local path="$1"
  local glob_pattern="${2:-*.y*ml}"
  local exclude="${3:-""}"
  _command "$POLINT" || error "$POLINT linter not installed"
  local files
  files=$(_find "$path" "${glob_pattern}")
  info "Linting '${glob_pattern}' files in '${path}' directory"
  _check "$files" "$exclude"
}

main() {
  local path="$1"
  local glob_pattern="${2:-*.y*ml}"
  local exclude="${3:-""}"
  [[ ! -d $path ]] && error "$path directory not found"
  if ! lint "$path" "${glob_pattern}" "$exclude"; then
    error "Linting failed"
  fi
  info "Linting succeded"
}

main "$@"
