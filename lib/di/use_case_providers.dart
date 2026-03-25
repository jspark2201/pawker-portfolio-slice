import 'package:pawker/di/repository_providers.dart';
import 'package:pawker/di/service_providers.dart';
import 'package:pawker/domain/use_cases/auth/auto_login_use_case.dart';
import 'package:pawker/domain/use_cases/auth/login_use_case.dart';
import 'package:pawker/domain/use_cases/auth/logout_use_case.dart';
import 'package:pawker/domain/use_cases/auth/signup_use_case.dart';
import 'package:pawker/domain/use_cases/user/update_profile_use_case.dart';
import 'package:pawker/domain/use_cases/walk/save_walk_record_use_case.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_providers.g.dart';

@riverpod
LoginUseCase loginUseCase(ref) => LoginUseCase(
  authRepository: ref.read(authRepositoryProvider),
  userRepository: ref.read(userRepositoryProvider),
  pushNotificationService: ref.read(fcmServiceProvider),
);

@riverpod
AutoLoginUseCase autoLoginUseCase(ref) => AutoLoginUseCase(
  authRepository: ref.read(authRepositoryProvider),
  userRepository: ref.read(userRepositoryProvider),
  pushNotificationService: ref.read(fcmServiceProvider),
);

@riverpod
LogoutUseCase logoutUseCase(ref) => LogoutUseCase(
  authRepository: ref.read(authRepositoryProvider),
  pushNotificationService: ref.read(fcmServiceProvider),
);

@riverpod
SignupUseCase signupUseCase(ref) => SignupUseCase(
  userRepository: ref.read(userRepositoryProvider),
);

@riverpod
UpdateProfileUseCase updateProfileUseCase(ref) => UpdateProfileUseCase(
  userRepository: ref.read(userRepositoryProvider),
);

@riverpod
SaveWalkRecordUseCase saveWalkRecordUseCase(ref) => SaveWalkRecordUseCase(
  walkRecordRepository: ref.read(walkRecordRepositoryProvider),
);
