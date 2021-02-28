import 'package:bell_delivery_hub/blocs/add_fund_bloc/bloc/add_fund_bloc.dart';
import 'package:bell_delivery_hub/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:bell_delivery_hub/data/repo/authentication_service.dart';
import 'package:bell_delivery_hub/blocs/login_bloc/login_bloc.dart';
import 'package:bell_delivery_hub/data/repo/wallet_repository.dart';
import 'package:bell_delivery_hub/blocs/wallet_bloc/wallet_bloc.dart';
import 'package:bell_delivery_hub/data/hive/hive_data_source.dart';
import 'package:bell_delivery_hub/data/local_data_source.dart';
import 'package:bell_delivery_hub/network/interceptors/dio_connectivity_request_retrier.dart';
import 'package:bell_delivery_hub/network/network_api.dart';
import 'package:bell_delivery_hub/theme/themes/theme_cubit.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt inject = GetIt.instance;

Future<void> initDependencyInjection() async {
  // register http client and configure network
  _registerNetworkAndLocalDatabase();
  _registerBlocs();
  _registerRepository();
}

void _registerNetworkAndLocalDatabase() {
  inject.registerSingleton(buildDio());

  inject.registerSingleton(SharedPreferences.getInstance());

  inject.registerSingleton(BotsNetworkApi(inject.get<Dio>()));

  inject.registerLazySingleton<LocalDataSource>(() => HiveDataSource());

  inject.registerLazySingleton(
    () => DioConnectivityRequestRetrier(connectivity: inject(), dio: inject()),
  );
}

void _registerBlocs() {
  inject.registerLazySingleton(() => ThemeCubit());
  inject.registerLazySingleton(() => AuthenticationRepository(
      networkApi: inject(), localDataSource: inject()));
  inject.registerLazySingleton(
      () => WalletRepository(networkApi: inject(), localDataSource: inject()));

  //BLOCS//

  inject.registerLazySingleton(() => AuthenticationBloc(inject()));
  inject.registerLazySingleton(() => LoginBloc(inject(), inject()));
  inject.registerLazySingleton(() => WalletBloc(walletRepository: inject()));
  inject.registerLazySingleton(() => AddFundBloc(walletRepository: inject()));
}

void _registerRepository() {}
