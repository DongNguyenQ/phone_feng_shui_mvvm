
import 'package:get_it/get_it.dart';
import 'package:phone_feng_shui_mvvm/repository/feng_shui_repository.dart';
import 'package:phone_feng_shui_mvvm/repository/service/local/local_service.dart';
import 'package:phone_feng_shui_mvvm/viewmodel/home_viewmodel.dart';

GetIt locator = GetIt.asNewInstance();

void setupLocator() {
  locator.registerLazySingleton(() => LocalService());
  locator.registerFactory<HomeViewModel>(() => HomeViewModel());
  locator.registerSingleton(FengShuiRepository(locator<LocalService>()));
}