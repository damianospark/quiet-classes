#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

read -rp "커밋 메시지를 입력하세요: " COMMIT_MSG

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
