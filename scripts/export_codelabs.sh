#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$ROOT_DIR/source"
DOCS_DIR="$ROOT_DIR/docs"
CLAAT_BIN="${CLAAT_BIN:-$ROOT_DIR/../claat}"
HOME_URL="https://damianospark.github.io/quiet-classes/"

if [[ ! -x "$CLAAT_BIN" ]]; then
  echo "[오류] claat 실행 파일을 찾을 수 없습니다: $CLAAT_BIN" >&2
  echo "CLAAT_BIN 환경 변수를 설정하거나 repo 상위 디렉터리에 claat 바이너리를 준비하세요." >&2
  exit 1
fi

if [[ ! -d "$SOURCE_DIR" ]]; then
  echo "[오류] source 디렉터리를 찾을 수 없습니다: $SOURCE_DIR" >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
cleanup() {
  rm -rf "$TMP_DIR"
}
trap cleanup EXIT

shopt -s nullglob
MD_FILES=("$SOURCE_DIR"/*.md)
if (( ${#MD_FILES[@]} == 0 )); then
  echo "[안내] 변환할 Markdown 파일이 없습니다." >&2
  exit 0
fi

for md in "${MD_FILES[@]}"; do
  echo "[변환] $(basename "$md")" >&2
  "$CLAAT_BIN" export -o "$TMP_DIR" "$md"
  if [[ $? -ne 0 ]]; then
    echo "[오류] claat export 실패: $md" >&2
    exit 1
  fi
  name="$(basename "$md" .md)"
  SRC_DIR="$TMP_DIR/$name"
  if [[ ! -d "$SRC_DIR" ]]; then
    SRC_DIR="$(ls -dt "$TMP_DIR"/*/ 2>/dev/null | head -n1)"
    SRC_DIR="${SRC_DIR%/}"
  fi
  if [[ -z "$SRC_DIR" || ! -d "$SRC_DIR" ]]; then
    echo "[경고] claat 출력 디렉터리를 찾을 수 없습니다: $md" >&2
    continue
  fi
  DEST_DIR="$DOCS_DIR/$(basename "$SRC_DIR")"
  rm -rf "$DEST_DIR"
  mv "$SRC_DIR" "$DEST_DIR"
  echo "  ↳ $DEST_DIR" >&2
  INDEX_HTML="$DEST_DIR/index.html"
  if [[ -f "$INDEX_HTML" ]]; then
    python3 - "$INDEX_HTML" "$HOME_URL" <<'PY'
import sys
path, home = sys.argv[1:]
with open(path, encoding="utf-8") as f:
    data = f.read()
if 'home-url=' not in data:
    data = data.replace('<google-codelab ', f'<google-codelab home-url="{home}" ', 1)
override_id = 'codelab-home-override'
if override_id not in data:
    script = f"""
  <script id="{override_id}">
    (function() {{
      var HOME_URL = '{home}';
      function apply(target) {{
        var lab = target && target.tagName === 'GOOGLE-CODELAB' ? target : document.querySelector('google-codelab');
        if (!lab) return;
        lab.setAttribute('home-url', HOME_URL);
        try {{ lab.homeUrl = HOME_URL; }} catch (err) {{}}
        ['#arrow-back', '#done'].forEach(function(sel) {{
          var anchor = lab.querySelector(sel);
          if (anchor) {{
            anchor.setAttribute('href', HOME_URL);
            anchor.onclick = function(evt) {{
              evt.preventDefault();
              window.location.href = HOME_URL;
            }};
          }}
        }});
      }}
      document.addEventListener('google-codelab-ready', function(evt) {{
        apply(evt.target);
      }}, {{ once: false }});
      if (document.readyState === 'complete' || document.readyState === 'interactive') {{
        apply();
      }} else {{
        document.addEventListener('DOMContentLoaded', function() {{ apply(); }});
      }}
    }})();
  </script>
"""
    data = data.replace('</body>', script + '\n</body>')
with open(path, 'w', encoding='utf-8') as f:
    f.write(data)
PY
  fi
  if [[ -d "$SOURCE_DIR/img" ]]; then
    mkdir -p "$DEST_DIR/img"
    cp -R "$SOURCE_DIR/img"/* "$DEST_DIR/img"/ 2>/dev/null || true
  fi
  find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d -exec rm -rf {} + >/dev/null 2>&1 || true
  mkdir -p "$TMP_DIR"
done
shopt -u nullglob

echo "[완료] 모든 Codelab이 docs 디렉터리로 갱신되었습니다." >&2
