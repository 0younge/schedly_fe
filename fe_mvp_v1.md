# FE MVP v1

## 목적

Schedly FE MVP v1은 사용자가 처음 앱에 접속했을 때 캘린더를 바로 확인하고, 우측 상단 로그인 버튼을 통해 로그인/회원가입 화면으로 이동할 수 있는 프론트엔드 기본 버전이다.

이 문서는 지금까지의 프롬프트 흐름, 작업 규칙, 구현 결과물, 실행 및 검증 방법을 한 파일로 정리한다.

## 프롬프트 요약

1. 프로젝트는 FE와 BE를 분리한다.
2. FE IDE는 VS Code, BE IDE는 IntelliJ를 사용한다.
3. 초반에는 코드 작성보다 프로젝트 골격과 GitHub 설정을 우선한다.
4. FE와 BE는 각각 별도 GitHub 레포지토리로 관리한다.
5. Git 관련 작업은 매번 프롬프트로 지시하지 않아도 문서화된 규칙을 자동으로 읽고 수행한다.
6. commit, push, PR, review, issue, merge는 작업 단위로 일관되게 처리한다.
7. AI용 규칙 문서는 정확성을 유지하되 토큰 사용량을 줄이는 방향으로 짧고 트리거 기반으로 작성한다.
8. 공개 시 위험한 정보와 민감 정보는 `.env`, local config, `.gitignore`를 활용해 보호한다.
9. 코드 작성은 유지보수와 확장에 용이하게 한다.
10. FE부터 먼저 구성하고, 마음에 드는 FE 흐름에 맞춰 BE를 이후 설계한다.
11. FE MVP v1은 다음 화면을 포함한다.
    - 처음 접속 시 캘린더 화면
    - 로그인 화면
    - 회원가입 화면
12. 화면 스타일은 모던하고 통일감 있게 작성한다.
13. 캘린더 화면 우측 상단에 로그인 버튼을 둔다.
14. 로그인 화면 하단에 회원가입 버튼을 둔다.
15. Android emulator에서 발생한 캘린더 `BOTTOM OVERFLOWED` 오류를 해결한다.
16. 지금까지의 프롬프트와 FE 결과물을 `fe_mvp_v1.md`로 정리한다.

## 작업 규칙 요약

### 공통 규칙

- 작업 전 `.codex/rules.md`를 먼저 읽는다.
- 필요한 경우에만 추가 규칙 문서를 읽는다.
- 정확성을 우선하되, 관련 파일과 범위를 작게 유지해 토큰을 아낀다.
- 기존 사용자 변경사항은 되돌리지 않는다.
- 민감 정보는 커밋하지 않고 환경변수, local config, `.gitignore`로 보호한다.

### 코드 규칙

- 유지보수하기 쉬운 이름, 작은 단위, 단순한 흐름을 선호한다.
- 확장에 필요한 경계와 책임을 분리한다.
- 기존 프로젝트 스타일을 따른다.
- 실제 중복이나 책임 분리를 줄일 때만 추상화를 추가한다.
- 가능한 작은 단위로 테스트하고 검증한다.

### Git 규칙

- 작업 단위마다 issue, branch, commit, PR, review, merge 흐름을 따른다.
- 브랜치는 `feat|fix|chore|docs|test|refactor/<topic>` 형식을 사용한다.
- 커밋 메시지는 Conventional Commits 형식을 사용한다.
- PR은 `.github/PULL_REQUEST_TEMPLATE.md`를 기준으로 작성한다.
- 리뷰는 `.github/REVIEW_TEMPLATE.md`를 기준으로 작성한다.
- 병합은 가능한 경우 squash merge를 사용한다.

## FE MVP v1 결과물

### 기술 스택

- Flutter 3.44.0
- Dart 3.12.0
- Material 3
- 지원 플랫폼:
  - Web
  - Android
  - macOS

### 구현 화면

#### 1. 캘린더 화면

- 앱 최초 진입 화면이다.
- `Schedly` 브랜드명과 `May 2026` 월 표시가 보인다.
- 우측 상단에 `Login` 버튼이 있다.
- 월간 캘린더 그리드를 보여준다.
- 일정이 있는 날짜는 점 표시가 있다.
- 선택된 날짜는 primary color로 강조된다.
- 선택된 날짜의 일정 목록을 별도 패널에서 보여준다.
- 모바일/데스크톱 폭에 맞춰 반응형으로 배치된다.

#### 2. 로그인 화면

- `Welcome back` 제목을 표시한다.
- 이메일 입력 필드가 있다.
- 비밀번호 입력 필드가 있다.
- `Login` 버튼이 있다.
- 하단에 `Sign up` 버튼이 있고 회원가입 화면으로 이동한다.

#### 3. 회원가입 화면

