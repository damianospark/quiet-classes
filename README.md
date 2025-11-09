# quiet-classes

## Google Codelab 강의 자료 제작 및 배포 가이드

이 저장소는 GitHub Pages를 통해 `https://damianospark.github.io/quiet-classes/` 하위 경로에서
Google Codelab 형태의 강의 자료를 제공합니다.

### 1. 강의 자료 작성 방식 (claat 활용)

이 프로젝트는 **claat (Codelabs as a Thing)** 도구를 사용해 Markdown 또는 Google Docs로 작성한 콘텐츠를
Google Codelab HTML로 자동 변환합니다.

#### 1-1. claat 도구 설치

```bash
# macOS (darwin-amd64)
curl -L https://github.com/googlecodelabs/tools/releases/latest/download/claat-darwin-amd64 -o claat
chmod +x claat

# Linux
curl -L https://github.com/googlecodelabs/tools/releases/latest/download/claat-linux-amd64 -o claat
chmod +x claat

# 버전 확인
./claat version
```

#### 1-2. Markdown으로 Codelab 작성

`source/` 폴더에 Markdown 파일을 작성합니다. 파일 상단에 메타데이터를 포함해야 합니다:

```markdown
summary: 강의 요약
id: codelab-id
categories: digital-literacy
tags: notion, google-workspace
status: Published
authors: 박진우
Feedback Link: https://github.com/damianospark/quiet-classes/issues/new

# 강의 제목

## 1. 첫 번째 단계
Duration: 5

단계 내용...

## 2. 두 번째 단계
Duration: 10

단계 내용...
```

#### 1-3. Markdown을 Codelab HTML로 변환

```bash
# Markdown 파일을 Codelab HTML로 변환
./claat export source/your-codelab.md

# 생성된 폴더를 docs로 이동
mv your-codelab docs/
```

### 2. GitHub Pages 배포

#### 2-1. GitHub Pages 활성화

1. 저장소 Settings → Pages로 이동
2. **Source**를 `Deploy from a branch`로 설정
3. **Branch**를 `main` / `docs`로 선택하고 저장
4. 설정 후 약간의 시간이 지나면 `https://damianospark.github.io/quiet-classes/`로 접근 가능

#### 2-2. 변경사항 배포

```bash
git add .
git commit -m "feat: 새 Codelab 추가"
git push origin main
```

### 3. 현재 강의 목록

- **4모듈**: [팀 협업 중심 전략 기획](https://damianospark.github.io/quiet-classes/digi-literacy1-04/)
  - Notion·Google Workspace·ChatGPT 활용
- **5모듈**: [통합 AI 리터러시(AI 활용 일반)](https://damianospark.github.io/quiet-classes/digi-literacy1-05/)
  - Canva·Gemini·ChatGPT 활용

### 4. 새 강의 추가 워크플로

```bash
# 1. source 폴더에 Markdown 작성
vim source/new-codelab.md

# 2. claat로 변환
./claat export source/new-codelab.md

# 3. docs로 이동
mv new-codelab docs/

# 4. Git 커밋 & 푸시
git add .
git commit -m "feat: new-codelab 추가"
git push origin main
```

### 5. 자동화 스크립트

`scripts/` 디렉터리에 다음 유틸리티가 포함되어 있습니다.

- `export_codelabs.sh`: `source/*.md`를 claat로 변환해 `docs/`에 반영합니다. 필요 시 `CLAAT_BIN` 환경 변수로 claat 경로를 재정의하세요.
- `publish_changes.sh`: 변경 사항을 `git add` 한 뒤 커밋 메시지를 입력받아 커밋·푸시합니다.
- `export_and_publish.sh`: 위 두 스크립트를 순차 실행합니다.

```bash
# 변환만 수행
scripts/export_codelabs.sh

# 변환 후 커밋/푸시까지 한 번에
scripts/export_and_publish.sh
```

### 6. Google Docs 기반 작성 (선택)

Google Docs로 작성 후 공유 링크를 사용해 변환할 수도 있습니다:

```bash
./claat export https://docs.google.com/document/d/YOUR_DOC_ID
```

Docs 작성 시 [Google Codelab 포맷 가이드](https://github.com/googlecodelabs/tools/tree/main/claat)를 참고하세요.

---

### 참고 자료

- [claat 도구 공식 문서](https://github.com/googlecodelabs/tools/tree/main/claat)
- [Codelab 포맷 가이드](https://github.com/googlecodelabs/tools/blob/main/FORMAT-GUIDE.md)
- [Google Codelabs 예시](https://codelabs.developers.google.com/)
