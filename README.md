# 파우커 Portfolio Slice (Clean Architecture + Flavors/GoRouter + API + Auth Screens)

이 저장소는 원본 앱에서 **Clean Architecture 의존성 흐름**, 그리고 **개발/운영 환경 분기(flavor) + GoRouter 라우팅 구조**를 한 번에 보여주기 위해 만든 *sanitized slice* 입니다.

## Original Project Directory Structure (overview)
아래 트리는 **원본 프로젝트의 구조(개요)**이고, 이 서브 레포는 그 중 **일부만 발췌(sanitized subset)** 한 것입니다.

- `lib/ui/features/` 전체가 들어있진 않고, 인증(Auth) 수직 슬라이스에 해당하는 부분만 포함됩니다.

```txt
.
├─ android/
├─ assets/
├─ ios/
└─ lib/
   ├─ config/
   ├─ core/
   │  ├─ error/
   │  └─ utils/
   ├─ data/
   │  ├─ api/
   │  ├─ converters/
   │  ├─ interceptors/
   │  ├─ mappers/
   │  ├─ models/
   │  ├─ repositories/
   │  └─ services/
   ├─ di/
   ├─ domain/
   │  ├─ entities/
   │  ├─ repositories/     # contracts
   │  ├─ services/         # domain service interfaces
   │  ├─ use_cases/
   │  ├─ exceptions/
   │  └─ constants/
   ├─ routing/
   ├─ services/            # platform / cross-cutting
   ├─ ui/
   │  ├─ core/
   │  ├─ features/        # auth, chat, walk_*, jobs, ...
   │  └─ shared/
   ├─ flavors.dart
   └─ main_*.dart
```

## 포함 레이어
- `lib/domain/` : 엔티티(모델), 리포지토리 인터페이스, 도메인 서비스, Use Case
- `lib/core/` : 공통(딥링크, 실패/예외 타입, 유틸)
- `lib/di/` : UseCase/Repository 구현체를 연결하는 Provider (wiring)
- `lib/ui/features/auth/view_model/` : 프리젠테이션(UseCase 호출 지점)
- `lib/ui/features/auth/widgets/` : 로그인/회원가입/사용자정보 화면 (Presentation)
- `lib/data/repositories/` : (예시로) AuthRepository 구현체
- `lib/data/api/` : Retrofit(Dio) API 클라이언트(참조용)
- `lib/data/services/` : Repository가 호출하는 auth 관련 서비스(예: `auth_service.dart`)

## 앱 엔트리/환경 분기
- `lib/main_development.dart`, `lib/main_production.dart` : flavor + ENVIRONMENT 설정 흐름 확인용
- `lib/flavors.dart` : dev/prod flavor 정의
- `lib/config/environment.dart`, `lib/config/development.dart`, `lib/config/production.dart` : 런타임 환경 선택(운영용 값은 `REDACTED`)

## 포함한 “환경 분기/라우팅” 관점
- `lib/flavors.dart` : `dev/prod` flavor 정의
- `lib/config/environment.dart` : 런타임 환경 선택(Development/Production)
- `lib/config/development.dart`, `lib/config/production.dart` : 값은 `REDACTED`로 마스킹
- `lib/routing/app_router.dart` : GoRouter 라우팅 구성(참조용)

## Auth 프리젠테이션 흐름
- `lib/ui/features/auth/widgets/login_screen.dart` : 로그인 버튼/소셜 로그인 트리거 → `AuthViewModel.login()`
- `lib/ui/features/auth/view_model/auth_view_model.dart` : UseCase 실행
- `lib/domain/use_cases/auth/*` : 도메인 비즈니스 로직

## Auth 의존성 흐름(읽는 순서)
1) `lib/ui/features/auth/view_model/auth_view_model.dart`
   - UI에서 `loginUseCaseProvider` 를 읽어 `LoginUseCase` 실행
2) `lib/di/use_case_providers.dart`
   - `loginUseCaseProvider` 가 `LoginUseCase` 를 생성할 때 필요한 의존성 주입
3) `lib/domain/use_cases/auth/login_use_case.dart`
   - 실제 비즈니스 로직이 `AuthRepository` 인터페이스에 의존
4) `lib/domain/repositories/auth_repository.dart`
   - repository 인터페이스
5) `lib/di/repository_providers.dart`
   - `AuthRepository` 구현체 `AuthRepositoryImpl` 로 의존성 주입
6) `lib/data/repositories/auth_repository_impl.dart`
   - 인프라(HTTP/토큰/스토리지) 의존을 가진 repository 구현

## 제외
- 대량 DTO/네트워크 코드: `lib/data/models/**` (일부만 포함)
- 네트워크/플랫폼 인프라 서비스는 전부 포함하지 않고, 포트폴리오에서 필요한 최소 예시만 포함
- 플랫폼 인프라 서비스: `lib/services/**`
- 생성 파일: `**/*.g.dart`, `**/*.freezed.dart`
- 나머지 UI/라우팅에 필요한 파일들(뷰/스크린)은 `app_router.dart`가 참조하지만, 이 슬라이스에서는 일부만 포함됨

## 참고
- 이 슬라이스는 *구조/책임*을 보여주기 위한 목적입니다. 일부 참조 파일/생성 파일이 제외되어 있어, 완전 빌드/컴파일은 보장하지 않습니다.
