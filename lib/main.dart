// lib/main.dart

import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'core/network/http_overrides.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_theme.dart';
import 'core/network/network_info.dart';
import 'data/local/hive_service.dart';
import 'data/remote/superhero_remote_data_source.dart';
import 'data/repositories/superhero_repository.dart';
import 'presentation/blocs/search/search_bloc.dart';
import 'presentation/screens/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  HttpOverrides.global = AppHttpOverrides();

  await HiveService.init();

  final remoteDataSource = SuperheroRemoteDataSource();
  final hiveService = HiveService();
  final networkInfo = NetworkInfoImpl(Connectivity());

  final repository = SuperheroRepository(
    remote: remoteDataSource,
    local: hiveService,
    network: networkInfo,
  );

  runApp(MyApp(repository: repository));
}

class MyApp extends StatelessWidget {
  final SuperheroRepository repository;

  const MyApp({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: repository,
      child: BlocProvider(
        create: (context) => SearchBloc(repository: repository)..add(const SearchInitialLoad()),
        child: MaterialApp(
          title: 'Superhero Archive',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.dark,
          home: const SearchScreen(),
        ),
      ),
    );
  }
}