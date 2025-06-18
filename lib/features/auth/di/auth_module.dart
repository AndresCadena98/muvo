import 'package:get_it/get_it.dart';
import 'package:muvo/features/auth/presentation/bloc/auth/auth_bloc.dart';
import 'package:muvo/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:muvo/features/auth/domain/repositories/auth_repository.dart';
import 'package:muvo/features/auth/domain/services/auth_service.dart';

void setupAuthModule() {
  // Services
  GetIt.I.registerLazySingleton<AuthService>(
    () => AuthService(),
  );

  // Repositories
  GetIt.I.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(),
  );

  // Blocs
  GetIt.I.registerFactory<AuthBloc>(
    () => AuthBloc(authRepository: GetIt.I<AuthRepository>()),
  );
} 