#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
사용법: publish_changes.sh [옵션]

옵션:
  -m, --commit-message MESSAGE  사용할 커밋 메시지 지정
  -h, --help                    이 도움말을 표시
EOF
}

COMMIT_MSG=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    -m|--commit-message|--message)
      if [[ $# -lt 2 ]]; then
        echo "[오류] 커밋 메시지를 옵션과 함께 제공해야 합니다." >&2
        usage
        exit 1
      fi
      COMMIT_MSG="$2"
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

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ -z "${COMMIT_MSG// }" ]]; then
  read -rp "커밋 메시지를 입력하세요 (--commit-message 옵션 사용 가능): " COMMIT_MSG
fi

if [[ -z "${COMMIT_MSG// }" ]]; then
  echo "[오류] 커밋 메시지는 비워둘 수 없습니다." >&2
  exit 1
fi

git -C "$ROOT_DIR" add -A
if ! git -C "$ROOT_DIR" diff --cached --quiet; then
  git -C "$ROOT_DIR" commit -m "$COMMIT_MSG"
  git -C "$ROOT_DIR" push
  echo "[완료] 변경 사항이 원격 저장소에 반영되었습니다."
else
  echo "[안내] 커밋할 변경 사항이 없습니다." >&2
fi
