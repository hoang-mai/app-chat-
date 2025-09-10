import 'package:appchat/services/account_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:provider/provider.dart';

import 'app.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await FlutterConfig.loadEnvVariables();

  runApp(ChangeNotifierProvider.value(
    value: AccountService.instance,
    child: const AppChat(),
  ));
}


