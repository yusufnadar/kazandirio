import 'package:get_it/get_it.dart';
import 'package:kazandirio/repository/user_repository.dart';
import 'package:kazandirio/services/auth_service.dart';
import 'package:kazandirio/services/user_service.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => UserService());
}