- `Create account` 제목을 표시한다.
- 이름 입력 필드가 있다.
- 이메일 입력 필드가 있다.
- 비밀번호 입력 필드가 있다.
- `Create account` 버튼이 있다.
- `Back to login` 버튼으로 로그인 화면으로 돌아갈 수 있다.

### 라우트

| Route | 화면 | 파일 |
| --- | --- | --- |
| `/` | Calendar | `lib/features/calendar/calendar_screen.dart` |
| `/login` | Login | `lib/features/auth/login_screen.dart` |
| `/signup` | Sign up | `lib/features/auth/signup_screen.dart` |

### 주요 파일

| 파일 | 역할 |
| --- | --- |
| `lib/main.dart` | Flutter 앱 진입점 |
| `lib/app/schedly_app.dart` | MaterialApp, 테마, 초기 라우트 설정 |
| `lib/app/app_routes.dart` | 라우트 상수 |
| `lib/app/app_theme.dart` | 앱 공통 테마 |
| `lib/features/calendar/calendar_screen.dart` | 캘린더 화면 구성 |
| `lib/features/calendar/month_grid.dart` | 월간 날짜 그리드 |
| `lib/features/calendar/schedule_panel.dart` | 선택 날짜 일정 패널 |
| `lib/features/calendar/schedule_preview.dart` | 일정 preview model |
| `lib/features/auth/login_screen.dart` | 로그인 화면 |
| `lib/features/auth/signup_screen.dart` | 회원가입 화면 |
| `test/widget_test.dart` | 기본 화면 이동 및 모바일 overflow 회귀 테스트 |

## 완료된 설정

- FE GitHub repository: `0younge/schedly_fe`
- Flutter Web platform scaffold
- Flutter Android platform scaffold
- Flutter macOS platform scaffold
- VS Code Flutter/Dart extension 설치 확인
- Android SDK, emulator, license 설정 확인
- Xcode iOS Simulator runtime 설정 확인
- CocoaPods 설치 확인
- GitHub public repository 전환 전 보안 규칙과 `.gitignore` 정리

## 해결한 오류

### Flutter widget test overflow

- 버튼 theme의 최소 크기 설정 때문에 Row 내부에서 width overflow가 발생했다.
- `Size.fromHeight` 대신 명시적인 `Size(0, height)` 형태로 수정했다.
- widget test를 통과하도록 수정했다.

### Android calendar bottom overflow

- Android emulator compact 화면에서 날짜 셀 내부 텍스트와 점 간격이 fractional pixel 단위로 overflow를 만들었다.
- compact width에서 캘린더 grid padding, spacing, aspect ratio, day cell typography를 조정했다.
- 모바일 viewport widget test를 추가해 같은 문제가 재발하지 않도록 했다.

## 검증 결과

마지막 확인 기준으로 다음 항목을 통과했다.

```bash
flutter doctor -v
flutter test
flutter analyze
flutter build web
flutter build apk --debug
flutter build macos --debug
flutter run -d emulator-5554
```

확인된 결과:

- `flutter doctor -v`: No issues found
- `flutter test`: All tests passed
- `flutter analyze`: No issues found
- Web build 성공
- Android debug APK build 성공
- macOS debug build 성공
- Android emulator에서 캘린더 overflow 문구가 사라진 것을 확인

## 직접 실행 방법

VS Code에서 다음 폴더를 연다.

```text
/Users/gwon-yeonghyeon/schedly/schedly_fe
```

터미널 실행 예시:

```bash
flutter run -d chrome
flutter run -d macos
flutter emulators --launch apple_ios_simulator
flutter emulators --launch schedly_pixel_8
flutter run
```

VS Code GUI 실행:

1. `File > Open Folder...`
2. `/Users/gwon-yeonghyeon/schedly/schedly_fe` 선택
3. 오른쪽 아래 Flutter device 선택
4. `F5` 또는 `Run > Start Debugging`
5. 캘린더 화면, 로그인 화면, 회원가입 화면 이동 확인

## FE MVP v1 범위

### 포함

- 캘린더 첫 화면
- 로그인 화면
- 회원가입 화면
- 화면 간 라우팅
- 반응형 캘린더 레이아웃
- Web, Android, macOS 실행 가능한 Flutter platform scaffold
- 기본 widget test
- compact Android overflow 회귀 테스트

### 미포함

- 실제 로그인 API 연동
- 실제 회원가입 API 연동
- 일정 CRUD API 연동
- DB 연동
- 인증 토큰 저장
- 배포 URL
- 실제 사용자 데이터 persist

## 다음 작업 후보

1. FE 화면 디테일 확정
2. 로그인/회원가입 입력 validation 추가
3. 일정 생성/수정/삭제 UI 추가
4. BE API 계약서 작성
5. Supabase PostgreSQL DB 생성
6. Spring Boot BE 도메인 및 인증 구현
7. FE와 BE API 연동
