import 'package:chat_gpt_flutter/appconfig.dart';
import 'package:get_storage/get_storage.dart';

class AppStorage {
  final storageBox = () => GetStorage(StorageKey.kAppStorageKey);

  Future<void> appLogout() async {
    await storageBox().remove(StorageKey.kLoggedKeys);

    return;
  }

  dynamic read(String key) {
    return storageBox().read(key);
  }

  Future<void> write(String key, var value) async {
    return await storageBox().write(key, value);
  }

  AppConfig? getAppConfig() {
    final loggedKeys = read(StorageKey.kLoggedKeys);
    if (loggedKeys == null) {
      return null;
    }
    AppConfig appConfig = AppConfig.fromJson(loggedKeys);
    print('AppConfig getAppConfig - ${appConfig.toJson()}');
    return appConfig;
  }

  Future<void> setAppConfig(AppConfig appConfig) async {
    await write(StorageKey.kLoggedKeys, appConfig.toJson());
    return;
  }

  bool getBool(String key) {
    return read(key);
  }

  Future<void> setBool(String key, bool value) async {
    await write(key, value);
    return;
  }

  Future<void> setInt(String key, int value) async {
    await write(key, value);
    return;
  }

  Future<void> initStorage() async {
    await GetStorage.init(StorageKey.kAppStorageKey);
  }
}

class StorageKey {
  static const String kAppStorageKey = 'AppStorageKey';
  static const String kLoggedKeys = 'loggedKeys';
}
