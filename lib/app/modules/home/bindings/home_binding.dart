import 'dart:convert';

import 'package:chat_gpt_flutter/app_storage.dart';
import 'package:chat_gpt_flutter/appconfig.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart';

import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  final getStorage = GetStorage();

  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    initializeAppConfig();
  }

  Future<void> initializeAppConfig() async {
    try {
      var response = await get(Uri.parse(
          'http://raw.githubusercontent.com/vijaybheda/authprovider.io/main/legal_chat_response.json'));

      if (response.statusCode == 200 && response.body.isNotEmpty) {
        List data = jsonDecode(response.body);
        AppConfig appConfig = AppConfig.fromJson(data.first);
        print('AppConfig initializeAppConfig - ${appConfig.toJson()}');
        var appStorage = AppStorage();

        if (appStorage.getAppConfig() == null) {
          await appStorage.setAppConfig(appConfig);
          print('AppConfig setAppConfig if - ${appConfig.toJson()}');
        } else {
          if (appConfig.version! < appStorage.getAppConfig()!.version!) {
            await appStorage.setAppConfig(appConfig);
            print('AppConfig setAppConfig else - ${appConfig.toJson()}');
          }
        }
        return;
      }
    } catch (e) {
      print('AppConfig initializeAppConfig error');
      return;
    }
  }
}
