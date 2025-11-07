# quiet-classes

## Google Codelab 샘플 배포 안내

이 저장소는 GitHub Pages를 통해 `https://damianospark.github.io/quiet-classes/` 하위 경로에서
Google Codelab 형태의 강의 자료를 제공하기 위한 샘플을 포함합니다.

### 1. GitHub Pages 활성화

1. 저장소 Settings → Pages 로 이동합니다.
2. **Source** 를 `Deploy from a branch` 로 설정합니다.
3. **Branch** 를 `main` / `docs` 로 선택하고 저장합니다.
4. 설정 후 약간의 시간이 지나면 `https://damianospark.github.io/quiet-classes/` 로 접근할 수 있습니다.

### 2. Codelab 샘플 확인

- 샘플 강의 경로
  - `https://damianospark.github.io/quiet-classes/digi-literacy1-04/`
  - `https://damianospark.github.io/quiet-classes/digi-literacy1-05/`
- 로컬에서 확인하려면 `docs/digi-literacy1-04/index.html` 파일을 브라우저로 열면 됩니다.
- 동일하게 `docs/digi-literacy1-05/index.html` 로컬 파일을 열어 미리보기할 수 있습니다.

### 3. 새 수업 추가 방법

1. `docs/<새 강의 경로>/index.html` 파일을 생성하고, Google Codelab 컴포넌트를 활용해 콘텐츠를 작성합니다.
2. 변경 사항을 커밋하고 `main` 브랜치에 푸시합니다.
3. GitHub Pages가 자동으로 새 콘텐츠를 반영합니다.

강의 자료는 한국어 리소스를 기준으로 작성하며, 향후 i18n 스크립트와 함께 다국어 관리가 가능하도록 확장할 예정입니다.
