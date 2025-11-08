#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
사용법: export_and_publish.sh [옵션]

옵션:
  -m, --commit-message MESSAGE  publish 단계에서 사용할 커밋 메시지
  -h, --help                    이 도움말을 표시
EOF
}

COMMIT_MESSAGE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--commit-message|--message)
      if [[ $# -lt 2 ]]; then
        echo "[오류] 커밋 메시지를 옵션과 함께 제공해야 합니다." >&2
        usage
        exit 1
      fi
      COMMIT_MESSAGE="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[오류] 알 수 없는 옵션: $1" >&2
      usage
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

"$SCRIPT_DIR/export_codelabs.sh"

if [[ -n "$COMMIT_MESSAGE" ]]; then
  "$SCRIPT_DIR/publish_changes.sh" --commit-message "$COMMIT_MESSAGE"
else
  "$SCRIPT_DIR/publish_changes.sh"
fi
